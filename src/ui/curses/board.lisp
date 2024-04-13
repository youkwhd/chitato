(in-package :chitato)

(require :cl-charms)
(load "src/player.lisp")

(defun draw-board-ui-line (curses-window board)
  (loop for _ from 1 to (length (first board)) do
    (charms:write-string-at-cursor curses-window "+")
    (charms:write-string-at-cursor curses-window "---"))
  (charms:write-string-at-cursor curses-window "+")
  (charms:write-char-at-cursor curses-window #\newline))

(defun draw-board-ui-middle (curses-window board-row)
  (loop for cell in board-row do
    (charms:write-string-at-cursor curses-window "| ")
    (charms:write-char-at-cursor curses-window (player-char cell))
    (charms:write-char-at-cursor curses-window #\space))
  (charms:write-string-at-cursor curses-window "|")
  (charms:write-char-at-cursor curses-window #\newline))

(defun draw-board-ui (curses-window board)
  (dolist (row board)
    (draw-board-ui-line curses-window board)
    (draw-board-ui-middle curses-window row))

  (draw-board-ui-line curses-window board))

(defun board-ui-width (board)
  (1+ (* (length (first board)) 4)))

(defun board-ui-height (board)
  (1+ (* (length board) 2)))
