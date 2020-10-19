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
    ;;https://api.nasdaq.com/api/quote/INTC/realtime-trades?&limit=5
    
    (with-open-file (s (format nil "~a/app/index.html" *path*)
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
	   ;; https://stackoverflow.com/questions/63427191/security-warning-in-the-console-of-browserwindow-electron-9-2-0
	   (:meta :http-equiv "Content-Security-Policy"
			:content "default-src 'self' 'unsafe-inline'; script-src 'self' 'unsafe-inline'; connect-src *")
	   (:meta :name "viewport"
		  :content "width=device-width,initial-scale=1")
	   (:title "scraper"))
	  (:body
	   (:webview :style "min-height: 85vh;"
		     :src ;"https://youtube.com/"
		     "https://www.nasdaq.com/market-activity/stocks/intc/real-time"
		     ;"https://www.whatismybrowser.com/detect/what-is-my-user-agent"
		     :useragent "Tralala v1.2")
	   (:div :class "error-message")
	   
	   (:script "require('./renderer');"
		    #+nil "const button=document.querySelector('.alert');
button.addEventListener('click',()=>{alert(\"hello\");});"))))))
    (write-source (format nil "~a/app/main" *path*)
		  `(let (
			 ("{app, BrowserWindow}" (require (string "electron")) :type const)
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
					       (center true)
					       (show false)
					       (width 1450)
					       (height 600)
					       ;; https://github.com/electron/electron/issues/9920#issuecomment-575839738
					       
					        (webPreferences (dict
					;(contextIsolation true)
								 (worldSafeExecuteJavaScript true)
								 (nodeIntegration true)
								 (webviewTag true))))
					;"{webPreferences: { worldSafeExecuteJavaScript: true, nodeIntegration: true }}"
					      )))
		       
		       (mainWindow.webContents.openDevTools)
		       (mainWindow.webContents.loadURL (string-backtick "file://${__dirname}/index.html"))
		       (mainWindow.webContents.on
			(string "dom-ready")
			(lambda ()
			  (console.log (string "user-agent:")
				       (mainWindow.webContents.getUserAgent))
			  (mainWindow.webContents.openDevTools)
			  (mainWindow.maximize)
			  (mainWindow.show))
			))
		     (dot app
			  (whenReady)
			  (then createWindow))
		     #+nil (
		      (require (string "electron-reload"))
       	      __dirname)
		     
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
		  `(let ((webview (document.querySelector (string "webview"))
				  :type const)
			 (cheerio (require (string "cheerio"))
				  :type const)
			 )

		     (defun extractLinks (html)
		       (let ((h (cheerio.load html)
				:type const))
			 (dot (h (string "a"))
			      (each (lambda (i element)
				      ,(let ((l `((href (attr (string "href")))
						  (text (text)))))
					 `(do0
					   ,@(loop for (name code) in l collect
						   `(console.log
						     (+ (string ,(format nil "~a: " name))
							(dot (h element)
							     ,code)))))))))))
		     

		     (webview.addEventListener
		      (string "dom-ready")
		      (lambda ()
			(let ((currentURL (webview.getURL))
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
				       (extractLinks html)))))))
		     
		    ))))





