(in-package :chitato)

(defun change-player-turn (p)
  (case p
    ((:x)
     :o)
    ((:o)
     :x)))

(defun player-char (p)
  (case p
    ((:x)
     #\X)
    ((:o)
     #\O)
    (t #\space)))
