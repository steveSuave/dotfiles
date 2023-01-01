(when (fboundp 'c-mode)
  (defun c-compile-command ()
    (interactive)
    (let* ((start (if (use-region-p) (region-beginning) (point-min)))
           (end (if (use-region-p) (region-end) (point-max)))
           (file-name
            (if (or scratch-buffer (use-region-p))
                (make-temp-file "C" nil ".c" (buffer-substring-no-properties start end))
              (buffer-file-name))))
      (if (or scratch-buffer (use-region-p))
        (cd (file-name-directory file-name)))
      (compile (concat "cc "
                       file-name
                       " -o "
                       (file-name-sans-extension (file-name-nondirectory file-name))
                       " && "
                       (file-name-sans-extension file-name)) t)))
  (defun my-c-hooks ()
    "For use in `c-mode-hook'."
    (local-set-key "\C-c\C-c" #'c-compile-command))
  (add-hook 'c-mode-hook 'my-c-hooks))
