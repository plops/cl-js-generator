(eval-when (:compile-toplevel :execute :load-toplevel)
  (ql:quickload "cl-js-generator"))

(in-package :cl-js-generator)


;; emerge -av wxpython


(progn
  (defparameter *repo-sub-path* "01_electron")
  (defparameter *path* (format nil "/home/martin/stage/cl-js-generator/example/~a" *repo-sub-path*))
  (defparameter *code-file* "run_00_show")
  (defparameter *source* (format nil "~a/source/~a" *path* *code-file*))
  (defparameter *inspection-facts*
    `((10 "")))
  (defparameter *day-names*
    '("Monday" "Tuesday" "Wednesday"
      "Thursday" "Friday" "Saturday"
      "Sunday"))

  
  (let* ((code
	  `(let ((player (document.getElementById (string "player"))))
	     (def logger (message)
	       (if (== (string "object")
		       (typeof message))
		   (incf log.innnerHTML
			 (+ (? (and JSON
				    JSON.stringify)
			       (JSON.stringify message)
			       message)
			    (string "<br />")))
		   (incf log.innnerHTML
			 (+ message
			  (string "<br />"))))))))
    (write-source (format nil "~a/source/~a" *path* *code-file*) code)))





