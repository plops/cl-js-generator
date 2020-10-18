(eval-when (:compile-toplevel :execute :load-toplevel)
  (mapc #'ql:quickload `("cl-js-generator"
			 "cl-who")))

(in-package :cl-js-generator)

(setq cl-who:*attribute-quote-char* #\")
(setf cl-who::*html-mode* :html5)


(progn
  (defparameter *repo-sub-path* "04_electron_scrape")
  (defparameter *path* (format nil "/home/martin/stage/cl-js-generator/example/~a" *repo-sub-path*))
  (defparameter *inspection-facts*
    `((10 "")))
  (defparameter *day-names*
    '("Monday" "Tuesday" "Wednesday"
      "Thursday" "Friday" "Saturday"
      "Sunday"))

  
  (let* ()
    (with-open-file (s (format nil "~a/app/index.html" *path*)
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
	   ;; https://stackoverflow.com/questions/63427191/security-warning-in-the-console-of-browserwindow-electron-9-2-0
	   (:meta :http-equiv "Content-Security-Policy"
			:content "default-src 'self' 'unsafe-inline'; script-src 'self' 'unsafe-inline'; connect-src *")
	   (:meta :name "viewport"
		  :content "width=device-width,initial-scale=1")
	   (:title "bookmarker"))
	  (:body
	   (:webview :style "min-height: 85vh;"
		     :src "https://www.whatismybrowser.com/detect/what-is-my-user-agent"
		     :useragent "Tralala v1.2")
	   (:h1 "Hello from Electron")
	   (:div :class "error-message")
	   (:section :class "add-new-link"
		     (:form :class "new-link-form"
			    (:input :type "url"
				    :class "new-link-url"
				    :placeholder "URL"
				    :size "100"
				    :required)
			    (:input :type "submit"
				    :class "new-link-submit"
				    :value "Submit"
				    :disabled)))
	   (:section :class "links")
	   (:section :class "controls"
		     (:button :class "clear-storage"
			      "Clear Storage"))
	   
	   (:p (:button :class "alert"
			"current directory"))
	   (:script "require('./renderer');"
		    #+nil "const button=document.querySelector('.alert');
button.addEventListener('click',()=>{alert(\"hello\");});"))))))
    (write-source (format nil "~a/app/main" *path*)
		  `(let (("{app, BrowserWindow}" (require (string "electron")) :type const)
			 ;(isDev !app.isPackaged :type const)
			 (mainWindow null))
		     (defun createWindow ()
		       (console.log (string "hello2 from electron"))
		       ,@(loop for e in `(node chrome electron) collect
			    `(console.log (string-backtick ,(format nil "~a: ${process.versions.~a}" e e))))
					;(console.log (string-backtick "file://${__dirname}/index.html"))
		       ;; https://www.electronjs.org/docs/tutorial/first-app
		       (setf mainWindow (new (BrowserWindow
					      (dict
					       (width 1450)
					       (height 600)
					       ;; https://github.com/electron/electron/issues/9920#issuecomment-575839738
					       
					       (webPreferences (dict
								;(contextIsolation true)
								(worldSafeExecuteJavaScript true)
									  (nodeIntegration true))))
					      ;"{webPreferences: { worldSafeExecuteJavaScript: true, nodeIntegration: true }}"
					      )))
		       (mainWindow.webContents.loadURL (string-backtick "file://${__dirname}/index.html"))
		       (mainWindow.webContents.openDevTools))
		     (dot app
			  (whenReady)
			  (then createWindow))
		     #+nil (
		      (require (string "electron-reload"))
		      __dirname)
		     #+nil (
		      (require (string "electron-reload"))
			    __dirname
			    (dict (electron (path.join __dirname
						       (string "node_modules")
						       (string ".bin")
						       (string "electron")))))
		     
		     (app.on (string "window-all-closed")
			     (lambda ()
			       (unless (== process.platform (string "darwin"))
				   (app.quit)))
			     )
		     (app.on (string "activate")
			     (lambda ()
			       ;; for macos re-create window when dock icon is clicked and no other window open
			       (when (=== (dot BrowserWindow
					       (getAllWindows)
					       length)
					  0)
				 (createWindow)))
			     )))
    (write-source (format nil "~a/app/renderer" *path*)
		  `(let ((webview (document.querySelector (string "webview")))
			 (button (document.querySelector (string ".alert")) :type const)
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
		     
		     (webview.addEventListener
		      (string "dom-ready")
		      (lambda ()
			(let ((currenURL (webview.getURL))
			      (title (webview.getTitle)))
			  (console.log
			   (+ (string "currentURL=")
			      currentURL))
			  (console.log
			   (+ (string "title=")
			      title))
			  (dot (webview.executeJavaScript
			    (string-backtick "function gethtml(){
return new Promise((resolve,reject)=>{resolve(document.documentElement.innerHTML);});}
gethtml();"))
			       (then (lambda (html)
				       (console.log html)))))))

		     
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





