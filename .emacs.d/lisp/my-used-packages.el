(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'gptel)
(straight-use-package 'go-mode)
(straight-use-package 'lua-mode)
(straight-use-package 'sml-mode)
;;(straight-use-package 'dart-mode)
(straight-use-package 'sqlformat)
(straight-use-package 'yaml-mode)
(straight-use-package 'rust-mode)
;;(straight-use-package 'impostman)
(straight-use-package 'restclient)
(straight-use-package 'groovy-mode)
(straight-use-package 'use-package)
(straight-use-package 'racket-mode)
(straight-use-package 'haskell-mode)
(straight-use-package 'feature-mode)
(straight-use-package 'markdown-mode)
(straight-use-package 'darcula-theme)
(straight-use-package 'expand-region)
(straight-use-package 'smalltalk-mode)
(straight-use-package 'javadoc-lookup)
(straight-use-package 'dockerfile-mode)

(use-package esup
  :straight t
  :config (setq esup-depth 0))

(use-package minions
  :straight t
  :config (minions-mode 1))

(use-package which-key
  :straight t
  :config (which-key-mode))

(use-package texfrag
  :straight t
  :config
  (add-hook 'markdown-mode-hook #'texfrag-mode))

(defun my/ansi-colorize-buffer ()
  (let ((buffer-read-only nil))
    (ansi-color-apply-on-region (point-min) (point-max))))

(use-package ansi-color
  :straight t
  :config
  (add-hook 'compilation-filter-hook 'my/ansi-colorize-buffer))

(use-package undo-tree
  :straight t
  :init
  (global-undo-tree-mode)
  :custom ;; customizable variable: undo-tree-auto-save-history
  (undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo"))))

;; (straight-use-package 'yasnippet-snippets)
(use-package yasnippet
  :straight t
  ;; :defer t
  :config
  (yas-global-mode)
  (define-key minibuffer-local-map [tab] yas-maybe-expand)
  (yas--define-parents 'minibuffer-inactive-mode '(fundamental-mode)))
(add-hook 'minibuffer-setup-hook 'yas-minor-mode)

(use-package hideshow
  :bind (("C-c TAB" . hs-toggle-hiding)
         ("M-+" . hs-show-all))
  :init (add-hook #'prog-mode-hook #'hs-minor-mode)
  :diminish hs-minor-mode
  :config
  (setq hs-special-modes-alist
        (mapcar 'purecopy
                '((c-mode "{" "}" "/[*/]" nil nil)
                  (c++-mode "{" "}" "/[*/]" nil nil)
                  (java-mode "{" "}" "/[*/]" nil nil)
                  (js-mode "[{[]" "[}\\]]" "/[*/]" nil)
                  (json-mode "{" "}" "/[*/]" nil)
                  (javascript-mode  "{" "}" "/[*/]" nil)))))

;; Enable vertico
(use-package vertico
  :straight t
  :init
  (vertico-mode)
  ;; Different scroll margin
  (setq vertico-scroll-margin 0)
  ;; Show more candidates
  (setq vertico-count 15)
  ;; Grow and shrink the Vertico minibuffer
  ;; (setq vertico-resize t)
  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  (setq vertico-cycle t))

(use-package orderless
  :straight t
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic partial-completion)
        completion-category-defaults nil
        completion-category-overrides '((file (styles basic partial-completion)))
        ;; orderless-matching-styles '(orderless-regexp orderless-literal orderless-flex)
        orderless-style-dispatchers '(without-if-bang)))

(defun without-if-bang (pattern _index _total)
  (cond
   ((equal "!" pattern)
    '(orderless-literal . ""))
   ((string-prefix-p "!" pattern)
    `(orderless-without-literal . ,(substring pattern 1)))))

(use-package reverse-im
  :straight t
  :custom
  (reverse-im-input-methods '("greek"))
  ;; (reverse-im-activate "ukrainian-computer") ; the legacy way
  :config
  (reverse-im-mode t))

(use-package flutter
  :straight t
  :after dart-mode
  :bind (:map dart-mode-map
              ("C-M-x" . #'flutter-run-or-hot-reload))
  :custom
  (flutter-sdk-path "/Users/stefanoslevantis/development/flutter/"))

;; A few more useful configurations...
(use-package emacs
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  (setq read-extended-command-predicate
        #'command-completion-default-include-p)

  ;; Do not allow the cursor in the minibuffer prompt
  ;; (setq minibuffer-prompt-properties
  ;;       '(read-only t cursor-intangible t face minibuffer-prompt))
  ;; (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  (setq enable-recursive-minibuffers t))

(straight-use-package 'magit)
(with-eval-after-load 'magit
  (define-key magit-mode-map (kbd "<C-tab>") nil)
  (define-key magit-mode-map (kbd "<M-tab>") nil)
  (define-key magit-mode-map (kbd "<backtab>") nil)
  (define-key magit-mode-map (kbd "C-`") 'magit-section-cycle)
  (define-key magit-mode-map (kbd "M-`") 'magit-section-cycle-diffs)
  (define-key magit-mode-map "~" 'magit-section-cycle-global))

(straight-use-package 'diff-hl)
(global-diff-hl-mode)
(diff-hl-flydiff-mode)
(diff-hl-margin-mode)

(defun setup-lsp ()
  (interactive)

  (use-package company
    :straight t
    :config
    (global-company-mode)
    (global-set-key (kbd "<C-return>") 'company-complete))

  (use-package projectile
    :straight t
    :config
    (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
    (add-hook 'lsp-mode-hook 'projectile-mode))

  (straight-use-package 'flycheck)

  (use-package lsp-mode
    :straight t
    :commands (lsp lsp-deferred)
    :init
    (setq lsp-keymap-prefix "C-c l")
    :config
    (setq lsp-headerline-breadcrumb-enable nil)
    (setq lsp-modeline-code-actions-enable nil)
    (lsp-enable-which-key-integration t)))

;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-organize-imports t t)
  (add-hook 'before-save-hook #'lsp-format-buffer t t))

(defun setup-lsp-go ()
  (interactive)
  (setup-lsp)
  (add-hook 'go-mode-hook #'lsp-deferred)
  (add-hook 'go-mode-hook #'lsp-go-install-save-hooks))

(defun setup-lsp-java ()
  (interactive)
  (setup-lsp)
  (use-package lsp-java
    :straight t
    :config (add-hook 'java-mode-hook 'lsp)))

(defun setup-lsp-dart ()
  (interactive)
  (setup-lsp)
  (use-package lsp-dart
    :straight t
    :config (add-hook 'dart-mode-hook 'lsp)))


;; RSS
(use-package elfeed
  :straight t
  :bind ("C-c N" . elfeed)
  :config
  (setq elfeed-feeds
        '(("http://anaskafi.blogspot.com/feeds/posts/default" fun anaskafi archaeology)
          ("http://rss.slashdot.org/Slashdot/slashdotMain" slashdot tech)
          ("https://sarantakos.wordpress.com/feed" sarantakos fun)
          ;; https://codarium.substack.com/p/returning-the-killed-rss-of-reuters
          ("https://news.google.com/rss/search?q=when:24h+allinurl:reuters.com&ceid=US:en&hl=en-US&gl=US" reuters news)
          ("http://feeds2.feedburner.com/MarksDailyApple/" marksapple health)
          ("https://eli.thegreenplace.net/feeds/all.atom.xml" eli tech)
          ("https://binarycoders.dev/feed/" binarycoders tech)
          ("https://greatnavigators.com/feed" navigators sea fun)
          ("https://mostlydeadlanguages.tumblr.com/rss" deadlang archaeology)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC6fZpuI4-W4jAyEquo7A-Sw" youtube marcelofinco capoeira)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCbNpPBMvCHr-TeJkkezog7Q" youtube davidbeazley tech)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCDdKVro-7hS8cMjBrcqaAMQ" youtube tilf music)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCqq3PZwp8Ob8_jN0esCunIw" youtube justforlaughs comedy)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCrgLfFlVsszE1JSzYCmj9Yg" youtube tomcunliffe sea)))

  (defun elfeed-view-entry-mpv ()
    "Watch a video from URL in MPV"
    (interactive)
    (async-shell-command
     (format "mpv %s" (mapconcat #'identity (mapcar #'elfeed-entry-link (elfeed-search-selected)) " "))))
  (define-key elfeed-search-mode-map (kbd "v") 'elfeed-view-entry-mpv)

  (defun elfeed-msg-title ()
    (interactive)
    (let ((entry (elfeed-search-selected :ignore-region)))
      (message (or (elfeed-meta entry :title) (elfeed-entry-title entry) ""))))
  (define-key elfeed-search-mode-map (kbd "w") 'elfeed-msg-title)

  (defun elfeed-view-article-mpv ()
    "Watch a video from URL in MPV"
    (interactive)
    (async-shell-command
     (format "mpv %s" (elfeed-entry-link elfeed-show-entry))))
  (define-key elfeed-show-mode-map (kbd "v") 'elfeed-view-article-mpv))


;; GNUS configuration is a nightmare
(setq gnus-summary-line-format "%U%R %-18,18&user-date; %4L:%-25,25f %B%s\n"
      gnus-sum-thread-tree-indent " "
      gnus-sum-thread-tree-root "■ "
      gnus-sum-thread-tree-false-root "□ "
      gnus-sum-thread-tree-single-indent "▣ "
      gnus-sum-thread-tree-leaf-with-other "├─▶ "
      gnus-sum-thread-tree-vertical "│"
      gnus-sum-thread-tree-single-leaf "└─▶ ")

(setq gnus-article-sort-functions
      '((not gnus-article-sort-by-number)
        (not gnus-article-sort-by-date)))
(setq gnus-thread-sort-functions
      '((not gnus-thread-sort-by-date)
        (not gnus-thread-sort-by-number)))
(setq gnus-subthread-sort-functions
      'gnus-thread-sort-by-date)

(setq gnus-user-date-format-alist
      '(((gnus-seconds-today) . "Today at %R")
        ((+ (* 60 60 24) (gnus-seconds-today)) . "Yesterday, %R")
        (t . "%Y-%m-%d %R")))

(gptel-make-anthropic "Claude"          ;Any name you want
  :stream t                             ;Streaming responses
  :key "")

;; (gptel-make-ollama
;;  "Ollama"                  ;Any name of your choosing
;;  :host "localhost:11434"   ;Where it's running
;;  :models '("codellama" "llama2" "orca-mini" "llama3" "mistral" "gemma" "codegemma" "wizard-math" "meditron" "llama-pro" "llama2-uncensored" "ilsp/meltemi-instruct") ;Installed models
;;  :stream t)

;; ================================================================
(use-package copilot
  :straight (:host github :repo "copilot-emacs/copilot.el" :files ("*.el"))
  :ensure t)
;; you can utilize :map :hook and :config to customize copilot

(with-eval-after-load 'company
  ;; disable inline previews
  (delq 'company-preview-if-just-one-frontend company-frontends))

(define-key copilot-completion-map (kbd "<tab>") 'copilot-accept-completion)
(define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion)
;; Login to Copilot by M-x copilot-login. You can also check the
;; status by M-x copilot-diagnose.
;; ================================================================

;; (use-package ellama
;;   :straight t
;;   :init
;;   ;; setup key bindings
;;   (setopt ellama-keymap-prefix "C-c e")
;;   ;; language you want ellama to translate to
;;   (setopt ellama-language "English")
;;   ;; could be llm-openai for example
;;   (require 'llm-ollama)
;;   (setopt ellama-provider
;;           (make-llm-ollama
;;            ;; this model should be pulled to use it
;;            ;; value should be the same as you print in terminal during pull
;;            :chat-model "mistral"
;;            :embedding-model "mistral"))
;;   ;; Predefined llm providers for interactive switching.
;;   ;; You shouldn't add ollama providers here - it can be selected interactively
;;   ;; without it. It is just example.
;;   (setopt ellama-providers
;;           '(("zephyr" . (make-llm-ollama
;;                          :chat-model "zephyr"
;;                          :embedding-model "zephyr"))
;;             ))
;;   ;; Naming new sessions with llm
;;   (setopt ellama-naming-provider
;;           (make-llm-ollama
;;            :chat-model "mistral"
;;            :embedding-model "mistral"))
;;   (setopt ellama-naming-scheme 'ellama-generate-name-by-llm)
;;   ;; Translation llm provider
;;   (setopt ellama-translation-provider (make-llm-ollama
;;                                        :chat-model "openchat"
;;                                        :embedding-model "nomic-embed-text")))


(provide 'my-used-packages)
