(load "src/chitato.lisp")

(sb-ext:save-lisp-and-die
  "build/chitato"
  :toplevel 'chitato:main
  :executable t)
