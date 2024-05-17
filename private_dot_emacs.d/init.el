(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://radian-software.github.io/straight.el/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

(use-package evil)
(use-package doom-themes)
(use-package modus-themes)

(use-package helm) ;; incremental completions & narrowing selections ~~ file names, buffer names, selecting anything from a list
(use-package which-key)
(use-package avy) ;; like leap.nvim ~~ 2 char input, jump to text
(use-package corfu
  :straight (:files (:defaults "extensions/*"))
  :custom
  (corfu-auto t)          ;; Enable auto completion
  (corfu-cycle t)
  ;; (corfu-separator ?_) ;; Set to orderless separator, if not using space
  :bind
  ;; Free the RET key for less intrusive behavior.
  (:map corfu-map
        ;; Option 1: Unbind RET completely
	("RET" . nil))
  ;; Another key binding can be used, such as S-SPC.
  ;; (:map corfu-map ("M-SPC" . corfu-insert-separator))
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode))

(use-package emacs
  :init
  (setq tab-always-indent 'complete)
  (setq read-extended-command-predicate #'command-completion-default-include-p))

(use-package cape
  :init)
;;
(use-package lsp-mode)
(use-package lsp-ui)
(use-package lsp-treemacs)
(use-package dap-mode)
(use-package fsharp-mode)
(use-package lsp-haskell)

;; Avy Configuration
(global-set-key (kbd "C-'") 'avy-goto-char-2) ;; Ctrl + ' + <char><char> -> jump to word in tree

;; Enable Completion
(setq corfu-auto-delay 0 corfu-auto-prefix 2)
;;(add-hook 'after-init-hook 'global-company-mode)
;;(setq lsp-prefer-capf t) 
;;(setq company-idle-delay 0) 

;; Which Key
(require 'which-key)
(which-key-mode)

;;;; Enable Evil
(require 'evil)
(evil-mode 1)

;; LSP
(require 'lsp-mode)
(require 'lsp-haskell)
(require 'fsharp-mode)

;; Hooks so haskell and literate haskell major modes trigger LSP setup
(add-hook 'haskell-mode-hook #'lsp)
(add-hook 'haskell-literate-mode-hook #'lsp)
;; normal Hooks for lsp
;;(add-hook 'prog-mode-hook #'lsp)
(add-hook 'csharp-mode-hook #'lsp)
(add-hook 'fsharp-mode-hook #'lsp)
(add-hook 'python-mode-hook #'lsp)
(add-hook 'lua-mode-hook #'lsp)
(add-hook 'lisp-mode-hook #'lsp)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(doom-gruvbox))
 '(custom-safe-themes
   '("e3daa8f18440301f3e54f2093fe15f4fe951986a8628e98dcd781efbec7a46f2" "0f76f9e0af168197f4798aba5c5ef18e07c926f4e7676b95f2a13771355ce850" "c1638a7061fb86be5b4347c11ccf274354c5998d52e6d8386e997b862773d1d2" default))
 '(display-line-numbers-type 'relative)
 '(lsp-haskell-server-path "/home/jon/.ghcup/bin/haskell-language-server-wrapper"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Maple Mono" :slant normal :weight regular :height 158 :width normal :foundry "    ")))))
