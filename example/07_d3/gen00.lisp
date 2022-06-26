(eval-when (:compile-toplevel :execute :load-toplevel)
  (mapc #'ql:quickload `("cl-js-generator"
			 "cl-who")))

(in-package :cl-js-generator)

(setq cl-who:*attribute-quote-char* #\")
(setf cl-who::*html-mode* :html5)

(progn
  (defparameter *repo-sub-path* "07_d3")
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
    (with-open-file (s (format nil "~a/source/index.html" *path*)
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
	   (:title "d3 example 00")
	   (:style "body { padding: 0; margin: 0;}")
	   (:script :type "text/javascript"
		    :src
		    "https://d3js.org/d3.v7.min.js")
	   (:script :type "text/javascript"
		    :src
		    "sketch.js")
	   #+nil (:link :rel "stylesheet"
			:href "style.css"
			:type "text/css")
	   )
	  (:body
	   (:main
	    (:h1 "this is a d3 test")
	    (:p "this is a test paragraph. this is a test paragraph. this is a test paragraph. this is a test paragraph. this is a test paragraph. this is a test paragraph. this is a test paragraph. this is a test paragraph. this is a test paragraph. this is a test paragraph. this is a test paragraph. ")))))))
    (defun lprint (&key (msg "") (vars `()))
      `(console.log
	(string-backtick
	 ,(format nil "~a ~{~a~^, ~}"
		  msg
		  (loop for v in vars
			collect
			(format nil "~a=${~a}" v v))))))
    (write-source (format nil "~a/source/sketch" *path*)
		  `(do0
		    (defun tryd3 ()
		      (dot d3
			 ;(select (string "body"))
			 (selectAll (string "p"))
			 (style (string "color")
				(lambda () (return (+ (string "hsl(")
						      (* (Math.random)
							 360)
						      (string "100%,50%)")))))))

		    (setf window.onload
			  (lambda ()
			    (dot d3
			 ;(select (string "body"))
			 (selectAll (string "p"))
			 (style (string "color")
				(lambda () (return (+ (string "hsl(")
						      (* (Math.random)
							 360)
						      (string "100%,50%)"))))))
			    (alert (string "page has loaded!"))))
		    
		    ))
    ))





