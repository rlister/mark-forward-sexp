# mark-forward-sexp.el

## Description

mark-forward-sexp behaves in a similar fashion to vim's 'co' and 'ci'
keystrokes, by jumping forward(/backward) to the content of matching
delimiters and marking that content. For example:

```lisp
C-c i "
```

will jump to the next matched-pair of double-quotes mark the inside
contents. Unlike vim, this version crosses lines and has a strong
understanding of s-expressions.

## Usage

Add the following to your emacs config:

```lisp
(add-to-list 'load-path "~/path/to/mark-forward-sexp")
(require 'mark-forward-sexp)
```

and some keybindings, e.g.:

```lisp
(global-set-key (kbd "C-c o") 'mark-forward-sexp)
(global-set-key (kbd "C-c O") 'mark-backward-sexp)
(global-set-key (kbd "C-c i") 'mark-inside-forward-sexp)
(global-set-key (kbd "C-c I") 'mark-inside-backward-sexp)
```

## Copyright

Copyright (c) 2012 Richard Lister.
