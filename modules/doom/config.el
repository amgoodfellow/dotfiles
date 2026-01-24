;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).


;; Pre package load variables --------------------------------------------------

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Aaron Goodfellow"
      user-mail-address "amgoodfellow@protonmail.com")

;; Theme Config
(setq doom-font (font-spec :family "Fira Code" :size 21))
(setq doom-theme 'doom-gruvbox)
(setq display-line-numbers-type t)

;; Org Variables
(setq org-directory "~/Documents/org")
(setq org-roam-directory "~/Documents/org/roam")
(setq initial-major-mode 'org-mode)

;; Disable formatting on certain modes
(setq +format-on-save-disabled-modes
      '(;; Defaults
        sql-mode
        tex-mode
        latex-mode
        LaTeX-mode
        org-msg-edit-mode
        ;; custom
        java-mode))

;; Post package load variables -------------------------------------------------

(after! evil
  (setq evil-escape-key-sequence "jj")
  (setq evil-escape-delay 0.45)
  (map! :map evil-window-map
        (:leader
         (:prefix ("w" . "Select Window")
          :n :desc "Left"  "<left>" 'evil-window-left
          :n :desc "Up"    "<up>" 'evil-window-up
          :n :desc "Down"  "<down>" 'evil-window-down
          :n :desc "Right" "<right>" 'evil-window-right
          ))))

(after! rustic
  (setq rustic-lsp-server 'rust-analyzer))

(after! org
  (setq org-todo-keywords
        '((sequence "UNASSIGNED" "ASSIGNED" "IN-PROGRESS" "|" "BLOCKED" "DONE")
          (sequence "TODO" "WAITING" "|" "DONE")))
  (setq-default elfeed-search-filter "@1-day-ago +unread ")
  (setq org-babel-clojure-backend 'cider)
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))
  ;; org agenda config
  (setq org-agenda-todo-ignore-scheduled 'future)
  (setq org-agenda-todo-ignore-scheduled t)
  (setq org-agenda-tags-todo-honor-ignore-options t)
  ;; log the time when I clock out
  (setq org-log-done 'time)

  (setq org-capture-templates
        '(("t" "Todo" entry (file+headline "~/Documents/org/tasks.org" "Personal")
           "* TODO %^{title?}\n")
          ("T" "Todo Clipboard" entry (file "~/Documents/org/inbox.org")
           "* TODO %?\n%U\n   %c" :empty-lines 1)
          ("w" "Work Task" entry (file+headline "~/Documents/org/tasks.org" "Work")
           "* TODO %^{title?}%^{CATEGORY}p%^{CREATED_AT|%U}p\n%?")
          ("p" "Personal Task" entry (file+headline "~/Documents/org/tasks.org" "Personal")
           "* TODO %^{title?}%^{CATEGORY}p%^{CREATED_AT|%U}p\n%?")))

  (map! :map (org-roam-mode-map org-mode-map)
        :ni "C-c n i" 'org-roam-node-insert
        :ni "C-c n f" 'org-roam-node-find
        :ni "C-c n c" 'org-roam-capture))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#221F22" "#CC6666" "#A9DC76" "#FFD866" "#78DCE8" "#FF6188" "#78DCE8" "#FCFCFA"])
 '(custom-safe-themes
   (quote
    ("e2acbf379aa541e07373395b977a99c878c30f20c3761aac23e9223345526bcc" "71e5acf6053215f553036482f3340a5445aee364fb2e292c70d9175fb0cc8af7" default)))
 '(fci-rule-color "#4C4A4D")
 '(fill-column 100)
 '(jdee-db-active-breakpoint-face-colors (cons "#19181A" "#FCFCFA"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#19181A" "#A9DC76"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#19181A" "#727072"))
 '(objed-cursor-color "#CC6666")
 '(pdf-view-midnight-colors (cons "#FCFCFA" "#2D2A2E"))
 '(rustic-ansi-faces
   ["#2D2A2E" "#CC6666" "#A9DC76" "#FFD866" "#78DCE8" "#FF6188" "#78DCE8" "#FCFCFA"])
 '(vc-annotate-background "#2D2A2E")
 '(vc-annotate-color-map
   (list
    (cons 20 "#A9DC76")
    (cons 40 "#c5da70")
    (cons 60 "#e2d96b")
    (cons 80 "#FFD866")
    (cons 100 "#fec266")
    (cons 120 "#fdad66")
    (cons 140 "#FC9867")
    (cons 160 "#fd8572")
    (cons 180 "#fe737d")
    (cons 200 "#FF6188")
    (cons 220 "#ee627c")
    (cons 240 "#dd6471")
    (cons 260 "#CC6666")
    (cons 280 "#b56869")
    (cons 300 "#9f6b6c")
    (cons 320 "#886d6f")
    (cons 340 "#4C4A4D")
    (cons 360 "#4C4A4D")))
 '(vc-annotate-very-old-color nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
