(defun tree-sitter-mark-bigger-node ()
  (interactive)
  (let* ((root (tsc-root-node tree-sitter-tree))
         (node (tsc-get-descendant-for-position-range root (region-beginning) (region-end)))
         (node-start (tsc-node-start-position node))
         (node-end (tsc-node-end-position node)))
    ;; Node fits the region exactly. Try its parent node instead.
    (when (and (= (region-beginning) node-start) (= (region-end) node-end))
      (when-let ((node (tsc-get-parent node)))
        (setq node-start (tsc-node-start-position node)
              node-end (tsc-node-end-position node))))
    (set-mark node-end)
    (goto-char node-start)))
