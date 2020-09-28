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
	  `(let ( (Logger  (require (string "./logger")) :type const)
		 (logger (new (Logger)) :type const)
		 ;(EventEmitter  (require (string "events")) :type const)
		 ; (emitter (new EventEmitter))
		 ;(path  (require (string "path")) :type const)
		  ;(os  (require (string "os")) :type const)
		 ,@(loop for e in `(path os fs http) collect
			`(,e  (require (string ,e)) :type const)))
	     
	     (logger.on (string "messageLogged")
			 (lambda (arg)
			   (console.log (string "listener called") arg)))

	     (let ((server (http.createServer) :type const))
	       (server.on (string "connection")
			  (lambda ()
			    (console.log (string "new connection ..."))))
	       (server.listen 3000)

	       (console.log (string "listening on port 3000 ..."))
	       )
	     (defun sayHello (name)
	       (logger.log (+ (string "hello")
			       name)))
	     (sayHello (string "Mosh")
		       )
	     #+nil(do0
	      (console.log module)
	      (console.log __filename)
	      (console.log __dirname)
	      (console.log (path.parse __filename))
	      ,@(loop for e in `(totalmem freemem) collect
		     `(console.log (string-backtick ,(format nil "~a ${os.~a()}" e e))))

	      (fs.readdir (string "./")
			  (lambda (err files)
			    (if err
				(console.log (string "Error") err)
				(console.log (string "Result") files)))))
	     
	     
	     )))
    (write-source (format nil "~a/source/~a" *path* *code-file*) code)

    (write-source (format nil "~a/source/~a" *path* "logger")
		  `(let ((url (string "http://mylogger.io/log"))
			 (EventEmitter  (require (string "events")) :type const)
			 ;(emitter (new EventEmitter))
			 )
		     (defclass "Logger extends EventEmitter"
			    (defmethod log (message)
			      (console.log message) 
			      
			      (this.emit (string "messageLogged")
					    (dict (id 1)
						  (url (string "http://")) ))))
		     (setf module.exports ; .log
			   Logger
					; module.exports.endPoint url
			   )))

    )))


 
