(eval-when (:compile-toplevel :execute :load-toplevel)
  (mapc #'ql:quickload `("cl-js-generator"
			 "cl-who")))

(in-package :cl-js-generator)

(setq cl-who:*attribute-quote-char* #\")
(setf cl-who::*html-mode* :html5)

(progn
  (defparameter *repo-sub-path* "06_p5_js")
  (defparameter *path* (format nil "~a/stage/cl-js-generator/example/~a"
			       (user-homedir-pathname)
			       *repo-sub-path*))
  (defparameter *inspection-facts*
    `((10 "")))
  (defparameter *day-names*
    '("Monday" "Tuesday" "Wednesday"
      "Thursday" "Friday" "Saturday"
      "Sunday"))

  (let* ()
    (with-open-file (s (format nil "~a/source/00_first/index.html" *path*)
		       :direction :output
		       :if-exists :supersede
		       :if-does-not-exist :create)
      (cl-who:with-html-output (s nil :prologue t :indent t)
	(cl-who:htm
	 (:html
	  (:head
	   (:meta :charset "utf-8")
	   (:meta :name "viewport"
		  :content "width=device-width, initial-scale=1.0")
	   (:title "p5.js example 00")
	   (:style "body { padding: 0; margin: 0;}")
	   (:script :type "text/javascript"
		    :src
		    "../p5.min.js")
	   (:script :type "text/javascript"
		    :src
		    "sketch.js")
	   #+nil (:link :rel "stylesheet"
			:href "style.css"
			:type "text/css")
	   )
	  (:body
	   (:main))))))
    (defun lprint (&key (msg "") (vars `()))
      `(console.log
	(string-backtick
	 ,(format nil "~a ~{~a~^, ~}"
		  msg
		  (loop for v in vars
			collect
			(format nil "~a=${~a}" v v))))))
    (write-source (format nil "~a/source/00_first/sketch" *path*)
		  `(do0
		    (defun setup ()
		      (CreateCanvas 400 400))
		    (defun draw ()
		      (background 220)
		      (ellipse 50 50 80 80))
		    ))
    ))





