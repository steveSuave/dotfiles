(package-initialize)

(custom-set-variables
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(auto-save-file-name-transforms (quote ((".*" "~/.emacs.d/autosaves/\\1" t))))
 '(backup-directory-alist (quote ((".*" . "~/.emacs.d/backups/"))))
 '(custom-enabled-themes (quote (wombat)))
 '(newsticker-url-list
    (quote
      (("slashdot" "http://rss.slashdot.org/Slashdot/slashdotMain" nil nil nil)
       ("thalassoporoi" "https://greatnavigators.com/feed" nil nil nil)
       ("eli-bendersky" "https://eli.thegreenplace.net/feeds/all.atom.xml" nil nil nil))))
 '(package-selected-packages (quote (sml-mode))))

(custom-set-faces

)

;; create the autosave dir if necessary, since emacs won't.
(make-directory "~/.emacs.d/autosaves/" t)

;; ===========================
;; from here on starts my stuff
(setq calendar-latitude 37.9)
(setq calendar-longitude 23.7)

(global-visual-line-mode t)
(delete-selection-mode t)
(show-paren-mode t)
(menu-bar-mode -1)

(setq-default indent-tabs-mode nil)
(defalias 'yes-or-no-p 'y-or-n-p)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; someguys functions to emulate vi o and O
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

(defun vi-open-line (&optional abovep)
  "Insert a newline below the current line and put point at beginning.
With a prefix argument, insert a newline above the current line."
  (interactive "P")
  (if abovep
      (vi-open-line-above)
    (vi-open-line-below)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; could emulate vi o with this (typou makro?)
;(global-set-key "\C-co" "\C-a\C-j\C-p")

;; original suggestion was to bind vi-open-line to
;; M-insert as follows: [(meta insert)]

;; vims o  = C-c o
(define-key global-map "\C-co" 'vi-open-line)
;; vims O  = C-c O
(define-key global-map "\C-cO" 'vi-open-line-above)
;; vims dd = C-c d
(global-set-key "\C-cd" 'kill-whole-line)
;; vims yy = C-c y
(global-set-key "\C-cy" "\C-a\C- \C-n\M-w")

;; toggle numbers
(global-set-key "\C-cn" 'display-line-numbers-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;; unset a key
; (global-set-key (kbd "C-b") nil)

; ;; unset a key
; (global-unset-key (kbd "C-b"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(global-set-key (kbd "ESC <up>") 'scroll-down-line)
(global-set-key (kbd "ESC <down>") 'scroll-up-line)

(defun annot (num char)
  (interactive "nColumn to send cursor? \nsComment symbol to insert? ")
  (move-to-column num t)
  (insert char))
