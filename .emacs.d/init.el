;; -------
;; GENERAL
;; -------

(recentf-mode 1)
(tooltip-mode -1)
(tool-bar-mode -1)
;;(menu-bar-mode -1)
(show-paren-mode t)
(delete-selection-mode t)
(setq-default word-wrap t)
(setenv "LANG" "en_US.UTF-8")
(set-default 'truncate-lines t)
(put 'scroll-left 'disabled nil)
(defalias 'yes-or-no-p 'y-or-n-p)
(prefer-coding-system 'utf-8-unix)
(put 'upcase-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(setq-default indent-tabs-mode nil)
;; (global-display-line-numbers-mode 1)
(put 'downcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)

(setq EMACS_DIR "~/.emacs.d/")
(setq user-cache-directory (concat EMACS_DIR "cache"))
(setq backup-directory-alist `(("." . ,(expand-file-name "backups" user-cache-directory)))
      url-history-file (expand-file-name "url/history" user-cache-directory)
      auto-save-list-file-prefix (expand-file-name "auto-save-list/.saves-" user-cache-directory))

;; mac specific settings
(when (eq system-type 'darwin)
  (setq dired-use-ls-dired nil)
  (when (display-graphic-p)
    (setq mac-option-modifier 'control)
    (setq mac-command-modifier 'meta)
    ;; values can be 'control, 'alt, 'meta, 'super, 'hyper, nil
    ;; (setting to nil allows the OS to assign values)
    (let ((my-path "/usr/local/mysql/bin:/Library/Frameworks/Python.framework/Versions/3.7/bin:"))
      (setenv "PATH" (concat my-path (getenv "PATH")))
      (setq exec-path (append (split-string my-path path-separator) exec-path)))))

;; --------
;; PACKAGES
;; --------

(add-to-list 'load-path "~/.emacs.d/lisp/")
(require 'my-used-packages)
(require 'scratch)
(require 'oberon)

;; (require 'frame-bufs)
;; (frame-bufs-mode t)

;; (add-to-list 'load-path "/Applications/LilyPond.app/Contents/Resources/share/emacs/site-lisp/")
;; (autoload 'LilyPond-mode "lilypond-mode")

;; ---------------
;; MODES AND HOOKS
;; ---------------

(global-diff-hl-mode)
(diff-hl-flydiff-mode)
(diff-hl-margin-mode)

(when (fboundp 'java-mode)
  (defun j-compile-command ()
    "run current program (that requires no input)"
    (interactive)
    (let* ((source (file-name-nondirectory buffer-file-name))
           (out    (file-name-sans-extension source))
           (class  (concat out ".class")))
      (save-buffer)
      (shell-command (format "rm -f %s && javac %s" class source))
      (if (file-exists-p class)
          (shell-command (format "java %s" out) "*compilation*")
        (progn
          (set (make-local-variable 'compile-command)
               (format "javac %s" source))
          (command-execute 'compile)))))

  (defun my-java-hooks ()
    "For use in `java-mode-hook'."
    (require 'google-java-format)
    (local-set-key "\C-c\C-c" #'j-compile-command)
    (local-set-key "\C-cj" #'google-java-format-region)
    (local-set-key "\C-cI" #'lsp-java-organize-imports)
    (local-set-key "\C-ci" #'lsp-java-add-import)
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
    (setq lsp-ui-sideline-enable nil)
    (when scratch-buffer
      (goto-char (point-min))
      (insert "public class LetsDoDis {\n\n\n\n}")
      (forward-line -2)))
  (add-hook 'java-mode-hook 'my-java-hooks))

(when (fboundp 'sql-mode)
  (defun now ()
    (interactive)
    (re-search-forward "'[0-9]\\{4\\}\\(-[0-9]\\{2\\}\\)\\{2\\} \\([0-9]\\{2\\}:\\)\\{2\\}[0-9]\\{2\\}\\.[0-9]'")
    (replace-match "NOW()"))
  (defun my-sql-hooks ()
    "For use in `sql-mode-hook'."
    (setq sqlformat-command 'pgformatter
          sqlformat-args '("-s2" "-g"))
    (local-set-key (kbd "C-c C-q") 'sqlformat)
    (local-set-key "\C-ccq" #'sql-set-sqli-buffer)
    (local-set-key "\C-ct"  #'now))
  (add-hook 'sql-mode-hook  'my-sql-hooks))

;; (require 'sql-completion)
;; (setq sql-interactive-mode-hook
;;       (lambda ()
;;         (define-key sql-interactive-mode-map "\t" 'comint-dynamic-complete)
;;         (sql-mysql-completion-init)))

(when (fboundp 'oberon-mode)
  (defun ob-compile-command ()
    (interactive)
      (compile (concat "obnc "
                       (file-truename buffer-file-name)
                       " && "
                       (file-name-sans-extension buffer-file-name))))
  (defun my-oberon-hooks ()
    "For use in `oberon-mode-hook'."
    (abbrev-mode t)
    (local-set-key "\C-c\C-c" #'ob-compile-command))
  (add-hook 'oberon-mode-hook 'my-oberon-hooks))

(when (fboundp 'c-mode)
  (defun c-compile-command ()
    (interactive)
    (compile (concat "cc "
                     (file-truename buffer-file-name)
                     " -o "
                     (file-name-sans-extension ( file-name-nondirectory buffer-file-name))
                     " && "
                     (file-name-sans-extension buffer-file-name))))
  (defun my-c-hooks ()
    "For use in `c-mode-hook'."
    (local-set-key "\C-c\C-c" #'c-compile-command))
  (add-hook 'c-mode-hook 'my-c-hooks))

(when (fboundp 'haskell-mode)
  (defun haskell-compile-command ()
    (interactive)
    (compile (concat "runhaskell "
                     (file-truename buffer-file-name))))
  (defun my-haskell-hooks ()
    "For use in `haskell-mode-hook'."
    (local-set-key "\C-c\C-c" #'haskell-compile-command))
  (add-hook 'haskell-mode-hook 'my-haskell-hooks))

;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)
(add-hook 'go-mode-hook #'lsp-deferred)

(defun make-tramp-file-read-only-hook ()
  (when (file-remote-p (buffer-file-name))
    (setq buffer-read-only t)
    (hl-line-mode)
    (view-mode)))
(add-hook 'find-file-hook 'make-tramp-file-read-only-hook)

(with-eval-after-load 'dired
  (require 'dired-x)
  ;; Set dired-x global variables here.  For example:
  ;; (setq dired-guess-shell-gnutar "gtar")
  ;; (setq dired-x-hands-off-my-keys nil)
  (setq dired-omit-files
        (concat dired-omit-files "\\|^\\..+$")))

(add-hook 'dired-mode-hook
          (lambda ()
            ;; Set dired-x buffer-local variables here.  For example:
            (dired-omit-mode 1)))

(when (fboundp 'LilyPond-mode)
  (defun l-compile-command ()
    "Use C-c C-l to run lilypond before opening pdf and midi"
    (interactive)
    (let* ((source (file-name-nondirectory buffer-file-name))
           (out    (file-name-sans-extension source))
           (pdf  (concat out ".pdf"))
           (midi  (concat out ".midi")))
      (shell-command (format "open %s" pdf))
      (async-shell-command (format "fluidsynth -i %s" midi))))

  (defun my-lilypond-hooks ()
    "For use in `lilypond-mode-hook'."
    (local-set-key "\C-c\C-d" #'l-compile-command)
    (local-unset-key (kbd "C-c C-f")))
  (add-hook 'LilyPond-mode-hook 'my-lilypond-hooks))

(add-hook 'dired-mode-hook 'dired-hide-details-mode)
(add-hook 'calendar-today-visible-hook 'calendar-mark-today)
(add-hook 'sql-interactive-mode-hook 'my-sql-save-history-hook)
(add-hook 'LilyPond-mode-hook (lambda () (turn-on-font-lock)))
(add-hook 'find-file-hook 'make-large-file-read-only-hook)
(add-hook 'after-change-major-mode-hook 'check-and-set-whitespace-trail)
(add-hook 'font-lock-mode-hook 'color-tabs)

;; ---------
;; FUNCTIONS
;; ---------

(defun make-large-file-read-only-hook ()
  "If a file is over a given size, make the buffer read only."
  (when (and (file-exists-p (buffer-name))
             (< (* 1024 1024 2) ;2M
                (file-attribute-size (file-attributes (buffer-file-name)))))
    (setq buffer-read-only t)
    (hl-line-mode)
    (view-mode)))

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

;; (defun sql-db-local ()
;;   (interactive)
;;   (sql-connect 'db-local))

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

;;(defun json-format (start end &optional bool) (interactive "r") (shell-command-on-region start end (if bool "jq -jc" "jq -j") nil t))
;; 22:36 < bpalmer> notice that it uses interactive to provide the region bounds, and nil for the buffer
;; 22:36 < bpalmer> that could also be (interactive "rP"), so that you can use a prefix arg to handle the 'bool' flag
(defun json-format (&optional bool)
  (interactive)
  (save-excursion
    (shell-command-on-region (region-beginning)
                             (region-end)
                             (if bool "jq -jc ." "jq -j .")
                             (buffer-name)
                             t)))

(defun xml-format (&optional bool)
  (interactive)
  (if bool
      (progn
        (replace-regexp "\\(^[[:space:]]*\\|\n\\)" "" nil (region-beginning) (1- (region-end)))
        (move-beginning-of-line nil))
    (shell-command-on-region (region-beginning) (region-end) "xmllint --format -" (buffer-name) t)))

(defun myerc ()
  (interactive)
  (let
      ((password-cache nil))
    (erc
     :server "irc.libera.chat"
     :port "6667"
     :nick "ou-tis"
     ;; :password (password-read (format "password for ou-tis at Freenode? "))
     )))

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
      ;; (frame-bufs-buffer-list (selected-frame)))
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
    (cond ((or (string-equal "*scratch*" the-buff)
               (string-equal "*SQL: <db>*" the-buff))
           t)
          ((or (string-equal "diary" the-buff)
               (string-equal major-mode "dired-mode")
               (string-match "\\*.+\\*$" the-buff)
               (string-match "magit.*$" the-buff))
           nil)
          (t t))))

(defun metaar()
  (interactive)
  (message
   (shell-command-to-string
    ". ~/.bin/alif && metar lgav 2>/dev/null")))

(defun taaf()
  (interactive)
  (message
   (shell-command-to-string
    ". ~/.bin/alif && taf lgav 2>/dev/null")))

;; huaiyuan from https://stackoverflow.com/a/2592685
(require 'cl-lib)
(defun parallel-query-replace (plist &optional delimited start end)
  "Replace every occurrence of the (2n)th token of PLIST in
buffer with the (2n+1)th token; if only two tokens are provided,
replace them with each other (ie, swap them).

If optional second argument DELIMITED is nil, match words
according to syntax-table; otherwise match symbols.

When called interactively, PLIST is input as space separated
tokens, and DELIMITED as prefix arg."
  (interactive
   `(,(cl-loop with input = (read-from-minibuffer "Replace: ")
               with limit = (length input)
               for  j = 0 then i
               for (item . i) = (read-from-string input j)
               collect (prin1-to-string item t) until (<= limit i))
     ,current-prefix-arg
     ,@(if (use-region-p) `(,(region-beginning) ,(region-end)))))
  (let* ((alist (cond ((= (length plist) 2) (list plist (reverse plist)))
                      ((cl-loop for (key val . tail) on plist by #'cddr
                                collect (list (prin1-to-string key t) val)))))
         (matcher (regexp-opt (mapcar #'car alist)
                              ;; (if delimited 'words 'symbols)
                              ))
         (to-spec `(replace-eval-replacement replace-quote
                                             (cadr (assoc-string (match-string 0) ',alist
                                                                 case-fold-search)))))
    (query-replace-regexp matcher to-spec nil start end)))

(defun my-change-number-at-point (change increment)
  (or (looking-at "[0-9]+")
      (progn
        (re-search-forward "[0-9]")
        (forward-char -1)))
  (let ((number (number-at-point))
        (point (point)))
    (when number
      (progn
        (forward-word)
        (search-backward (number-to-string number))
        (replace-match (number-to-string (funcall change number increment)))
        (goto-char point)))))

(defun my-increment-number-at-point (&optional increment)
  "Increment number at point like vim's C-a"
  (interactive "p")
  (my-change-number-at-point '+ (or increment 1))
  (set-temporary-overlay-map
   (let ((map (make-sparse-keymap)))
     (define-key map (kbd "a") 'my-increment-number-at-point)
     map)))

(defun my-decrement-number-at-point (&optional increment)
  "Decrement number at point like vim's C-x"
  (interactive "p")
  (my-change-number-at-point '- (or increment 1))
  (set-temporary-overlay-map
   (let ((map (make-sparse-keymap)))
     (define-key map (kbd "x") 'my-decrement-number-at-point)
     map)))

(defun recentf-open-files-compl ()
  (interactive)
  (defun find-mult (list-of-files)
    (if (null list-of-files)
        (message "find-mult done")
      (find-file (car list-of-files))
      (find-mult (cdr list-of-files))))
  (find-mult (completing-read-multiple "Find recent files: " recentf-list)))

(defun toggle-window-split ()
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
                                         (car next-win-edges))
                                     (<= (cadr this-win-edges)
                                         (cadr next-win-edges)))))
             (splitter
              (if (= (car this-win-edges)
                     (car (window-edges (next-window))))
                  'split-window-horizontally
                'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))

;; ;; Enable transparency
;; (set-frame-parameter (selected-frame) 'alpha '(85 . 50)) ;; other 3rd arguments: <both> '(<active> . <inactive>)
;; (add-to-list 'default-frame-alist '(alpha . (85 . 50)))

(defun toggle-transparency ()
  (interactive)
  (let ((alpha (frame-parameter nil 'alpha)))
    (set-frame-parameter
     nil 'alpha
     (if (eql (cond ((numberp alpha) alpha)
                    ((numberp (cdr alpha)) (cdr alpha))
                    ;; Also handle undocumented (<active> <inactive>) form.
                    ((numberp (cadr alpha)) (cadr alpha)))
              100)
         '(85 . 50) '(100 . 100)))))

(defun djcb-opacity-modify (&optional dec)
  "modify the transparency of the emacs frame; if DEC is t,
    decrease the transparency, otherwise increase it in 10%-steps"
  (let* ((alpha-or-nil (frame-parameter nil 'alpha)) ; nil before setting
         (oldalpha (if alpha-or-nil alpha-or-nil 100))
         (newalpha (if dec (- oldalpha 10) (+ oldalpha 10))))
    (when (and (>= newalpha frame-alpha-lower-limit) (<= newalpha 100))
      (modify-frame-parameters nil (list (cons 'alpha newalpha))))))

(defun color-tabs (&optional remove)
  "Draw tabs with the same color as trailing whitespace"
  (let ((tab-handle '(("\t" 0 'trailing-whitespace prepend))))
    (if remove
        (font-lock-remove-keywords nil tab-handle)
      (font-lock-add-keywords nil tab-handle))))

(defun color-whitespace ()
  (interactive)
  (setq show-trailing-whitespace (not show-trailing-whitespace))
  (color-tabs (not show-trailing-whitespace))
  (font-lock-flush)
  (font-lock-ensure)
  (redraw-display))

(defun check-and-set-whitespace-trail ()
  (if (or (eq major-mode 'eww-mode)
          (eq major-mode 'calendar-mode)
          (eq major-mode 'Buffer-menu-mode))
      (setq show-trailing-whitespace nil)
    (setq show-trailing-whitespace t)))

(defun bind-white-clean ()
  (interactive)
  (let ((region
         (if (use-region-p)
             (cons (region-beginning) (region-end))
           (cons (point-min) (point-max)))))
    (whitespace-cleanup-region (car region) (cdr region))))

(defun toggle-indent-tabs-mode ()
  (interactive)
  (setq indent-tabs-mode (not indent-tabs-mode))
  (message "set indent-tabs-mode to %s for this buffer" indent-tabs-mode))

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
(global-set-key (kbd "<C-S-return>") 'completion-at-point)
;;(global-set-key "\C-cq" 'sql-db-local)
(global-set-key (kbd "C-c c s") 'scratch-with-prefix-arg)
(global-set-key "\C-c$" 'toggle-truncate-lines)
(global-set-key (kbd "C-S-s") 'isearch-forward-symbol-at-point)
;; (global-set-key "\C-cN" #'newsticker-show-news)
(global-set-key "\C-c\C-e" #'myerc)
(global-set-key "\C-cC" #'calendar)
;;(global-set-key (kbd "M-i") 'change-inner)
;;(global-set-key (kbd "M-o") 'change-outer)
(global-set-key (kbd "C-\\") 'er/expand-region)
;;(global-set-key [remap kill-buffer] 'kill-buffer-and-window)
(global-set-key (kbd "<C-M-tab>") #'next-multiframe-window)
(global-set-key (kbd "<C-S-M-tab>") #'previous-multiframe-window)
(global-set-key "\C-cB" #'shell)
(global-set-key (kbd "C-=") (lambda () (interactive) (text-scale-increase 0.2)))
(global-set-key (kbd "C-+") (lambda () (interactive) (text-scale-decrease 0.2)))
(global-set-key (kbd "<S-mouse-5>") (lambda () (interactive) (scroll-left 10)))
(global-set-key (kbd "<S-mouse-4>") (lambda () (interactive) (scroll-right 10)))
(global-set-key (kbd "<S-triple-wheel-up>") (lambda () (interactive) (scroll-left 10)))
(global-set-key (kbd "<S-triple-wheel-down>") (lambda () (interactive) (scroll-right 10)))
(global-set-key "\C-c\C-w" #'met-with-prefix-arg)

(global-set-key (kbd "<C-tab>") 'move-front-end-window)
(global-set-key (kbd "<C-iso-lefttab>") 'move-front-end-window-back)
;; (global-set-key (kbd "<C-S-tab>") 'move-front-end-window-back)
;; (global-set-key (kbd "<C-S-lefttab>") 'move-front-end-window-back)
;; (global-set-key (kbd "<S-M-tab>") 'move-front-end-window-back)
;; (global-set-key (kbd "ESC <backtab>") 'move-front-end-window-back)
(global-set-key (kbd "<f5>") #'move-back-end-window)
(global-set-key (kbd "<f6>") #'move-back-end-window-back)

(global-set-key "\C-cw" (lambda () (interactive) (metaar)))
(global-set-key "\C-cW" (lambda () (interactive) (taaf)))
(global-set-key "\C-x52" (lambda () (interactive) (switch-to-buffer-other-frame "*Messages*")))
;; (global-set-key "\C-x\C-b" (lambda () (interactive) (progn (list-buffers) (other-window 1))))
(global-set-key (kbd "C-h j") 'javadoc-lookup)
(global-set-key (kbd "C-c a") 'my-increment-number-at-point)
(global-set-key (kbd "C-c x") 'my-decrement-number-at-point)
(global-set-key "\C-cj" (lambda () (interactive) (json-format)))
(global-set-key "\C-cJ" (lambda () (interactive) (json-format t)))
(global-set-key "\C-ccx" (lambda () (interactive) (xml-format)))
(global-set-key "\C-ccX" (lambda () (interactive) (xml-format t)))
(global-set-key (kbd "C-c C-f") 'recentf-open-files-compl)
(global-set-key "\C-cL" 'hl-line-mode)
(global-set-key (kbd "C-c ^") 'toggle-window-split)
(global-set-key (kbd "C-c %") 'window-swap-states)

;; C-8 will increase opacity (== decrease transparency)
;; C-9 will decrease opacity (== increase transparency
;; C-0 will returns the state to normal
(global-set-key (kbd "C-8") #'(lambda()(interactive)(djcb-opacity-modify)))
(global-set-key (kbd "C-9") #'(lambda()(interactive)(djcb-opacity-modify t)))
(global-set-key (kbd "C-0") #'(lambda()(interactive)(modify-frame-parameters nil `((alpha . 100)))))
(global-set-key (kbd "C-c ct") 'toggle-transparency)
(global-set-key "\C-ccb" 'toggle-indent-tabs-mode)
(global-set-key "\C-ccw" 'color-whitespace)
(global-set-key "\C-ccc" 'bind-white-clean)

;; (global-set-key (kbd "s-x") '(lambda () (interactive) (message "hello")))
;; another key notation: [(meta insert)]

(with-eval-after-load 'magit
  (define-key magit-mode-map (kbd "<C-tab>") nil)
  (define-key magit-mode-map (kbd "<M-tab>") nil)
  (define-key magit-mode-map (kbd "<backtab>") nil)
  (define-key magit-mode-map (kbd "C-`") 'magit-section-cycle)
  (define-key magit-mode-map (kbd "M-`") 'magit-section-cycle-diffs)
  (define-key magit-mode-map "~" 'magit-section-cycle-global)
  )

(when (display-graphic-p)
  ;; or (global-set-key (kbd "C-z") nil)
  (global-unset-key (kbd "C-z")))

;; ---------
;; VARIABLES
;; ---------

(setq visible-bell nil
      column-number-mode t
      calendar-latitude 37.9
      calendar-longitude 23.7
      inhibit-startup-screen t
      ;; completion-ignore-case t
      ;; split-width-threshold 180
      ;; frame-background-mode nil
      Buffer-menu-name-width 35
      helm-buffer-max-length nil
      recentf-max-saved-items 150
      lsp-modeline-diagnostics-enable nil
      read-buffer-completion-ignore-case t
      read-file-name-completion-ignore-case t
      custom-file "~/.emacs.d/lisp/custom.el"
      mouse-wheel-scroll-amount '(1 ((shift) . 1))
      ring-bell-function (lambda nil (message ""))
      ;; initial-scratch-message ";; let's do dis\n\n"
      initial-scratch-message ";; ready, set, go\n\n"
      find-function-C-source-directory "~/.emacs.d/emacs-master/src")

;; (setq sql-connection-alist
;;       '((db-local
;;          (sql-product 'postgres)
;;          (sql-user "slevantis")
;;          (sql-database "local")
;;          (sql-server "10.9.0.77")
;;          (sql-port 5432))))

(setq display-buffer-alist
      '(("\\*\\(grep\\|log-edit-files\\|vc-log\\)\\*"
         (display-buffer-below-selected))
        ("\\*\\(java\\|sql\\|js\\|SQL: <db>\\|Buffer List\\)\\*"
         (display-buffer-same-window))
        ("*Async Shell Command*"
         display-buffer-no-window (nil))))

(setq auto-mode-alist
      (append
       '(("\\.awk\\'" . awk-mode)
         ("ChangeLog" . change-log-mode)
         ("\\.bashrc\\'" . sh-mode)
         ("\\.c\\'" . c-mode)
         ("\\.conf\\'" . conf-mode)
         ("\\.config\\'" . conf-mode)
         ("\\.css\\'" . css-mode)
         ("Dockerfile" . dockerfile-mode)
         ("\\.diff\\'" . diff-mode)
         ("\\.el\\'"  . emacs-lisp-mode)
         ("\\.emacs\\'" . emacs-lisp-mode)
         ("\\.go\\'" . go-mode)
         ("\\.htm\\'" . html-mode)
         ("\\.html\\'" . html-mode)
         ("\\.java$" . java-mode)
         ("\\.js$" . js-mode)
         ("\\.json$" . js-mode)
         ("\\.lua$" . lua-mode)
         ("\\.ly$" . LilyPond-mode)
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
         ("\\.xml$" . xml-mode) ;; psgml-mode, nxml-mode
         ("\\.xsd$" . nxml-mode) ;; xsl-mode
         ("\\.xsl$" . nxml-mode) ;; xsl-mode
         ("\\.yaml\\'" . yaml-mode)
         ("\\.yml\\'" . yaml-mode)
         ("github.*\\.txt$" . markdown-mode)
         ;; ("pom.xml" . nxml-mode)
         ("\\.http$" . restclient-mode)
         ("\\.rest$" . restclient-mode)
         ("\\.st$" . smalltalk-mode)
         ("\\.obn$" . oberon-mode)
         ("\\.Mod$" . oberon-mode)
         ("\\.mod$" . oberon-mode))))

;; -------
;; FINALLY
;; -------

;; (set-fontset-font t 'greek (font-spec :family "Monaco Sans Mono"))
(set-face-attribute 'default nil :font "Menlo" :height 160)
(make-directory "~/.emacs.d/sql/" t)
(load custom-file)

;; (load-theme 'darktooth)
;; (darktooth-modeline)
(when (display-graphic-p)
  (load-theme 'wombat))

(require 'server)
(unless (server-running-p) (server-start))

(display-time)
(diary)
