#!/usr/bin/bash

sbcl --non-interactive \
     --load src/chitato.lisp \
     --eval "((lambda () (format t \"~%[$0 ::]~%\") (chitato:main)))"
