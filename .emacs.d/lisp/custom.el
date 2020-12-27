(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-file-name-transforms '((".*" "~/.emacs.d/autosaves/\\1" t)))
 '(backup-directory-alist '((".*" . "~/.emacs.d/backups/")))
 '(calendar-date-style 'iso)
 '(display-time-24hr-format t)
 '(ediff-split-window-function 'split-window-horizontally)
 '(ediff-window-setup-function 'ediff-setup-windows-plain)
 '(holiday-bahai-holidays nil)
 '(holiday-christian-holidays nil)
 '(holiday-general-holidays nil)
 '(holiday-hebrew-holidays nil)
 '(holiday-islamic-holidays nil)
 '(holiday-oriental-holidays nil)
 '(holiday-other-holidays
   '((holiday-fixed 1 1 "Prwtoxronia")
     (holiday-fixed 1 6 "Theofaneia")
     (holiday-fixed 3 25 "Eyaggelismos")
     ;; kathara deytera = easter - 48 days
     (holiday-greek-orthodox-easter)
     ;; agiou pnevmatos = easter + 48 days
     (holiday-fixed 5 1 "Prwtomagia")
     (holiday-fixed 8 15 "Koimisi")
     (holiday-fixed 10 28 "Oxi")
     (holiday-fixed 12 25 "Christougenna")
     (holiday-fixed 12 26 "Synaxi")))
 '(holiday-solar-holidays nil)
 '(newsticker-url-list
   '(("thalassoporoi" "https://greatnavigators.com/feed" nil nil nil)
     ("slashdot" "http://rss.slashdot.org/Slashdot/slashdotMain" nil nil nil)
     ("eli-bendersky" "https://eli.thegreenplace.net/feeds/all.atom.xml" nil nil nil)))
 '(treemacs-show-hidden-files nil)
 '(python-shell-interpreter "python3")
 '(package-selected-packages
   '(helm
     hydra
     lsp-ui
     diff-hl
     company
     scratch
     helm-lsp
     dap-java
     dap-mode
     flycheck
     lsp-mode
     lsp-java
     treemacs
     sml-mode
     lua-mode
     which-key
     yasnippet
     restclient
     projectile
     racket-mode
     lsp-treemacs
     change-inner
     expand-region
     javadoc-lookup
     darktooth-theme)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(erc-input-face ((t (:foreground "salmon"))))
 '(erc-my-nick-face ((t (:foreground "goldenrod" :weight bold)))))
