;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-
(declaim (optimize (speed 0) (safety 3) (debug 3)))

(in-package :org-ckons-serializable)

(defgeneric all-slots-value-list-no-nulls (serializable)
  (:documentation "Returns all slots of `record' as an alist. Not
  limited to field slots."))

(defgeneric all-slots-plist-no-nulls (serializable)
  (:documentation "Returns all slots of `record' as a plist. Not
limited to field slots."))

(defgeneric serialize (serializable &key package-name)
  (:documentation "Returns a string that, when read with
`read-from-string', will instantiate the `seializable' object."))
