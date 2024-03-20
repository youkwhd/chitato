(in-package :chitato)

(defun change-player-turn (p)
  (case p
    ((:x)
     :o)
    ((:o)
     :x)))
