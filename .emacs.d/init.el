(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(setq inhibit-startup-message t)
(setq package-enable-at-startup nil)
(scroll-bar-mode -1)

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))

(defun dashboard-insert-custom (list-size)
  (insert "
  _____      _ _                 _       ______                          
 / ____|    | | |               ( )     |  ____|                         
| |     __ _| | |_   _ _ __ ___ |/ ___  | |__   _ __ ___   __ _  ___ ___ 
| |    / _` | | | | | | '_ ` _ \\  / __| |  __| | '_ ` _ \\ / _` |/ __/ __|
| |___| (_| | | | |_| | | | | | | \\__ \\ | |____| | | | | | (_| | (__\\__ \\ 
 \\_____\\__,_|_|_|\\__,_|_| |_| |_| |___/ |______|_| |_| |_|\\__,_|\\___|___/ "))
(add-to-list 'dashboard-item-generators  '(custom . dashboard-insert-custom))
(add-to-list 'dashboard-items '(custom))


;; Set the title
;;(setq dashboard-banner-logo-title )

(defcustom centaur-logo (expand-file-name
                         "cemacs.txt"
                         user-emacs-directory)
  "Set Centaur logo. nil means official logo."
  :type 'string)


(setq dashboard-startup-banner 'nil)
;; Value can be
;; 'official which displays the official emacs logo
;; 'logo which displays an alternative emacs logo
;; 1, 2 or 3 which displays one of the text banners
;; "path/to/your/image.png" or "path/to/your/text.txt" which displays whatever image/text you would prefer

;; Centre content
(setq dashboard-center-content t)

(load-theme 'material t)

(column-number-mode)

;; Enable line numbers for some modes
(dolist (mode '(text-mode-hook
                prog-mode-hook
                conf-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 1))))

;; Override some modes which derive from the above
(dolist (mode '(org-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 17)))

(use-package ivy
  :ensure t
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))


(use-package counsel
  :ensure t
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))


(use-package ivy-rich
  :ensure t
  :init
  (ivy-rich-mode 1))

(use-package which-key
  :ensure t
  :config (which-key-mode))

(use-package rainbow-delimiters
  :ensure t 
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package projectile
  :ensure t
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/Projects/")
    (setq projectile-project-search-path '("~/Projects/")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :ensure t
  :config (counsel-projectile-mode))

(use-package magit
  :ensure t
  )

(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(setq org-latex-packages-alist '(("margin=2cm" "geometry" nil)))


;;(setq org-fontify-whole-heading-line t)



(setq org-babel-default-header-args
      (cons '(:tangle . "yes")
            (assq-delete-all :tangle org-babel-default-header-args)))

(use-package backline
  :ensure t
  :after outline
  :config (advice-add 'outline-flag-region :after 'backline-update))

(defun my-org-scrot ()
  "Take a screenshot into a time stamped unique-named file in the
same directory as the org-buffer and insert a link to this file."
  (interactive)
  (if (not (file-exists-p "images"))
      (make-directory "images")
      (message "Directory Exists"))
  (setq filename
        (concat
         (make-temp-name
          (concat (file-name-directory (buffer-file-name))
		  "images/"
		  (file-name-base (buffer-file-name))
                  "_"
                  (format-time-string "%Y%m%d_%H%M%S_")) ) ".png"))
  (call-process "import" nil nil nil filename)
  (insert (concat "[[" filename "]]"))
  (org-display-inline-images))

(defun fix-bkw ()
  "Remove all whitespace if the character behind the cursor is whitespace, otherwise remove a word."
  (interactive)
  (if (looking-back "[ \n]")
      ;; delete horizontal space before us and then check to see if we
      ;; are looking at a newline
      (progn (delete-horizontal-space 't)
             (while (looking-back "[ \n]")
               (backward-delete-char 1)))
    ;; otherwise, just do the normal kill word.
    (backward-kill-word 1)))

(global-set-key [C-backspace] 'fix-bkw)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ivy-mode t)
 '(package-selected-packages
   '(ivy-rich rainbow-delimiters doom-modeline ivy org-bullets which-key use-package try))
 '(safe-local-variable-values
   '((eval add-hook 'after-save-hook
	   (lambda nil
	     (org-babel-tangle))
	   nil t))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(use-package general
  :ensure t
  :config
  (general-create-definer cmacs/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")
  (cmacs/leader-keys
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")))

(general-define-key
"C-M-j" 'counsel-switch-buffer
"<escape>" 'keyboard-escape-quit)

;;Make ESC quit prompts
;;(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))
 
(use-package evil-collection
  :ensure t
  :after evil
  :config
  (evil-collection-init))

(use-package evil-magit
  :ensure t
  :after magit)
;;Switch Buffer
;;(global-set-key (kbd "C-M-j") 'counsel-switch-buffer)

(use-package hydra
  :ensure t)

(defhydra hydra-buffer-swap (:timeout 4)
  "Swap Buffer"
  ("h" next-buffer "next")
  ("l" previous-buffer "prev")
  ("f" nil "finished" :exit t))

(cmacs/leader-keys
  "c" '(counsel-switch-buffer :which-key "search buffers")
  "b"  '(:ignore t :which-key "buffer")
  "bb" '(counsel-switch-buffer :which-key "search buffers")
  "bn" '(hydra-buffer-swap/body :which-key "cycle buffers"))
