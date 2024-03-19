(in-package :chitato)

(require :cl-charms)

(defconstant +board+
  '((0 0 0)
    (0 0 0)
    (0 0 0)))

(defun hello (to)
  (format t "Hello, ~a!~%" to))

(defun draw-board-line (curses-window board w h)
  (loop for _ from 1 to (length board) do
    (charms:write-string-at-cursor curses-window "+")
    (charms:write-string-at-cursor curses-window "---"))
  (charms:write-string-at-cursor curses-window "+")
  (charms:write-char-at-cursor curses-window #\newline))

(defun draw-board-middle (curses-window board-row w h)
  (loop for x in board-row do
    (charms:write-string-at-cursor curses-window "| ")
    (case x
      ((0)
       (charms:write-char-at-cursor curses-window #\space)))
    (charms:write-char-at-cursor curses-window #\space))
  (charms:write-string-at-cursor curses-window "|")
  (charms:write-char-at-cursor curses-window #\newline))

(defun draw-board (curses-window board)
  (charms:clear-window curses-window)
  (charms:refresh-window curses-window)

  (dolist (row board)
      (draw-board-line curses-window board 0 0)
      (draw-board-middle curses-window row 0 0))

  (draw-board-line curses-window board 0 0))
