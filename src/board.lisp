(in-package :chitato)

(require :cl-charms)

(defparameter *board*
  '((:e :e :e)
    (:x :o :e)
    (:x :e :e))
  "board :e for empty, :x, :o are players")

(defun hello (to)
  (format t "Hello, ~a!~%" to))

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
