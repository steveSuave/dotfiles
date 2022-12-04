;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :straight t
  :init
  (savehist-mode))

(defadvice vertico-insert
    (after vertico-insert-add-history activate)
  "Make vertico-insert add to the minibuffer history."
  (unless (eq minibuffer-history-variable t)
    (add-to-history minibuffer-history-variable (minibuffer-contents))))

;; Enable rich annotations using the Marginalia package
(use-package marginalia
  :straight t
  ;; Either bind `marginalia-cycle' globally or only in the minibuffer
  :bind (("M-A" . marginalia-cycle)
         :map minibuffer-local-map
         ("M-A" . marginalia-cycle))

  ;; The :init configuration is always executed (Not lazy!)
  :init

  ;; Must be in the :init section of use-package such that the mode gets
  ;; enabled right away. Note that this forces loading the package.
  (marginalia-mode))

;; ================================================================

(straight-use-package 'vlfi)
(require 'vlf-setup)
(add-hook 'vlf-before-chunk-update-hook 'make-large-file-read-only-hook)

(straight-use-package 'flycheck)
(flycheck-define-checker java-checkstyle
  "A java syntax checker using checkstyle. See `https://www.checkstyle.org'."
  :command ("java" "-jar" "~/Downloads/checkstyle-9.1-all.jar" "-c" "~/checkstyle/src/main/resources/sun_checks.xml" source)
  :error-patterns
  ((error line-start "[ERROR] " (file-name) ":" line ":" column ": " (message) ". [" (id (one-or-more alnum)) "]" line-end))
  :modes java-mode)

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

;; Deprecating helm
(define-key help-map "\C-h" 'which-key-C-h-dispatch)
(define-key helm-map (kbd "TAB") #'helm-execute-persistent-action)
(define-key helm-map (kbd "<tab>") #'helm-execute-persistent-action)
(define-key helm-map (kbd "C-j") #'helm-select-action)

(use-package projectile
  :straight t
  :defer t
  :init (projectile-mode +1)
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(use-package company
  :straight t
  :defer t
  :config (global-company-mode 1))
(global-set-key (kbd "<C-return>") 'company-complete)
(add-hook 'sql-interactive-mode-hook 'company-mode)

(straight-use-package 'hydra)

;; ================================================================
;; LSP JAVA

(use-package lsp-mode
  :straight t
  :init (setq
         lsp-keymap-prefix "C-c l"    ; this is for which-key integration documentation, need to use lsp-mode-map
         lsp-enable-file-watchers nil)
  :hook ((lsp-mode . lsp-enable-which-key-integration)))

(use-package lsp-java
  :straight t
  :config
  (add-hook 'java-mode-hook 'lsp)
  ;; ;; Use Google style formatting by default
  ;; (setq lsp-java-format-settings-url
  ;;       "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml")
  ;; (setq lsp-java-format-settings-profile "GoogleStyle")
  )

(require 'lsp-java-boot)
;; to enable the lenses
(add-hook 'lsp-mode-hook #'lsp-lens-mode)
(add-hook 'java-mode-hook #'lsp-java-boot-lens-mode)

(use-package dap-mode
  :straight t
  :after lsp-mode
  :config (dap-auto-configure-mode))

(use-package lsp-ui :straight t)
(use-package helm-lsp :straight t)
(use-package lsp-treemacs :straight t)
(global-set-key "\C-cm" #'treemacs)
(setq treemacs--width-is-locked nil)

;; ================================================================
