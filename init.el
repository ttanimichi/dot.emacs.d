(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/elisp")
(add-to-list 'load-path "~/.emacs.d/elisp/helm")
(add-to-list 'load-path "~/.emacs.d/elisp/yasnippet")
(add-to-list 'load-path "~/.emacs.d/elisp/auto-complete")
(add-to-list 'load-path "~/.emacs.d/elisp/rhtml")
(add-to-list 'load-path "~/.emacs.d/elisp/rcodetools")

;; ツールバーを表示しない
(tool-bar-mode -1)

;; メニューバーを表示しない
(menu-bar-mode -1)

;; スクロールバーを表示しない
(scroll-bar-mode -1)

;; カラーテーマの設定
(load-theme 'wombat t)

;; 折り返し記号を目立たなくする
(set-face-foreground 'fringe "#404F58")

;; カーソルの位置を覚えておく
(require 'saveplace)
(setq-default save-place t)

;; yes/noにaliasを設定
(defalias 'yes-or-no-p 'y-or-n-p)

;; カーソル位置の表示
(column-number-mode 1)

;; スタート画面を表示しない
(setq inhibit-startup-screen t)

;; scratchバッファのメッセージを表示しない
(setq initial-scratch-message "")

;; gcの頻度を下げる
(setq gc-cons-threshold (* 10 gc-cons-threshold))

;; エコーエリアへのキーストークの表示を早くする
(setq echo-keystrokes 0.1)

;; 対応する括弧をハイライトする
(show-paren-mode 1)

;; カーソルの点滅をオフにする
(blink-cursor-mode 0)

;; メッセージログの最大値
(setq message-log-max 10000)

;; visible-bellを表示しない
(setq ring-bell-function 'ignore)

;; ファイル閲覧履歴の件数
(defvar recentf-max-saved-items 3000)

;; バッファを自動で再読み込み
(global-auto-revert-mode 1)

;; generi-x
(require 'generic-x)

;; 起動直後にホームディレクトリに移動する
(cd "~/")

;; 同名ファイルのバッファ名を分かりやすくする
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;; 半透明
(when window-system
  (progn
    (setq default-frame-alist
          (append (list '(alpha . 75)) default-frame-alist))))

;; history
;;; 記録するhistory数の最大値
(setq history-length 2000)
;;; historyファイルの格納場所を設定
(defvar savehist-file "~/.emacs.d/dat/history")
;;; historyを有効化
(savehist-mode 1)

;; VC連携を無効化。gitの操作にはmagitを使う
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

;; フォントの設定
(create-fontset-from-ascii-font
 "Menlo-14:weight=normal:slant=normal" nil "menlokakugo")
(set-fontset-font
 "fontset-menlokakugo"
 'unicode (font-spec :family "Hiragino Kaku Gothic ProN" :size 16)
 nil 'append)
(add-to-list 'default-frame-alist '(font . "fontset-menlokakugo"))

;; 行末の空白文字に色をつける
(when (boundp 'show-trailing-whitespace)
  (setq-default show-trailing-whitespace t))
(set-face-background 'trailing-whitespace "DimGrey")

;; メモをするための関数を定義
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
(setq display-buffer-function 'popwin:display-buffer)

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
(setq auto-save-buffers-enhanced-interval 5)
(auto-save-buffers-enhanced t)

;; auto-async-byte-compile
(require 'auto-async-byte-compile)
(setq auto-async-byte-compile-exclude-files-regexp "/junk/")
(add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode)
;;; pop-winの設定
(push '(" *auto-async-byte-compile*" :height 14 :position bottom :noselect t)
      popwin:special-display-config)
(push '("*VC-log*" :height 10 :position bottom) popwin:special-display-config)

;; direx
;; Warning: pop-winに依存
(require 'direx)
(require 'direx-project)
(defun direx:jump-to-project-directory ()
  (interactive)
  (let ((result (ignore-errors
                  (direx-project:jump-to-project-root-other-window) t)))
    (unless result
      (direx:jump-to-directory-other-window))))
(global-set-key (kbd "C-x j") 'direx:jump-to-project-directory)
;;; pop-winの設定
(push '(direx:direx-mode :position left :width 50 :dedicated t)
      popwin:special-display-config)

;; quickrun
(require 'quickrun)
;;; pop-winの設定
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

;; init-ruby
(require 'init-ruby)

;; js2-mode
;(custom-set-variables '(js2-basic-offset 2))
;; js-mode
(add-to-list 'auto-mode-alist '("\\.js$" . js-mode))

;; paredit
;; 対応する括弧を自動で補完するマイナーモード
(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
;;; 各種Lispのモード起動時に有効化する
(add-hook 'lisp-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
(add-hook 'scheme-mode-hook 'enable-paredit-mode)
(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook 'enable-paredit-mode)
(add-hook 'ielm-mode-hook 'enable-paredit-mode)

;; rainbow-delimiters
;; 括弧を色分けするマイナーモード
(require 'rainbow-delimiters)
;;; 各種Lispのモード起動時に有効化する
(add-hook 'lisp-mode-hook 'rainbow-delimiters-mode)
(add-hook 'lisp-interaction-mode-hook 'rainbow-delimiters-mode)
(add-hook 'scheme-mode-hook 'rainbow-delimiters-mode)
(add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode)
(add-hook 'eval-expression-minibuffer-setup-hook 'rainbow-delimiters-mode)
(add-hook 'ielm-mode-hook 'rainbow-delimiters-mode)

;; org-mode
(require 'org-install)
;;; 行末で折り返す
(defvar org-startup-truncated nil)
;;; org-rememberを使う
;;; C-c rでorg-rememberを起動
(define-key global-map "\C-cr" 'org-remember)
;;; org-remeberのテンプレート
;;; TODO: ファイル名を2013とかにする。一年で１ファイル
(defvar org-remember-templates
      '(("Note" ?n "** %T\n\n%?\n\n %i %a" "~/Dropbox/Notes/org-remember.org")))
(org-remember-insinuate)

(require 'nginx-mode)
(add-hook 'conf-mode-hook
          (lambda () (when (string-match "nginx" (buffer-file-name)) (nginx-mode))))
