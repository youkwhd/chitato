(defpackage :chitato
  (:use :common-lisp)
  (:export :main))

(in-package :chitato)
(require :cl-charms)

(defun main ()
  (format t "Hello, Common Lisp!~%"))
