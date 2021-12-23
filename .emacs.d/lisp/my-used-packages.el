(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'magit)
(straight-use-package 'diff-hl)
(straight-use-package 'go-mode)
;; (straight-use-package 'hydra)
(straight-use-package 'lua-mode)
(straight-use-package 'sml-mode)
(straight-use-package 'flycheck)
(straight-use-package 'sqlformat)
(straight-use-package 'restclient)
(straight-use-package 'use-package)
(straight-use-package 'racket-mode)
(straight-use-package 'expand-region)
(straight-use-package 'javadoc-lookup)

(use-package esup
  :straight t
  :config (setq esup-depth 0))

(use-package minions
  :straight t
  :config (minions-mode 1))

(use-package which-key
  :straight t
  :config (which-key-mode))

(use-package helm
  :straight t
  :init
  (helm-mode 1)
  (progn (setq helm-buffers-fuzzy-matching t))
  :bind
  (("C-c h" . helm-command-prefix))
  (("M-x" . helm-M-x))
  (("C-x C-f" . helm-find-files))
  (("C-x b" . helm-buffers-list))
  (("C-c b" . helm-bookmarks))
  (("C-c C-f" . helm-recentf))         ;; Add new key to recentf
  (("C-c g" . helm-grep-do-git-grep))) ;; Search using grep in a git project

(use-package helm-descbinds
  :straight t
  :bind ("C-h b" . helm-descbinds))

(use-package company
  :straight t
  :defer t
  :config (global-company-mode 1))

(defun my/ansi-colorize-buffer ()
  (let ((buffer-read-only nil))
    (ansi-color-apply-on-region (point-min) (point-max))))

(use-package ansi-color
  :straight t
  :config
  (add-hook 'compilation-filter-hook 'my/ansi-colorize-buffer))

(use-package projectile
  :straight t
  :defer t
  :init (projectile-mode +1)
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(straight-use-package 'yasnippet-snippets)
(use-package yasnippet
  :straight t
  :defer t
  :config
  (yas-global-mode)
  (define-key minibuffer-local-map [tab] yas-maybe-expand)
  (yas--define-parents 'minibuffer-inactive-mode '(fundamental-mode)))


(flycheck-define-checker java-checkstyle
  "A java syntax checker using checkstyle. See `https://www.checkstyle.org'."
  :command ("java" "-jar" "~/Downloads/checkstyle-9.1-all.jar" "-c" "~/checkstyle/src/main/resources/sun_checks.xml" source)
  :error-patterns
  ((error line-start "[ERROR] " (file-name) ":" line ":" column ": " (message) ". [" (id (one-or-more alnum)) "]" line-end))
  :modes java-mode)

;;================================================================
;; LSP JAVA

;; (use-package lsp-mode
;;   :straight t
;;   :init (setq
;;          lsp-keymap-prefix "C-c l"    ; this is for which-key integration documentation, need to use lsp-mode-map
;;          lsp-enable-file-watchers nil)
;;   :hook ((lsp-mode . lsp-enable-which-key-integration)))

;; (use-package lsp-java
;;   :straight t
;;   :config
;;   (add-hook 'java-mode-hook 'lsp)
;;   ;; ;; Use Google style formatting by default
;;   ;; (setq lsp-java-format-settings-url
;;   ;;       "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml")
;;   ;; (setq lsp-java-format-settings-profile "GoogleStyle")
;;   )

;; (require 'lsp-java-boot)
;; ;; to enable the lenses
;; (add-hook 'lsp-mode-hook #'lsp-lens-mode)
;; (add-hook 'java-mode-hook #'lsp-java-boot-lens-mode)

;; (use-package dap-mode
;;   :straight t
;;   :after lsp-mode
;;   :config (dap-auto-configure-mode))

;; (use-package lsp-ui :straight t)
;; (use-package helm-lsp :straight t)
;; (use-package lsp-treemacs :straight t)

;; ================================================================


(provide 'my-used-packages)
