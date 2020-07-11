(custom-set-variables
 ;; custom-set-variables was added by Custom.
 '(auto-save-file-name-transforms (quote ((".*" "~/.emacs.d/autosaves/\\1" t))))
 '(backup-directory-alist (quote ((".*" . "~/.emacs.d/backups/"))))
 '(newsticker-url-list
   (quote
     ("slashdot" "http://rss.slashdot.org/Slashdot/slashdotMain" nil nil nil)
     ("eli-bendersky" "https://eli.thegreenplace.net/feeds/all.atom.xml" nil nil nil)
     ("thalassoporoi" "https://greatnavigators.com/feed" nil nil nil)
 '(package-selected-packages
   (quote
    (racket-mode sml-mode use-package helm-lsp which-key yasnippet projectile dap-mode company-lsp flycheck lsp-ui lsp-java))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 )

;; create the autosave dir if necessary, since emacs won't.
(make-directory "~/.emacs.d/autosaves/" t)

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

(require 'lsp-java)
(add-hook 'java-mode-hook #'lsp)

(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))

(when (string= system-type "darwin")
  (setq dired-use-ls-dired nil))

(use-package projectile)
(use-package flycheck)
(use-package yasnippet :config (yas-global-mode))
(use-package lsp-mode :hook ((lsp-mode . lsp-enable-which-key-integration))
  :config (setq lsp-completion-enable-additional-text-edit nil))
(use-package hydra)
(use-package company)
(use-package lsp-ui)
(use-package which-key :config (which-key-mode))
(use-package lsp-java :config (add-hook 'java-mode-hook 'lsp))
(use-package dap-mode :after lsp-mode :config (dap-auto-configure-mode))
(use-package dap-java :ensure nil)
(use-package helm-lsp)
(use-package helm
  :config (helm-mode))
(use-package lsp-treemacs)

(when (fboundp 'java-mode)
  (defun my-java-hooks ()
    "For use in `java-mode-hook'."
    (require 'google-java-format)
    (local-set-key "\C-cj" #'google-java-format-region)
    (local-set-key "\C-ci" #'lsp-java-organize-imports)
    (local-set-key "\C-cI" #'lsp-java-add-import)   
    (local-set-key "\C-cg" #'lsp-goto-implementation)
    (local-set-key "\C-cG" #'lsp-goto-type-definition)
    (local-set-key "\C-ce" #'flycheck-next-error)
    (local-set-key "\C-cE" #'flycheck-previous-error)
    (local-set-key "\C-ct" #'dap-java-run-test-class)
    (local-set-key "\C-cT" #'dap-java-run-test-method)
    (local-set-key "\C-cr" #'lsp-treemacs-references)
    (local-set-key "\C-cR" #'lsp-treemacs-implementations))
  (add-hook 'java-mode-hook 'my-java-hooks)
 ;(add-hook 'before-save-hook 'gofmt-before-save)
  )

(when (fboundp 'js-mode)
  (defun json-format ()
    (interactive)
    (save-excursion
      (shell-command-on-region (region-beginning)
                               (region-end)
                               "jq"
                               (buffer-name)
                               t)))
  (defun json-minify ()
    (interactive)
    (save-excursion
      (shell-command-on-region (region-beginning)
                               (region-end)
                               "jq -c"
                               (buffer-name)
                               t)))  
  (defun my-js-hooks ()
    "For use in `js-mode-hook'."
    (local-set-key "\C-cj" #'json-format)
    (local-set-key "\C-cJ" #'json-minify))
  (add-hook 'js-mode-hook 'my-js-hooks))

;; Make Emacs wrap long lines visually, but not actually (i.e. no
;; extra line breaks are inserted.
(global-visual-line-mode t)
(delete-selection-mode t)
(show-paren-mode t)
(menu-bar-mode -1)
(prefer-coding-system 'utf-8-unix)
(tooltip-mode -1)
(global-company-mode 1)

(add-to-list 'load-path "~/.emacs.d/lisp/")

(add-hook 'markdown-mode-hook 'flyspell-mode)
(add-hook 'sql-interactive-mode-hook
          '(lambda ()
             (company-mode)))

(defalias 'yes-or-no-p 'y-or-n-p)
(setq-default indent-tabs-mode nil)

(setq calendar-latitude 37.9)
(setq calendar-longitude 23.7)
(setq display-time-24hr-format t)
(display-time)

(setq frame-background-mode nil
      column-number-mode t
      inhibit-startup-screen t
      initial-scratch-message ";; let's do dis\n\n"
      ;; no visible or audible bells
      visible-bell nil
      ring-bell-function (lambda nil (message "")))

(defun annot (num char)
  (interactive "nColumn to send cursor? \nsComment symbol to insert? ")
  (move-to-column num t)
  (insert char))

;; navigate between visible windows
(defun other-window-backward (&optional n)
  (interactive "p")
  (if n
      (other-window (- n))
    (other-frame -1)))

;; Interpret shell escapes
(defun display-ansi-colors ()
  (interactive)
  (let ((inhibit-read-only t))
    (ansi-color-apply-on-region (point-min) (point-max))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; someones functions to emulate vi o and O
(defun vi-open-line-above ()
  "Insert a newline above the current line and put point at beginning."
  (interactive)
  (unless (bolp)
    (beginning-of-line))
  (newline)
  (forward-line -1)
  (indent-according-to-mode))

(defun vi-open-line-below ()
  "Insert a newline below the current line and put point at beginning."
  (interactive)
  (unless (eolp)
    (end-of-line))
  (newline-and-indent))

(defun vi-open-line (&optional abovep)
  "Insert a newline below the current line and put point at beginning.
  With a prefix argument, insert a newline above the current line."
  (interactive "P")
  (if abovep
      (vi-open-line-above)
    (vi-open-line-below)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; could emulate vi o with this (typou makro)
;(global-set-key "\C-co" "\C-a\C-j\C-p")

;; other key notations:
;; (kbd "C-c C-c") [(meta insert)]
     
;; vims o  = C-c o
(define-key global-map "\C-co" 'vi-open-line)
;; vims O  = C-c O
(define-key global-map "\C-cO" 'vi-open-line-above)
;; vims dd = C-c d
(global-set-key "\C-cd" 'kill-whole-line)
;; vims yy = C-c y
(global-set-key "\C-cy" "\C-a\C- \C-n\M-w")

;; toggle numbers
(global-set-key "\C-cn" 'display-line-numbers-mode)

(global-set-key (kbd "ESC <up>") 'scroll-down-line)
(global-set-key (kbd "ESC <down>") 'scroll-up-line)

(global-set-key "\C-x\C-n" 'other-window)
(global-set-key "\C-x\C-p" 'other-window-backward)

(global-set-key "\C-\M-f" 'find-file-at-point)
(global-set-key "\C-cf" 'find-dired)
(global-set-key "\C-cF" 'grep-find)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;; unset a key
; (global-set-key (kbd "C-b") nil)

; ;; unset a key
; (global-unset-key (kbd "C-b"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq auto-mode-alist
      (append
       '(("\\.awk\\'" . awk-mode)
         ("ChangeLog" . change-log-mode)
         ("\\.bashrc\\'" . sh-mode)
         ("\\.c\\'" . c-mode)
         ("\\.cgi\\'" . python-mode)
         ("\\.conf\\'" . conf-mode)
         ("\\.config\\'" . conf-mode)
         ("config" . conf-mode)
         ("\\.css\\'" . css-mode)
         ("Dockerfile" . dockerfile-mode)
         ("\\.diff\\'" . diff-mode)
         ("\\.el\\'"  . emacs-lisp-mode)
         ("\\.emacs\\'" . emacs-lisp-mode)
         ("\\.htm\\'" . html-mode)
         ("\\.html\\'" . html-mode)
         ("\\.ini\\'" . conf-mode)
         ("\\.java$" . java-mode)
         ("\\.js$" . js-mode)
         ("\\.json$" . js-mode)
         ("\\.jsp$" . nxml-mode) ;; nxml-mode
         ("\\.jspf$" . nxml-mode) ;; nxml-mode
         ("\\.less\\'" . javascript-mode)
         ("\\.magik$" . python-mode)
         ("\\Makefile$" . makefile-mode)
         ("\\makefile$" . makefile-mode)
         ("\\.md$" . markdown-mode)
         ("\\.org\\'" . org-mode)
         ("\\.patch\\'" . diff-mode)
         ("\\.pdf\\'" . doc-view-mode)
         ("\\.properties.template\\'" . conf-mode)
         ("\\.properties\\'" . conf-mode)
         ("\\.py$" . python-mode)
         ("\\.py\\'" . python-mode)
         ("\\.rkt\\'" . racket-mode)
         ("\\.scm\\'" . scheme-mode)
         ("\\.sed\\'" . sh-mode)
         ("\\.sh\\'" . sh-mode)
         ("\\.shtml\\'" . nxml-mode)
         ("\\.sml\\'" . sml-mode)
         ("\\.sql\\'" . sql-mode)
         ("\\.text\\'" . text-mode)
         ("\\.txt\\'" . text-mode)
         ("\\.vcl\\'" . java-mode)
         ("\\.vm\\'" . emacs-lisp-mode)
         ("\\.wsdd\\'" . nxml-mode)
         ("\\.xml$" . nxml-mode) ;; psgml-mode, nxml-mode
         ("\\.xsd$" . nxml-mode) ;; xsl-mode
         ("\\.xsl$" . nxml-mode) ;; xsl-mode
         ("\\.yaml\\'" . yaml-mode)
         ("\\.yml\\'" . yaml-mode)
         ("\\config\\'" . conf-mode)
         ("control" . conf-mode)
         ("github.*\\.txt$" . markdown-mode)
         ("pom.xml" . nxml-mode)
         )))

;(load-theme 'wombat)

