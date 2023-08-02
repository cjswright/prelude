(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(require 'use-package)

(use-package solarized-theme
  :config (setq prelude-theme 'solarized-dark))
