;; ------------------------------------------------------------------
;; Make alt-tab work (it takes a minor mode for extensibilitys shake)
;; ------------------------------------------------------------------

(define-key function-key-map [(control shift iso-lefttab)] [(control shift tab)])
(define-key function-key-map [(meta shift iso-lefttab)] [(meta shift tab)])
(define-key function-key-map [(meta control shift iso-lefttab)] [(meta control shift tab)])
(defvar tsa-keys-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "M-TAB") 'move-front-end-window) ;; this works most of the time
    (define-key map [(meta tab)] 'move-front-end-window)  ;; gnus
    (define-key map "\M-\C-i" 'move-front-end-window) ;;  gnus
    (define-key map (kbd "M-C-i") 'move-front-end-window) ;; gnus
    (define-key map [M-tab] 'move-front-end-window) ;; from magit
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

(provide 'minor-mode-to-make-alt-tab-work)

;; ------------------------------------------------------------------

