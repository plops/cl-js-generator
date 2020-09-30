(eval-when (:compile-toplevel :execute :load-toplevel)
  (mapc #'ql:quickload `("cl-js-generator"
			 "cl-who")))

(in-package :cl-js-generator)

(setq cl-who:*attribute-quote-char* #\")
(setf cl-who::*html-mode* :html5)


;; bookmark list application from Steve Kinney: Electron in Action p. 18
;; https://github.com/electron-in-action/bookmarker

;; mkdir app
;; touch app/main.js app/renderer.js app/style.css app/index.html
;; git add app/main.js app/renderer.js app/style.css app/index.html
;; npm init
;; -- answer a bunch of questions
;; npm install electron --save
;; -- add start script to package.json
;; npm start
;;  sudo npm install -g js-beautify
(progn
  (defparameter *repo-sub-path* "02_electron")
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
      (cl-who:with-html-output (s nil)
	(cl-who:htm
	 (:html
	  (:head
	   (:meta :charset "UTF-8")
	   ;; https://stackoverflow.com/questions/63427191/security-warning-in-the-console-of-browserwindow-electron-9-2-0
	   (:meta :http-equiv "Content-Security-Policy"
			:content "default-src 'self'; script-src 'self' 'unsafe-inline'; connect-src *")
	   (:meta :name "viewport"
		  :content "width=device-width,initial-scale=1")
	   (:title "bookmarker"))
	  (:body
	   (:h1 "Hello from Electron")
	   (:p (:button :class "alert"
			"current directory"))
	   (:script "require('./renderer');"
		    #+nil "const button=document.querySelector('.alert');
button.addEventListener('click',()=>{alert(\"hello\");});"))))))
    (write-source (format nil "~a/app/main" *path*)
		  `(let (("{app, BrowserWindow}" (require (string "electron")) :type const)
			 (mainWindow null))
		     (app.on (string "ready")
			     (lambda ()
			       (console.log (string "hello from electron"))
			       (console.log (string-backtick "file://${__dirname}/index.html"))
 
			       (setf mainWindow (new (BrowserWindow "{webPreferences: { worldSafeExecuteJavaScript: true }}")))
			       (mainWindow.webContents.loadURL (string-backtick "file://${__dirname}/index.html"))))))
    (write-source (format nil "~a/app/renderer" *path*)
		  `(let ((button (document.querySelector (string ".alert")) :type const)
			 )
		     (button.addEventListener (string "click")
					      (lambda ()
						(alert (string "bla"))))))))





