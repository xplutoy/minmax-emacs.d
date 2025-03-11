;;; -*- lexical-binding: t -*-

;; Author:  yangxue <yangxue.cs@foxmail.com>
;; Created: 2024-07-05 12:00:03
;; License: GPLv3

;;; Commentary:

;;

;;; Code:


;;; Org
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setopt org-directory "~/org/")
(setopt org-default-notes-file (file-name-concat org-directory "inbox.org"))

(setopt org-agenda-files `(,org-default-notes-file))
(setopt org-agenda-diary-file (file-name-concat org-directory "diary.org"))

(setopt org-capture-templates
	'(("t" "Task" entry (file+headline "" "Tasks") "** TODO %?")
	  ("f" "Fleeting note" entry (file+headline "" "Notes") "** %?")))

(use-package denote
  :bind (("C-c n n"   . denote-subdirectory)
	 ("C-c n j"   . denote-journal-extras-new-entry)
	 ("C-c n o"   . denote-open-or-create)
	 ("C-c n i"   . denote-link-or-create)
	 ("C-c n l"   . denote-find-link)
	 ("C-c n C-l" . denote-find-backlink)
	 ("C-c n r"   . denote-rename-file-using-front-matter)
	 ("C-c n C-r" . denote-rename-file))
  :custom
  (denote-directory org-directory)
  (denote-org-store-link-to-heading nil)
  (denote-date-prompt-use-org-read-date t)
  (denote-journal-extras-title-format nil)
  (denote-dired-directories-include-subdirectories t)
  :config
  (denote-rename-buffer-mode 1)
  (add-hook 'dired-mode-hook #'denote-dired-mode-in-directories))


(provide 'init-writing)
;;; init-writing.el ends here
