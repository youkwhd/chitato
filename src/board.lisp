(in-package :chitato)

(require :cl-charms)
(load "src/player.lisp")

(defparameter *board*
  '((:e :e :e)
    (:e :e :e)
    (:e :e :e))
  "board :e for empty, :x, :o are players")

(defun new-board (old-board)
  (map 'list (lambda (board-row)
               (map 'list (lambda (_)
                            (declare (ignore _))
                            :e)
                    board-row))
       old-board))

(defun draw-board-line (curses-window board)
  (loop for _ from 1 to (length (first board)) do
    (charms:write-string-at-cursor curses-window "+")
    (charms:write-string-at-cursor curses-window "---"))
  (charms:write-string-at-cursor curses-window "+")
  (charms:write-char-at-cursor curses-window #\newline))

(defun draw-board-middle (curses-window board-row)
  (loop for cell in board-row do
    (charms:write-string-at-cursor curses-window "| ")
    (charms:write-char-at-cursor curses-window (player-char cell))
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

(defun check-if-player-wins-vertical (board x y n)
  (assert (>= n 1))

  (defun fn (board x y n prev-player)
    (when (eq n 0)
      (return-from fn t))
    (let ((cell (nth x (nth y board))))
      (and
        (eq cell prev-player)
        (fn board x (+ y 1) (1- n) cell))))

  (let ((cell (nth x (nth y board))))
    (when (or (eq cell :e)
              (> (+ y n) (length board)))
      (return-from check-if-player-wins-vertical nil))
    (fn board x y n cell)))

(defun check-if-player-wins-right-diagonal (board x y n)
  (assert (>= n 1))

  (defun fn (board x y n prev-player)
    (when (eq n 0)
      (return-from fn t))
    (let ((cell (nth x (nth y board))))
      (and
        (eq cell prev-player)
        (fn board (+ x 1) (+ y 1) (1- n) cell))))

  (let ((cell (nth x (nth y board))))
    (when (or (eq cell :e)
              (or
                (> (+ x n) (length (first board)))
                (> (+ y n) (length board))))
      (return-from check-if-player-wins-right-diagonal nil))
    (fn board x y n cell)))

(defun check-if-player-wins-left-diagonal (board x y n)
  (assert (>= n 1))

  (defun fn (board x y n prev-player)
    (when (eq n 0)
      (return-from fn t))
    (let ((cell (nth x (nth y board))))
      (and
        (eq cell prev-player)
        (fn board (- x 1) (+ y 1) (1- n) cell))))

  (let ((cell (nth x (nth y board))))
    (when (or (eq cell :e)
              (or
                (< (- (+ x 1) n) 0)
                (> (+ y n) (length board))))
      (return-from check-if-player-wins-left-diagonal nil))
    (fn board x y n cell)))

(defun check-if-player-wins (board range)
  (loop for y from 0 to (1- (length board)) do
    (loop for x from 0 to (1- (length (nth y board))) do
      (when (or
              (check-if-player-wins-horizontal board x y range)
              (check-if-player-wins-vertical board x y range)
              (check-if-player-wins-right-diagonal board x y range)
              (check-if-player-wins-left-diagonal board x y range))
        (return-from check-if-player-wins t))))
  nil)

(defun check-if-draw (board)
  (every (lambda (res) (eq res t))
         (map 'list (lambda (board-row)
                      (notany (lambda (cell) (eq cell :e)) board-row)) board)))
