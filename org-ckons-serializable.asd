;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-
(declaim (optimize (speed 0) (safety 3) (debug 3)))

(in-package :cl)

(defpackage :org-ckons-serializable-system (:use :cl :asdf))
(in-package :org-ckons-serializable-system)

(defmacro do-defsystem (&key name version maintainer author description long-description depends-on components)
  `(defsystem ,name
       :name ,name
       :version ,version
       :maintainer ,maintainer
       :author ,author
       :description ,description
       :long-description ,long-description
       :depends-on ,(eval depends-on)
       :components ,components))

(defparameter *quicklisp-packages* '())
(defparameter *asdf-packages* '(org-ckons-core))
(defparameter *all-packages* (append *quicklisp-packages* *asdf-packages*))

(loop for pkg in *quicklisp-packages* do
     (ql:quickload (symbol-name pkg)))

(do-defsystem :name "org-ckons-serializable"
              :version "1"
              :maintainer "Carlos Konstanski <me@ckons.org>"
              :author "Carlos Konstanski <me@ckons.org>"
              :description "org-ckons-serializable"
              :long-description "org-ckons-serializable is a library which provides HTML rendering functionality and a drakma HTTP client wrapper."
              :depends-on *all-packages*
              :components ((:module src
                            :components ((:file "package")
                                         (:file "generics" :depends-on ("package"))
                                         (:file "serializable" :depends-on ("generics"))))))
