(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/elisp")
(add-to-list 'load-path "~/.emacs.d/elisp/yasnippet")
(add-to-list 'load-path "~/.emacs.d/elisp/auto-complete")
(add-to-list 'load-path "~/.emacs.d/elisp/rhtml")
(add-to-list 'load-path "~/.emacs.d/elisp/rcodetools")

;; don't show tool bar
(tool-bar-mode -1)

;; don't show menu bar
(menu-bar-mode -1)

;; don't show scroll bar
(scroll-bar-mode -1)

;;  discreet fringe
(set-face-foreground 'fringe "#404F58")

;; remember the position of the cursor
(require 'saveplace)
(setq-default save-place t)

;; alias to yes/no
(defalias 'yes-or-no-p 'y-or-n-p)

;; show cursor position
(column-number-mode 1)

;; don't show start up screen
(setq inhibit-startup-screen t)

;; don't show scratch buffer's message
(setq initial-scratch-message "")

;; decrease the frequency of GC
(setq gc-cons-threshold (* 10 gc-cons-threshold))

;; set keystrokes faster
(setq echo-keystrokes 0.1)

;; highlight paren
(show-paren-mode 1)

;; don't blink cursor
(blink-cursor-mode 0)

;; max size of message log
(setq message-log-max 10000)

;; don't show visible-bell
(setq ring-bell-function 'ignore)

;; max size of recentf
(defvar recentf-max-saved-items 1000)

;; reload buffer automatically
(global-auto-revert-mode 1)

;; generi-x
(require 'generic-x)

;; cd $HOME after starting up
(cd "~/")

;; make buffer names unique
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;; history
(setq history-length 10000)
(defvar savehist-file "~/.emacs.d/dat/history")
(savehist-mode 1)

;; don't use vc. use magit.
(setq vc-handled-backends ())

;; なぜかdiredがエラーを吐くので回避策
;; Emacs同梱のlsコマンドを使う
(defvar ls-lisp-use-insert-directory-program nil)
(require 'ls-lisp)

;; auto-save-listの格納場所を設定
(setq auto-save-list-file-prefix "~/.emacs.d/dat/auto-save-list/.saves-")

;; チルダの付くbackupファイルを一箇所にまとめる
(setq backup-directory-alist
      (cons (cons "\\.*$" (expand-file-name "~/.emacs.d/dat/backup"))
	    backup-directory-alist))

;; font settings
(set-face-attribute 'default nil :family "Ricty" :height 140)
(set-fontset-font "fontset-default" 'japanese-jisx0208 '("Ricty" . "iso10646-*"))

;; adjust fringe width
(setq-default left-fringe-width 10)
(setq-default right-fringe-width 10)

;; 行末の空白文字に色をつける
(when (boundp 'show-trailing-whitespace)
  (setq-default show-trailing-whitespace t))
(set-face-background 'trailing-whitespace "DimGrey")

;; don't use tab for indent
(setq-default indent-tabs-mode nil)

;; function for note
(defun memo ()
  (interactive)
  (let ((path "~/Desktop/") (filename (format-time-string "%H.%M.%S")))
    (if (file-directory-p path)
	(switch-to-buffer (find-file (concat path filename ".md")))
      (message (concat "No such directory: " path)))))
(global-set-key (kbd "C-c m") 'memo)

;; 縦3分割を行うための関数を定義
(defun split-n (n)
  (interactive "p")
  (if (= n 2)
      (progn (split-window-horizontally) (other-window 2))
    (progn
      (split-window-horizontally (/ (window-width) n))
      (other-window 1) (split-n (- n 1)))))
(defun other-window-or-split ()
  (interactive)
  (if (one-window-p) (split-n 3)) (other-window 1))
;;; C-x 4に割り当てる
(global-set-key (kbd "C-x 4") 'other-window-or-split)

;; cua-modeの矩形選択だけを有効にする
(cua-selection-mode t)

;; 基本的には行は折り返さない
(setq-default truncate-lines t)
;; テキスト編集系のmodeでだけは行を折り返す
(add-hook 'text-mode-hook (lambda () (setq truncate-lines nil)))
(add-hook 'markdown-mode-hook (lambda () (setq truncate-lines nil)))
(add-hook 'org-mode-hook (lambda () (setq truncate-lines nil)))

;; pop-win
(require 'popwin)
(popwin-mode 1)

;; ELPA
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;; auto-install
(require 'auto-install)
(setq auto-install-directory "~/.emacs.d/elisp/")
;;; パッケージ名の更新は重いので普段は無効化
;;; (auto-install-update-emacswiki-package-name t)
(auto-install-compatibility-setup)

;; カラーテーマの設定
(load-theme 'solarized-dark t)

;; magit
(require 'magit)
(global-set-key (kbd "C-c g") 'magit-status)

;; helm
(require 'helm-config)
;;; コマンドの絞り込み
(define-key global-map (kbd "M-x") 'helm-M-x)
;;; ファイルの絞り込み
(global-set-key (kbd "C-x b") 'helm-for-files)
;;; isearchとoccurの融合
(global-set-key (kbd "C-x g") 'helm-occur)
;;; クリップボードの履歴を表示
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
;;; 直前のhelmセッションを再開
(global-set-key (kbd "C-z") 'helm-resume)
;;; imenu
(global-set-key (kbd "C-r") 'helm-imenu)

;; auto-save-buffers-enhanced
(require 'auto-save-buffers-enhanced)
;;; しばらく入力がないと自動保存する
(setq auto-save-buffers-enhanced-interval 1)
(auto-save-buffers-enhanced t)

;; auto-async-byte-compile
(require 'auto-async-byte-compile)
(setq auto-async-byte-compile-exclude-files-regexp "/junk/")
(add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode)
;;; pop-winの設定
(push '(" *auto-async-byte-compile*" :height 14 :position bottom :noselect t)
      popwin:special-display-config)
(push '("*VC-log*" :height 10 :position bottom) popwin:special-display-config)

;;; wdired
(require 'wdired)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)

;; direx (depends on pop-win)
(require 'direx)
(require 'direx-project)
(defun direx:jump-to-project-directory ()
  (interactive)
  (let ((result (ignore-errors
                  (direx-project:jump-to-project-root-other-window) t)))
    (unless result
      (direx:jump-to-directory-other-window))))
(global-set-key (kbd "C-x j") 'direx:jump-to-project-directory)
;; pop-win setting
(push '(direx:direx-mode :position left :width 50 :dedicated t)
      popwin:special-display-config)

;; quickrun
(require 'quickrun)
;; pop-win setting
(push '("*quickrun*") popwin:special-display-config)
(global-set-key (kbd "C-x e") 'quickrun)

;; auto-highlight-symbol
(require 'auto-highlight-symbol)
(global-auto-highlight-symbol-mode t)

;; ag
(require 'ag)

;; yasnippet
(require 'yasnippet)
(setq yas-snippet-dirs '("~/.emacs.d/elisp/yasnippet/mysnippets/"))
(yas-global-mode 1)
(custom-set-variables '(yas-trigger-key "TAB"))
(define-key yas-minor-mode-map (kbd "C-x i n") 'yas-new-snippet)
(define-key yas-minor-mode-map (kbd "C-x i v") 'yas-visit-snippet-file)

;; auto-complete
;; yasnippetに一部依存
(require 'auto-complete-config)
(ac-config-default)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/elisp/auto-complete/dict")
;;; ac-comphistの格納場所を設定
(setq ac-comphist-file "~/.emacs.d/dat/ac-comphist.dat")
(setq ac-auto-start 1)
;;; C-p/C-nで候補間を移動
(setq ac-use-menu-map t)
;;; 大文字小文字を区別する
;;; デフォルト値は (setq ac-ignore-case 'smart)
(setq ac-ignore-case nil)
(setq ac-use-fuzzy t)
;;; html-modeでもACを有効化
(add-to-list 'ac-modes 'html-mode)
;;; web-modeでもACを有効化
(add-to-list 'ac-modes 'web-mode)

;; web-mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.html?$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb?$" . web-mode))
;;; インデント数
(defun web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2))
(add-hook 'web-mode-hook  'web-mode-hook)

;; markdown-mode
(autoload 'markdown-mode "markdown-mode" "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))

;; ruby-mode
(require 'ruby-electric)
(require 'ruby-block)
;;; インデントを浅くする
(setq ruby-deep-indent-paren-style nil)
;;; マジックコメントを挿入しない
(setq ruby-insert-encoding-magic-comment nil)
(add-to-list 'auto-mode-alist '("Gemfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("[Rr]akefile" . ruby-mode))

;; yaml-mode
(when (require 'yaml-mode nil t)
  (add-to-list 'auto-mode-alist '("¥¥.yml$" . yaml-mode)))

;; js-mode
(add-to-list 'auto-mode-alist '("\\.js$" . js-mode))

;; scss-mode
(autoload 'scss-mode "scss-mode")
(defvar scss-compile-at-save nil)
(add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))
(add-to-list 'ac-modes 'scss-mode)

;; haml-mode
(require 'haml-mode)

;; nginx-mode
(require 'nginx-mode)
(add-hook 'conf-mode-hook (lambda () (when (string-match "nginx" (buffer-file-name)) (nginx-mode))))

;; org-mode
(require 'org-install)
;; 行末で折り返す
(defvar org-startup-truncated nil)

;; paredit
;; 対応する括弧を自動で補完するマイナーモード
(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
;; 各種Lispのモード起動時に有効化する
(add-hook 'lisp-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
(add-hook 'scheme-mode-hook 'enable-paredit-mode)
(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook 'enable-paredit-mode)
(add-hook 'ielm-mode-hook 'enable-paredit-mode)

;; rainbow-delimiters
;; 括弧を色分けするマイナーモード
(require 'rainbow-delimiters)
;; 各種Lispのモード起動時に有効化する
(add-hook 'lisp-mode-hook 'rainbow-delimiters-mode)
(add-hook 'lisp-interaction-mode-hook 'rainbow-delimiters-mode)
(add-hook 'scheme-mode-hook 'rainbow-delimiters-mode)
(add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode)
(add-hook 'eval-expression-minibuffer-setup-hook 'rainbow-delimiters-mode)
(add-hook 'ielm-mode-hook 'rainbow-delimiters-mode)

;; expand-region
(require 'expand-region)
(global-set-key (kbd "C-.") 'er/expand-region)

;; exec-path-from-shell
(when (memq window-system '(mac ns)) (exec-path-from-shell-initialize))
(defun exec-path-from-shell-initialize () ()) ;; suppress warning

;; windmove
(windmove-default-keybindings)

;; volatile-highlights
(require 'volatile-highlights)
(volatile-highlights-mode t)

;; pig-mode
(require 'pig-mode)

;; anzu
(global-anzu-mode +1)
(defun global-anzu-mode (dummy) ()) ;; suppress warning
