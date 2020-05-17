;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(auto-save-file-name-transforms (quote ((".*" "~/.emacs.d/autosaves/\\1" t))))
 '(backup-directory-alist (quote ((".*" . "~/.emacs.d/backups/"))))
 '(custom-enabled-themes (quote (wombat)))
 '(package-selected-packages (quote (sml-mode))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; create the autosave dir if necessary, since emacs won't.
(make-directory "~/.emacs.d/autosaves/" t)

;; ===========================
;; from here on starts my shit
(setq calendar-latitude 37.9)
(setq calendar-longitude 23.7)

(global-visual-line-mode t)
(delete-selection-mode t)
(show-paren-mode t)
(menu-bar-mode -1)
;(ido-mode 1)
;(ido-everywhere 1)

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
