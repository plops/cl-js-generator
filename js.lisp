;; sudo pacman -S python-jsbeautifier
;; https://blog.glyphobet.net/essay/2557/
;; https://jlongster.com/Outlet--My-Lisp-to-Javascript-Experiment
;; https://github.com/jlongster/outlet
;; https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures

;; lambda
;; setf
;; 10 use this to define def
;; 20 missing arguments are undefined, extra are in 'arguments' object

;; 30 semicolon separates statements

;; 40 global scope is shared between all js files (use anonymous function
;; to separate). in js the single way to create scope is a new
;; function

;; 50 variables can be defined anywhere but the declaration is 'hoisted'
;; to the beginning -> i think i should expose this

;; 60 assign methods to object's prototype, don't forget new!

;; 70 the keyword 'this' usually refers to the object before the point but
;; can be changed with apply and call; the global object of the browser is called `window`

;; http://asmjs.org/spec/latest/

;; https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Strict_mode
;; communication to webworker https://developer.mozilla.org/en-US/docs/Web/API/Window/postMessage

;; https://developer.mozilla.org/en-US/docs/Web/JavaScript/A_re-introduction_to_JavaScript

;; 11 lambdas can have a name for recursive function calls

;; 80 rest arguments look like this: `function trivialNew(constructor, ...args) {`

;; 90 i think i have to introduce let (using call to unnamed lambda)

;; 100 the user program must be in package cl-js-generator (or i have to export all possible symbols)

