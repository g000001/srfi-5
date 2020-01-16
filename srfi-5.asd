;;;; srfi-5.asd

(cl:in-package :asdf)

(defsystem :srfi-5
    :version "1"
    :description "SRFI-5: A compatible let form with signatures and rest arguments"
    :long-description "SRFI-5: A compatible let form with signatures and rest arguments
https://srfi.schemers.org/srfi-5"
    :author "Andy Gaynor"
    :maintainer "CHIBA Masaomi"
    :serial t
    :depends-on (:fiveam :mbe)
    :components ((:file "package")
                 (:file "srfi-5")))

(defmethod perform :after ((o load-op) (c (eql (find-system :srfi-5))))
  (let ((name "https://github.com/g000001/srfi-5")
        (nickname :srfi-5))
    (if (and (find-package nickname)
             (not (eq (find-package nickname)
                      (find-package name))))
        (warn "~A: A package with name ~A already exists." name nickname)
        (rename-package name name `(,nickname)))))

(defmethod perform ((o test-op) (c (eql (find-system :srfi-5))))
  (or (flet ((_ (pkg sym)
               (intern (symbol-name sym) (find-package pkg))))
        (let ((result (funcall (_ :fiveam :run)
                               (_ "https://github.com/g000001/srfi-5#internals" :srfi-5))))
          (funcall (_ :fiveam :explain!) result)
          (funcall (_ :fiveam :results-status) result)))
      (error "test-op failed") ))
