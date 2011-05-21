;;;; package.lisp

(cl:in-package :cl-user)

(defpackage :srfi-5
  (:export :let))

(defpackage :srfi-5-internal
  (:use :srfi-5 :cl :fiveam :mbe)
  (:shadowing-import-from :srfi-5 :let))