(in-package #:cl-js-generator)
(setf (readtable-case *readtable*) :invert)

(defparameter *file-hashes* (make-hash-table))


(defun write-source (name code &optional (dir (user-homedir-pathname)))
  (let* ((fn (merge-pathnames (format nil "~a.js" name)
			      dir))
	(code-str (emit-js
		   :clear-env t
		   :code code))
	(fn-hash (sxhash fn))
	 (code-hash (sxhash code-str)))
    (multiple-value-bind (old-code-hash exists) (gethash fn-hash *file-hashes*)
     (when (or (not exists) (/= code-hash old-code-hash))
       ;; store the sxhash of the c source in the hash table
       ;; *file-hashes* with the key formed by the sxhash of the full
       ;; pathname
       (setf (gethash fn-hash *file-hashes*) code-hash)
       (with-open-file (s fn
			  :direction :output
			  :if-exists :supersede
			  :if-does-not-exist :create)
	 (write-sequence code-str s))
       (sb-ext:run-program "/usr/bin/js-beautify" (list "-r" (namestring fn)))))))


(defun beautify-source (code)
  (let* ((code-str (emit-js
		   :clear-env t
		   :code code)))
    (with-input-from-string (s code-str)
      (with-output-to-string (o)
	(sb-ext:run-program "/usr/bin/js-beautify" (list "-i") :input s :output o :wait t)))))

#+nil
(beautify-source '(setf a 3))

(defun print-sufficient-digits-f64 (f)
  "print a double floating point number as a string with a given nr. of
  digits. parse it again and increase nr. of digits until the same bit
  pattern."
  (let* ((ff (coerce f 'double-float))
	 (s (format nil "~E" ff)))
    #+nil (assert (= 0d0 (- ff
			    (read-from-string s))))
    (assert (< (abs (- ff
		       (read-from-string s)))
	       1d-12))
   (substitute #\e #\d s)))

;(print-sufficient-digits-f64 1d0)


(defparameter *env-functions* nil)
(defparameter *env-macros* nil)





(defun test ()
 (loop for e in `((dot bla woa fup)
		  (setf a 3)
		  (do (setf a 3
			    b 4))
		  (do bla
		      fuoo)
		  (dict (a 1) (b 2))
		  (def bla (foo) (setf x 1))
		  (def bla (foo &key (bla 3) (foo 4)) (setf x 1))
		  (def bla (foo &rest rest) (setf x 1))
		  (lambda (x y) (+ x y))
		  (if (== a 3)
		      (setf b 3)
		      (setf q 3))
		  (if (== a 4)
		      (setf b 4))
		  (for-in (p alph) (setf a p))
		  (for-of (o (foo)) (setf o 3))
		  (dotimes (i n) (setf a i))
		  (let-decl a 3)
		  (var-decl b 3)
		  (const-decl c 3)
		  (let ((a 3))
		    )
		  (dot (bla)
		       (then
			(lambda ()
			  (return
			    (=== a 3)))))
		  (getUserMedia :video true :audio false)
		  )
      and i from 0
    do
      (format t "~d:~%~a~%" i
	      
	      (emit-js :code e)
	      ;(beautify-source e)
	      )))

#+nil
(test)

(defun emit-js (&key code (str nil) (clear-env nil) (level 0))
					;(format t "emit ~a ~a~%" level code)
  (when clear-env
    (setf *env-functions* nil
	  *env-macros* nil))
  (flet ((emit (code &optional (dl 0))
	   (emit-js :code code :clear-env nil :level (+ dl level))))
    (if code
	(if (listp code)
	    (case (car code)
	      (paren (let ((args (cdr code)))
		       (format nil "(~{~a~^, ~})" (mapcar #'emit args))))
	      (curly (let ((args (cdr code)))
		       (format nil "{~{~a~^, ~}}" (mapcar #'emit args))))
	      (list (let ((args (cdr code)))
		      (format nil "[~{~a~^, ~}]" (mapcar #'emit args))))
              (dict (let* ((args (cdr code)))
		      (let ((str (with-output-to-string (s)
				   (loop for (e f) in args
				      do
					(format s "~a:(~a)," (emit e) (emit f))))))
			(format nil "{~a}" ;; remove trailing comma
				(subseq str 0 (- (length str) 1))))))
	      (dictionary (let* ((args (cdr code)))
			    (format nil "~a"
				    (emit `(curly ,@(loop for (e f) on args by #'cddr
							  collect
							  (format nil "~a: (~a)" (emit e) (emit f))))))))
	      (space
		   ;; space {args}*
		   (let ((args (cdr code)))
		     (format nil "~{~a~^ ~}" (mapcar #'emit args))))
	      (await (let ((args (cdr code)))
		       (format nil "~a" (emit `(space "await"
						      ,@args)))))
	      (async (let ((args (cdr code)))
		       (format nil "~a" (emit `(space "async"
						      ,@args)))))
	      (indent (format nil "~{~a~}~a"
			      (loop for i below level collect "    ")
			      (emit (cadr code))))
	      (statement (with-output-to-string (s)
			   (format s "~{~a;~%~}" (mapcar #'(lambda (x) (emit `(indent ,x))) (cdr code)))))
	      (new
		   ;; new arg
		   (let ((arg (cadr code)))
		     (format nil "new ~a" (emit arg))))
	      (do (with-output-to-string (s)
		    (format s "~{~a~}" (mapcar #'(lambda (x) (emit `(statement ,x) 1)) (cdr code)))))
	      (progn (with-output-to-string (s)
			   ;; progn {form}*
			   ;; like do but surrounds forms with braces.
			   (format s "{~{~&~a~}~&}" (mapcar #'(lambda (x) (emit `(indent (do0 ,x)) 1)) (cdr code)))))
	      (do0 (with-output-to-string (s)
		     (format s "~a~%~{~a~%~}"
			     (emit (cadr code))
			     (mapcar #'(lambda (x) (emit `(indent ,x) 0)) (cddr code)))))
	      (lambda (format nil "~a" (emit `(defun "" ,@(cdr code)))))
	      
	      (defun (destructuring-bind (name lambda-list &rest body) (cdr code)
		     (multiple-value-bind (req-param opt-param res-param
						     key-param other-key-p aux-param key-exist-p)
			 (parse-ordinary-lambda-list lambda-list)
		       (declare (ignorable req-param opt-param res-param
					   key-param other-key-p aux-param key-exist-p))
		       (with-output-to-string (s)
			 ;; function bla (para) {
			 ;; function bla (para, ...rest) {
			 ;; function bla ({ from = 0, to = this.length } = {}) {
			 (format s "function ~a~a"
				 name
				 (emit `(paren ,@(append req-param
							 (when key-param
							   `((setf (dict
								    ,@(loop for e in key-param collect
									   (destructuring-bind ((keyword-name name) init suppliedp)
									       e
									     (declare (ignorable keyword-name suppliedp))
									     `(,name ,init))))
								   "{}")))
							 (when res-param
							   (list (format nil "...~a" res-param)))))))
			 (format s "{~a}" (emit `(do ,@body)))))))
	      (defclass (let ((args (cdr code)))
			  (destructuring-bind (name &rest rest) args
			   (emit `(space ,(format nil "class ~a" name)
				    (progn ,@rest))))))
	      (defmethod (destructuring-bind (name lambda-list &rest body) (cdr code)
		     (multiple-value-bind (req-param opt-param res-param
						     key-param other-key-p aux-param key-exist-p)
			 (parse-ordinary-lambda-list lambda-list)
		       (declare (ignorable req-param opt-param res-param
					   key-param other-key-p aux-param key-exist-p))
		       (with-output-to-string (s)
			 ;; function bla (para) {
			 ;; function bla (para, ...rest) {
			 ;; function bla ({ from = 0, to = this.length } = {}) {
			 (format s "~a~a"
				 name
				 (emit `(paren ,@(append req-param
							 (when key-param
							   `((setf (dict
								    ,@(loop for e in key-param collect
									   (destructuring-bind ((keyword-name name) init suppliedp)
									       e
									     (declare (ignorable keyword-name suppliedp))
									     `(,name ,init))))
								   "{}")))
							 (when res-param
							   (list (format nil "...~a" res-param)))))))
			 (format s "{~a}" (emit `(do ,@body)))))))
	      (in (destructuring-bind (a b) (cdr code)
		    (format nil "(~a in ~a)" (emit a) (emit b))))
	      (= (destructuring-bind (a b) (cdr code)
		   (format nil "~a=~a" (emit a) (emit b))))
	      (incf (destructuring-bind (a b) (cdr code)
		   (format nil "~a+=~a" (emit a) (emit b))))
	      (setf (let ((args (cdr code)))
		      (format nil "~a"
			      (emit `(,(if (eq (length args) 2)
					   `do0
					   `statement)
				       ,@(loop for i below (length args) by 2 collect
					      (let ((a (elt args i))
						    (b (elt args (+ 1 i))))
						`(= ,a ,b))))))))
	      (let-decl (destructuring-bind (var init-form) (cdr code)
			  (format nil "let ~a"
				  (emit `(statement (setf ,var ,init-form))))))
	      (var-decl (destructuring-bind (var init-form) (cdr code)
			  (format nil "var ~a"
				  (emit `(statement (setf ,var ,init-form))))))
	      (const-decl (destructuring-bind (var init-form) (cdr code)
			  (format nil "const ~a"
				  (emit `(statement (setf ,var
							  ,init-form))))))
	      ;; global, don't enclose in function
	      (let (destructuring-bind (decls &rest body) (cdr code)
		     (format nil "~a"
			     (emit `(statement
				     ,@(loop for d in decls collect
					    (destructuring-bind (name val &key (type 'let)) d
					      (ecase type
						(let `(let-decl ,name ,val))
						(var `(var-decl ,name ,val))
						(const `(const-decl ,name ,val))
						(t (break "unknown type in let")))))
				     ,@body)))))
	      (let-l (destructuring-bind (decls &rest body) (cdr code)
		     (format nil "~a"
			     (emit `(statement ((paren
						 (lambda ()
						   ,@(loop for d in decls collect
							  (destructuring-bind (name val &key (type 'let)) d
							    (ecase type
							      (let `(let-decl ,name ,val))
							      (var `(var-decl ,name ,val))
							      (const `(const-decl ,name ,val))
							      (t (break "unknown type in let")))))
						   ,@body))))))))
	      (aref (destructuring-bind (name &rest indices) (cdr code)
		      (format nil "~a[~{~a~^,~}]" (emit name) (mapcar #'emit indices))))
	      (slice (let ((args (cdr code)))
		       (if (null args)
			   (format nil ":")
			   (format nil "~{~a~^:~}" (mapcar #'emit args)))))
	      (dot (let ((args (cdr code)))
		     (format nil "~{~a~^.~}" (mapcar #'emit args))))
	      (+ (let ((args (cdr code)))
		   (format nil "(~{(~a)~^+~})" (mapcar #'emit args))))
	      (- (let ((args (cdr code)))
		   (format nil "(~{(~a)~^-~})" (mapcar #'emit args))))
	      (* (let ((args (cdr code)))
		   (format nil "(~{(~a)~^*~})" (mapcar #'emit args))))
	      (== (let ((args (cdr code)))
		    (format nil "(~{(~a)~^==~})" (mapcar #'emit args))))
	      (=== (let ((args (cdr code)))
		     (format nil "(~{(~a)~^===~})" (mapcar #'emit args))))
	      (!= (let ((args (cdr code)))
		    (format nil "(~{(~a)~^!=~})" (mapcar #'emit args))))
	      (< (let ((args (cdr code)))
		   (format nil "(~{(~a)~^<~})" (mapcar #'emit args))))
	      (<= (let ((args (cdr code)))
		    (format nil "(~{(~a)~^<=~})" (mapcar #'emit args))))
	      (/ (let ((args (cdr code)))
		   (format nil "((~a)/(~a))"
			   (emit (first args))
			   (emit (second args)))))
	      (** (let ((args (cdr code)))
		    (format nil "((~a)**(~a))"
			    (emit (first args))
			    (emit (second args)))))
	      (// (let ((args (cdr code)))
		    (format nil "((~a)//(~a))"
			    (emit (first args))
			    (emit (second args)))))
	      (% (let ((args (cdr code)))
		   (format nil "((~a)%(~a))"
			   (emit (first args))
			   (emit (second args)))))
	      (and (let ((args (cdr code)))
		     (format nil "(~{(~a)~^ && ~})" (mapcar #'emit args))))
	      (or (let ((args (cdr code)))
		    (format nil "(~{(~a)~^ || ~})" (mapcar #'emit
							   args))))
	      (logior (let ((args (cdr code)))
		    (format nil "(~{(~a)~^ | ~})" (mapcar #'emit
							   args))))
	      (not (let ((args (cdr code)))
		    (format nil "(!(~a))" (emit (car args)))))
	      (string (format nil "\"~a\"" (cadr code)))
	      (string-backtick (format nil "`~a`" (cadr code)))
	      (return_ (format nil "return ~a" (emit (caadr code))))
	      (return (let ((args (cdr code)))
			(format nil "~a" (emit `(return_ ,args)))))
	      (for (destructuring-bind ((start end iter) &rest body) (cdr code)

		     ;;  for(count = 0; count < 10; count++){
		     (with-output-to-string (s)
		       (format s "for(~a ; ~a; ~a){~%"
			       (emit start)
			       (emit end)
			       (emit iter))
		       (format s "~a}" (emit `(do ,@body))))))
	      (dotimes (destructuring-bind ((start end) &rest body) (cdr code)
			 ;;  for(count = 0; count < 10; count++){
			 (with-output-to-string (s)
			   (format s "~a"
				   (emit `(for ((setf ,start 0) (< ,start ,end) (setf start (+ 1 start)))
					       ,@body))))))
	      (for-in (destructuring-bind ((vs ls) &rest body) (cdr code)
			;; for (var property1 in object1) {
			(with-output-to-string (s)
			  (format s "for (var ~a in ~a){~%"
				  (emit vs)
				  (emit ls))
			  (format s "~a}" (emit `(do ,@body))))))
	      (for-of (destructuring-bind ((vs ls) &rest body) (cdr code)
			;; for (let o of foo) {
			(with-output-to-string (s)
			  (format s "for (let ~a of ~a){~%"
				  (emit vs)
				  (emit ls))
			  (format s "~a}" (emit `(do ,@body))))))

	      (if (destructuring-bind (condition true-statement &optional false-statement) (cdr code)
		    (with-output-to-string (s)
		      (format s "if ( ~a )~%{~a}"
			      (emit condition)
			      (emit `(do ,true-statement)))
		      (when false-statement
			(format s "~a~%{~a}"
				(emit `(indent "else"))
				(emit `(do ,false-statement)))))))
	      (when (destructuring-bind (condition &rest forms) (cdr code)
			  (emit `(if ,condition
				     (do0
				      ,@forms)))))

	      (? (destructuring-bind (condition true-expr false-expr)
		     (cdr code)
		    (with-output-to-string (s)
		      (format s "~a ? ~a : ~a"
			      (emit `(paren ,condition))
			      (emit `(paren ,true-expr))
			      (emit `(paren ,false-expr))))))
	      #+nil
	      (import (destructuring-bind (args) (cdr code)
			(if (listp args)
			    (format nil "import ~a as ~a~%" (second args) (first args))
			    (format nil "import ~a~%" args))))
	      #+nil
	      (imports (destructuring-bind (args) (cdr code)
			 (format nil "~{~a~}" (mapcar #'(lambda (x) (emit `(import ,x))) args))))
	      #+nil (with (destructuring-bind (form &rest body) (cdr code)
			    ;; i should not use with
			    (with-output-to-string (s)
			      (format s "~a~a:~%~a"
				      (emit "with ")
				      (emit form)
				      (emit `(do ,@body))))))
	      #+nil
	      (try (destructuring-bind (prog &rest exceptions) (cdr code)
		     (with-output-to-string (s)
		       (format s "~a:~%~a"
			       (emit "try")
			       (emit `(do ,prog)))
		       (loop for e in exceptions do
			    (destructuring-bind (form &rest body) e
			      (format s "~a~%"
				      (emit `(indent ,(format nil "except ~a:" (emit form)))))
			      (format s "~a" (emit `(do ,@body))))))))
	      (t (destructuring-bind (name &rest args) code
		   (let* ((positional (loop for i below (length args) until (keywordp (elt args i)) collect
					   (elt args i)))
			  (plist (subseq args (length positional)))
			  (props (loop for e in plist by #'cddr collect e)))
		     (format nil "~a~a" (if (listp name) (emit name)
					    name)
			     (if (and (listp props) (< 0 (length props)))
			      (emit `(paren ,@(append
					       positional
					       (list `(dict
						       ,@(loop for e in props collect
							      `(,(format
								  nil "~a" e) ,(getf plist e))))))))
			      (emit `(paren ,@positional))))))))
	    (cond
	      ((or (symbolp code)
		   (stringp code)) ;; print variable
	       (format nil "~a" code))
	      ((numberp code) ;; print constants
	       (cond ((integerp code) (format str "~a" code))
		     ((floatp code)
		      (format str "(~a)" (print-sufficient-digits-f64 code)))
		     ((complexp code)
		      (format str "((~a) + 1j * (~a))"
			      (print-sufficient-digits-f64 (realpart code))
			      (print-sufficient-digits-f64 (imagpart code))))))))
	"")))


