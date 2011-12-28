;;;; srfi-5.lisp

(cl:in-package :srfi-5-internal)

(def-suite srfi-5)

(in-suite srfi-5)

;; Use your own standard let.
;; Or call a lambda.
;; (define-syntax standard-let
;;
;;   (syntax-rules ()
;;
;;     ((let ((var val) ...) body ...)
;;      ((lambda (var ...) body ...) val ...))))

(define-syntax let

  (syntax-rules (:false)

    ;; No bindings: use standard-let.
    ((let () body ***)
     (cl:let () body ***))
    ;; Or call a lambda.
    ;; ((lambda () body ***))

    ;; All standard bindings: use standard-let.
    ((let ((var val) ***) body ***)
     (cl:let ((var val) ***) body ***))
    ;; Or call a lambda.
    ;; ((lambda (var ***) body ***) val ***)

    ;; One standard binding: loop.
    ;; The all-standard-bindings clause didn't match,
    ;; so there must be a rest binding.
    ((let ((var val) . bindings) body ***)
     (let-loop :false bindings (var) (val) (body ***)))

    ;; Signature-style name: loop.
    ((let (name binding ***) body ***)
     (let-loop name (binding ***) () () (body ***)))

    ;; defun-style name: loop.
    ((let name bindings body ***)
     (let-loop name bindings () () (body ***)))))

(define-syntax let-loop

  (syntax-rules (:false)

    ;; Standard binding: destructure and loop.
    ((let-loop name ((var0 val0) binding ***) (var ***     ) (val ***     ) body)
     (let-loop name (            binding ***) (var *** var0) (val *** val0) body))

    ;; Rest binding, no name: use standard-let, listing the rest values.
    ;; Because of let's first clause, there is no "no bindings, no name" clause.
    ((let-loop :false (rest-var rest-val ***) (var ***) (val ***) body)
     (cl:let ((var val) *** (rest-var (list rest-val ***))) . body))
    ;; Or call a lambda with a rest parameter on all values.
    ;; ((lambda (var *** . rest-var) . body) val *** rest-val ***))
    ;; Or use one of several other reasonable alternatives.

    ;; No bindings, name: call a letrec'ed lambda.
    ((let-loop name () (var ***) (val ***) body)
     (labels ((name (var ***)
                (declare (optimize (debug 0) (space 3)))
                . body))
       (name val ***)))

    ;; Rest binding, name: call a letrec'ed lambda.
    ((let-loop name (rest-var rest-val ***) (var ***) (val ***) body)
     (labels ((name (var *** . rest-var)
                (declare (optimize (debug 0) (space 3)))
                . body))
       (name val *** rest-val ***)))))

;;
(test let
  (is (= (let fact1 ((x 10) (acc 1))
              (if (zerop x)
                  acc
                  (fact1 (1- x) (* acc x))))
         3628800))
  (is (= (let (fact1 (x 10) (acc 1))
           (if (zerop x)
               acc
               (fact1 (1- x) (* acc x))))
         3628800)))
