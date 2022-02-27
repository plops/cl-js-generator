(eval-when (:compile-toplevel :execute :load-toplevel)
  (mapc #'ql:quickload `("cl-js-generator"
			 "cl-who")))

(in-package :cl-js-generator)

(setq cl-who:*attribute-quote-char* #\")
(setf cl-who::*html-mode* :html5)


(progn
  (defparameter *repo-sub-path* "05_video")
  (defparameter *path* (format nil "/home/martin/stage/cl-js-generator/example/~a" *repo-sub-path*))
  (defparameter *inspection-facts*
    `((10 "")))
  (defparameter *day-names*
    '("Monday" "Tuesday" "Wednesday"
      "Thursday" "Friday" "Saturday"
      "Sunday"))
  
  (let* ()
    ;;https://api.nasdaq.com/api/quote/INTC/realtime-trades?&limit=5
    
    (with-open-file (s (format nil "~a/source/index.html" *path*)
		       :direction :output
		       :if-exists :supersede
		       :if-does-not-exist :create)
      (cl-who:with-html-output (s nil :prologue t :indent t)
	(cl-who:htm
	 (:html
	  (:head
	   (:script :type "text/javascript"
		    :src
		    "get_video.js"
		    ;; "get_video_compiled.js"
		    )
	   #+nil (:link :rel "stylesheet"
		  :href "style.css"
		  :type "text/css")
	   (:meta :charset "UTF-8")
	   
	   (:title "video test"))
	  (:body
	   "cam:"
	   (:video :id "cam")
	   "mod:"
	   (:video :id "mod")
	   (:script
	    "start()")
	   )))))
    (defun lprint (&key (msg "") (vars `()))
      `(console.log (string-backtick ,(format nil "~a ~{~a~^, ~}"
					     msg
					     (loop for v in vars
						   collect
						   (format nil "~a=${~a}" v v))))))
    (write-source (format nil "~a/source/get_video" *path*)
		  `(let ((W 640)
			 (H 480))

		     (space async
		      (defun start ()
			(console.log (string "hello"))
			(let ((cam (aref
				    (dot (paren (space await
						       (dot navigator
							    mediaDevices
							    (enumerateDevices))))
					 (filter (lambda (device)
						   (return
						     (=== device.kind
							  (string "videoinput"))))))
				    0))
			      ((curly deviceId)
			       cam))
			  ,(lprint :vars `(deviceId))
			  (let ((constraints (dictionary
					      :audio false
					      :video
					      (dictionary
					       :width W
					       :height H
					       :deviceId deviceId)))
				(camStream (await
					    (dot navigator
						 mediaDevices
						 (getUserMedia constraints))))
				(camVideoTag (document.getElementById (string "cam")))
				)
			    ,(lprint :vars `(camStream))
			    (setf camVideoTag.srcObject camStream)
			    ,(lprint :vars `(camVideoTag))
			    (let (((list videoTrack) (dot camStream
							  (getVideoTracks)))
				  (trackProcessor (new (MediaStreamTrackProcessor
							(dictionary :track videoTrack))))
				  (trackGenerator (new (MediaStreamTrackGenerator
							(dictionary :kind (string "video"))))))
			      ,(lprint :vars `(videoTrack))
			      (dot trackPocessor 
				   readable
				   (pipeThrough transformer)
				   (pipeTo trackGenerator.writable))
			      (let ((streamAfter (new (MediaStream (list trackGenerator))))
				    (modVideoTag (dot document
						      (getElementById (string "mod")))))
				(setf modVideoTag.srcObject
				      streamAfter)))))))
		     ))
    ))




