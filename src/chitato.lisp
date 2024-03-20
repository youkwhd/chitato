(defpackage :chitato
  (:use :common-lisp)
  (:export :main))

(in-package :chitato)

(require :cl-charms)
(load "src/player.lisp")
(load "src/board.lisp")

(defparameter *current-player* :o)
(defparameter *x* 0)
(defparameter *y* 0)

(defparameter *last-cursor-x* 0)
(defparameter *last-cursor-y* 0)

(defun main ()
  (let ((stdwin (charms:initialize)))
    (charms:disable-echoing)
    (charms:enable-raw-input :interpret-control-characters t)
    (charms:enable-non-blocking-mode stdwin)

    (charms:clear-window stdwin)
    (charms:move-cursor stdwin 0 0)
    (draw-board stdwin *board*)
    (charms:refresh-window stdwin)

    ;; should decrement move up but there's already newline
    ;; printed from (draw-board), so no need.
    (charms:move-cursor-up stdwin :amount (* (length *board*) 2))
    (charms:move-cursor-right stdwin :amount 2)

    (multiple-value-bind (x y)
      (charms:cursor-position stdwin)
      (setf *last-cursor-x* x)
      (setf *last-cursor-y* y))

    ;; TODO: wrap in a function
    (loop
      (let ((ch (charms:get-char stdwin
                       :ignore-error t)))
        (case ch
          ((nil) nil)
          ((#\w)
           (when (> *y* 0)
             (charms:move-cursor-up stdwin :amount 2)
             (setf *y* (1- *y*))))
          ((#\a)
           (when (> *x* 0)
             (charms:move-cursor-left stdwin :amount 4)
             (setf *x* (1- *x*))))
          ((#\s)
           (when (< *y* (1- (length *board*)))
             (charms:move-cursor-down stdwin :amount 2)
             (setf *y* (1+ *y*))))
          ((#\d)
           (when (< *x* (1- (length (first *board*))))
             (charms:move-cursor-right stdwin :amount 4)
             (setf *x* (1+ *x*))))
          ((#\space)
           (when (equal (nth *x* (nth *y* *board*)) :e)
             (setf (nth *x* (nth *y* *board*)) *current-player*)
             (setf *current-player* (change-player-turn *current-player*))

             (multiple-value-bind (x y)
               (charms:cursor-position stdwin)
               (setf *last-cursor-x* x)
               (setf *last-cursor-y* y))

             ;; TODO: wrap in a function
             (charms:clear-window stdwin)
             (charms:move-cursor stdwin 0 0)
             (draw-board stdwin *board*)
             (charms:refresh-window stdwin)

             (charms:move-cursor-up stdwin :amount (* (length *board*) 2))
             (charms:move-cursor-right stdwin :amount 2)

             (charms:move-cursor stdwin *last-cursor-x* *last-cursor-y*)))
          ((#\q)
           (charms:finalize)
           (sb-ext:exit)))))))
