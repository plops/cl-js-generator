(eval-when (:compile-toplevel :execute :load-toplevel)
  (mapc #'ql:quickload `("cl-js-generator"
			 "cl-who")))

(in-package :cl-js-generator)

(setq cl-who:*attribute-quote-char* #\")
(setf cl-who::*html-mode* :html5)

(progn
  (defparameter *repo-sub-path* "03_electron_capture")
  (defparameter *path* (format nil "/home/martin/stage/cl-js-generator/example/~a" *repo-sub-path*))
  (defparameter *inspection-facts*
    `((10 "")))
  (defparameter *day-names*
    '("Monday" "Tuesday" "Wednesday"
      "Thursday" "Friday" "Saturday"
      "Sunday"))

  
  (let* ()
    (with-open-file (s (format nil "~a/my-app/src/index.html" *path*) 
		       :direction :output
		       :if-exists :supersede
		       :if-does-not-exist :create)
      (cl-who:with-html-output (s nil :prologue t :indent t)
	(cl-who:htm
	 (:html
	  (:head
	   #+nil (:link :rel "stylesheet"
		  :href "style.css"
		  :type "text/css")
	   (:meta :charset "UTF-8")
	   (:meta :http-equiv "Content-Security-Policy"
			:content "default-src 'self' 'unsafe-inline'; script-src 'self' 'unsafe-inline'; connect-src *")
	   (:meta :name "viewport"
		  :content "width=device-width,initial-scale=1")
	   (:title "screencapture")
	   (:link :rel "stylesheet" ;; why a web link?
		  ;; i downloaded the 0.9.1 version
		  :href ;"https://cdn.jsdelivr.net/npm/bulma@0.8.0/css/bulma.min.css"
		  "bulma.min.css"
		  )
	   (:link :rel "stylesheet"
		  :herf "index.css"
		  :type "text/css")
	   (:script  :src "render.js" :defer))
	  (:body :class "content"
		 (:h1 "electron screen recorder")
		 (:video)
		 (:button :id "startBtn"
			  :class "button is-primary"
			  "start")
		 (:button :id "stopBtn"
			  :class "button is-warning"
			  "stop")
		 (:button :id "videoSelectBtn"
			  :class "button is-text"
			  "choose a video source"))))))
    (write-source (format nil "~a/my-app/src/index" *path*)
		  `(let (("{app, BrowserWindow}" (require (string "electron")) :type const)
			 (path (require (string "path")))
			 (mainWindow null))
		     (when (require (string "electron-squirrel-startup"))
		       ;; creating/removing shortcuts on windows
		       (app.quit)
		       )
		     (defun createWindow ()
		       ,@(loop for e in `(node chrome electron) collect
			    `(console.log (string-backtick ,(format nil "~a: ${process.versions.~a}" e e))))
					
		       (setf mainWindow (new (BrowserWindow
					      (dict
					       (width 800)
					       (height 600)
					       (webPreferences (dict ;(worldSafeExecuteJavaScript true)
								(nodeIntegration true)
								;; https://stackoverflow.com/questions/37884130/electron-remote-is-undefined
								(enableRemoteModule true))))
					      )))
		       (mainWindow.loadFile (path.join __dirname (string "index.html")))
		       ;(mainWindow.webContents.loadURL (string-backtick "file://${__dirname}/index.html"))
		       (mainWindow.webContents.openDevTools))
		     (dot app
			  (on (string "ready")
			      createWindow))
		     
		     
		     (app.on (string "window-all-closed")
			     (lambda ()
			       ;; on os x apps and their menu bar stay active unitl explicit quit with Cmd+Q
			       (unless (== process.platform (string "darwin"))
				   (app.quit))))
		     (app.on (string "activate")
			     (lambda ()
			       ;; for macos re-create window when dock icon is clicked and no other window open
			       (when (=== (dot BrowserWindow
					       (getAllWindows)
					       length)
					  0)
				 (createWindow)))
			     )))
    (write-source (format nil "~a/my-app/src/render" *path*)
		  `(do0
		    (let (("{desktopCapturer, remote}" (require (string "electron")) :type const)
			  ;; remote is used for native menus
			  ("{writeFile}" (require (string "fs")) :type const)
			  ("{dialog,Menu}" remote :type const)))
		    
		    
		    (let ((mediaRecorder null)
			  (recordedChunks "[]" :type const)
			  (videoElement (document.querySelector (string "video")) :type const)))
		    ,@(loop for (name code) in
			   `((startBtn (lambda ()
					 (mediaRecorder.start)
					 (startBtn.classList.add (string "is-danger"))
					 (setf startBtn.innerText (string "Recording"))))
			     (stopBtn (lambda ()
					(mediaRecorder.stop)
					(startBtn.classList.remove (string "is-danger"))
					(setf startBtn.innerText (string "start"))))
			     (videoSelectBtn getVideoSources))
			 collect
			   `(let ((,name (document.getElementById (string ,name)) :type const))
			      (setf (dot ,name onclick)
				    ,code)))
		    (space "async"
		     (defun getVideoSources ()
		       (let ((inputSources (space await
						  (deskopCapturer.getSources
						   (dict (types (list (string "window")
								      (string "screen"))))))
			       :type const)
			     (videoOptionsMenu (Menu.buildFromTemplate
						(inputSources.map (lambda (source)
								    (return (dict (label source.name)
										  (click (lambda ()
											   (selectSource source))))))))))
			 (videoOptionsMenu.popup))))

		    (space async
			   (defun selectSource (source)
			     (setf videoSelectBtn.innerText source.name)
			     (let ((constraints (dict (audio false)
						      (video (dict (mandatory (dict (chromeMediaSource (string "desktop"))
										    (chromeMediaSourceId source.id))))))
				     :type const)
				   (stream (space await (dot navigator.mediaDevices
							     (getUserMedia constraints)))
				     :type const))
			       (setf videoElement.srcObject stream)
			       (videoElement.play)
			       (let ((options (dict (mimeType (string "video/webm; codecs=vp9")))))
				 (setf mediaRecorder (new (MediaRecorder stream options)))
				 (setf mediaRecorder.ondataavailable handleDataAvailable
				       mediaRecorder.onstop handleStop))
			       )))

		    (defun handleDataAvailable (e)
		      (console.log (string "video data available"))
		      (recordedChunks.push e.data))
		    (space async
			   (defun handleStop (e)
			     (let ((blob (new (Blob recordedChunks
						    (dict (type (string "video/webm; codecs=vp9")))) )
				     :type const)
				   (buffer (Buffer.from (space await (blob.arrayBuffer)))
				     :type const)
				   ("{filePath}" (space await (dialog.showSaveDialog
							       (dict (buttonLabel (string "save video"))
								     (defaultPath (string-backtick "vid-${Date.now()}.webm")))))))
			       (when filePath
				 (writeFile filePath
					    buffer
					    (lambda ()
					      (console.log (string "video saved successfully."))))))))
		    
		    ))))





