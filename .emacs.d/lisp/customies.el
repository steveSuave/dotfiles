;;-----------------
;; xah cycle buffer
;;-----------------

(defun xah-next-user-buffer ()
  "Switch to the next user buffer.
“user buffer” is determined by `xah-user-buffer-q'.
URL `http://ergoemacs.org/emacs/elisp_next_prev_user_buffer.html'
Version 2016-06-19"
  (interactive)
  (next-buffer)
  (let ((i 0))
    (while (< i 20)
      (if (not (xah-user-buffer-q))
          (progn (next-buffer)
                 (setq i (1+ i)))
        (progn (setq i 100))))))

(defun xah-previous-user-buffer ()
  "Switch to the previous user buffer.
“user buffer” is determined by `xah-user-buffer-q'.
URL `http://ergoemacs.org/emacs/elisp_next_prev_user_buffer.html'
Version 2016-06-19"
  (interactive)
  (previous-buffer)
  (let ((i 0))
    (while (< i 20)
      (if (not (xah-user-buffer-q))
          (progn (previous-buffer)
                 (setq i (1+ i)))
        (progn (setq i 100))))))

(defun xah-user-buffer-q ()
  "Return t if current buffer is a user buffer, else nil.
Typically, if buffer name starts with *, it's not considered a user buffer.
This function is used by buffer switching command and close buffer command, so that next buffer shown is a user buffer.
You can override this function to get your idea of “user buffer”.
version 2016-06-18"
  (interactive)
  (cond ((or (string-equal "*js*" (buffer-name))
             (string-equal "*sql*" (buffer-name))
             (string-equal "*java*" (buffer-name))
             (string-equal "*scratch*" (buffer-name)))
         t)
        ((or (string-equal "diary" (buffer-name))
             (string-equal major-mode "dired-mode")
             (string-equal "*" (substring (buffer-name) 0 1)))
         nil)        
        (t t)))

(defun xah-next-emacs-buffer ()
  "Switch to the next emacs buffer.
“emacs buffer” here is buffer whose name starts with *.
URL `http://ergoemacs.org/emacs/elisp_next_prev_user_buffer.html'
Version 2016-06-19"
  (interactive)
  (next-buffer)
  (let ((i 0))
    (while (and (not (string-equal "*" (substring (buffer-name) 0 1))) (< i 20))
      (setq i (1+ i)) (next-buffer))))

(defun xah-previous-emacs-buffer ()
  "Switch to the previous emacs buffer.
“emacs buffer” here is buffer whose name starts with *.
URL `http://ergoemacs.org/emacs/elisp_next_prev_user_buffer.html'
Version 2016-06-19"
  (interactive)
  (previous-buffer)
  (let ((i 0))
    (while (and (not (string-equal "*" (substring (buffer-name) 0 1))) (< i 20))
      (setq i (1+ i)) (previous-buffer))))

(global-set-key (kbd "ESC <backtab>") 'xah-previous-user-buffer)
(global-set-key (kbd "<f5>") 'xah-previous-emacs-buffer)
(global-set-key (kbd "<f6>") 'xah-next-emacs-buffer)

;; ------------------------------------------------------------------
;; Make alt-tab work (it takes a minor mode for extensibilitys shake)
;; ------------------------------------------------------------------

(define-key function-key-map [(control shift iso-lefttab)] [(control shift tab)])
(define-key function-key-map [(meta shift iso-lefttab)] [(meta shift tab)])
(define-key function-key-map [(meta control shift iso-lefttab)] [(meta control shift tab)])
(defvar tsa-keys-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "M-TAB") 'xah-next-user-buffer) ;; this works most of the time
    (define-key map [(meta tab)] 'xah-next-user-buffer)  ;; gnus
    (define-key map "\M-\C-i" 'xah-next-user-buffer) ;;  gnus
    (define-key map (kbd "M-C-i") 'xah-next-user-buffer) ;; gnus
    (define-key map [M-tab] 'xah-next-user-buffer) ;; from magit
    map)
  "tsa-keys-minor-mode keymap.")

(define-minor-mode tsa-keys
  "A minor mode so that my key settings override annoying major modes."
  :init-value t)
;; :lighter " aT" ; for displaying in major-minor modes

(global-set-key (kbd "<C-f3>") 'tsa-keys)
(tsa-keys 1)

(add-hook 'after-load-functions 'my-keys-have-priority)

(defun my-keys-have-priority (_file)
  "Try to ensure that my keybindings retain priority over other minor modes.

Called via the `after-load-functions' special hook."
  (unless (eq (caar minor-mode-map-alist) 'tsa-keys)
    (let ((mykeys (assq 'tsa-keys minor-mode-map-alist)))
      (assq-delete-all 'tsa-keys minor-mode-map-alist)
      (add-to-list 'minor-mode-map-alist mykeys))))

(provide 'customies)
;; ------------------------------------------------------------------------------

