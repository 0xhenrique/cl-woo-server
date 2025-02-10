(defsystem "cl-woo-server"
  :description "A simple web server using Woo"
  :author "Henrique"
  :license "AGPL"
  :version "0.1.0"
  :serial t
  :components ((:file "src/package.lisp")
               (:file "src/server.lisp ")))
