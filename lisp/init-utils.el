;;; -*- lexical-binding: t -*-

;; Author:  yangxue <yangxue.cs@foxmail.com>
;; Created: 2024-07-05 11:18:22
;; License: GPLv3

;;; Commentary:

;;

;;; Code:

(defun mm/top-join-line ()
  "Join the current line with the line beneath it."
  (interactive)
  (delete-indentation 1))

(keymap-global-set "C-^" #'mm/top-join-line)


(defun mm/keyboard-quit ()
  "Do-What-I-Mean behaviour for a general `keyboard-quit'."
  (interactive)
  (cond ((region-active-p)
	 (keyboard-quit))
	((derived-mode-p 'completion-list-mode)
	 (delete-completion-window))
	((> (minibuffer-depth) 0)
	 (abort-recursive-edit))
	(t
	 (keyboard-quit))))

(keymap-global-set "C-g" #'mm/keyboard-quit)


(defun mm/comment-dwim (n)
  "Comment N lines, defaulting to the current one.
When the region is active, comment its lines instead."
  (interactive "p")
  (if (use-region-p)
      (comment-or-uncomment-region (region-beginning) (region-end))
    (comment-line n)))

(keymap-global-set "M-;" #'mm/comment-dwim)


(defun mm/quick-window-jump ()
  "My DWIM window jumping.
If there is only one windows, splite it sensibly.
If there are only two windows, jump directly to the other window.
Otherwise jump to a window by typing its assigned character label."
  (interactive)
  (let* ((window-lst (window-list nil 'no-mini))
	 (window-num (length window-lst)))
    (cond ((= window-num 1)
	   (split-window-sensibly)
	   (other-window 1)
	   (switch-to-buffer (other-buffer (current-buffer))))
	  ((= window-num 2)
	   (select-window (other-window-for-scrolling)))
	  (t
	   (let* ((my-quick-window-overlays nil)
		  (sorted-windows (sort window-lst
					(lambda (w1 w2)
					  (let ((edges1 (window-edges w1))
						(edges2 (window-edges w2)))
					    (or (< (car edges1) (car edges2))
						(and (= (car edges1) (car edges2))
						     (< (cadr edges1) (cadr edges2))))))))
		  (window-keys (seq-take '("j" "k" "l" ";" "a" "s" "d" "f") window-num))
		  (window-map (cl-pairlis window-keys sorted-windows)))
	     (setq my-quick-window-overlays
		   (mapcar (lambda (entry)
			     (let* ((key (car entry))
				    (window (cdr entry))
				    (start (window-start window))
				    (overlay (make-overlay start start (window-buffer window))))
			       (overlay-put overlay 'after-string
					    (propertize (format "[%s]" key)
							'face '(:foreground "white" :background "blue" :weight bold)))
			       (overlay-put overlay 'window window)
			       overlay))
			   window-map))
	     (let ((key (read-key (format "Select window [%s]: " (string-join window-keys ", ")))))
	       (mapc #'delete-overlay my/quick-window-overlays)
	       (setq my-quick-window-overlays nil)
	       (when-let ((selected-window (cdr (assoc (char-to-string key) window-map))))
		 (select-window selected-window))))))))

(keymap-global-set "M-o" #'mm/quick-window-jump)


(defun mm/narrow-or-widen-dwim ()
  "Widen if buffer is narrowed, narrow-dwim otherwise."
  (interactive)
  (cond ((buffer-narrowed-p)
	 (widen)
	 (recenter-top-bottom))
	((region-active-p)
	 (narrow-to-region (region-beginning)
			   (region-end)))
	((derived-mode-p 'org-mode)
	 (or (ignore-errors (org-narrow-to-block) t)
	     (org-narrow-to-subtree)))
	(t
	 (narrow-to-defun))))

(keymap-global-set "C-x /" #'mm/narrow-or-widen-dwim)


(defun mm/github-search ()
  "Search code from github.com via default browser."
  (interactive)
  (if-let* ((base-url "https://github.com/search?q=")
	    (query (if (use-region-p)
		       (buffer-substring-no-properties (region-beginning) (region-end))
		     (thing-at-point 'symbol t))))
      (browse-url-default-browser (concat base-url query))
    (browse-url-default-browser (concat base-url (read-string "Look up github: ")))))

(keymap-global-set "M-s /" #'mm/github-search)


(defun mm/toggle-highlight-symbol-at-point ()
  "Toggle highlighting for the symbol at point."
  (interactive)
  (require 'hi-lock)
  (when-let* ((regexp (find-tag-default-as-symbol-regexp)))
    (if (member regexp (hi-lock--regexps-at-point))
	(hi-lock-unface-buffer regexp)
      (hi-lock-face-symbol-at-point))))

(keymap-global-set "M-s h h" #'mm/toggle-highlight-symbol-at-point)


(provide 'init-utils)
;;; init-utils.el ends here
