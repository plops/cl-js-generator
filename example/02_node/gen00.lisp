(eval-when (:compile-toplevel :execute :load-toplevel)
  (ql:quickload "cl-js-generator"))

(in-package :cl-js-generator)


;; emerge -av wxpython


(progn
  (defparameter *repo-sub-path* "02_node")
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
	  `(let ((logger  (require (string "./logger")) :type const))
	    
	     (def sayHello (name)
	       (logger.log (+ (string "hello")
			       name)))
	     (sayHello (string "Mosh"))
	     (console.log module))))
    (write-source (format nil "~a/source/~a" *path* *code-file*) code)
    (write-source (format nil "~a/source/~a" *path* "logger")
		  `(let ((url (string "http://mylogger.io/log")))
		     (def log (message)
		       (console.log message))
		     ;; exports = log would export single function
		     (setf module.exports.log log
			  ; module.exports.endPoint url
			   )))))





