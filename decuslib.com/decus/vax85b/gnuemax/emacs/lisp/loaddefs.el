;; Define standard autoloads and keys of other files, for Emacs. 
;; Copyright (C) 1985 Richard M. Stallman. 
 
;; This file is part of GNU Emacs. 
 
;; GNU Emacs is distributed in the hope that it will be useful, 
;; but without any warranty.  No author or distributor 
;; accepts responsibility to anyone for the consequences of using it 
;; or for whether it serves any particular purpose or works at all, 
;; unless he says so in writing. 
 
;; Everyone is granted permission to copy, modify and redistribute 
;; GNU Emacs, but only under the conditions described in the 
;; document "GNU Emacs copying permission notice".   An exact copy 
;; of the document is supposed to have been given to you along with 
;; GNU Emacs so that you can know how you may redistribute it all. 
;; It should be in a file named COPYING.  Among other things, the 
;; copyright notice and this notice must be preserved on all copies. 
 
 
;; Know which function the debuger is! 
(setq debugger 'debug) 
 
;; Just establish default. 
;; Site may override this in site-init.el. 
(setq Info-directory (concat (file-name-directory exec-directory) "info/")) 
 
 
;; These variables are used by autoloadable packages. 
;; They are defined here so that they do not get overridden 
;; by the loading of those packages. 
 
(defconst paragraph-start "^[ \t\n\f]" 
  "*Regexp for beginning of a line that starts OR separates paragraphs.") 
(defconst paragraph-separate "^[ \t\f]*$" 
  "*Regexp for beginning of a line that separates paragraphs. 
If you change this, you may have to change paragraph-start also.") 
 
(defconst sentence-end   "[.?!][]\")]*\\($\\|\t\\|  \\)[ \t\n]*" 
  "*Regexp describing the end of a sentence. 
All paragraph boundaries also end sentences, regardless.") 
 
(defconst page-delimiter "^\014" 
  "*Regexp describing line-beginnings that separate pages.") 
 
(defconst case-replace t 
  "*Non-nil means query-replace should preserve case in replacements.") 
 
;; indent.el may not be autoloading, but it still loses 
;; if lisp-mode is ever called before this defvar is done. 
(defvar indent-line-function 
  'indent-to-left-margin 
  "Function to indent current line.") 
 
(defconst only-global-abbrevs nil 
  "*t means user plans to use global abbrevs only. 
Makes the commands to define mode-specific abbrevs define global ones instead.") 
 
(defconst abbrev-file-name "~/.abbrev_defs" 
  "*Default name of file to read abbrevs from.") 
 
;; Names in directory that end in one of these 
;; are ignored in completion, 
;; making it more likely you will get a unique match. 
(setq completion-ignored-extensions '(".o" ".elc" "~")) 
 
(defvar compile-command "make -k" 
  "*Last shell command used to do a compilation; default for next compilation.") 
 
(defconst lpr-switches nil 
  "*List of strings to pass as extra switch args to lpr when it is invoked.") 
 
(defconst mail-self-blind nil 
  "*Non-nil means insert BCC to self in messages to be sent. 
This is done when the message is initialized, 
so you can remove or alter the BCC field to override the default.") 
 
(defconst mail-interactive nil 
  "*Non-nil means when sending a message wait for and display errors. 
nil means let mailer mail back a message to report errors.") 
 
(defconst mail-yank-ignored-headers 
   "^via:\\|^mail-from:\\|^origin:\\|^status:\\|^remailed\\|^received:\\|^message-id:\\|^summary-line:\\|^to:\\|^subject:\\|^in-reply-to:\\|^return-path:" 
   "Delete these headers from old message when it's inserted in a reply.") 
 
(defvar tags-file-name nil 
  "*File name of tag table. 
To switch to a new tag table, setting this variable is sufficient. 
Use the ctags program to make a tag table file.") 
 
(defconst shell-prompt-pattern 
  "^[^ ]*>" 
  "*Regexp used by Newline command in shell mode to match subshell prompts. 
Anything from beginning of line up to the end of what this pattern matches 
is deemed to be prompt, and is not reexecuted.") 
 
(defconst ledit-save-files t 
  "*Non-nil means Ledit should save files before transferring to Lisp.") 
(defconst ledit-go-to-lisp-string "%?lisp" 
  "*Shell commands to execute to resume Lisp job.") 
(defconst ledit-go-to-liszt-string "%?liszt" 
  "*Shell commands to execute to resume Lisp compiler job.") 
 
;; Autoload random libraries. 
;; Alphabetical order by library name. 
 
(autoload 'add-change-log-entry "add-log" 
  "\ 
Find change log file and add an entry for today." 
  t) 
 
(autoload 'occur-menu "aton" 
  "\ 
Show menu of lines containing match for REGEXP. 
Enters recursive edit on text showing an entry for each matching line. 
User can move to an entry and then exit with C-Z to 
move to the line in the original buffer described by the selected entry. 
Abort with C-] to avoid moving in the original buffer. 
 
If REGEXP is empty then THE EXACT SAME menu is presented again, 
with cursor initially at the next successive entry. 
This is useful for stepping through located lines rapidly in order." 
  t) 
 
(autoload 'byte-compile-file "bytecomp" 
  "\ 
Compile a file of Emacs Lisp code into byte code. 
Argument is input file name; output file name is made 
by appending a \"c\" to the end." 
  t) 
 
(autoload 'byte-recompile-directory "bytecomp" 
  "\ 
Recompile every .el file in DIRECTORY that needs recompilation. 
This is if a .elc file exists but is older than the .el file."  
  t) 
 
(autoload 'compare-windows "compare-windows" 
  "\ 
Compare text in current window with text in next window. 
Compares the text starting at dot in each window, 
moving over text in each one as fas as they match." 
  t) 
 
(autoload 'compile "compile" 
  "\ 
Compile the program including the current buffer.  Default: run make. 
Runs COMMAND, a shell command, in a separate process asynchronously 
with output going to the buffer *compilation*. 
You can then use the command next-error to find the next error message 
and move to the source code that caused it." 
  t) 
 
(autoload 'grep "compile" 
  "\ 
Run grep, with user-specified args, and collect output in a buffer. 
While grep runs asynchronously, you can use the next-error command 
to find the text that grep hits refer to." 
  t) 
 
(autoload 'debug "debug" 
  "\ 
Enter debugger.  Returns if user says \"continue\". 
Arguments are mainly for use when this is called 
 from the internals of the evaluator. 
You may call with no args, or you may 
 pass nil as the first arg and any other args you like. 
 In that case, the list of args after the first will  
 be printed into the backtrace buffer." 
  t) 
 
(autoload 'cancel-debug-on-entry "debug" 
  "\ 
Undoes effect of debug-on-entry on FUNCTION." 
  t) 
 
(autoload 'debug-on-entry "debug" 
  "\ 
Request FUNCTION to invoke debugger each time it is called. 
If the user continues, FUNCTION's execution proceeds. 
Works by modifying the definition of FUNCTION, 
which must be written in Lisp, not predefined." 
  t) 
 
(define-key ctl-x-map "d" 'dired) 
 
(autoload 'dired "dired" 
  "\ 
\"Edit\" directory DIRNAME.  Delete some files in it. 
Dired displays a list of files in DIRNAME. 
You can move around in it with the usual commands. 
You can mark files for deletion with C-D 
and then delete them by typing `x'. 
Type `h' after entering dired for more info." 
  t) 
 
(define-key ctl-x-4-map "d" 'dired-other-window) 
 
(autoload 'dired-other-window "dired" 
  "\ 
\"Edit\" directory DIRNAME in other window. 
Like dired command but displays dired buffer in other window." 
  t) 
 
(autoload 'dired-noselect "dired" 
  "\ 
Find or create a dired buffer, return it, don't select it. 
Call like dired.") 
 
(autoload 'dissociated-press "dissociate" 
  "\ 
Dissociate the text of the current buffer. 
Output goes in buffer named *Dissociation*, 
which is redisplayed each time text is added to it. 
Every so often the user must say whether to continue. 
If ARG is positive, require ARG words of continuity. 
If ARG is negative, require -ARG chars of continuity. 
Default is 2." t) 
 
(autoload 'info "info" 
  "\ 
Enter Info documentation browser." 
  t) 
 
(autoload 'ledit-mode "ledit" 
  "\ 
Major mode for editing text and stuffing it to a Lisp job. 
Like Lisp mode, plus these special commands: 
  M-C-d	-- record defun at or after dot 
	   for later transmission to Lisp job. 
  M-C-r -- record region for later transmission to Lisp job. 
  C-x z -- transfer to Lisp job and transmit saved text. 
  M-C-c -- transfer to Liszt (Lisp compiler) job 
	   and transmit saved text. 
To make Lisp mode automatically change to Ledit mode, 
do (setq lisp-mode-hook 'ledit-from-lisp-mode)" 
  t) 
 
(autoload 'ledit-from-lisp-mode "ledit") 
 
(autoload 'lpr-buffer "lpr" 
  "\ 
Print contents of buffer as with Unix command `lpr'." 
  t) 
 
(autoload 'print-buffer "lpr" 
  "\ 
Print contents of buffer as with Unix command `lpr -p'." 
  t) 
 
(autoload 'append-kbd-macro "macros" 
  "\ 
Append kbd macro NAME in file FILE, as Lisp code to define the macro. 
Use  load  to load the file. 
Third argument KEYS non-nil means also record the keys it is on. 
 (This is the prefix argument, when calling interactively.)" 
  t) 
 
(autoload 'kbd-macro-query "macros" 
  "\ 
Query user during kbd macro execution. 
With prefix argument, enters recursive edit, 
 reading keyboard commands even within a kbd macro. 
 You can give different commands each time the macro executes. 
Without prefix argument, reads a character.  Your options are: 
 Space -- execute the rest of the macro. 
 Delete -- skip the rest of the macro; start next repetition. 
 C-d -- skip rest of the macro and don't repeat it any more. 
 C-r -- enter a recursive edit, then on exit ask again for a character 
 C-l -- redisplay screen and ask again." 
  t) 
 
(autoload 'write-kbd-macro "macros" 
  "\ 
Save kbd macro NAME in file FILE, as Lisp code to define the macro. 
Use  load  to load the file. 
Third argument KEYS non-nil means also record the keys it is on. 
 (This is the prefix argument, when calling interactively.) 
Fourth argument APPENDFLAG non-nil meams append to FILE's existing contents." 
  t) 
 
(autoload 'manual-entry "man" 
  "\ 
Display Unix manual entry for TOPIC." 
  t) 
 
(setq disabled-command-hook 'disabled-command-hook) 
 
(autoload 'disabled-command-hook "novice") 
(autoload 'enable-command "novice" 
  "\ 
Allow COMMAND to be executed without special confirmation from now on. 
The user's emacs.profile file is altered so that this will apply 
to future sessions." t) 
 
(autoload 'disable-command "novice" 
  "\ 
Require special confirmation to execute COMMAND from now on. 
The user's emacs.profile file is altered so that this will apply 
to future sessions." t) 
 
(autoload 'list-options "options" 
  "\ 
Display a list of Emacs user options, with values and documentation." 
  t) 
 
(autoload 'edit-options "options" 
  "\ 
Edit a list of Emacs user option values. 
Selects a buffer containing such a list, 
in which there are commands to set the option values. 
Type C-H m in that buffer for a list of commands." 
  t) 
 
(autoload 'outline-mode "outline" 
  "\ 
Set up Emacs for editing an outline, doing selective hiding of text." 
  t) 
 
(autoload 'clear-rectangle "rect" 
  "\ 
Blank out rectangle with corners at dot and mark. 
The text previously in the region is overwritten by the blanks." 
  t) 
 
(autoload 'delete-rectangle "rect" 
  "\ 
Delete (don't save) text in rectangle with dot and mark as corners. 
The same range of columns is deleted in each line 
starting with the line where the region begins 
and ending with the line where the region ends." 
  t) 
 
(autoload 'delete-extract-rectangle "rect" 
   "\ 
Return and delete contents of rectangle with corners at START and END. 
Value is list of strings, one for each line of the rectangle.") 
 
(autoload 'extract-rectangle "rect" 
  "\ 
Return contents of rectangle with corners at START and END. 
Value is list of strings, one for each line of the rectangle.") 
 
(autoload 'insert-rectangle "rect" 
  "\ 
Insert text of RECTANGLE with upper left corner at dot. 
RECTANGLE's first line is inserted at dot, 
its second line is inserted at a point vertically under dot, etc. 
RECTANGLE should be a list of strings.") 
 
(autoload 'kill-rectangle "rect" 
  "\ 
Delete rectangle with corners at dot and mark; save as last killed one. 
Calling from program, supply two args START and END, buffer positions. 
But in programs you might prefer to use delete-extract-rectangle." 
  t) 
 
(autoload 'open-rectangle "rect" 
  "\ 
Blank out rectangle with corners at dot and mark, shifting text right. 
The text previously in the region is not overwritten by the blanks, 
but insted winds up to the right of the rectangle." 
  t) 
 
(autoload 'yank-rectangle "rect" 
  "\ 
Yank the last killed rectangle with upper left corner at dot." 
  t) 
 
(define-key ctl-x-map "r" 'rmail) 
 
(autoload 'rmail "rmail" 
  "\ 
Read (or delete or answer) your mail." 
  t) 
 
(autoload 'rnews "rnews" 
  "Read netnews for groups for which you are a member and add or delete groups. 
You can reply to articles posted and send articles to any group. 
  Type Help m once reading news to get a list of rnews commands." 
  t) 
 
(define-key ctl-x-4-map "m" 'mail-other-window) 
(define-key ctl-x-map "m" 'mail) 
 
(autoload 'mail-other-window "sendmail" 
  "\ 
Like mail command but displays in other window." 
  t) 
 
(autoload 'mail "sendmail" 
  "\ 
Edit a message to be sent.  Argument means resume editing (don't erase). 
Returns with message buffer seleted; value t if message freshly initialized. 
While editing message, type C-z C-z to send the message and exit. 
 
Various special commands starting with C-z are available in sendmail mode 
to move to message header fields.  Type C-z? for a list of them. 
 
If mail-self-blind is non-nil, a bcc to yourself is inserted 
when the message is initialized. 
 
If mail-setup-hook is bound, its value is called with no arguments 
after the message is initialized.  It can add more default fields. 
 
When calling from a program, the second through fifth arguments 
 TO, SUBJECT, CC and IN-REPLY-TO specify if non-nil 
 the initial contents of those header fields. 
 These arguments should not have final newlines. 
The sixth argument REPLYBUFFER is a buffer whose contents 
 should be yanked if the user types C-Z y." 
  t) 
 
(autoload 'shell "shell" 
  "\ 
Run an inferior shell, with I/O through buffer *shell*. 
If buffer exists but shell process is not running, make new shell. 
The buffer is put in shell-mode, giving commands for sending input 
and controlling the subjobs of the shell.  See shell-mode." 
  t) 
 
(autoload 'spell-buffer "spell" 
  "\ 
Check spelling of every word in the buffer. 
For each incorrect word, you are asked for the correct spelling 
and then put into a query-replace to fix some or all occurrences. 
If you do not want to change a word, just give the same word 
as its \"correct\" spelling; then the query replace is skipped." 
  t) 
 
(autoload 'spell-word "spell" 
  "\ 
Check spelling of word at or after dot. 
If it is not correct, ask user for the correct spelling 
and query-replace the entire buffer to substitute it." 
  t) 
 
(autoload 'spell-string "spell" 
  "\ 
Check spelling of string supplied as argument." 
  t) 
 
(autoload 'untabify "tabify" 
  "\ 
Convert all tabs in region to multiple spaces, preserving columns. 
The variable tab-width controls the action." 
  t) 
 
(autoload 'tabify "tabify" 
  "\ 
Convert multiple spaces in region to tabs when possible. 
A group of spaces is partially replaced by tabs 
when this can be done without changing the column they end at. 
The variable tab-width controls the action." 
  t) 
 
(define-key esc-map "." 'find-tag) 
 
(autoload 'find-tag "tags" 
  "\ 
Find next tag (in current tag table) whose name contains TAGNAME. 
 Selects the buffer that the tag is contained in 
and puts dot at its definition. 
 If TAGNAME is a null string, the expression in the buffer 
around or before dot is used as the tag name. 
 If second arg NEXT is non-nil (interactively, with prefix arg), 
searches for the next tag in the tag table 
that matches the tagname used in the previous find-tag. 
 
See documentation of variable tags-file-name." 
  t) 
 
(define-key ctl-x-4-map "." 'find-tag-other-window) 
 
(autoload 'find-tag-other-window "tags" 
  "\ 
Find tag (in current tag table) whose name contains TAGNAME. 
 Selects the buffer that the tag is contained in 
and puts dot at its definition. 
 If TAGNAME is a null string, the expression in the buffer 
around or before dot is used as the tag name. 
 If second arg NEXT is non-nil (interactively, with prefix arg), 
searches for the next tag in the tag table 
that matches the tagname used in the previous find-tag. 
 
See documentation of variable tags-file-name." 
  t) 
 
(autoload 'list-tags "tags" 
  "\ 
Display list of tags in file FILE." 
  t) 
 
(autoload 'next-file "tags" 
  "\ 
Select next file among files in current tag table. 
Non-nil argument (prefix arg, if interactive) 
initializes to the beginning of the list of files in the tag table." 
  t) 
 
(autoload 'tags-apropos "tags" 
  "\ 
Display list of all tags in tag table that contain STRING." 
  t) 
 
(define-key esc-map "," 'tags-loop-continue) 
(autoload 'tags-loop-continue "tags" 
  "\ 
Continue last tags-search or tags-query-replace command. 
Used noninteractively with non-nil argument 
to begin such a command.  See variable tags-loop-form." 
  t) 
 
(autoload 'tag-table-files "tags" 
  "\ 
Return a list of files in the current tag table.") 
 
(autoload 'tags-query-replace "tags" 
  "\ 
Query-replace FROM with TO through all files listed in tag table. 
If you exit (C-G or ESC), you can resume the query-replace 
with the command tags-loop-continue. 
 
See documentation of variable tags-file-name." 
  t) 
 
(autoload 'tags-search "tags" 
  "\ 
Search through all files listed in tag table for match for REGEXP. 
Stops when a match is found. 
To continue searching for next match, use command tags-loop-continue. 
 
See documentation of variable tags-file-name." 
  t) 
 
(autoload 'display-time "time" 
  "\ 
Display current time and load level in mode line of each buffer. 
Updates automatically every minute." 
  t) 
 
(autoload 'underline-region "underline" 
  "\ 
Underline all nonblank characters in the region. 
Works by overstriking underscores. 
Called from program, takes two arguments START and END 
which specify the range to operate on." 
  t) 
 
(autoload 'ununderline-region "underline" 
  "\ 
Remove allunderlining (overstruck underscores) in the region. 
Called from program, takes two arguments START and END 
which specify the range to operate on." 
  t) 
 
(define-key esc-map "\^f" 'forward-sexp) 
(define-key esc-map "\^b" 'backward-sexp) 
(define-key esc-map "\^u" 'backward-up-list) 
(define-key esc-map "\^@" 'mark-sexp) 
(define-key esc-map "\^d" 'down-list) 
(define-key esc-map "\^k" 'kill-sexp) 
(define-key esc-map "\^n" 'forward-list) 
(define-key esc-map "\^p" 'backward-list) 
(define-key esc-map "\^a" 'beginning-of-defun) 
(define-key esc-map "\^e" 'end-of-defun) 
(define-key esc-map "\^h" 'mark-defun) 
(define-key esc-map "(" 'insert-parentheses) 
(define-key esc-map ")" 'move-past-close-and-reindent) 
 
(define-key ctl-x-map "" 'eval-last-sexp) 
 
(define-key ctl-x-map "/" 'dot-to-register) 
(define-key ctl-x-map "j" 'register-to-dot) 
(define-key ctl-x-map "x" 'copy-to-register) 
(define-key ctl-x-map "g" 'insert-register) 
(define-key ctl-x-map "r" 'copy-rectangle-to-register) 
 
(define-key esc-map "q" 'fill-paragraph) 
(define-key esc-map "g" 'fill-region) 
(define-key ctl-x-map "." 'set-fill-prefix) 
 
(define-key esc-map "[" 'backward-paragraph) 
(define-key esc-map "]" 'forward-paragraph) 
(define-key esc-map "h" 'mark-paragraph) 
(define-key esc-map "a" 'backward-sentence) 
(define-key esc-map "e" 'forward-sentence) 
(define-key esc-map "k" 'kill-sentence) 
(define-key ctl-x-map "\177" 'backward-kill-sentence) 
 
(define-key ctl-x-map "[" 'backward-page) 
(define-key ctl-x-map "]" 'forward-page) 
(define-key ctl-x-map "\^p" 'mark-page) 
(define-key ctl-x-map "p" 'narrow-to-page) 
(define-key ctl-x-map "l" 'count-lines-page) 
 
(defun isearch-forward () 
  "\ 
Do incremental search forward. 
As you type characters, they add to the search string and are found. 
Type Delete to cancel characters from end of search string. 
Type ESC to exit, leaving dot at location found. 
Type C-S to search again forward, C-R to search again backward. 
Type C-W to yank word from buffer onto end of search string and search for it. 
Type C-Y to yank rest of line onto end of search string, etc. 
Type C-Q to quote control character to search for it. 
Other control and meta characters terminate the search 
 and are then executed normally. 
C-G while searching or when search has failed 
 cancels input back to what has been found successfully. 
C-G when search is successful aborts and moves dot to starting point." 
  (interactive) 
  (isearch t)) 
 
(defun isearch-forward-regexp () 
  "\ 
Do incremental search forward for regular expression. 
Like ordinary incremental search except that your input 
is treated as a regexp.  See  isearch-forward  for more info." 
  (interactive) 
  (isearch t t)) 
 
(defun isearch-backward () 
  "\ 
Do incremental search backward. 
See  isearch-forward  for more information." 
  (interactive) 
  (isearch nil)) 
 
(defun isearch-backward-regexp () 
  "\ 
Do incremental search backward for regular expression. 
Like ordinary incremental search except that your input 
is treated as a regexp.  See  isearch-forward  for more info." 
  (interactive) 
  (isearch nil t)) 
 
(defvar search-last-string "" 
  "Last string search for by a search command. 
This does not include direct calls to the primitive search functions, 
and does not include searches that are aborted.") 
 
(defconst search-repeat-char ?\^S 
  "Character to repeat incremental search forwards.") 
(defconst search-reverse-char ?\^R 
  "Character to repeat incremental search backwards.") 
(defconst search-exit-char ?\e 
  "Character to exit incremental search.") 
(defconst search-yank-word-char ?\^W 
  "Character to pull next word from buffer into search string.") 
(defconst search-yank-line-char ?\^Y 
  "Charatcer to pull rest of line from buffer into search string.") 
(defconst search-exit-option t 
  "Non-nil means random control characters terminate incremental search.") 
 
(autoload 'isearch "isearch") 
 
(define-key global-map "\^s" 'isearch-forward) 
(define-key global-map "\^r" 'isearch-backward) 
(define-key esc-map "\^s" 'isearch-forward-regexp) 
 
(defun query-replace (from-string to-string &optional arg) 
  "\ 
Replace some occurrences of FROM-STRING with TO-STRING. 
As each match is found, the user must type a character saying 
what to do with it. 
Type Help char within query-replace for directions. 
 
Preserves case in each replacement if case-replace and case-fold-search 
are non-nil and FROM-STRING has no uppercase letters. 
Third arg DELIMITED non-nil means replace only matches 
surrounded by word boundaries.  Interactively, this is the prefix arg." 
  (interactive "sQuery replace: \nsQuery replace %s with: \nP") 
  (perform-replace from-string to-string t nil arg)) 
 
(defun query-replace-regexp (regexp to-string &optional arg) 
  "\ 
Replace some things after dot matching REGEXP with TO-STRING. 
As each match is found, the user must type a character saying 
what to do with it. 
Type Help char within query-replace for directions. 
 
Preserves case in each replacement if case-replace and case-fold-search 
are non-nil and REGEXP has no uppercase letters. 
Third arg DELIMITED non-nil means replace only matches 
surrounded by word boundaries. 
In TO-STRING, \\& means insert what matched REGEXP, 
and \\<n> means insert what matched <n>th \\(...\\) in REGEXP." 
  (interactive "sQuery replace regexp: \nsQuery replace regexp %s with: \nP") 
  (perform-replace regexp to-string t t arg)) 
 
(defun replace-string (from-string to-string &optional delimited) 
  "\ 
Replace occurrences of FROM-STRING with TO-STRING. 
Preserve case in each match if case-replace and case-fold-search 
are non-nil and FROM-STRING has no uppercase letters. 
Third arg DELIMITED non-nil means replace only matches 
surrounded by word boundaries." 
  (interactive "sReplace string: \nsReplace string %s with: \nP") 
  (perform-replace from-string to-string nil nil delimited)) 
 
(defun replace-regexp (regexp to-string &optional delimited) 
  "\ 
Replace things after dot matching REGEXP with TO-STRING. 
Preserve case in each match if case-replace and case-fold-search 
are non-nil and REGEXP has no uppercase letters. 
Third arg DELIMITED non-nil means replace only matches 
surrounded by word boundaries. 
In TO-STRING, \\& means insert what matched REGEXP, 
and \\<n> means insert what matched <n>th \\(...\\) in REGEXP." 
  (interactive "sReplace regexp: \nsReplace regexp %s with: \nP") 
  (perform-replace regexp to-string nil t delimited)) 
 
(define-key esc-map "%" 'query-replace) 
 
(autoload 'perform-replace "replace") 
 
(define-key ctl-x-map "\^a" 'add-mode-abbrev) 
(define-key ctl-x-map "\+" 'add-global-abbrev) 
(define-key ctl-x-map "\^h" 'add-mode-abbrev) 
(define-key ctl-x-map "\-" 'add-global-abbrev) 
(define-key esc-map "'" 'abbrev-prefix-mark) 
