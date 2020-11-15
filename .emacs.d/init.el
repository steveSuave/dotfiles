(custom-set-variables
 '(auto-save-file-name-transforms (quote ((".*" "~/.emacs.d/autosaves/\\1" t))))
 '(backup-directory-alist (quote ((".*" . "~/.emacs.d/backups/"))))
 '(newsticker-url-list
   (quote
    ("slashdot" "http://rss.slashdot.org/Slashdot/slashdotMain" nil nil nil)
    ("eli-bendersky" "https://eli.thegreenplace.net/feeds/all.atom.xml" nil nil nil)
    ("thalassoporoi" "https://greatnavigators.com/feed" nil nil nil)))
 '(package-selected-packages
   (quote
    (racket-mode sml-mode scratch restclient lsp-treemacs helm helm-lsp dap-java dap-mode which-key lsp-ui company hydra lsp-mode yasnippet flycheck projectile lsp-java))))
(custom-set-faces
 '(erc-input-face ((t (:foreground "salmon"))))
 '(erc-my-nick-face ((t (:foreground "goldenrod" :weight bold)))))

;; create the autosave dir if necessary, since emacs won't.
(make-directory "~/.emacs.d/autosaves/" t)

(set-face-attribute 'default (selected-frame) :height 140)

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))

(when (string= system-type "darwin")
  (setq dired-use-ls-dired nil))

(require 'lsp-java)
(add-hook 'java-mode-hook #'lsp)

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
    (local-set-key "\C-cR" #'lsp-treemacs-implementations)
    (local-set-key "\C-cs" #'lsp-treemacs-symbols)
    (local-set-key "\C-cl" #'helm-semantic-or-imenu)
    (setq lsp-ui-doc-enable nil)
    (setq lsp-ui-sideline-enable nil))
  (add-hook 'java-mode-hook 'my-java-hooks)
  ;;(add-hook 'before-save-hook 'gofmt-before-save)
  )

(add-hook 'java-mode-hook
          (lambda ()
            (when scratch-buffer
              (goto-char (point-min))
              (insert "public class LetsDoDis {\n\n\n\n}")
              (previous-line 2))))

(defun json-format (&optional bool)
  (interactive)
  (if (eq t bool)
      (setq jq "jq -c")
      (setq jq "jq"))
  (save-excursion
    (shell-command-on-region (region-beginning)
                             (region-end)
                             jq
                             (buffer-name)
                             t)))

(defun my-json-hooks ()
  "For use in `js-mode-hook'."
  (local-set-key "\C-cj" (lambda () (interactive) (json-format)))
  (local-set-key "\C-cJ" (lambda () (interactive) (json-format t))))

(add-hook 'js-mode-hook 'my-json-hooks)
(add-hook 'restclient-mode-hook 'my-json-hooks)
(add-hook 'dired-mode-hook 'dired-hide-details-mode)
(add-hook 'markdown-mode-hook 'flyspell-mode)
(add-hook 'sql-interactive-mode-hook
          '(lambda ()
             (company-mode)))

(when (fboundp 'sql-mode)
  (defun now ()
    (interactive)
    (re-search-forward "'[0-9]\\{4\\}\\(-[0-9]\\{2\\}\\)\\{2\\} \\([0-9]\\{2\\}:\\)\\{2\\}[0-9]\\{2\\}\\.[0-9]'")
    (replace-match "NOW()"))    
  (defun my-sql-hooks ()
    "For use in `sql-mode-hook'."
    (local-set-key "\C-ct" #'now)
    (add-hook 'sql-mode-hook 'my-sql-hooks)))

(setq sql-connection-alist
      '((db-local
         (sql-product 'mysql)
         (sql-server "127.0.0.1")
         (sql-port 3306))))

(defun sql-db-local ()
  (interactive)
  (sql-connect 'db-local))

(global-set-key "\C-cq" 'sql-db-local)

(defun scratch-with-prefix-arg ()
  (interactive)
  (setq current-prefix-arg '(4)) ; C-u
  (call-interactively 'scratch))

(global-set-key (kbd "C-c c s") 'scratch-with-prefix-arg)

(global-set-key "\C-c$" 'toggle-truncate-lines)
(set-default 'truncate-lines t)

(delete-selection-mode t)
(show-paren-mode t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(prefer-coding-system 'utf-8-unix)
(tooltip-mode -1)
(global-company-mode 1)
(global-display-line-numbers-mode 1)

(add-to-list 'load-path "~/.emacs.d/lisp/")

(defalias 'yes-or-no-p 'y-or-n-p)
(setq-default indent-tabs-mode nil)

(setq completion-ignore-case  t)
(setq read-file-name-completion-ignore-case t)
(setq read-buffer-completion-ignore-case t)

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

;; ----------------------------------------
;; someones functions to emulate vi o and O
;; ----------------------------------------
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

;; ----------------------------------------
;; could emulate vi o with this (typou makro)
;;(global-set-key "\C-co" "\C-a\C-j\C-p")

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

(global-set-key (kbd "<M-down>") 'scroll-up-line)  ;; or (kbd "ESC <down>")
(global-set-key (kbd "<M-up>") 'scroll-down-line)

(global-set-key "\C-x\C-n" 'other-window)
(global-set-key "\C-x\C-p" 'other-window-backward)
(global-set-key "\C-cA" 'display-ansi-colors)

(global-set-key "\C-\M-f" 'find-file-at-point)
(global-set-key "\C-cf" 'find-dired)
(global-set-key "\C-cF" 'grep-find)

(global-set-key (kbd "<C-tab>") 'completion-at-point)
(global-set-key (kbd "<C-return>") 'company-complete)

(global-set-key (kbd "<S-mouse-4>") #'scroll-right)
(global-set-key (kbd "<S-mouse-5>") #'scroll-left)

;;(global-set-key (kbd "C-S-s") 'isearch-forward-symbol-at-point)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; unset a key
;; (global-set-key (kbd "C-b") nil)

;; ;; unset a key
;; (global-unset-key (kbd "C-b"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

(setq auto-mode-alist
      (append
       '(("\\.awk\\'" . awk-mode)
         ("ChangeLog" . change-log-mode)
         ("\\.bashrc\\'" . sh-mode)
         ("\\.c\\'" . c-mode)
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
         ("\\.java$" . java-mode)
         ("\\.js$" . js-mode)
         ("\\.json$" . js-mode)
         ("\\.jsp$" . nxml-mode) ;; nxml-mode
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
         ("\\.sml\\'" . sml-mode)
         ("\\.sql\\'" . sql-mode)
         ("\\.text\\'" . text-mode)
         ("\\.txt\\'" . text-mode)
         ("\\.xml$" . nxml-mode) ;; psgml-mode, nxml-mode
         ("\\.xsd$" . nxml-mode) ;; xsl-mode
         ("\\.xsl$" . nxml-mode) ;; xsl-mode
         ("\\.yaml\\'" . yaml-mode)
         ("\\.yml\\'" . yaml-mode)
         ("github.*\\.txt$" . markdown-mode)
         ("pom.xml" . nxml-mode)
         ("\\.rest$" . restclient-mode)
         )))

(put 'upcase-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)
(put 'scroll-left 'disabled nil)

(load-theme 'wombat)

(require 'customies)

