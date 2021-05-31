;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-
(declaim (optimize (speed 0) (safety 3) (debug 3)))

(in-package :org-ckons-serializable)

(defclass serializable ()
  ()
  (:documentation "Provides class serialization and deserialization."))

(defmacro with-all-slots-to-list (serializable &body body)
  "Iterates over all the slots of `serializable' and builds an alist
based on those slots."
  `(remove-if 'null (mapcar (lambda (slot)
                              ,@body)
                            (org-ckons-core::map-slot-names ,serializable))))

(defmethod all-slots-value-list-no-nulls ((serializable serializable))
  (with-all-slots-to-list serializable
    (when (slot-value serializable slot)
      `(,slot . ,(slot-value serializable slot)))))

(defmethod all-slots-plist-no-nulls ((serializable serializable))
  (let ((slot-plist ()))
    (loop for slot in (all-slots-value-list-no-nulls serializable) do
         (setf slot-plist (append slot-plist `(,(intern (format nil "~a" (car slot)) :keyword) ,(cdr slot)))))
    slot-plist))

(defmethod serialize ((serializable serializable) &key (package-name (package-name #.*package*)))
  (let ((output (make-array '(0) :element-type 'character :fill-pointer 0 :adjustable t)))
    (with-output-to-string (stream output)
      (loop for field in (all-slots-plist-no-nulls serializable) do
           (princ " " stream)
           (prin1 field stream)))
    (format nil "(make-instance '~a::~a~a)" (string-upcase package-name) (type-of serializable) output)))

(defun deserialize (form)
  "`form' is a string representation of a `make-instance' form."
  (eval (read-from-string form)))
