;;; helm-rcodetools.el --- accurate Ruby method completion with helm
;; $Id: helm-rcodetools.el,v 1.13 2009/04/20 16:25:37 rubikitch Exp $

;;; Copyright (c) 2007 rubikitch

;; Author: rubikitch <rubikitch@ruby-lang.org>
;; URL: http://www.emacswiki.org/cgi-bin/wiki/download/helm-rcodetools.el

;;; Use and distribution subject to the terms of the Ruby license.

;;; Commentary:

;; (0) You need rcodetools, helm.el and FastRI. Note that you do not have to
;;     configure helm.el if you use helm.el for this package.
;; (1) You need to add to .emacs:
;;       (require 'helm)
;;       (require 'helm-rcodetools)
;;       ;; Command to get all RI entries.
;;       (setq rct-get-all-methods-command "PAGER=cat fri -l")
;;       ;; See docs
;;       (define-key helm-map "\C-z" 'helm-execute-persistent-action)

;;; Commands:
;;
;; Below are complete command list:
;;
;;
;;; Customizable Options:
;;
;; Below are customizable option list:
;;

;;; History:

;; $Log: helm-rcodetools.el,v $
;; Revision 1.13  2009/04/20 16:25:37  rubikitch
;; Set helm-samewindow to nil
;;
;; Revision 1.12  2009/04/18 10:12:02  rubikitch
;; Adjust to change of `use-helm-show-completion'
;;
;; Revision 1.11  2009/04/17 20:21:47  rubikitch
;; * require helm
;; * require helm-show-completion.el if available
;;
;; Revision 1.10  2009/04/17 20:11:03  rubikitch
;; removed old code
;;
;; Revision 1.9  2009/04/17 20:07:52  rubikitch
;; * use --completion-emacs-helm option
;; * New implementation of `helm-c-source-complete-ruby-all'
;;
;; Revision 1.8  2009/04/15 10:25:25  rubikitch
;; Set `helm-execute-action-at-once-if-one' t
;;
;; Revision 1.7  2009/04/15 10:24:23  rubikitch
;; regexp bug fix
;;
;; Revision 1.6  2008/01/14 17:59:34  rubikitch
;; * uniform format (helm-c-source-complete-ruby, helm-c-source-complete-ruby-all)
;; * rename command: helm-c-ri -> helm-rct-ri
;;
;; Revision 1.5  2008/01/13 17:54:04  rubikitch
;; helm-current-buffer advice.
;;
;; Revision 1.4  2008/01/08 14:47:34  rubikitch
;; Added (require 'rcodetools).
;; Revised commentary.
;;
;; Revision 1.3  2008/01/04 09:32:29  rubikitch
;; *** empty log message ***
;;
;; Revision 1.2  2008/01/04 09:21:23  rubikitch
;; fixed typo
;;
;; Revision 1.1  2008/01/04 09:21:05  rubikitch
;; Initial revision
;;

;;; Code:

(require 'helm)
(require 'rcodetools)
(when (require 'helm-show-completion nil t)
  (use-helm-show-completion 'rct-complete-symbol--helm
                                '(length pattern)))

(defun helm-rct-ri (meth)
  (ri (get-text-property 0 'desc meth)))

(defun helm-rct-complete  (meth)
  (save-excursion
    (set-buffer helm-current-buffer)
    (search-backward pattern)
    (delete-char (length pattern)))
  (insert meth))

(setq rct-complete-symbol-function 'rct-complete-symbol--helm)
(defvar helm-c-source-complete-ruby
  '((name . "Ruby Method Completion")
    (candidates . rct-method-completion-table)
    (init
     . (lambda ()
         (condition-case x
             (rct-exec-and-eval rct-complete-command-name "--completion-emacs-helm")
           ((error) (setq rct-method-completion-table nil)))))
    (action
     ("Completion" . helm-rct-complete)
     ("RI" . helm-rct-ri))
    (volatile)
    (persistent-action . helm-rct-ri)))

(defvar rct-get-all-methods-command "PAGER=cat fri -l")
(defvar helm-c-source-complete-ruby-all
  '((name . "Ruby Method Completion (ALL)")
    (init
     . (lambda ()
         (unless (helm-candidate-buffer)
           (with-current-buffer (helm-candidate-buffer 'global)
             (call-process-shell-command rct-get-all-methods-command nil t)
             (goto-char 1)
             (while (re-search-forward "^.+[:#.]\\([^:#.]+\\)$" nil t)
               (replace-match "\\1\t[\\&]"))))))
    (candidates-in-buffer
     . (lambda ()
         (let ((helm-pattern (format "^%s.*%s" (regexp-quote pattern) helm-pattern)))
           (helm-candidates-in-buffer))))
    (display-to-real
     . (lambda (line)
         (if (string-match "\t\\[\\(.+\\)\\]$" line)
             (propertize (substring line 0 (match-beginning 0))
                         'desc (match-string 1 line))
           line)))
    (action
     ("Completion" . helm-rct-complete)
     ("RI" . helm-rct-ri))
    (persistent-action . helm-rct-ri)))


(defun rct-complete-symbol--helm ()
  (interactive)
  (let ((helm-execute-action-at-once-if-one t)
        helm-samewindow)
    (helm '(helm-c-source-complete-ruby
                helm-c-source-complete-ruby-all))))

(provide 'helm-rcodetools)

;; How to save (DO NOT REMOVE!!)
;; (emacswiki-post "helm-rcodetools.el")
;;; install-elisp.el ends here
;;; helm-rcodetools.el --- accurate Ruby method completion with helm
;; $Id: helm-rcodetools.el,v 1.13 2009/04/20 16:25:37 rubikitch Exp $

;;; Copyright (c) 2007 rubikitch

;; Author: rubikitch <rubikitch@ruby-lang.org>
;; URL: http://www.emacswiki.org/cgi-bin/wiki/download/helm-rcodetools.el

;;; Use and distribution subject to the terms of the Ruby license.

;;; Commentary:

;; (0) You need rcodetools, helm.el and FastRI. Note that you do not have to
;;     configure helm.el if you use helm.el for this package.
;; (1) You need to add to .emacs:
;;       (require 'helm)
;;       (require 'helm-rcodetools)
;;       ;; Command to get all RI entries.
;;       (setq rct-get-all-methods-command "PAGER=cat fri -l")
;;       ;; See docs
;;       (define-key helm-map "\C-z" 'helm-execute-persistent-action)

;;; Commands:
;;
;; Below are complete command list:
;;
;;
;;; Customizable Options:
;;
;; Below are customizable option list:
;;

;;; History:

;; $Log: helm-rcodetools.el,v $
;; Revision 1.13  2009/04/20 16:25:37  rubikitch
;; Set helm-samewindow to nil
;;
;; Revision 1.12  2009/04/18 10:12:02  rubikitch
;; Adjust to change of `use-helm-show-completion'
;;
;; Revision 1.11  2009/04/17 20:21:47  rubikitch
;; * require helm
;; * require helm-show-completion.el if available
;;
;; Revision 1.10  2009/04/17 20:11:03  rubikitch
;; removed old code
;;
;; Revision 1.9  2009/04/17 20:07:52  rubikitch
;; * use --completion-emacs-helm option
;; * New implementation of `helm-c-source-complete-ruby-all'
;;
;; Revision 1.8  2009/04/15 10:25:25  rubikitch
;; Set `helm-execute-action-at-once-if-one' t
;;
;; Revision 1.7  2009/04/15 10:24:23  rubikitch
;; regexp bug fix
;;
;; Revision 1.6  2008/01/14 17:59:34  rubikitch
;; * uniform format (helm-c-source-complete-ruby, helm-c-source-complete-ruby-all)
;; * rename command: helm-c-ri -> helm-rct-ri
;;
;; Revision 1.5  2008/01/13 17:54:04  rubikitch
;; helm-current-buffer advice.
;;
;; Revision 1.4  2008/01/08 14:47:34  rubikitch
;; Added (require 'rcodetools).
;; Revised commentary.
;;
;; Revision 1.3  2008/01/04 09:32:29  rubikitch
;; *** empty log message ***
;;
;; Revision 1.2  2008/01/04 09:21:23  rubikitch
;; fixed typo
;;
;; Revision 1.1  2008/01/04 09:21:05  rubikitch
;; Initial revision
;;

;;; Code:

(require 'helm)
(require 'rcodetools)
(when (require 'helm-show-completion nil t)
  (use-helm-show-completion 'rct-complete-symbol--helm
                                '(length pattern)))

(defun helm-rct-ri (meth)
  (ri (get-text-property 0 'desc meth)))

(defun helm-rct-complete  (meth)
  (save-excursion
    (set-buffer helm-current-buffer)
    (search-backward pattern)
    (delete-char (length pattern)))
  (insert meth))

(setq rct-complete-symbol-function 'rct-complete-symbol--helm)
(defvar helm-c-source-complete-ruby
  '((name . "Ruby Method Completion")
    (candidates . rct-method-completion-table)
    (init
     . (lambda ()
         (condition-case x
             (rct-exec-and-eval rct-complete-command-name "--completion-emacs-helm")
           ((error) (setq rct-method-completion-table nil)))))
    (action
     ("Completion" . helm-rct-complete)
     ("RI" . helm-rct-ri))
    (volatile)
    (persistent-action . helm-rct-ri)))

(defvar rct-get-all-methods-command "PAGER=cat fri -l")
(defvar helm-c-source-complete-ruby-all
  '((name . "Ruby Method Completion (ALL)")
    (init
     . (lambda ()
         (unless (helm-candidate-buffer)
           (with-current-buffer (helm-candidate-buffer 'global)
             (call-process-shell-command rct-get-all-methods-command nil t)
             (goto-char 1)
             (while (re-search-forward "^.+[:#.]\\([^:#.]+\\)$" nil t)
               (replace-match "\\1\t[\\&]"))))))
    (candidates-in-buffer
     . (lambda ()
         (let ((helm-pattern (format "^%s.*%s" (regexp-quote pattern) helm-pattern)))
           (helm-candidates-in-buffer))))
    (display-to-real
     . (lambda (line)
         (if (string-match "\t\\[\\(.+\\)\\]$" line)
             (propertize (substring line 0 (match-beginning 0))
                         'desc (match-string 1 line))
           line)))
    (action
     ("Completion" . helm-rct-complete)
     ("RI" . helm-rct-ri))
    (persistent-action . helm-rct-ri)))


(defun rct-complete-symbol--helm ()
  (interactive)
  (let ((helm-execute-action-at-once-if-one t)
        helm-samewindow)
    (helm '(helm-c-source-complete-ruby
                helm-c-source-complete-ruby-all))))

(provide 'helm-rcodetools)

;; How to save (DO NOT REMOVE!!)
;; (emacswiki-post "helm-rcodetools.el")
;;; install-elisp.el ends here

