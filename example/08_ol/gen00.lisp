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
	   (:style "body { padding: 0; margin: 0; overflow: hidden};"
		   ".tick text { font-size: 24px; }")
	   (:script :type "text/javascript"
		    :src
		    "https://d3js.org/d3.v7.min.js")
	   (:script :type "text/javascript"
		    :src
		    "sketch.js")
	   (:link :rel "icon"
		  :href "data:;base64,=")
	   #+nil (:link :rel "stylesheet"
			:href "style.css"
			:type "text/css")
	   )
	  (:body
	   (:main
	    #+nil (:h1 "this is a d3 test")
	    #+nil (:p "this is a test paragraph. this is a test paragraph. this is a test paragraph. this is a test paragraph. this is a test paragraph. this is a test paragraph. this is a test paragraph. this is a test paragraph. this is a test paragraph. this is a test paragraph. this is a test paragraph. ")))))))
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
		    ; "import * as d3 from \"d3\""
		    #+nil (setf (space const (curly csv select scaleLinear
					      extent axisLeft axisBottom)
				 )
				d3)
		    "import {scaleLinear} from \"d3-scale\""
		    #+nil (space import (curly csv select scaleLinear
					 extent axisLeft axisBottom)
			   from
			   (string "./d3.v7.min"))
		    (defun tryScatter ()
		      (let ((csvUrl (string "iris.csv"
					    #+nil "/home/martin/stage/cl-js-generator/example/07_d3/https:/gist.github.com/netj/8836201/raw/6f9306ad21398ea43cba4f7d537619d0e07d5ae3/iris.csv")
			      :type const)
			    (parseRaw (lambda (d)
					,@(loop for e in `(sepal_width sepal_length
								       petal_length
								       petal_width)
						collect
						`(setf (dot d ,e) (space "+" (dot d ,e))))
					(return d)))
			    (xValue (lambda (d) (return (dot d petal_length)))
			      :type const)
			    (yValue (lambda (d) (return (dot d sepal_length)))
				    :type const)
			    (radius 5 :type const)
			    (main (space async
					 (lambda ()
					   (let ((data (space await (csv csvUrl parseRaw))
						   :type const)


						 (margin (dictionary
							  :top 20
							  :right 20
							  :bottom 40
							  :left 50))
						 (width window.innerWidth :type const)
						 (height window.innerHeight :type const)

						 (x (dot (scaleLinear)
							 (domain (extent data xValue))
							 (range (list margin.left (- width margin.right))))
						   :type const)
						 (y (dot (scaleLinear)
							 (domain (extent data yValue))
							 (range (list (- height margin.bottom) margin.top)))
						   :type const)
						 (marks (dot data
							     (map (lambda (d)
								    (return
								     (dictionary :x (x (xValue d))
										 :y (y (yValue d)))))))
						   :type const)
						 (svg (dot (select (string "body"))
							   (append (string "svg"))
							   ,@(loop for  e in `(width height)
								   collect
								   `(attr (string ,e)
									  ,e)))
						      :type const))
					     (dot
					      svg
					      (selectAll (string "circle"))
					      (data marks)
					      (join (string "circle"))
					      ,@(loop for  (e f) in `((cx (lambda (d) (return d.x)))
								      (cy (lambda (d) (return d.y)))
								      (r radius))
						      collect
						      `(attr (string ,e)
							     ,f)))
					     (dot
					      svg
					      (append (string "g"))
					      (attr (string "transform")
						    (string-backtick "translate(${margin.left},0)")
						    )
					      (call (axisLeft y)))
					     (dot
					      svg
					      (append (string "g"))
					      (attr (string "transform")
						    (string-backtick "translate(0,${height - margin.bottom})")
						    )
					      (call (axisBottom x))))))
			      :type const)
			    )
			(main)
			))
		    #+nil (defun tryd3 ()
			    (dot d3
					;(select (string "body"))
				 (selectAll (string "p"))
				 (style (string "color")
					(lambda () (return (+ (string "hsl(")
							      (* (Math.random)
								 360)
							      (string "100%,50%)")))))))
		    ;; https://blog.sentry.io/2016/01/04/client-javascript-reporting-window-onerror
		    (setf window.onerror
			  (lambda (msg src lineno colno error)
			    (when error
			      (alert (+ (string "error:")
					msg
					src lineno colno (JSON.stringify error))))
			    (return true)))
		    (setf window.onload
			  (lambda ()
			    (tryScatter)
			    #+nil (dot d3
				       (selectAll (string "p"))
				       (style (string "color")
					      (string "blue")))
			    #+nil (alert (string "page has loaded!"))))
		    
		    ))
    ))





