;;; python-mode-config.el --- settings for python
;;; Author: Vedang Manerikar
;;; Created on: 09 Jan 2012
;;; Time-stamp: "2012-06-22 01:03:21 vedang"
;;; Copyright (c) 2012 Vedang Manerikar <vedang.manerikar@gmail.com>

;; This file is not part of GNU Emacs.

;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the Do What The Fuck You Want to
;; Public License, Version 2, which is included with this distribution.
;; See the file LICENSE.txt

;;; Code:


(require 'pymacs)
(pymacs-load "ropemacs" "rope-")
(setq ropemacs-confirm-saving 'nil
      ropemacs-enable-autoimport t)

;;; ropemacs Integration with auto-completion
;;; from github.com/gabrielelanaro
(eval-after-load "auto-complete"
  '(progn
    (defun ac-ropemacs-candidates ()
      (mapcar (lambda (completion)
                (concat ac-prefix completion))
              (rope-completions)))

    (ac-define-source nropemacs
      '((candidates . ac-ropemacs-candidates)
        (symbol . "p")))

    (ac-define-source nropemacs-dot
      '((candidates . ac-ropemacs-candidates)
        (symbol . "p")
        (prefix . c-dot)
        (requires . 0)))

    (defun ac-nropemacs-setup ()
      (setq ac-sources (append '(ac-source-nropemacs
                                 ac-source-nropemacs-dot) ac-sources)))
    (defun ac-python-mode-setup ()
      (add-to-list 'ac-sources 'ac-source-yasnippet))

    (add-hook 'python-mode-hook 'ac-python-mode-setup)
    (add-hook 'rope-open-project-hook 'ac-nropemacs-setup)))


;; Flymake for Python : unleash the full power of the python
;; interpreter by turning on flymake

(add-hook 'find-file-hook 'flymake-find-file-hook)

(eval-after-load "flymake"
  '(progn
    ;; http://git.vo20.nl/
    ;; Fix for nasty `cannot open doc string file` flymake error
    (defun flymake-create-temp-intemp (file-name prefix)
      "Return file name in temporary directory for checking FILE-NAME.
    This is a replacement for `flymake-create-temp-inplace'. The
    difference is that it gives a file name in
    `temporary-file-directory' instead of the same directory as
    FILE-NAME.

    For the use of PREFIX see that function.

    Note that not making the temporary file in another directory
    \(like here) will not if the file you are checking depends on
    relative paths to other files \(for the type of checks
    flymake makes)."
      (unless (stringp file-name) (error "Invalid file-name"))
      (or prefix (setq prefix "flymake"))
      (let* ((name (concat
                    (file-name-nondirectory
                     (file-name-sans-extension file-name))
                    "_" prefix))
             (ext  (concat "." (file-name-extension file-name)))
             (temp-name (make-temp-file name nil ext)))
        (flymake-log 3 "create-temp-intemp: file=%s temp=%s" file-name temp-name)
        temp-name))

    (defun flymake-pyflakes-init ()
      (let* ((temp-file (flymake-init-create-temp-buffer-copy
                         'flymake-create-temp-intemp))
             (local-file (file-relative-name
                          temp-file
                          (file-name-directory buffer-file-name))))
        (list "pycheckers"  (list local-file))))
    (add-to-list 'flymake-allowed-file-name-masks
                 '("\\.py\\'" flymake-pyflakes-init))

    (delete '("\\.html?\\'" flymake-xml-init) flymake-allowed-file-name-masks)

    (require 'cl)
    (load "flymake-cursor" t)))

(eval-after-load "flymake-cursor"
  '(progn
     (global-set-key [f3] 'flymake-goto-prev-error)
     (global-set-key [f2] 'flymake-goto-next-error)))


(defun vedang/python-mode-settings ()
  (when (eq major-mode 'python-mode)
    (flyspell-prog-mode)))


(add-hook 'find-file-hook 'vedang/python-mode-settings)
(define-key python-mode-map (kbd "RET") 'reindent-then-newline-and-indent)


(provide 'python-mode-config)
