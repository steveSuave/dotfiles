(use-package yasnippet :config (yas-global-mode))
;; (use-package yasnippet-snippets :ensure t)
(use-package company :config (global-company-mode 1))
(use-package which-key :config (which-key-mode))
(use-package flycheck)
(use-package hydra)
(use-package treemacs
  :ensure t
  :commands (treemacs)
  :after (lsp-mode))
(use-package lsp-treemacs)
(use-package helm                                                                                                                 
  :ensure t                                                                                                                       
  :init                                                                                                                           
  (helm-mode 1)                                                                                                                   
  (progn (setq helm-buffers-fuzzy-matching t))                                                                                    
  :bind
  ;;(("M-y" . helm-show-kill-ring))
  (("C-c h" . helm-command-prefix))                                                                                               
  (("M-x" . helm-M-x))                                                                                                            
  (("C-x C-f" . helm-find-files))                                                                                                 
  (("C-x b" . helm-buffers-list))                                                                                                 
  (("C-c b" . helm-bookmarks))                                                                                                    
  (("C-c C-f" . helm-recentf))   ;; Add new key to recentf
  ;; (("C-c g" . helm-grep-do-git-grep)) ;; Search using grep in a git project
  )
(use-package helm-descbinds
  :ensure t
  :bind ("C-h b" . helm-descbinds))
(use-package helm-lsp)
(use-package lsp-mode
  :ensure t
  :hook ((lsp-mode . lsp-enable-which-key-integration)
         (java-mode . #'lsp-deferred))
  :init (setq 
         lsp-keymap-prefix "C-c l" ; this is for which-key integration documentation, need to use lsp-mode-map
         lsp-enable-file-watchers nil
         ;read-process-output-max (* 1024 1024)  ; 1 mb
         lsp-completion-provider :capf
         lsp-idle-delay 0.500)
  :config 
  (setq lsp-intelephense-multi-root nil) ; don't scan unnecessary projects
  (with-eval-after-load 'lsp-intelephense
    (setf (lsp--client-multi-root (gethash 'iph lsp-clients)) nil))
  (define-key lsp-mode-map (kbd "C-c l") lsp-command-map))
(use-package lsp-java :config (add-hook 'java-mode-hook 'lsp))
(use-package lsp-ui)
(use-package dap-mode
  :ensure t
  :after (lsp-mode)
  :functions dap-hydra/nil
  :config
  (require 'dap-java)
  :bind (:map lsp-mode-map
              ("<f8>" . dap-debug)
              ("M-<f8>" . dap-hydra))
  :hook ((dap-mode . dap-ui-mode)
         ;; (dap-session-created . (lambda (&_rest) (dap-hydra)))
         ;; (dap-terminated . (lambda (&_rest) (dap-hydra/nil))))
         ))
(use-package dap-java :ensure nil)
(use-package projectile 
  :ensure t
  :init (projectile-mode +1)
  :config 
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(use-package javadoc-lookup)

(provide 'my-used-packages)

