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
  (setq org-log-done 'time)
  (setq org-todo-keywords
        '((sequence "UNASSIGNED" "ASSIGNED" "IN-PROGRESS" "|" "BLOCKED" "DONE")
          (sequence "TODO" "WAITING" "|" "DONE")))
  (setq org-capture-templates
        (doct `(
                ("Clipboard Todo" :keys "C"
                 :type entry
                 :file "~/Documents/org/tasks.org"
                 :headline "Personal"
                 :template "* TODO %?\n%U\n   %c")
                ("Task" :keys "t"
                 :type entry
                 :file "~/Documents/org/tasks.org"
                 :headline "Personal"
                 :template "* TODO %^{title?}%^{CATEGORY}p%^{CREATED_AT|%U}p\n%?")
                ("Work" :keys "w"
                 :children (
                            ;; Typical task items
                            ("Task" :keys "t" :type entry :file "~/Documents/org/tasks.org")
                            ;; Typical task items
                            ("Meeting" :keys "m" :type entry :datetree t :file "~/Documents/org/meetings.org")
                            ;; These items represent capturing thoughts to add to the next persistent meeting
                            (:group "Thoughts" :type item :file "~/Documents/org/thoughts.org" :children
                                    (("Standup Notes" :keys "s" :headline "Standup")
                                     ("Retro Notes"    :keys "r" :headline "Retro"
                                      :function ,(defun +org-capture-goto ()
                                                   "Move point to location of interactively selected heading."
                                                   (let ((org-goto-interface 'outline-path-completion))
                                                     (org-goto))))
                                     ("Sprint Planning Notes" :keys "p" :headline "Sprint Planning")
                                     ("One on One Notes" :keys "o" :headline "One on One"))))))))

  ;; Org roam config
  (map! :map (org-roam-mode-map org-mode-map)
        :ni "C-c n i" 'org-roam-node-insert
        :ni "C-c n f" 'org-roam-node-find
        :ni "C-c n c" 'org-roam-capture)

  ;; Org babel
  (setq org-babel-clojure-backend 'cider)
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))

  ;; Elfeed
  (setq-default elfeed-search-filter "@1-day-ago +unread ")

  ;; Org super agenda settings
  ;; (let ((org-super-agenda-groups
  ;;        '(;; Each group has an implicit boolean OR operator between its selectors.
  ;;          (:name "Today"  ; Optionally specify section name
  ;;           :time-grid t  ; Items that appear on the time grid
  ;;           :todo "TODAY")  ; Items that have this TODO keyword
  ;;          (:name "Important"
  ;;           ;; Single arguments given alone
  ;;           :tag "bills"
  ;;           :priority "A")
  ;;          ;; Set order of multiple groups at once
  ;;          (:order-multi (2 (:name "Shopping in town"
  ;;                            ;; Boolean AND group matches items that match all subgroups
  ;;                            :and (:tag "shopping" :tag "@town"))
  ;;                           (:name "Food-related"
  ;;                            ;; Multiple args given in list with implicit OR
  ;;                            :tag ("food" "dinner"))
  ;;                           (:name "Personal"
  ;;                            :habit t
  ;;                            :tag "personal")
  ;;                           (:name "Space-related (non-moon-or-planet-related)"
  ;;                            ;; Regexps match case-insensitively on the entire entry
  ;;                            :and (:regexp ("space" "NASA")
  ;;                                  ;; Boolean NOT also has implicit OR between selectors
  ;;                                  :not (:regexp "moon" :tag "planet")))))
  ;;          ;; Groups supply their own section names when none are given
  ;;          (:todo "WAITING" :order 8)  ; Set order of this section
  ;;          (:todo ("SOMEDAY" "TO-READ" "CHECK" "TO-WATCH" "WATCHING")
  ;;           ;; Show this group at the end of the agenda (since it has the
  ;;           ;; highest number). If you specified this group last, items
  ;;           ;; with these todo keywords that e.g. have priority A would be
  ;;           ;; displayed in that group instead, because items are grouped
  ;;           ;; out in the order the groups are listed.
  ;;           :order 9)
  ;;          (:priority<= "B"
  ;;           ;; Show this section after "Today" and "Important", because
  ;;           ;; their order is unspecified, defaulting to 0. Sections
  ;;           ;; are displayed lowest-number-first.
  ;;           :order 1)
  ;;          ;; After the last group, the agenda will display items that didn't
  ;;          ;; match any of these groups, with the default order position of 99
  ;;          )))
  ;;   (org-agenda nil "a"))
  ;; (let ((org-super-agenda-groups
  ;;        '((:auto-group t))))
  ;;   (org-agenda-list))

  ;; (let ((org-super-agenda-groups
  ;;        '((:auto-category t))))
  ;;   (org-agenda-list))

  )

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
