(eval-when (:compile-toplevel :execute :load-toplevel)
  (ql:quickload "cl-js-generator"))

(in-package :cl-js-generator)


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
  (defparameter *source* (format nil "~a/source/~a" *path* *code-file*))
  (defparameter *inspection-facts*
    `((10 "")))
  (defparameter *day-names*
    '("Monday" "Tuesday" "Wednesday"
      "Thursday" "Friday" "Saturday"
      "Sunday"))

  
  (let* ()
    (write-source (format nil "~a/app/main" *path*)
		  `(let (("{app, BrowserWindow}" (require (string "electron")) :type const)
			 (mainWindow null))
		     (app.on (string "ready")
			     (lambda ()
			       (console.log (string "hello from electron"))
			       (setf mainWindow (new BrowserWindow))))))))





