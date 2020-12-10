;; -------
;; GENERAL
;; -------

(recentf-mode 1)            
(tooltip-mode -1)
(tool-bar-mode -1)
;;(menu-bar-mode -1)
(show-paren-mode t)
(delete-selection-mode t)
(setenv "LANG" "en_US.UTF-8")
(set-default 'truncate-lines t)
(put 'scroll-left 'disabled nil)
(defalias 'yes-or-no-p 'y-or-n-p)
(prefer-coding-system 'utf-8-unix)
(put 'upcase-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(setq-default indent-tabs-mode nil)
(setq treemacs--width-is-locked nil)
(global-display-line-numbers-mode 1)
(put 'narrow-to-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)

;; mac specific settings
(when (eq system-type 'darwin)
  (setq dired-use-ls-dired nil)
  (when (display-graphic-p)
    (setq mac-option-modifier 'control)
    (setq mac-command-modifier 'meta)
    ;; values can be 'control, 'alt, 'meta, 'super, 'hyper, nil
    ;; (setting to nil allows the OS to assign values)
    (global-set-key (kbd "<C-tab>") 'move-front-end-window)
    (global-set-key (kbd "<C-S-tab>") 'move-front-end-window-back)
    (let ((my-path "/usr/local/mysql/bin:/Library/Frameworks/Python.framework/Versions/3.7/bin:"))
      (setenv "PATH" (concat my-path (getenv "PATH")))
      (setq exec-path (append (split-string my-path path-separator) exec-path)))))

;; --------
;; PACKAGES
;; --------

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))

(add-to-list 'load-path "~/.emacs.d/lisp/")
(require 'minor-mode-to-make-alt-tab-work)
(require 'my-used-packages)
(require 'change-inner)

(require 'frame-bufs)
(frame-bufs-mode t)

(require 'lsp-java)
(add-hook 'java-mode-hook #'lsp)

;; ---------------
;; MODES AND HOOKS
;; ---------------

(global-diff-hl-mode)
(diff-hl-flydiff-mode)
(diff-hl-margin-mode)

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
    (local-set-key "\M-n"  #'dap-next)
    (local-set-key "\M-N"  #'dap-continue)
    (local-set-key "\M-q"  #'dap-disconnect)
    (setq dap-auto-configure-features '(locals)) ;controls tooltip sessions
    (setq lsp-ui-doc-enable nil)
    (setq lsp-ui-sideline-enable nil))
  (add-hook 'java-mode-hook 'my-java-hooks))

(when (fboundp 'sql-mode)
  (defun now ()
    (interactive)
    (re-search-forward "'[0-9]\\{4\\}\\(-[0-9]\\{2\\}\\)\\{2\\} \\([0-9]\\{2\\}:\\)\\{2\\}[0-9]\\{2\\}\\.[0-9]'")
    (replace-match "NOW()"))
  (defun my-sql-hooks ()
    "For use in `sql-mode-hook'."
    (local-set-key "\C-ccq" #'sql-set-sqli-buffer)
    (local-set-key "\C-ct"  #'now))
  (add-hook 'sql-mode-hook  'my-sql-hooks))

;; (require 'sql-completion)
;; (setq sql-interactive-mode-hook
;;       (lambda ()
;;         (define-key sql-interactive-mode-map "\t" 'comint-dynamic-complete)
;;         (sql-mysql-completion-init)))

(add-hook 'js-mode-hook 'my-json-hooks)
(add-hook 'restclient-mode-hook 'my-json-hooks)
(add-hook 'dired-mode-hook 'dired-hide-details-mode)
(add-hook 'calendar-today-visible-hook 'calendar-mark-today)
(add-hook 'sql-interactive-mode-hook 'my-sql-save-history-hook)
(add-hook 'sql-interactive-mode-hook 'company-mode)
(add-hook 'minibuffer-setup-hook 'yas-minor-mode)
(add-hook 'java-mode-hook
          (lambda ()
            (when scratch-buffer
              (goto-char (point-min))
              (insert "public class LetsDoDis {\n\n\n\n}")
              (forward-line -2))))

;; ---------
;; FUNCTIONS
;; ---------

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

;; someones functions to emulate vi o and O
(defun vi-open-line (&optional abovep)
  "Insert a newline below the current line and put point at beginning.
   With a prefix argument, insert a newline above the current line."
  (interactive "P")
  (if abovep
      (vi-open-line-above)
    (vi-open-line-below)))

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
;; could emulate vi o with this (typou makro)
;;(global-set-key "\C-co" "\C-a\C-j\C-p")

(defun scratch-with-prefix-arg ()
  (interactive)
  (setq current-prefix-arg '(4)) ; C-u
  (call-interactively 'scratch))

(defun sql-db-local ()
  (interactive)
  (sql-connect 'db-local))

(defun my-sql-save-history-hook ()
  (let ((lval 'sql-input-ring-file-name)
        (rval 'sql-product))
    (if (symbol-value rval)
        (let ((filename 
               (concat "~/.emacs.d/sql/"
                       (symbol-name (symbol-value rval))
                       "-history.sql")))
          (set (make-local-variable lval) filename))
      (error
       (format "SQL history will not be saved because %s is nil"
               (symbol-name rval))))))

(defun json-format (&optional bool)
  (interactive)
  (save-excursion
    (shell-command-on-region (region-beginning)
                             (region-end)
                             (if bool "jq -jc" "jq -j")
                             (buffer-name)
                             t)))

(defun my-json-hooks ()
  "For use in `js-mode-hook'."
  (local-set-key "\C-cj" (lambda () (interactive) (json-format)))
  (local-set-key "\C-cJ" (lambda () (interactive) (json-format t))))

(defun myerc ()
  (interactive)
  (let
      ((password-cache nil))
    (erc
     :server "irc.freenode.net"
     :port "6667"
     :nick "ou-tis"
     :password (password-read (format "password for ou-tis at Freenode? ")))))

(defun ormap (fn ls)
"Simple ormap recursive implementation for flat lists,
apply a function sequentially to the elements of a list and 
return true if at least one application returns true, or else false"
  (cond ((null ls) nil)
        ((funcall fn (car ls)) t)
        (t (ormap fn (cdr ls)))))

;; (ormap (lambda (el) (> el 10)) '(1 2 11)) ; true
;; (ormap (lambda (el) (> el 10)) '(1 2 3))  ; false

(defun andmap (fn ls)
"Simple andmap recursive implementation for flat lists,
apply a function to all elements of a list and return true
if all applications return true, or else false"
  (cond ((null ls) t)
        ((not (funcall fn (car ls))) nil)
        (t (andmap fn (cdr ls)))))

;; (andmap (lambda (el) (> el 10)) '(11 12 13)) ; true
;; (andmap (lambda (el) (> el 10)) '(11 12 3))  ; false

(defun create-and-switch-to-scratch-buffer nil
  "create and switch to a scratch buffer"
  (interactive)
  (switch-to-buffer (get-buffer-create "*scratch*"))
  (insert initial-scratch-message)
  (lisp-interaction-mode))

(defun where-to (bool)
  (if bool
      (previous-buffer)
    (next-buffer)))

(defun move-back-end-window (&optional prev)
  "On first call switch to *Messages* buffer. On subsequent calls change
buffers until a 'back-end' one is found (user-defined in `front-bufsp' function)."
  (interactive)
  (if (not
       (or (eq last-command 'move-back-end-window)
           (eq last-command 'move-back-end-window-back)))
      (switch-to-buffer (messages-buffer))
    (progn (where-to prev)
           (while (or (front-bufsp)
                      (string-match "*helm.*"
                                    (buffer-name)))
             (where-to prev)))))

(defun move-back-end-window-back ()
  (interactive)
  (move-back-end-window t))

(defun move-front-end-window (&optional prev)
  "If there are no 'front-end' buffers open (user-defined in `front-bufsp' function),
then re-create *scratch* and switch to it, or else change buffers until a 'front-end' one is found."
  (interactive)
  (if (andmap
       (lambda (el)
         (not (front-bufsp el)))
       (buffer-list))
      (create-and-switch-to-scratch-buffer)
    (progn (where-to prev)
           (while (not (front-bufsp))
             (where-to prev)))))

(defun move-front-end-window-back ()
  (interactive)
  (move-front-end-window t))

(defun front-bufsp (&optional buff)
  "Return t if current buffer is a user buffer, or else nil.
User buffer will be defined as not enwrapped in stars '*', with some exceptions."
  (interactive)
  (let ((the-buff (buffer-name buff)))
    (cond ((or (string-equal "*js*" the-buff)
               (string-equal "*sql*" the-buff)
               (string-equal "*java*" the-buff)
               (string-equal "*scratch*" the-buff))
           t)
          ((or (string-equal "diary" the-buff)
               (string-equal major-mode "dired-mode")
               (string-match "\\*.+\\*" the-buff))
           nil)        
          (t t))))

;; --------
;; BINDINGS
;; --------

;; vims o  = C-c o
(define-key global-map "\C-co" 'vi-open-line)
;; vims O  = C-c O
(define-key global-map "\C-cO" 'vi-open-line-above)
;; vims dd = C-c d
(global-set-key "\C-cd" 'kill-whole-line)
;; vims yy = C-c y
(global-set-key "\C-cy" "\C-a\C- \C-e\M-w\C-a")
;; toggle numbers
(global-set-key "\C-cn" 'display-line-numbers-mode)
(global-set-key (kbd "<M-down>") 'scroll-up-line)
(global-set-key (kbd "<M-up>") 'scroll-down-line)
(global-set-key (kbd "ESC <up>") 'scroll-down-line)
(global-set-key (kbd "ESC <down>") 'scroll-up-line)
(global-set-key "\C-x\C-n" 'other-window)
(global-set-key "\C-x\C-p" 'other-window-backward)
(global-set-key "\C-cA" 'display-ansi-colors)
(global-set-key "\C-\M-f" 'find-file-at-point)
(global-set-key "\C-cf" 'find-dired)
(global-set-key "\C-cF" 'rgrep)
(global-set-key (kbd "<C-return>") 'company-complete)
(global-set-key (kbd "<C-S-return>") 'completion-at-point)
(global-set-key "\C-cq" 'sql-db-local)
(global-set-key (kbd "C-c c s") 'scratch-with-prefix-arg)
(global-set-key "\C-c$" 'toggle-truncate-lines)
(global-set-key (kbd "C-S-s") 'isearch-forward-symbol-at-point)
(global-set-key "\C-cN" #'newsticker-show-news)
(global-set-key "\C-cm" #'treemacs)
(global-set-key "\C-c\C-e" #'myerc)
(global-set-key "\C-cC" #'calendar)
(global-set-key (kbd "M-i") 'change-inner)
(global-set-key (kbd "M-o") 'change-outer)
(global-set-key (kbd "C-\\") 'er/expand-region)
;;(global-set-key [remap kill-buffer] 'kill-buffer-and-window)
(global-set-key (kbd "<C-M-tab>") #'next-multiframe-window)
(global-set-key (kbd "<C-S-M-tab>") #'previous-multiframe-window)
(global-set-key "\C-cB" (lambda () (interactive) (term "/bin/bash")))
(global-set-key (kbd "C-=") (lambda () (interactive) (text-scale-increase 0.2)))
(global-set-key (kbd "C-+") (lambda () (interactive) (text-scale-decrease 0.2)))
(global-set-key (kbd "<S-mouse-5>") (lambda () (interactive) (scroll-left 10)))
(global-set-key (kbd "<S-mouse-4>") (lambda () (interactive) (scroll-right 10)))
(global-set-key "\C-c\C-w" #'met-with-prefix-arg)
(global-set-key (kbd "<S-M-tab>") 'move-front-end-window-back)
(global-set-key (kbd "ESC <backtab>") 'move-front-end-window-back)
(global-set-key (kbd "<f5>") #'move-back-end-window)
(global-set-key (kbd "<f6>") #'move-back-end-window-back)
(global-set-key "\C-x52" (lambda () (interactive) (switch-to-buffer-other-frame "*Messages*")))
(global-set-key "\C-x\C-b" (lambda () (interactive) (progn (list-buffers) (other-window 1))))

;; another key notation: [(meta insert)]

(when (display-graphic-p)
;; or (global-set-key (kbd "C-z") nil)
  (global-unset-key (kbd "C-z")))

(define-key helm-map (kbd "TAB") #'helm-execute-persistent-action)
(define-key helm-map (kbd "<tab>") #'helm-execute-persistent-action)
(define-key helm-map (kbd "C-j") #'helm-select-action)
(define-key minibuffer-local-map [tab] yas-maybe-expand)

;; ---------
;; VARIABLES
;; ---------

(setq visible-bell nil
      column-number-mode t      
      calendar-latitude 37.9
      calendar-longitude 23.7
      inhibit-startup-screen t
      completion-ignore-case t
      ;; frame-background-mode nil
      Buffer-menu-name-width 35
      helm-buffer-max-length nil
      recentf-max-saved-items 50
      lsp-modeline-diagnostics-enable nil
      read-buffer-completion-ignore-case t
      read-file-name-completion-ignore-case t
      custom-file "~/.emacs.d/lisp/custom.el"
      mouse-wheel-scroll-amount '(1 ((shift) . 1))
      ring-bell-function (lambda nil (message ""))
      initial-scratch-message ";; let's do dis\n\n")

(setq sql-connection-alist
      '((db-local
         (sql-product 'mysql)
         (sql-server "127.0.0.1")
         (sql-port 3306))))

(setq display-buffer-alist
      '(("\\*\\(grep\\|log-edit-files\\|vc-log\\)\\*"
         (display-buffer-below-selected))
        ("\\*\\(java\\|sql\\|js\\|javascript\\)\\*"
         (display-buffer-same-window))))

(yas--define-parents 'minibuffer-inactive-mode '(fundamental-mode))

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
         ("\\.jsp$" . nxml-mode)
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
         ("\\.http$" . restclient-mode)
         ("\\.rest$" . restclient-mode))))

;; -------
;; FINALLY
;; -------

(set-face-attribute 'default nil :height 140)
(make-directory "~/.emacs.d/autosaves/" t)
(make-directory "~/.emacs.d/sql/" t)
(load custom-file)

;; (load-theme 'wombat)
;; (darktooth-modeline)
(load-theme 'darktooth)
(display-time)
(diary)

