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
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(menu-bar-mode -1)

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

;;(load-theme 'material t)

(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-oceanic-next t)

  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

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

;; C-Like
(dolist (mode-iter '(c-mode c++-mode glsl-mode java-mode javascript-mode rust-mode))
  (font-lock-add-keywords
    mode-iter
    '(("\\([~^&\|!<>=,.\\+*/%-]\\)" 0 'font-lock-operator-face keep)))
  (font-lock-add-keywords
    mode-iter
    '(("\\([\]\[}{)(:;]\\)" 0 'font-lock-delimit-face keep)))
  ;; functions
  (font-lock-add-keywords
    mode-iter
    '(("\\([_a-zA-Z][_a-zA-Z0-9]*\\)\s*(" 1 'font-lock-function-name-face keep))))

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

(setq ivy-initial-inputs-alist ())


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

(defun efs/lsp-mode-setup ()
(setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
(lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
:ensure t
:commands (lsp lsp-deferred)
:hook (lsp-mode . efs/lsp-mode-setup)
:init
(setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
:config
(lsp-enable-which-key-integration t))

(use-package typescript-mode
:ensure t
:mode "\\.ts\\'"
:hook (typescript-mode . lsp-deferred)
:config
(setq typescript-indent-level 2))

(add-hook 'c-mode-hook 'lsp)
(add-hook 'cpp-mode-hook 'lsp)

(use-package company
  :ensure t
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :ensure t
  :hook (company-mode . company-box-mode))

(use-package lsp-ui
:ensure t
  :hook (lsp-mode . lsp-ui-mode)
  :bind (("<f12>" . lsp-ui-doc-glance)))

 (setq lsp-ui-doc-position 'bottom)
 (setq lsp-ui-doc-max-height 50)
 (setq lsp-ui-doc-max-width 250)

(use-package lsp-treemacs
 :ensure t
:after lsp)

(use-package org
  :ensure t
  :config
  (setq org-ellipsis "▾"))

(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(setq org-latex-packages-alist '(("margin=2cm" "geometry" nil)))


;;(setq org-fontify-whole-heading-line t)



(setq org-babel-default-header-args
      (cons '(:tangle . "yes")
            (assq-delete-all :tangle org-babel-default-header-args)))

;;(use-package backline
;;  :ensure t
;;  :after outline
;;  :config (advice-add 'outline-flag-region :after 'backline-update))

(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("sh" . "src sh"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("sc" . "src scheme"))
(add-to-list 'org-structure-template-alist '("ts" . "src typescript"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))
(add-to-list 'org-structure-template-alist '("yaml" . "src yaml"))
(add-to-list 'org-structure-template-alist '("json" . "src json"))

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
   '(evil-easymotion ivy-rich rainbow-delimiters doom-modeline ivy org-bullets which-key use-package try)))
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

(defhydra hydra-buffers (:color blue :hint nil)
            "
                                                                     ╭─────────┐
   Move to Window         Switch                  Do                 │ Buffers │
╭────────────────────────────────────────────────────────────────────┴─────────╯
         ^_k_^          [_b_] switch (ido)       [_d_] kill the buffer
         ^^↑^^          [_i_] ibuffer            [_r_] toggle read-only mode
     _h_ ←   → _l_      [_a_] alternate          [_u_] revert buffer changes
         ^^↓^^          [_s_] switch (helm)      [_w_] save buffer
         ^_j_^
--------------------------------------------------------------------------------
            "
            ("<tab>" hydra-master/body "back")
            ("<ESC>" nil "quit")
            ("a" joe-alternate-buffers)
            ("b" ido-switch-buffer)
            ("d" joe-kill-this-buffer)
            ("i" ibuffer)
            ("h" buf-move-left  :color red)
            ("k" buf-move-up    :color red)
            ("j" buf-move-down  :color red)
            ("l" buf-move-right :color red)
            ("r" read-only-mode)
            ("s" helm-buffers-list)
            ("u" joe-revert-buffer)
            ("w" save-buffer))

  (defhydra hydra-window (:color blue :hint nil)
          "
                                                                     ╭─────────┐
   Move to      Size    Scroll        Split                    Do    │ Windows │
╭────────────────────────────────────────────────────────────────────┴─────────╯
      ^_k_^           ^_K_^       ^_p_^    ╭─┬─┐^ ^        ╭─┬─┐^ ^         ↺ [_u_] undo layout
      ^^↑^^           ^^↑^^       ^^↑^^    │ │ │_v_ertical ├─┼─┤_b_alance   ↻ [_r_] restore layout
  _h_ ←   → _l_   _H_ ←   → _L_   ^^ ^^    ╰─┴─╯^ ^        ╰─┴─╯^ ^         ✗ [_d_] close window
      ^^↓^^           ^^↓^^       ^^↓^^    ╭───┐^ ^        ╭───┐^ ^         ⇋ [_w_] cycle window
      ^_j_^           ^_J_^       ^_n_^    ├───┤_s_tack    │   │_z_oom
      ^^ ^^           ^^ ^^       ^^ ^^    ╰───╯^ ^        ╰───╯^ ^       
--------------------------------------------------------------------------------
          "
          ("<tab>" hydra-master/body "back")
          ("<ESC>" nil "quit")
          ("n" joe-scroll-other-window :color red)
          ("p" joe-scroll-other-window-down :color red)
          ("b" balance-windows)
          ("d" delete-window)
          ("H" shrink-window-horizontally :color red)
          ("h" windmove-left :color red)
          ("J" shrink-window :color red)
          ("j" windmove-down :color red)
          ("K" enlarge-window :color red)
          ("k" windmove-up :color red)
          ("L" enlarge-window-horizontally :color red)
          ("l" windmove-right :color red)
          ("r" winner-redo :color red)
          ("s" split-window-vertically :color red)
          ("u" winner-undo :color red)
          ("v" split-window-horizontally :color red)
          ("w" other-window)
          ("z" delete-other-windows))

(defhydra hydra-simple-window (:color blue :hint nil)
"      ^ 
<-(h) |(j) |(k) ->(l) Move Rapidly Between Windows (Press A for advanced window mode)
           v"

            ("A" hydra-window/body :color red)
            ("h" windmove-left :color red)
            ("j" windmove-down :color red)
            ("k" windmove-up :color red)
            ("l" windmove-right :color red)
            ("<left>" windmove-left :color red)
            ("<down>" windmove-down :color red)
            ("<up>" windmove-up :color red)
            ("<right>" windmove-right :color red)
            
 )

(cmacs/leader-keys
  "c" '(counsel-switch-buffer :which-key "search buffers")
  "b"  '(:ignore t :which-key "buffer")
  "bb" '(counsel-switch-buffer :which-key "search buffers")
  "bn" '(hydra-buffer-swap/body :which-key "cycle buffers")
  "v" '(hydra-simple-window/body :which-key "cycle windows")
  )
