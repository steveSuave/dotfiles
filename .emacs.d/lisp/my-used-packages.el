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
(straight-use-package 'yaml-mode)
(straight-use-package 'restclient)
(straight-use-package 'use-package)
(straight-use-package 'racket-mode)
(straight-use-package 'expand-region)
(straight-use-package 'smalltalk-mode)
(straight-use-package 'javadoc-lookup)

(straight-use-package 'vlfi)
(require 'vlf-setup)
(defun make-large-file-read-only-hook ()
  "If a file is over a given size, make the buffer read only."
  (when (< (* 1024 1024 2) ;2M
           (file-attribute-size (file-attributes (buffer-file-name))))
    (setq buffer-read-only t)
    (hl-line-mode)
    (view-mode)))
(add-hook 'vlf-before-chunk-update-hook 'make-large-file-read-only-hook)

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

(use-package elfeed
  :straight t
  :bind ("C-c N" . elfeed)
  :config
  (setq elfeed-feeds
        '(("http://anaskafi.blogspot.com/feeds/posts/default" anaskafi archaeo)
          ("http://rss.slashdot.org/Slashdot/slashdotMain" slashdot tech)
          ("https://sarantakos.wordpress.com/feed" sarantakos fun)
          ("https://www.reutersagency.com/feed/" reuters news)
          ("http://feeds2.feedburner.com/MarksDailyApple/" marksapple health)
          ("https://eli.thegreenplace.net/feeds/all.atom.xml" eli tech)
          ("https://binarycoders.dev/feed/" bcoders tech)
          ("https://greatnavigators.com/feed" navigators sea fun)
          ("https://mostlydeadlanguages.tumblr.com/rss" deadlang archaeo)
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
                  (js-mode "{" "}" "/[*/]" nil)
                  (json-mode "{" "}" "/[*/]" nil)
                  (javascript-mode  "{" "}" "/[*/]" nil)))))

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
