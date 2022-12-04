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
(straight-use-package 'rust-mode)
(straight-use-package 'restclient)
(straight-use-package 'use-package)
(straight-use-package 'racket-mode)
(straight-use-package 'haskell-mode)
(straight-use-package 'markdown-mode)
(straight-use-package 'expand-region)
(straight-use-package 'smalltalk-mode)
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

;; (use-package company
;;   :straight t
;;   :defer t
;;   :config (global-company-mode 1))

(defun my/ansi-colorize-buffer ()
  (let ((buffer-read-only nil))
    (ansi-color-apply-on-region (point-min) (point-max))))

(use-package ansi-color
  :straight t
  :config
  (add-hook 'compilation-filter-hook 'my/ansi-colorize-buffer))

;; (straight-use-package 'yasnippet-snippets)
(use-package yasnippet
  :straight t
  ;; :defer t
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
          ("https://binarycoders.dev/feed/" binarycoders tech)
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
  (setq vertico-cycle t)
  )

(use-package orderless
  :straight t
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic partial-completion)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))
        ;; orderless-matching-styles '(orderless-regexp orderless-literal orderless-flex)
        orderless-style-dispatchers '(without-if-bang)))

(defun without-if-bang (pattern _index _total)
  (cond
   ((equal "!" pattern)
    '(orderless-literal . ""))
   ((string-prefix-p "!" pattern)
    `(orderless-without-literal . ,(substring pattern 1)))))

;; (flycheck-define-checker java-checkstyle
;;   "A java syntax checker using checkstyle. See `https://www.checkstyle.org'."
;;   :command ("java" "-jar" "~/Downloads/checkstyle-9.1-all.jar" "-c" "~/checkstyle/src/main/resources/sun_checks.xml" source)
;;   :error-patterns
;;   ((error line-start "[ERROR] " (file-name) ":" line ":" column ": " (message) ". [" (id (one-or-more alnum)) "]" line-end))
;;   :modes java-mode)


(provide 'my-used-packages)
