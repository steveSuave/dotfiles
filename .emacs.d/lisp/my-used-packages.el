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
(straight-use-package 'lua-mode)
(straight-use-package 'sml-mode)
(straight-use-package 'flycheck)
(straight-use-package 'sqlformat)
(straight-use-package 'restclient)
(straight-use-package 'use-package)
(straight-use-package 'racket-mode)
(straight-use-package 'expand-region)
(straight-use-package 'javadoc-lookup)

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
  (("C-c C-f" . helm-recentf))   ;; Add new key to recentf
  ;; (("C-c g" . helm-grep-do-git-grep)) ;; Search using grep in a git project
  )

(use-package helm-descbinds
  :straight t
  :bind ("C-h b" . helm-descbinds))

(use-package company
  :straight t
  :config (global-company-mode 1))

(straight-use-package 'yasnippet-snippets)
(use-package yasnippet :straight t :config (yas-global-mode))

;;================================================================
;; LSP JAVA

;; (setenv "JAVA_HOME"  "path_to_java_folder/Contents/Home/")
;; (setq lsp-java-java-path "path_to_java_folder/Contents/Home/bin/java"

;; Avoid garbage collection at statup
;; (setq gc-cons-threshold most-positive-fixnum ; 2^61 bytes
;;       gc-cons-percentage 0.6)

;; (add-hook 'emacs-startup-hook
;;   (lambda ()
;;     (setq gc-cons-threshold 300000000 ; 300mb
;;           gc-cons-percentage 0.1)))

(defun my/ansi-colorize-buffer ()
  (let ((buffer-read-only nil))
    (ansi-color-apply-on-region (point-min) (point-max))))

(use-package ansi-color
  :straight t
  :config
  (add-hook 'compilation-filter-hook 'my/ansi-colorize-buffer))

(use-package projectile
  :straight t
  :init (projectile-mode +1)
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(straight-use-package 'hydra)

(use-package dap-mode
  :straight t
  :after (lsp-mode)
  :functions dap-hydra/nil
  :config
  (require 'dap-java)
  :bind (:map lsp-mode-map
              ("<f8>" . dap-debug)
              ("M-<f8>" . dap-hydra))
  :hook ((dap-mode . dap-ui-mode)
         ;;   (dap-session-created . (lambda (&_rest) (dap-hydra)))
         ;;   (dap-terminated . (lambda (&_rest) (dap-hydra/nil)))
         ))

(use-package lsp-treemacs
  :straight t
  :after (lsp-mode treemacs)
  :commands lsp-treemacs-errors-list
  :bind (:map lsp-mode-map
              ("M-9" . lsp-treemacs-errors-list)))

(use-package treemacs
  :straight t
  :commands (treemacs)
  :after (lsp-mode))

(use-package lsp-ui
  :straight t
  :after (lsp-mode)
  :bind (:map lsp-ui-mode-map
              ([remap xref-find-definitions] . lsp-ui-peek-find-definitions)
              ([remap xref-find-references] . lsp-ui-peek-find-references))
  :init (setq lsp-ui-doc-delay 1.5
              lsp-ui-doc-position 'bottom
              lsp-ui-doc-max-width 100))

(use-package helm-lsp
  :straight t
  :after (lsp-mode)
  :commands (helm-lsp-workspace-symbol)
  :init (define-key lsp-mode-map [remap xref-find-apropos] #'helm-lsp-workspace-symbol))

(use-package lsp-mode
  :straight t
  :hook ((lsp-mode . lsp-enable-which-key-integration)
         (java-mode . #'lsp-deferred))
  :init (setq
         lsp-keymap-prefix "C-c l"              ; this is for which-key integration documentation, need to use lsp-mode-map
         lsp-enable-file-watchers nil
         read-process-output-max (* 1024 1024)  ; 1 mb
         lsp-completion-provider :capf
         lsp-idle-delay 0.500)
  :config
  (setq lsp-intelephense-multi-root nil) ; don't scan unnecessary projects
  (with-eval-after-load 'lsp-intelephense
    (setf (lsp--client-multi-root (gethash 'iph lsp-clients)) nil))
  (define-key lsp-mode-map (kbd "C-c l") lsp-command-map))

(use-package lsp-java
  :straight t
  :config (add-hook 'java-mode-hook 'lsp))

;;================================================================
;; LSP JAVA "minimal"

;; (use-package projectile)
;; (use-package flycheck)
;; (use-package yasnippet :config (yas-global-mode))
;; (use-package lsp-mode :hook ((lsp-mode . lsp-enable-which-key-integration))
;;   :config (setq lsp-completion-enable-additional-text-edit nil))
;; (use-package hydra)
;; (use-package company)
;; (use-package lsp-ui)
;; (use-package which-key :config (which-key-mode))
;; (use-package lsp-java :config (add-hook 'java-mode-hook 'lsp))
;; (use-package dap-mode :after lsp-mode :config (dap-auto-configure-mode))
;; (use-package dap-java :ensure nil)
;; (use-package helm-lsp)
;; (use-package helm
;;   :config (helm-mode))
;; (use-package lsp-treemacs)


(provide 'my-used-packages)
