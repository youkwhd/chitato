(defpackage :chitato
  (:use :common-lisp)
  (:export :main))

(in-package :chitato)

(require :cl-charms)
(load "src/player.lisp")
(load "src/board.lisp")

(defconstant +WIN-CHECK-RANGE+ 3)

(defparameter *current-player* :o)
(defparameter *x* 0)
(defparameter *y* 0)

(defparameter *last-cursor-x* 0)
(defparameter *last-cursor-y* 0)

(defun save-cursor-pos (curses-window)
  (multiple-value-bind (x y)
    (charms:cursor-position curses-window)
    (setf *last-cursor-x* x)
    (setf *last-cursor-y* y)))

;; TODO(refactor): These kind of function is so cursed
(defun draw-board-and-adjust-cursor (curses-window)
  (charms:clear-window curses-window)
  (draw-board curses-window *board*)
  (charms:refresh-window curses-window)

  ;; should decrement move up but there's already newline
  ;; printed from (draw-board), so no need.
  (charms:move-cursor-up curses-window :amount (* (length *board*) 2))
  (charms:move-cursor-right curses-window :amount 2))

(defun draw-board-and-restore-cur-pos (curses-window)
  (save-cursor-pos curses-window)
  (draw-board-and-adjust-cursor curses-window)
  (charms:move-cursor curses-window *last-cursor-x* *last-cursor-y*))

(defun main ()
  (let ((stdwin (charms:initialize)))
    (charms:disable-echoing)
    (charms:enable-raw-input :interpret-control-characters t)
    (charms:enable-non-blocking-mode stdwin)

    (draw-board-and-adjust-cursor stdwin)

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

             (draw-board-and-restore-cur-pos stdwin)

             (when (check-if-player-wins *board* +WIN-CHECK-RANGE+)
               (charms:finalize)
               (sb-ext:exit))

             (when (check-if-draw *board*)
               (setf *board* (new-board *board*))
               (draw-board-and-restore-cur-pos stdwin))))
          ((#\r)
           (setf *board* (new-board *board*))
           (draw-board-and-restore-cur-pos stdwin))
          ((#\q)
           (charms:finalize)
           (sb-ext:exit)))))))
