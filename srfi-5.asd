;;;; srfi-5.asd

(cl:in-package :asdf)

(defsystem :srfi-5
  :serial t
  :depends-on (:fiveam :mbe)
  :components ((:file "package")
               (:file "srfi-5")))

(defmethod perform ((o test-op) (c (eql (find-system :srfi-5))))
  (load-system :srfi-5)
  (or (flet ((_ (pkg sym)
               (intern (symbol-name sym) (find-package pkg))))
         (let ((result (funcall (_ :fiveam :run) (_ :srfi-5-internal :srfi-5))))
           (funcall (_ :fiveam :explain!) result)
           (funcall (_ :fiveam :results-status) result)))
      (error "test-op failed") ))
