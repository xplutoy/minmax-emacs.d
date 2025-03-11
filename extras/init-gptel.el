;;; -*- lexical-binding: t -*-

;; Author:  xplutoyz
;; Created: 2025-03-07 21:29:09

;;; Commentary:

;;

;;; Code:

(use-package gptel
  :bind (("C-c <return>" . gptel-send)
	 ("C-c C-<return>" . gptel-menu))
  :custom
  (gptel-model 'deepseek-chat)
  (gptel-backend (gptel-make-openai "DeepSeek"
		   :host "api.deepseek.com"
		   :key 'gptel-api-key
		   :endpoint "/chat/completions"
		   :models '(deepseek-chat deepseek-coder)))
  (gptel-default-mode 'org-mode)

  :config

  (when IS-WIN
    (setopt gptel-use-curl nil))

  (add-hook 'gptel-post-response-functions 'gptel-end-of-response))


(provide 'init-gptel)
;;; init-gptel.el ends here
