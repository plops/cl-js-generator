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

		     (defun sat (val)
		       (when (< 255 val)
			 (return 255))
		       (when (< val 0)
			 (return 0))
		       (return (logior val
				       "0x00")))

		     (let ((bufferYUV (new (Uint8Array (/ (* 3 W H)
							  2))))
			   (bufferRGBA (new (Uint8Array (* W H 4))))
			   (transformer
			    (new (TransformStream
				  (curly
				   (space async transform (paren videoFrame
						     controller)
					  (curly
					   (let ((copyResult (await (dot videoFrame
									 (copyTo bufferYUV))))
						 ((curly 
						   stride
						   "offset:Voffset")
						  (aref copyResult 1))
						 ((dictionary
						   :offset Uoffset)
						  (aref copyResult 2))
						 (xUV 0)
						 (yUV 0))
					     (dotimes (y H)
					       (do0
						(setf yUV (* stride (>> y 1)))
						(dotimes (x W)
						  (do0
						   (setf xUV (>> x 1))
						   (let ((Y (aref bufferYUV (+ x (* y W))))
							 (V (- (aref bufferYUV (+ Voffset xUV yUV))
							       128))
							 (U (- (aref bufferYUV (+ Uoffset xUV yUV))
							       128))
							 (R (sat (+ Y (* 1.370705 V))))
							 (G (sat (- Y (* 0.698001 V)
								    (* 0.337633 U))))
							 (B (sat (+ Y (* 1.732446 U)))))
						     (when (< (* .6 (+ R B))
							      G)
						       ,@(loop for e in `(R G B) and e-i from 0
							       collect
							       `(setf ,e Y 
								      #+nil (aref pixelData.data (+ ,e-i
											      (* x 4)
											      (* y 4 W))))))
						     ,@(loop for e in `(R G B 255)
							     and e-i from 0
							     collect
							     `(setf (aref bufferRGBA (+ ,e-i
											(* 4 x)
											(* 4 y W)))
								    ,e))
						     )))
						))


					     (do0
				    (init (dictionary :timestamp videoFrame.timestamp
						      :codedWidth W
						      :codedHeight H
						      :format (string "RGBA")))

				    
				    (newFrame (new (VideoFrame bufferRGBA
							       init)))

				    (videoFrame.close)

				    (controller.enqueue newFrame))
					     
					     )))

				   
				   

				   ))))
			   
			   
			   )
		       
		       )
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
					       :owheight H
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
			      (dot trackProcessor 
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





