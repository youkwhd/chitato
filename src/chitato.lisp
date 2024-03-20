(defpackage :chitato
  (:use :common-lisp)
  (:export :main))

(in-package :chitato)

(require :cl-charms)
(load "src/board.lisp")

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
           (charms:move-cursor-up stdwin))
          ((#\a)
           (charms:move-cursor-left stdwin))
          ((#\s)
           (charms:move-cursor-down stdwin))
          ((#\d)
           (charms:move-cursor-right stdwin))
          ((#\q)
           (charms:finalize)
           (sb-ext:exit)))))))
