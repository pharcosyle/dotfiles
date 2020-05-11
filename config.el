;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Krzysztof Baranowski"
      user-mail-address "pharcosyle@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode' ; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Source Code Variable" :size 12))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default.
;; (setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.



(use-package! dash)



;;;; Doom resets

;; I'd like to have this on but in the doom code it says it's more efficient not to.
;; (setq-default cursor-in-non-selected-windows t)

(setq-default indent-tabs-mode t
              word-wrap nil
              truncate-lines nil
              truncate-partial-width-windows 50)

;; TODO `visual-line` is the new text mode default, try it out for a while, otherwise: (remove-hook 'text-mode-hook #'visual-line-mode)



(setq scroll-margin 10)
(setq save-interprogram-paste-before-kill t)



(defun trans! (&rest rest)
  (-each (-partition 2 rest)
    (-lambda ((to from))
      (define-key key-translation-map (kbd to) (kbd from)))))

(trans! "s-n" "<escape>"

        "s-h" "<left>"
        "s-j" "<down>"
        "s-k" "<up>"
        "s-l" "<right>"

        "s-J" "C-d"
        "s-K" "C-u"

        "s-i" "RET"
        "s-o" "<tab>"
        "s-O" "<backtab>"

        "s-u" "SPC u"                   ; TODO maybe

        "s-r" "SPC f r"

        "s-w" "SPC b k"
        "s-W" "SPC w d"
        "s-," "SPC w w"

        "s-a" "g s SPC"

        "s-g" "SPC g g"
        "s-m" "SPC m"                   ; TODO maybe

        "s-." "C-x z")                  ; TODO trying this out

(map! "s-V" #'yank-pop

      (:after ivy :map ivy-minibuffer-map
        "C-k" #'kill-line
        "C-u" #'ivy-scroll-down-command
        "C-d" #'ivy-scroll-up-command
        "s-r" #'ivy-reverse-i-search)   ; TODO probably a temporary binding

      ;; (:after lispy :map lispy-mode-map-lispy
      ;;   "[" #'lispy-brackets)

      (:after lispyville :map lispyville-mode-map
        "s-C-j" #'lispyville-forward-sexp
        "s-C-k" #'lispyville-backward-sexp
        "s-C-h" #'lispyville-backward-up-list
        "s-C-l" #'lispyville-up-list
        "s-C-u" #'lispyville-beginning-of-next-defun
        "s-C-i" #'lispyville-beginning-of-defun
        "s-C-o" #'lispyville-end-of-defun))



(after! avy
  (setq avy-all-windows t)
  (setq avy-single-candidate-jump t))

(setq-hook! emacs-lisp-mode indent-tabs-mode nil)

(add-hook! cider-repl-mode
  #'goto-address-prog-mode
  #'highlight-numbers-mode
  #'rainbow-delimiters-mode
  #'yas-minor-mode-on
  #'lispy-mode)

(after! cider
  (pushnew! cider-font-lock-dynamically 'deprecated)
  (setq cider-repl-history-size 1000000
        cider-print-options '(("length" 100))))

(add-hook! clj-refactor-mode
  (cljr-add-keybindings-with-prefix "s-C-.")) ; TODO temporary binding

(setq clojure-refactor-map-prefix (kbd "s-C-,")) ; Has to be set before clojure-mode laods. ; TODO temporary binding

(after! evil-multiedit
  (setq evil-multiedit-follow-matches t))

;; Trying this out
(after! ivy
  (setq +ivy-buffer-preview t))

(after! lispy
  (lispy-set-key-theme '(lispy)))

(after! lispyville
  (lispyville-set-key-theme
   '(c-u
     prettify
     text-objects
     commentary
     slurp/barf-cp
     additional-wrap))
  (setq lispyville-barf-stay-with-closing t))

(after! paren
  (setq! show-paren-delay 0))

;; TODO try this out after doing lispy et al for a while. Probably be more selective where it's enabled (with an :after and not global-... or aggressive-indent-excluded-modes). Even if I want it everywhere should I put it behind an :after just to defer loading?
;; (use-package! aggressive-indent
;;   :config
;;   (global-aggressive-indent-mode 1))



(add-to-list 'custom-theme-load-path (concat doom-private-dir "emacs-doom-themes/themes/pharcosyle"))
(load-theme 'doom-pharcosyle-atomic t)

(setq rainbow-delimiters-max-face-count 8)
(setq +evil--default-cursor-color "#fdd94a")

(custom-theme-set-faces! 'doom-pharcosyle-atomic
  '(font-lock-comment-face :foreground "#63677F")
  '(font-lock-comment-delimiter-face :foreground "#939abd")
  `(font-lock-doc-face :foreground ,(doom-color 'cyan))
  ;; `(line-number :inherit 'default :foreground ,(doom-color 'base5) :distant-foreground nil :weight normal :italic nil :underline nil :strike-through nil)
  `(line-number-current-line :inherit (hl-line default) :foreground "#AEB9F3" :distant-foreground nil :weight normal :italic nil :underline nil :strike-through nil)
  `(rainbow-delimiters-depth-1-face :foreground ,(doom-color 'fg))
  `(rainbow-delimiters-depth-2-face :foreground ,(doom-color 'magenta))
  `(rainbow-delimiters-depth-3-face :foreground ,(doom-color 'blue))
  `(rainbow-delimiters-depth-4-face :foreground ,(doom-color 'cyan))
  `(rainbow-delimiters-depth-5-face :foreground ,(doom-color 'green))
  `(rainbow-delimiters-depth-6-face :foreground ,(doom-color 'yellow))
  `(rainbow-delimiters-depth-7-face :foreground ,(doom-color 'orange))
  `(rainbow-delimiters-depth-8-face :foreground ,(doom-color 'red))
  `(clojure-interop-method-face :foreground ,(doom-color 'cyan))
  `(clojure-character-face :foreground ,(doom-color 'violet) :weight bold))



;; Can I move this line up without the "weird sizing things" my old config referrred to? Do I care?
;; (toggle-frame-fullscreen)
(setq initial-frame-alist '((width . 194) (fullscreen . fullheight)))
(set-frame-position (selected-frame) 66 23)



(prodigy-define-service
  :name "Amplify Mock"
  :command "amplify"
  :args '("mock")
  :cwd "~/Projects/Krush/hyperdrive/apps/singularity"
  :kill-process-buffer-on-stop t)

(prodigy-define-service
  :name "Datomic Access (exogenesis)"
  :command "bash"
  :args '("datomic" "client" "access" "exogenesis")
  :cwd "~/Projects/Krush/hyperdrive/ion/team"
  :kill-process-buffer-on-stop t)

(pushnew! safe-local-variable-values
          '(cider-preferred-build-tool . shadow-cljs)
          '(cider-default-cljs-repl . shadow)
          '(cider-shadow-default-options . ":app")
          '(cider-offer-to-open-cljs-app-in-browser . nil)
          '(cider-clojure-cli-global-options . "-A:dev")
          '(eval . (setenv "DATOMIC_APP_INFO_MAP" "{:app-name \"neutrino\"}"))
          '(eval . (setenv "DATOMIC_ENV_MAP" "{:env :dev}"))
          '(cider-clojure-cli-global-options . nil))
