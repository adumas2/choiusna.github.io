;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;USNA Computer Science Dept. Default .emacs file
;;;;         14 Mar 2001
;;;;Modified:
;;;;         28 Sep 2005 flc
;;;;         07 Jan 2010 cwb
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;SETTING YOUR LOAD-PATH
;;You may want to create your own lisp packages, or install ones written
;;by others.  To do this, you need the .el or .elc files located in a
;;directory on the load-path.  It is traditional to create a directory in
;;your home called elisp.  Place any elisp packeges in that directory.  Then you
;;uncomment the following line to add that directory to your load-path
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;(setq load-path (cons "~/elisp" load-path))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Xemacs vs. FSF GNU emacs
;;Sometimes there are differences between xemacs (formerly Lucid) and emacs (aka
;;GNU emacs from FSF).  Both use the .emacs file, so any incompatible commands
;;will be loaded separately:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(if (string-match "xemacs" emacs-version)
    (progn ;not much for Xemacs yet, but changes could be added here.
      (turn-on-font-lock)
      (mwheel-install) ; Makes mouse scroll wheel work
      )
  (progn  ;FSF (GNU) Emacs
    ;;When the frame has multiple windows, the following enables
    ;;you to use the arrow keys with the Meta ket to grow and shrink
    ;;the window.
    ;;the bracket format is special to fsf emacs, thus why it's in
    ;;this file.
    (global-font-lock-mode t)		;Use pretty colors on text
    (global-set-key [M-up] 'enlarge-window)
    (global-set-key [M-down] 'shrink-window)
    (require 'mwheel) ; Makes mouse scroll wheel work
    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;GENERAL SETTINGS.  
;;These settings make sure your environment is nice for editing.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq visible-bell t)			;flashes the screen instead of beeping
(setq default-major-mode 'text-mode)	;deafualt mode is text
(define-key global-map "\C-h" 
  'backward-delete-char-untabify)	;ensure C-h will actually backspace
(define-key global-map "\e\C-h"		
  'backward-kill-word)			;M-h deletes an entire word.
(setq text-mode-hook 
  '(lambda () (auto-fill-mode 1)))	;auto-wraps lines in text mode
(define-key global-map "\e\C-z" 
  'help-for-help)			;help is a common enough need, so
					;give it a special key combo: C-M-z

(line-number-mode t)			;show the line number. default in FSF
(delete-selection-mode t)
;;By default, the automatic indenting of C (and related) code, is 2 spaces.
;;If you would like it to be more, change the value below.
(setq c-basic-offset 2)

;; These three commands display the time & date
(load "time" nil t)
(setq display-time-day-and-date t)  
(display-time)                      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;OTHER SOURCES.  
;;;There are many other sources for ideas on how to customize your .emacs files.
;;;In particular, try:
;;;www.dotemacs.de
;;;www.dotfiles.com
;;;They are full of examples, both esoteric and mundane, of other peoples'
;;;.emacs files.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 '(load-home-init-file t t))
(custom-set-faces)

;; This is a slight modification of emacs' default style C/C++-mode
;; style, which indents a "{" opening a block following an "if" or
;; a loop.  This isn't how Visual Studio works, so the following code
;; changes the indentation to match the Visual Studio behavior, whic
;; is more familiar to students coming out of IC210.
(defun chris-custom () (c-set-offset 'substatement-open 0))
(add-hook 'c++-mode-hook  'chris-custom)
(add-hook 'c-mode-hook  'chris-custom)
(add-hook 'java-mode-hook  'chris-custom-java)

;;; Get .icc .l .ypp suffixed files to go into C++ mode automatically!
;;; Add .h to the list if you prefer .h files to be in C++ by default.
(setq auto-mode-alist
      (append '(("\\.C$"    . c++-mode)
		("\\.cc$"   . c++-mode)
		("\\.icc$"  . c++-mode) 
		("\\.l$"    . c++-mode) 
		("\\.ypp$"  . c++-mode) 
		) auto-mode-alist))

;; open with single window
(setq inhibit-startup-screen t)
(add-hook 'emacs-startup-hook 'delete-other-windows)
(setq inhibit-startup-buffer-menu t)
