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
	   (:link :rel "stylesheet"
		  :href "style.css"
		  :type "text/css")
	   (:meta :charset "UTF-8")
	   (:meta :http-equiv "Content-Security-Policy"
			:content "default-src 'self' 'unsafe-inline'; script-src 'self' 'unsafe-inline'; connect-src *")
	   (:meta :name "viewport"
		  :content "width=device-width,initial-scale=1")
	   (:title "screencapture")
	   (:link :rel "stylesheet" ;; why a web link?
		  :href "https://cdn.jsdelivr.net/npm/bulma@0.8.0/css/bulma.min.css")
	   (:link :rel "stylesheet"
		  :herf "index.css")
	   (:script :defer :src "render.js"))
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
									  (nodeIntegration true))))
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
    (write-source (format nil "~a/my-app/render" *path*)
		  `(let ((button (document.querySelector (string ".alert")) :type const)
			 (parser (new (DOMParser)) :type const)
			 ,@(loop for e in `(links error-message new-link-form new-link-url
						  new-link-submit clear-storage)
			      collect
				`(,(substitute #\_ #\- (format nil "~a" e))
				   (document.querySelector (string ,(format nil ".~a" e))) :type const))
			 (clearForm (lambda ()
				      (setf new_link_url.value null))
			   :type const)
			 (parseResponse (lambda (text)
					   (return (parser.parseFromString text
									   (string "text/html"))))
			   :type const)
			 (findTitle (lambda (nodes)
				      (return (dot nodes
						   (querySelector (string "title"))
						   innerText)))
			   :type const)
			 (storeLink (lambda (title url)
				      (localStorage.setItem url
							    (JSON.stringify (dict (title title)
										  (url url)))))
			   :type const)
			 (getLinks (lambda ()
				     (console.log (string-backtick "getLinks Object.keys(localStorage)=${Object.keys(localStorage)}"))
				     (return (dot (Object.keys localStorage)
						  (map (lambda (key)
							 (JSON.parse (localStorage.getItem key)))))))
			   :type const)

			 (convertToElement (lambda (link)
					     (console.log (string-backtick "convertToElement ${link}"))
					     (return
					       (string-backtick
						,(cl-who:with-html-output-to-string (s)
						   (cl-who:htm
						    (:div :class "link"
							  ;(:h3 "${link.title}")
							  #+nil (:p (:a :href "${link.url}"
								  "${link.url}")
							      )))))))
			   :type const)
			 (renderLinks (lambda ()
					(console.log (string-backtick "renderLinks"))
					
					(let ((linkElements (dot (getLinks)
								 (map convertToElement)
								 (join (string "")))
						:type const))
					  (setf links.innerHTML linkElements))
					)
			   :type const))
		     

		     (new_link_url.addEventListener
		      (string "keyup")
		      (lambda ()
			(setf new_link_submit.disabled !new_link_url)))
		     (new_link_form.addEventListener
		      (string "submit")
		      (lambda (event)
			(event.preventDefault)
			(let ((url new_link_url.value :type const))
			  (dot (fetch url)
			       (then (lambda (response)
				       (return (response.text))))
			       (then parseResponse)
			       (then findTitle)
			       (then (lambda (title)
				       (storeLink title url)))
			       (then clearForm)
			       (then renderLinks)))))
		     (renderLinks)
		     (button.addEventListener (string "click")
					      (lambda ()
						(alert (string "bla"))))
		     ))))





