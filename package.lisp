;;;; package.lisp

(cl:in-package :cl-user)

(defpackage "https://github.com/g000001/srfi-5"
  (:use)
  (:export :let))

(defpackage "https://github.com/g000001/srfi-5#internals"
  (:use "https://github.com/g000001/srfi-5"
        :cl :fiveam :mbe)
  (:shadowing-import-from "https://github.com/g000001/srfi-5"
                          :let))

