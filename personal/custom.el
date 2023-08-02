(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(solarized-theme dockerfile-mode yaml-mode web-mode geiser company-anaconda anaconda-mode json-mode js2-mode rainbow-mode elisp-slime-nav rainbow-delimiters lsp-dart lsp-ui lsp-mode company consult orderless vertico exec-path-from-shell zop-to-char zenburn-theme which-key volatile-highlights undo-tree super-save smartrep smartparens projectile operate-on-number nlinum move-text magit imenu-anywhere hl-todo guru-mode git-timemachine git-modes gist flycheck expand-region editorconfig easy-kill discover-my-major diminish diff-hl crux browse-kill-ring anzu ag ace-window)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq scroll-preserve-screen-position 'nil
      prelude-clean-whitespace-on-save 'nil)
(global-set-key (kbd "<f7>") 'recompile)

(add-hook 'c-mode-common-hook
          (lambda()
            (local-set-key (kbd "<f5>") 'ff-find-other-file)
            (c-set-offset 'inline-open 0)
            (c-set-offset 'innamespace 0)
            (c-set-offset 'inextern-lang 0)
            (c-set-offset 'comment-intro 0)
            (c-set-offset 'statement-case-open 0)
            (c-set-offset 'arglist-intro '+)
            (ggtags-mode 1)
            (setq c-basic-offset 4)
            (whitespace-mode 1)
            (subword-mode 1)
            (smartparens-strict-mode 0)
            ))

(add-hook 'prog-mode-hook
          (lambda ()
            (smartparens-strict-mode 0)
            (set-fill-column 80)
            (subword-mode 1)
            (setq indent-tabs-mode nil
                  c-default-style '((c-mode . "stroustrup")
                                    (c++-mode . "stroustrup")
                                    (java-mode . "java")
                                    (awk-mode . "awk")
                                    (other . "gnu")))
            (local-set-key (kbd "M-,") 'pop-tag-mark)
            ))

; Tab width of 4 everywhere
(setq-default tab-width 4)

(set-register ?c '(file . "~/.emacs.d/personal/custom.el"))

(setq auto-mode-alist
      (append '(("SConstruct" . python-mode)
                ("SConscript" . python-mode)
                ("*.scons" . python-mode))
              auto-mode-alist))

(defun ediff-copy-both-to-C ()
  (interactive)
  (ediff-copy-diff ediff-current-difference nil 'C nil
                   (concat
                    (ediff-get-region-contents ediff-current-difference 'A ediff-control-buffer)
                    (ediff-get-region-contents ediff-current-difference 'B ediff-control-buffer))))
(defun add-d-to-ediff-mode-map () (define-key ediff-mode-map "d" 'ediff-copy-both-to-C))
(add-hook 'ediff-keymap-setup-hook 'add-d-to-ediff-mode-map)

(add-hook 'text-mode-hook
          (lambda ()
            (set-fill-column 72)))

(add-hook 'python-mode-hook
          (lambda ()
            (set-fill-column 79)  ; PEP8 demands 79 char
            (setq python-docstring-sentence-end-double-space 'nil
                  python-fill-docstring-style 'onetwo)
            (python-docstring-mode 1)
            ))

(setq guru-warn-only nil)

(global-unset-key (kbd "C-x C-c"))
(global-unset-key (kbd "C-z"))

(global-set-key (kbd "C-x C-c C-q") 'save-buffers-kill-terminal)

(defun get-include-guard ()
  "Return a string suitable for use in a C/C++ include guard"
  (let* ((fname (buffer-file-name (current-buffer)))
         (fbasename (replace-regexp-in-string ".*/" "" fname))
         (inc-guard-base (replace-regexp-in-string "[.-]"
                                                   "_"
                                                   fbasename)))
    (concat (upcase inc-guard-base) "__")))

(add-hook 'find-file-not-found-hooks
          #'(lambda ()
              (let ((file-name (buffer-file-name (current-buffer))))
                (when (string= ".h" (substring file-name -2))
                  (let ((include-guard (get-include-guard)))
                    (insert "#ifndef " include-guard)
                    (newline)
                    (insert "#define " include-guard)
                    (newline 4)
                    (insert "#endif /* " include-guard " */")
                    (newline)
                    (previous-line 3)
                    (set-buffer-modified-p nil))))))

(global-set-key (kbd "C-c j") 'avy-goto-char)

(scroll-bar-mode -1)
(menu-bar-mode -1)
