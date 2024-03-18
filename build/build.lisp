;; loads your common lisp configuration and quicklisp
;; see: https://lispcookbook.github.io/cl-cookbook/scripting.html#quickloading-dependencies-from-a-script
(load "~/.sbclrc")

;; main entry file of chitato
(load "src/chitato.lisp")

(sb-ext:save-lisp-and-die
  "build/chitato"
  :toplevel 'chitato:main
  :executable t)
