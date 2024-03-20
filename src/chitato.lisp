(defpackage :chitato
  (:use :common-lisp)
  (:export :main))

(in-package :chitato)

(require :cl-charms)
(load "src/board.lisp")

(defparameter *x* 0)
(defparameter *y* 0)

(defun main ()
  (let ((stdwin (charms:initialize)))
    (charms:disable-echoing)
    (charms:enable-raw-input :interpret-control-characters t)
    (charms:enable-non-blocking-mode stdwin)

    (charms:clear-window stdwin)
    (charms:refresh-window stdwin)

    (draw-board stdwin +board+)

    ;; should decrement move up but there's already newline
    ;; printed from (draw-board), so no need.
    (charms:move-cursor-up stdwin :amount (* (length +board+) 2))
    (charms:move-cursor-right stdwin :amount 2)

    (loop
      (let ((ch (charms:get-char stdwin
                       :ignore-error t)))
        (case ch
          ((nil) nil)
          ((#\w)
           (when (> *y* 0)
             (charms:move-cursor-up stdwin :amount 2)
             (setq *y* (1- *y*))))
          ((#\a)
           (when (> *x* 0)
             (charms:move-cursor-left stdwin :amount 4)
             (setq *x* (1- *x*))))
          ((#\s)
           (when (< *y* (1- (length +board+)))
             (charms:move-cursor-down stdwin :amount 2)
             (setq *y* (1+ *y*))))
          ((#\d)
           (when (< *x* (1- (length (first +board+))))
             (charms:move-cursor-right stdwin :amount 4)
             (setq *x* (1+ *x*))))
          ((#\q)
           (charms:finalize)
           (sb-ext:exit)))))))
