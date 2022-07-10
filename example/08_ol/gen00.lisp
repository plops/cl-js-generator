(eval-when (:compile-toplevel :execute :load-toplevel)
  (mapc #'ql:quickload `("cl-js-generator"
			 "cl-who")))

(in-package :cl-js-generator)

(setq cl-who:*attribute-quote-char* #\")
(setf cl-who::*html-mode* :html5)

(progn
  (defparameter *repo-sub-path* "08_ol")
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
	   (:link :rel "icon"
		  :href "data:;base64,=")
	   (:meta :name "viewport"
		  :content "width=device-width, initial-scale=1.0")
	   (:link :rel "stylesheet"
		  :href "out.css"
		  :type "text/css")
	   (:title "openlayers with esbuild")
	   )
	  (:body
	   (:div :id "map")
	   (:script :type "module"
		    :src "./out.js"))))))
    (defun lprint (&key (msg "") (vars `()))
      `(console.log
	(string-backtick
	 ,(format nil "~a ~{~a~^, ~}"
		  msg
		  (loop for v in vars
			collect
			(format nil "~a=${~a}" v v))))))
    (write-source (format nil "~a/source/main" *path*)
		  `(do0
		    "import './style.css'"
		    "import {Map, View} from 'ol'"
		    "import TileLayer from 'ol/layer/Tile'"
		    "import OSM from 'ol/source/OSM'"
		    (let ((map (new (Map (dictionary :target (string "map")
						     :layers (list (new (TileLayer (dictionary :source (new OSM)))))
						     :view (new (View (dictionary :center (list 0 0)
										  :zoom 2))))))
			    :type const)))))
    ))





