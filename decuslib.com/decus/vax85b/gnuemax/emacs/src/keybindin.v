head     1.1;A
access   ; 
symbols  ; 
locks    ; strict; 
comment  @# @; 
 
 
1.1 
date     85.03.31.18.10.27;  author bbanerje;  state Exp; 
branches ; 
next     ; 
 
 
desc 
@@ 
 
 
 
1.1 
log 
@Initial revision 
@ 
text 
@Global Bindings: 
key		binding 
---		------- 
 
C-@@             set-mark-command 
C-a             beginning-of-line 
C-b             backward-char 
C-c             exit-recursive-edit 
C-d             delete-char 
C-e             end-of-line 
C-f             forward-char 
C-h             help-command 
C-i             indent-for-tab-command 
C-j             newline-and-indent 
C-k             kill-line 
C-l             recenter 
C-m             newline 
C-n             next-line 
C-o             open-line 
C-p             previous-line 
C-q             quoted-insert 
C-r             isearch-backward 
C-s             isearch-forward 
C-t             transpose-chars 
C-u             universal-argument 
C-v             scroll-up 
C-w             kill-region 
C-x             Control-X-prefix 
C-y             yank 
C-z             suspend-emacs 
ESC             ESC-prefix 
C-]             abort-recursive-edit 
C-_             undo 
  .. ~          self-insert-command 
C-?             delete-backward-char 
 
C-x C-a         add-mode-abbrev 
C-x C-b         list-buffers 
C-x C-c         save-buffers-kill-emacs 
C-x C-d         list-directory 
C-x C-e         eval-last-sexp 
C-x C-f         find-file 
C-x C-h         add-mode-abbrev 
C-x C-i         indent-rigidly 
C-x C-l         downcase-region 
C-x C-n         set-goal-column 
C-x C-o         delete-blank-lines 
C-x C-p         mark-page 
C-x C-q         toggle-read-only 
C-x C-r         find-file-read-only 
C-x C-s         save-buffer 
C-x C-t         transpose-lines 
C-x C-u         upcase-region 
C-x C-v         find-alternate-file 
C-x C-w         write-file 
C-x C-x         exchange-dot-and-mark 
C-x C-z         suspend-emacs 
C-x ESC         repeat-complex-command 
C-x $           set-selective-display 
C-x (           start-kbd-macro 
C-x )           end-kbd-macro 
C-x +           add-global-abbrev 
C-x -           add-global-abbrev 
C-x .           set-fill-prefix 
C-x /           dot-to-register 
C-x 0           delete-window 
C-x 1           delete-other-windows 
C-x 2           split-window-vertically 
C-x 4           ctl-x-4-prefix 
C-x 5           split-window-horizontally 
C-x ;           set-comment-column 
C-x <           scroll-left 
C-x =           what-cursor-position 
C-x >           scroll-right 
C-x [           backward-page 
C-x ]           forward-page 
C-x ^           enlarge-window 
C-x a           append-to-buffer 
C-x b           switch-to-buffer 
C-x d           dired 
C-x e           call-last-kbd-macro 
C-x f           set-fill-column 
C-x g           insert-register 
C-x h           mark-whole-buffer 
C-x i           insert-file 
C-x j           register-to-dot 
C-x k           kill-buffer 
C-x l           count-lines-page 
C-x m           mail 
C-x n           narrow-to-region 
C-x o           other-window 
C-x p           narrow-to-page 
C-x r           copy-rectangle-to-register 
C-x s           save-some-buffers 
C-x u           undo 
C-x w           widen 
C-x x           copy-to-register 
C-x {           shrink-window-horizontally 
C-x }           enlarge-window-horizontally 
C-x C-?         backward-kill-sentence 
 
ESC C-@@         mark-sexp 
ESC C-a         beginning-of-defun 
ESC C-b         backward-sexp 
ESC C-c         exit-recursive-edit 
ESC C-d         down-list 
ESC C-e         end-of-defun 
ESC C-f         forward-sexp 
ESC C-h         mark-defun 
ESC C-j         indent-new-comment-line 
ESC C-k         kill-sexp 
ESC C-n         forward-list 
ESC C-o         split-line 
ESC C-p         backward-list 
ESC C-s         isearch-forward-regexp 
ESC C-t         transpose-sexps 
ESC C-u         backward-up-list 
ESC C-v         scroll-other-window 
ESC C-w         append-next-kill 
ESC ESC         eval-expression 
ESC C-\         indent-region 
ESC             just-one-space 
ESC !           shell-command 
ESC %           query-replace 
ESC '           abbrev-prefix-mark 
ESC (           insert-parentheses 
ESC )           move-past-close-and-reindent 
ESC ,           tags-loop-continue 
ESC -           negative-argument 
ESC .           find-tag 
ESC 0 .. ESC 9  digit-argument 
ESC ;           indent-for-comment 
ESC <           beginning-of-buffer 
ESC =           count-lines-region 
ESC >           end-of-buffer 
ESC @@           mark-word 
ESC [           backward-paragraph 
ESC \           delete-horizontal-space 
ESC ]           forward-paragraph 
ESC ^           delete-indentation 
ESC a           backward-sentence 
ESC b           backward-word 
ESC c           capitalize-word 
ESC d           kill-word 
ESC e           forward-sentence 
ESC f           forward-word 
ESC g           fill-region 
ESC h           mark-paragraph 
ESC j           indent-new-comment-line 
ESC k           kill-sentence 
ESC l           downcase-word 
ESC m           back-to-indentation 
ESC q           fill-paragraph 
ESC r           move-to-screen-line 
ESC t           transpose-words 
ESC u           upcase-word 
ESC v           scroll-down 
ESC w           kill-ring-save 
ESC x           execute-extended-command 
ESC y           yank-pop 
ESC z           zap-to-char 
ESC |           shell-command-on-region 
ESC ~           not-modified 
ESC C-?         backward-kill-word 
 
C-x 4 C-f       find-file-other-window 
C-x 4 .         find-tag-other-window 
C-x 4 b         pop-to-buffer 
C-x 4 d         dired-other-window 
C-x 4 f         find-file-other-window 
C-x 4 m         mail-other-window 
@ 
