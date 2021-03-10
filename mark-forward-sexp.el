;;; mark-forward-sexp.el --- Mark regions sematically inside balanced expressions.
;;
;; Copyright (C) 2012 by Ric Lister
;;
;; Author: Ric Lister
;; Version: 20210310.3
;; Package-Requires: ((emacs "24.1"))
;; URL: https://github.com/rlister/mark-forward-sexp
;;
;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2 of the
;; License, or any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; if not, write to the Free Software
;; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
;; 02111-1307, USA.
;;
;;; Commentary:
;;
;; mark-forward-sexp behaves in a similar fashion to vim's 'co' and 'ci'
;; keystrokes, by jumping forward(/backward) to the contents of matching
;; delimiters and marking for change those contents. For example:
;;
;;   C-c i "
;;
;; will jump to the next matched-pair of "..." and mark the inside
;; contents. Unlike vim, this version crosses lines and has a strong
;; understanding of s-expressions.
;;
;; Usage:
;;
;; Add the following to your emacs config:
;;
;;   (add-to-list 'load-path "~/path/to/mark-forward-sexp")
;;   (require 'mark-forward-sexp)
;;
;; and some keybindings, e.g.:
;;
;;   (global-set-key (kbd "C-c o") 'mark-forward-sexp)
;;   (global-set-key (kbd "C-c O") 'mark-backward-sexp)
;;   (global-set-key (kbd "C-c i") 'mark-inside-forward-sexp)
;;   (global-set-key (kbd "C-c I") 'mark-inside-backward-sexp)

(defun shrink-region (&optional arg)
  "Shrink size of region by ARG amount at beginning and end, leaving
point at beginning of new region."
  (interactive "p")
  (when (region-active-p)
    (let* ((n (or arg 1))
           (p0 (+ (region-beginning) n))
           (p1 (- (region-end) n)))
      (push-mark p1 nil t)
      (goto-char p0))))

(defun skip-forward-sexp (char &optional arg)
  "Skip to beginning of ARGth balanced expression starting with CHAR.
Negative ARG moves backwards."
  (interactive "cSkip to sexp char: \nP")
  (let* ((n (or arg 1))
         (skip-function (if (< n 0) 'skip-chars-backward 'skip-chars-forward))
         (incr (/ n (abs n))))
    (funcall skip-function (concat "^\\" (char-to-string char)))
    (if (< n 0)
        (backward-sexp))                ;beginning of sexp
    (when (> (abs n) 1)                 ;recurse ARG times
      (forward-sexp incr)
      (skip-forward-sexp char (- n incr)))))

;;;###autoload
(defun mark-forward-sexp (char &optional arg)
  "Skip forward to beginning of ARGth balanced expression starting with CHAR
and mark active the expression. Negative ARG moves backward."
  (interactive "cForward to beginning: \nP")
  (let ((n (or arg 1)))
    (skip-forward-sexp char n)
    (push-mark
     (save-excursion
       (forward-sexp)
       (point)) nil t)))

;;;###autoload
(defun mark-backward-sexp (char &optional arg)
  "Skip backward to beginning of ARGth balanced expression starting with CHAR
and mark active the expression."
  (interactive "cBackward to beginning: \nP")
  (let ((n (or arg 1)))
    (mark-forward-sexp char (- n))))

;;;###autoload
(defun mark-inside-forward-sexp (char &optional arg)
  "Skip forward to beginning of ARGth balanced expression starting with CHAR
and mark active inside the expression."
  (interactive "cForward to beginning: \nP")
  (mark-forward-sexp char arg)
  (shrink-region))

;;;###autoload
(defun mark-inside-backward-sexp (char &optional arg)
  "Skip backward to beginning of ARGth balanced expression starting with CHAR
and mark active inside the expression."
  (interactive "cBackward to beginning: \nP")
  (let ((n (or arg 1)))
    (mark-inside-forward-sexp char (- n))))

(provide 'mark-forward-sexp)
;;; mark-forward-sexp.el ends here
