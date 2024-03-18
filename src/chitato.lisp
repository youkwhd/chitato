(defpackage :chitato
  (:use :common-lisp)
  (:export :main))

(in-package :chitato)

(require :cl-charms)
(load "src/board.lisp")

(defun main ()
  (hello "Common Lisp"))
