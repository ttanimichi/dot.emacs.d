;; Ruby関連の設定

;; ruby-mode
(require 'ruby-electric)
(require 'ruby-block)
;;; インデントを浅くする
(setq ruby-deep-indent-paren-style nil)
;;; Rakefile
(add-to-list 'auto-mode-alist '("[Rr]akefile" . ruby-mode))
;;; Gemfile
(add-to-list 'auto-mode-alist '("Gemfile" . ruby-mode))

;; inf-ruby
(autoload 'run-ruby "inf-ruby" "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby"
  "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook '(lambda () (inf-ruby-keys)))
(push '("*ruby*" :position right :width 70 :dedicated t) popwin:special-display-config)

;; rcodetools
(require 'rcodetools)
(add-hook 'ruby-mode-hook 
	  '(lambda () 
	     (ruby-block-mode t)
	     (setq ruby-block-highlight-toggle t)
	     (ruby-electric-mode t)))

;; yaml-mode
(when (require 'yaml-mode nil t)
  (add-to-list 'auto-mode-alist '("¥¥.yml$" . yaml-mode)))

(provide 'init-ruby)
