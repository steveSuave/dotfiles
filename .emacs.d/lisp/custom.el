(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(LilyPond-all-midi-command "fluidsynth -i")
 '(LilyPond-midi-command "fluidsynth -i")
 '(LilyPond-pdf-command "xdg-open")
 '(calendar-date-style 'iso)
 '(display-time-24hr-format t)
 '(ediff-split-window-function 'split-window-horizontally)
 '(ediff-window-setup-function 'ediff-setup-windows-plain)
 '(erc-autojoin-channels-alist '((Libera.Chat "#cb7")))
 '(erc-nick-uniquifier "+")
 '(erc-scrolltobottom-mode t)
 '(flutter-sdk-path '~/development/flutter/ t)
 '(font-lock-global-modes
   '(not elfeed-search-mode elfeed-show-mode gnus-summary-mode gnus-article-mode))
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
     (holiday-greek-orthodox-easter -48 "Kathara Deytera")
     (holiday-greek-orthodox-easter)
     (holiday-greek-orthodox-easter 50 "Agiou Pnevmatos")
     (holiday-fixed 5 1 "Prwtomagia")
     (holiday-fixed 8 15 "Koimisi")
     (holiday-fixed 10 28 "Oxi")
     (holiday-fixed 12 25 "Christougenna")
     (holiday-fixed 12 26 "Synaxi")))
 '(holiday-solar-holidays nil)
 '(ibuffer-formats
   '((mark modified read-only locked " "
           (name 35 35 :left :elide)
           " "
           (size 9 -1 :right)
           " "
           (mode 16 16 :left :elide)
           " " filename-and-process)
     (mark " "
           (name 16 -1)
           " " filename)))
 '(ibuffer-saved-filter-groups
   '(("BF"
      ("user"
       (predicate front-bufsp))
      ("system"
       (predicate not
                  (front-bufsp))))))
 '(lsp-dart-flutter-executable "~/development/flutter/bin/flutter")
 '(lsp-dart-flutter-sdk-dir "~/development/flutter/")
 '(lsp-dart-sdk-dir "~/development/flutter/bin/cache/dart-sdk/")
 '(magit-display-buffer-function 'magit-display-buffer-fullframe-status-v1)
 '(minions-mode-line-lighter "etc")
 '(minions-prominent-modes '(vlf-mode))
 '(mode-require-final-newline 'ask)
 '(newsticker-url-list
   '(("thalassoporoi" "https://greatnavigators.com/feed" nil nil nil)
     ("anaskafi" "http://anaskafi.blogspot.com/feeds/posts/default" nil nil nil)
     ("slashdot" "http://rss.slashdot.org/Slashdot/slashdotMain" nil nil nil)
     ("eli-bendersky" "https://eli.thegreenplace.net/feeds/all.atom.xml" nil nil nil)))
 '(org-format-latex-options
   '(:foreground default :background default :scale 2.0 :html-foreground "Black" :html-background "Transparent" :html-scale 1.0 :matchers
                 ("begin" "$1" "$" "$$" "\\(" "\\[")))
 '(python-shell-interpreter "python3")
 '(require-final-newline 'ask)
 '(scheme-program-name "mit-scheme")
 '(sml-program-name "poly")
 '(tab-width 4)
 '(tcl-application "tclsh")
 '(treemacs-show-hidden-files nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(erc-input-face ((t (:foreground "salmon"))))
 '(erc-my-nick-face ((t (:foreground "goldenrod" :weight bold))))
 '(hl-line ((t (:inherit nil :extend t :background "gray21" :underline nil))))
 '(trailing-whitespace ((t (:background "gray74")))))
