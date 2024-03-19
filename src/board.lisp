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
    (charms:write-string-at-cursor curses-window "  "))
  (charms:write-string-at-cursor curses-window "|")
  (charms:write-char-at-cursor curses-window #\newline))

(defun draw-board (curses-window board)
  (charms:clear-window curses-window)
  (charms:refresh-window curses-window)

  (let ((board-width (+ (* (length board) 4) 1))
        (board-height (+ (* (length (elt board 0)) 2) 1)))
    (draw-board-line curses-window board board-width board-height)
    (draw-board-middle curses-window board board-width board-height))

  (dolist (row board)
    (dolist (cell row)
      (charms:write-char-at-cursor curses-window #\0))
    (charms:write-char-at-cursor curses-window #\newline)))
