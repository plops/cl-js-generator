(asdf:defsystem cl-js-generator
    :version "0"
    :description "Emit Javascript code"
    :maintainer " <kielhorn.martin@gmail.com>"
    :author " <kielhorn.martin@gmail.com>"
    :licence "GPL"
    :depends-on ("alexandria")
    :serial t
    :components ((:file "package")
		 (:file "js")) )
