(in-package :chitato)

(require :cl-charms)

(defparameter *board*
  '((:e :o :e)
    (:x :o :e)
    (:x :e :e))
  "board :e for empty, :x, :o are players")

(defun draw-board-line (curses-window board)
  (loop for _ from 1 to (length board) do
    (charms:write-string-at-cursor curses-window "+")
    (charms:write-string-at-cursor curses-window "---"))
  (charms:write-string-at-cursor curses-window "+")
  (charms:write-char-at-cursor curses-window #\newline))

(defun draw-board-middle (curses-window board-row)
  (loop for cell in board-row do
    (charms:write-string-at-cursor curses-window "| ")
    (case cell 
      ((:e)
       (charms:write-char-at-cursor curses-window #\space))
      ((:x)
       (charms:write-char-at-cursor curses-window #\X))
      ((:o)
       (charms:write-char-at-cursor curses-window #\O)))
    (charms:write-char-at-cursor curses-window #\space))
  (charms:write-string-at-cursor curses-window "|")
  (charms:write-char-at-cursor curses-window #\newline))

(defun draw-board (curses-window board)
  (dolist (row board)
    (draw-board-line curses-window board)
    (draw-board-middle curses-window row))

  (draw-board-line curses-window board))

(defun check-if-player-wins-horizontal (board x y n)
  (assert (>= n 1))

  (defun fn (board x y n prev-player)
    (when (eq n 0)
      (return-from fn t))
    (let ((cell (nth x (nth y board))))
      (and
        (eq cell prev-player)
        (fn board (+ x 1) y (1- n) cell))))

  (let ((cell (nth x (nth y board))))
    (when (or (eq cell :e)
              (> (+ x n) (length (first board))))
      (return-from check-if-player-wins-horizontal nil))
    (fn board x y n cell)))

(defun check-if-player-wins (board)
  (loop for y from 0 to (1- (length board)) do
    (loop for x from 0 to (1- (length (nth y board))) do
      (when (check-if-player-wins-horizontal board x y 3)
        (return-from check-if-player-wins t))))
  nil)
