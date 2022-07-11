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
  (defparameter *dir-num* "03")
  (defparameter *inspection-facts*
    `((10 "")))
  (defparameter *day-names*
    '("Monday" "Tuesday" "Wednesday"
      "Thursday" "Friday" "Saturday"
      "Sunday"))

  (let* ()
    (with-open-file (s (format nil "~a/source~a/index.html" *path* *dir-num*)
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
	   (:title "openlayers workshop geotiff")

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
    (write-source
     (format nil "~a/source~a/main" *path* *dir-num*)


     `(do0
       "import './style.css'"
       
       (imports (ol/source/GeoTIFF.js GeoTIFF)
		(ol/Map.js Map)
		(ol/proj/Projection.js Projection)
		(ol/layer/WebGLTile.js TileLayer)
		(ol/View.js View)
		(ol/extent.js "{getCenter}"))
       

       "// metadata from https://s3.us-west-2.amazonaws.com/sentinel-cogs/sentinel-s2-l2a-cogs/21/H/UB/2021/9/S2B_21HUB_20210915_0_L2A/S2B_21HUB_20210915_0_L2A.json"

       (let ((projection
	       (new (Projection
		     (dictionary
		      :code (string "EPSG:32721")
		      :units (string "m"))))
	       :type const)

	     (sourceExtent
	       (list 300000
		     6090260
		     409760
		     6200020)
	       :type const)
	     (source
	       (new (GeoTIFF
		     (dictionary
		      :sources
		      (list
		       (dictionary
			:url
			(string "TCI.tif"
					;"https://sentinel-cogs.s3.us-west-2.amazonaws.com/sentinel-s2-l2a-cogs/21/H/UB/2021/9/S2B_21HUB_20210915_0_L2A/TCI.tif"
			 ))))))
	       :type const)
	     
	     (layer (new (TileLayer
			  (dictionary :source source)))
		    :type const)
	     
	     (map
	       (new (Map
		     (dictionary
		      :target (string "map")
		      :layers (list layer)
		      :view (new
			     (View
			      (dictionary
			       :projection projection
			       :center
			       (getCenter sourceExtent)
			       :zoom 1))))))
	       :type const)))))
    ))


