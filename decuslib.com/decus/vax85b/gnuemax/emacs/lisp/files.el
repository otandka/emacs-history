;; File input and output commands for Emacs 
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
(defconst delete-auto-save-files nil 
  "*Non-nil means delete a buffer's auto-save file 
when the buffer is saved for real.") 
 
(defconst backup-before-writing t 
  "*Create a backup of each file when it is saved for the first time. 
This can be done by renaming the file or by copying, according to the 
values of  backup-by-copying  and  backup-by-copying-when-linked.") 
 
(defconst backup-by-copying nil 
 "*Non-nil means create backups of files by copying rather than by renaming.") 
 
(defconst backup-by-copying-when-linked nil 
 "*Non-nil means create backups of multi-named files by copying 
rather than by renaming. 
This causes the alternate names to refer to the latest version as edited.") 
 
(defconst require-final-newline nil 
  "*t says silently put a newline at the end whenever a file is saved. 
Non-nil but not t says ask user whether to add a newline in each such case. 
nil means don't add newlines.") 
 
(defconst auto-save-default t 
  "*t says by default do auto-saving of every file-visiting buffer.") 
 
(defconst auto-save-visited-filename nil 
  "*t says auto-save a buffer in the file it is visiting, when practical. 
Normally auto-save files are written under other names.") 
 
(defconst save-abbrevs t 
  "*Non-nil means save word abbrevs too when files are saved.") 
 
(defun pwd () 
  "Show the current default directory." 
  (interactive nil) 
  (message "Directory %s" default-directory)) 
 
(defun cd (dir) 
  "Make DIR become the current buffer's default directory." 
  (interactive "DChange default directory: ") 
  (setq default-directory (expand-file-name dir)) 
  (or (string-match "/$" default-directory) 
      (setq default-directory (concat default-directory "/"))) 
  (pwd)) 
 
(defun find-file (filename) 
  "Edit file FILENAME. 
Switch to a buffer visiting file FILENAME, 
creating one if none already exists." 
  (interactive "FFind file: ") 
  (switch-to-buffer (find-file-noselect filename))) 
 
(defun find-file-other-window (filename) 
  "Edit file FILENAME, in another window. 
May create a new window, or reuse an existing one; 
see the function display-buffer." 
  (interactive "FFind file in other window: ") 
  (pop-to-buffer (find-file-noselect filename))) 
 
(defun find-file-read-only (filename) 
  "Edit file FILENAME but don't save without confirmation. 
Like find-file but marks buffer as read-only." 
  (interactive "fFind file read-only: ") 
  (find-file filename) 
  (setq buffer-read-only t)) 
 
(defun find-file-noselect (filename) 
  "Read file FILENAME into a buffer and return the buffer. 
If a buffer exists visiting FILENAME, return that one, 
but verify that the file has not changed since visited or saved. 
The buffer is not selected, just returned to the caller." 
  (if (file-directory-p filename) 
      (dired-noselect filename) 
    (let ((buf (get-file-buffer filename)) 
	  nonexfile) 
      (if buf 
	  (progn 
	    (or (verify-visited-file-modtime buf) 
		(if (not (file-exists-p filename)) 
		    (progn 
		      (message "Note: file %s no longer exists" filename) 
		      t)) 
		(not (yes-or-no-p 
		  (if (not (buffer-modified-p buf)) 
   "File has changed since last visited or saved.  Read from disk? " 
   "File has changed since last visited or saved.  Flush your changes? "))) 
		(save-excursion 
		  (set-buffer buf) 
		  (revert-buffer t))) 
	    buf) 
	(setq buf (create-file-buffer filename)) 
	(setq filename (expand-file-name filename)) 
	(save-excursion 
	  (set-buffer buf) 
	  (condition-case () 
	      (insert-file-contents filename t) 
	    (file-error (setq nonexfile t 
			      default-directory (file-name-directory filename) 
			      buffer-file-name filename))) 
	  (if (file-writable-p filename) 
	      (if nonexfile 
		  (message "(New file)")) 
	    (setq buffer-read-only t) 
	    (message (if nonexfile 
			 "File not found and directory write-protected" 
		       "File is write protected"))) 
	  (if auto-save-default 
	      (auto-save-mode t)) 
	  (condition-case () 
			  (set-auto-mode) 
	    (error (message "Error processing file's mode specifications"))))) 
      buf))) 
 
(defun find-alternate-file (filename) 
  "Find file FILENAME, select its buffer, kill previous buffer. 
If the current buffer now contains an empty file that you just visited 
\(presumably by mistake), use this command to visit the file you really want." 
  (interactive "FFind alternate file: ") 
  (if (null buffer-file-name) 
      (error "Non-file buffer")) 
  (let ((obuf (current-buffer)) 
	(oname (buffer-name))) 
    (rename-buffer " **lose**") 
    (unwind-protect 
        (find-file filename) 
      (if (eq obuf (current-buffer)) 
	  (rename-buffer oname))) 
    (kill-buffer obuf))) 
 
;; Determine mode according to filename 
 
(defvar auto-mode-alist 
	'(("\\.text$" . text-mode) 
	  ("\\.text~$" . text-mode) 
	  ;; Mailer puts message to be edited in /tmp/Re.... or Message 
	  ("^/tmp/Re" . text-mode) 
 	  ("/Message[0-9]*$" . text-mode) 
          ("\\.c$" . c-mode) ("\\.c~$" . c-mode) 
          ("\\.h$" . c-mode) ("\\.h~$" . c-mode) 
          ("\\.y$" . c-mode) ("\\.y~$" . c-mode) 
          ("\\.scm$" . lisp-mode) ("\\.scm~$" . lisp-mode) 
	  ("\\..*emacs" . lisp-mode) 
          ("\\.el$" . lisp-mode) ("\\.el~$" . lisp-mode) 
          ("\\.ml$" . lisp-mode) ("\\.ml~$" . lisp-mode) 
	  ("\\.l$" . lisp-mode) ("\\.l~$" . lisp-mode)) 
  "Alist of filename patterns vs corresponding major mode functions. 
Each element looks like (REGEXP . FUNCTION). 
Visiting a file whose name matches REGEXP causes FUNCTION to be called.") 
 
(defun set-auto-mode () 
  "Select major mode appropriate for current buffer. 
May base decision on visited file name (See variable auto-mode-list) 
or on buffer contents (-*- line or local variables spec)." 
  (let ((alist auto-mode-alist) 
	(case-fold-search nil) 
	found) 
    (while (and (not found) alist) 
      (if (string-match (car (car alist)) buffer-file-name) 
	  (setq found (car alist))) 
      (setq alist (cdr alist))) 
    (if found 
	(funcall (cdr found)))) 
  ;; Look for -*-MODENAME-*- or -*- ... mode: MODENAME; ... -*- 
  (let (beg end mode (case-fold-search t)) 
    (save-excursion 
     (goto-char (dot-min)) 
     (skip-chars-forward " \t\n") 
     (if (and (search-forward "-*-" (save-excursion (end-of-line) (dot)) t) 
	      (progn 
	       (skip-chars-forward " \t") 
	       (setq beg (dot)) 
	       (search-forward "-*-" (save-excursion (end-of-line) (dot)) t))) 
	 (progn 
	  (forward-char -3) 
	  (skip-chars-backward " \t") 
	  (setq end (dot)) 
	  (goto-char beg) 
	  (if (search-forward ":" end t) 
	      (progn 
	       (goto-char beg) 
	       (if (search-forward "mode:" end t) 
		   (progn 
		    (skip-chars-forward " \t") 
		    (setq beg (dot)) 
		    (if (search-forward ";" end t) 
			(forward-char -1) 
		      (goto-char end)) 
		    (skip-chars-backward " \t") 
		    (setq mode (buffer-substring beg (dot)))))) 
	    (setq mode (buffer-substring beg end))) 
	  (if mode 
	      (funcall (intern (concat (downcase mode) "-mode")))))))) 
  ;; Look for "Local variables:" line in last page. 
  (save-excursion 
   (goto-char (dot-max)) 
   (search-backward "\n^L" (max (- (dot-max) 10000) (dot-min)) 'move) 
   (if (and (or (bobp) (looking-at "\n\^L")) 
	    (let ((case-fold-search t)) 
	      (search-forward "Local Variables:" nil t))) 
       (let ((continue t) 
	     prefix prefixlen suffix beg) 
	 ;; The prefix is what comes before "local variables:" in its line. 
	 ;; The suffix is what comes after "local variables:" in its line. 
	 (or (eolp) 
	     (setq suffix (buffer-substring (dot) 
					    (progn (end-of-line) (dot))))) 
	 (goto-char (match-beginning 0)) 
	 (or (bolp) 
	     (setq prefix 
		   (buffer-substring (dot) 
				     (progn (beginning-of-line) (dot))))) 
	 (if prefix (setq prefixlen (length prefix) 
			  prefix (regexp-quote prefix))) 
	 (if suffix (setq suffix (regexp-quote suffix))) 
	 (while continue 
	   ;; Look at next local variable spec. 
	   (forward-line 1) 
	   ;; Skip the prefix, if any. 
	   (if prefix 
	       (if (looking-at prefix) 
		   (forward-char prefixlen) 
		 (error "Local variables entry is missing the prefix"))) 
	   ;; Find the variable name; strip whitespace. 
	   (skip-chars-forward " \t") 
	   (setq beg (dot)) 
	   (skip-chars-forward "^:\n") 
	   (if (eolp) (error "Missing colon in local variables entry")) 
	   (skip-chars-backward " \t") 
	   (let ((var (intern (buffer-substring beg (dot)))) 
		 val) 
	     ;; Setting variable named "end" means end of list. 
	     (if (eq var 'end) 
		 (setq continue nil) 
	       ;; Otherwise read the variable value. 
	       (skip-chars-forward "^:") 
	       (forward-char 1) 
	       (setq val (read (current-buffer))) 
	       (skip-chars-backward "\n") 
	       (skip-chars-forward " \t") 
	       (or (if suffix (looking-at suffix) (eolp)) 
		   (error "Local variables entry is terminated wrong")) 
	       ;; Set the variable.  "Variables" mode and eval are funny. 
	       (if (eq var 'mode) 
		   (funcall (intern (concat (downcase (symbol-name val)) 
					    "-mode"))) 
		 (if (eq var 'eval) 
		     (eval val) 
		   (make-local-variable var) 
		   (set var val)))))))))) 
 
(defun set-visited-file-name (filename) 
  "Change name of file visited in current buffer to FILENAME. 
The next time the buffer is saved it will go in the newly specified file. 
nil or empty string as argument means make buffer not be visiting any file." 
  (interactive "FSet visited file name: ") 
  (setq buffer-file-name 
	(if (string-equal filename "") 
	    nil 
	  (expand-file-name filename))) 
  (or (string-equal filename "") 
      (progn 
       (setq default-directory (file-name-directory buffer-file-name)) 
       (or (get-buffer (file-name-nondirectory buffer-file-name)) 
	   (rename-buffer (file-name-nondirectory buffer-file-name))))) 
  (setq buffer-backed-up nil) 
  (clear-visited-file-modtime) 
  (auto-save-mode (and buffer-file-name auto-save-default)) 
  (if buffer-file-name 
      (set-buffer-modified-p t))) 
 
(defun write-file (filename) 
  "Write current buffer into file FILENAME. 
Makes buffer visit that file, and marks it not modified." 
  (interactive "FWrite file: ") 
  (or (null filename) (string-equal filename "") 
      (set-visited-file-name filename)) 
  (set-buffer-modified-p t) 
  (setq buffer-read-only (not (file-writable-p filename))) 
  (save-buffer)) 
 
(defun backup-buffer () 
  "Make a backup of the disk file visited by the current buffer. 
This is done before saving the buffer the first time." 
  (and backup-before-writing 
       (not buffer-backed-up) 
       (file-exists-p buffer-file-name) 
       (not (string-equal "/tmp/" (substring buffer-file-name 0 5))) 
    (condition-case () 
	(let ((backupname (concat buffer-file-name "~")) 
	      setmodes) 
	  (if (or (file-symlink-p buffer-file-name) 
		  backup-by-copying 
		  (and backup-by-copying-when-linked 
		       (> (file-nlinks buffer-file-name) 1))) 
	      (copy-file buffer-file-name backupname) 
	    (condition-case () 
	        (delete-file backupname) 
	      (file-error nil)) 
	    (rename-file buffer-file-name backupname) 
	    (setq setmodes (file-modes backupname))) 
	  (setq buffer-backed-up t) 
	  setmodes) 
      (file-error nil)))) 
 
(defun file-nlinks (filename) 
  "Return number of names file FILENAME has."  
  (car (cdr (file-attributes filename)))) 
 
(defun save-buffer () 
  "Save the current buffer in its visited file, if it has been modified."   
  (interactive) 
  (if (buffer-modified-p) 
      (let (setmodes) 
	(or buffer-file-name 
	    (setq buffer-file-name 
		  (read-file-name "File to save in: "))) 
	(if buffer-read-only 
	    (or (yes-or-no-p "Buffer is read-only; save anyway? ") 
		(error "Attempt to saving read-only buffer"))) 
	(or (verify-visited-file-modtime (current-buffer)) 
	    (not (file-exists-p buffer-file-name)) 
	    (yes-or-no-p 
	      "File has changed on disk since last visited or saved.  Save anyway? ") 
	    (error "Save not confirmed")) 
	(or buffer-backed-up 
	    (setq setmodes (backup-buffer))) 
	(save-restriction 
	  (widen) 
	  (and (> (dot-max) 1) 
	       (/= (char-after (1- (dot-max))) ?\n) 
	       (or (eq require-final-newline t) 
		   (and require-final-newline 
			(yes-or-no-p 
			 (format "Buffer %s does not end in newline.  Add one? " 
				 (buffer-name))))) 
	       (save-excursion 
		 (goto-char (dot-max)) 
		 (insert ?\n))) 
	  (write-region (dot-min) (dot-max) buffer-file-name nil t) 
	  (if setmodes 
	      (condition-case () 
			      (set-file-modes buffer-file-name setmodes) 
		(error nil)))) 
	(and buffer-auto-save-file-name delete-auto-save-files 
	  (progn 
	    (condition-case () 
		(delete-file buffer-auto-save-file-name) 
	      (file-error nil)) 
	    (set-buffer-auto-saved)))) 
    (message "(No changes need to be saved)"))) 
 
(defun save-some-buffers (&optional arg) 
  "Save some modified file-visiting buffers.  Asks user about each one. 
With argument, saves all with no questions." 
  (interactive "P") 
  (let (considered (list (buffer-list))) 
    (while list 
      (let ((buffer (car list))) 
	(condition-case () 
	    (and (buffer-modified-p buffer) 
		 (buffer-file-name buffer) 
		 (setq considered t) 
		 (or arg 
		     (y-or-n-p (format "Save file %s? " (buffer-file-name buffer)))) 
		 (save-excursion 
		   (set-buffer buffer) 
		   (or buffer-read-only 
		       (save-buffer)))) 
	  (error nil))) 
      (setq list (cdr list))) 
    (and save-abbrevs abbrevs-changed 
	 (setq considered t) 
	 (or arg 
	     (y-or-n-p (format "Save abbrevs in %s? " abbrev-file-name))) 
	 (progn 
	  (write-abbrev-file nil) 
	  (setq abbrevs-changed nil))) 
    (or considered 
	(message "(No files need saving)")))) 
 
(defun not-modified () 
  "Mark current buffer as unmodified, not needing to be saved." 
  (interactive) 
  (message "Modification-flag cleared") 
  (set-buffer-modified-p nil)) 
 
(defun toggle-read-only () 
  "Change whether this buffer is visiting its file read-only." 
  (interactive) 
  (setq buffer-read-only (not buffer-read-only)) 
  ;; Force mode-line redisplay 
  (set-buffer-modified-p (buffer-modified-p))) 
 
(defun insert-file (filename) 
  "Insert contents of file FILENAME into buffer after dot. 
Set mark after the inserted text." 
  (interactive "fInsert file: ") 
  (let ((tem (insert-file-contents filename))) 
    (push-mark (+ (dot) (car (cdr tem)))))) 
 
(defun append-to-file (start end filename) 
  "Append the contents of the region to the end of file FILENAME. 
When called from a function, expects three arguments, 
START, END and FILENAME.  START and END are buffer positions 
saying what text to write." 
  (interactive "r\nfAppend to file: ") 
  (write-region start end filename t)) 
 
 
(defvar revert-buffer-function nil 
  "Function to use to revert this buffer, or nil to do the default.") 
 
(defun revert-buffer (&optional arg) 
  "Replace the buffer text with the text of the visited file on disk. 
This undoes all changes since the file was visited or saved. 
If latest auto-save file is more recent than the visited file, 
asks user whether to use that instead, unless a non-nil argument is given. 
 
If revert-buffer-function's value is non-nil, it is called to do the work." 
  (interactive "P") 
  (if revert-buffer-function 
      (funcall revert-buffer-function arg) 
    (let* ((odot (dot)) 
	   (auto-save-p (and (null arg) (recent-auto-save-p) 
			      (y-or-n-p "Buffer has been auto-saved recently.  Revert from auto-save file? "))) 
	   (file-name (if auto-save-p 
			  buffer-auto-save-file-name 
			buffer-file-name))) 
      (cond ((null file-name) 
	     (error "Buffer does not seem to be associated with any file")) 
	    ((not (file-exists-p file-name)) 
	     (error "File %s no longer exists!" file-name)) 
	    ((yes-or-no-p (format "Revert buffer from file %s? " file-name)) 
	     (if (file-exists-p file-name) 
		 (erase-buffer)) 
	     (insert-file-contents file-name (not auto-save-p)))) 
      (goto-char (min odot (dot-max)))))) 
 
(defun kill-some-buffers () 
  "For each buffer, ask whether to kill it." 
  (interactive) 
  (let ((list (buffer-list))) 
    (while list 
      (let* ((buffer (car list)) 
	     (name (buffer-name buffer))) 
	(and (not (string-equal name "")) 
	     (/= (aref name 0) ? ) 
	     (yes-or-no-p 
	      (format "Buffer %s %s.  Kill? " 
		      name 
		      (if (buffer-modified-p buffer) 
			  "HAS BEEN EDITED" "is unmodified"))) 
	     (kill-buffer buffer))) 
      (setq list (cdr list))))) 
 
(defun auto-save-mode (arg) 
  "Toggle auto-saving of contents of current buffer. 
With arg, turn auto-saving on if arg is positive, else off." 
  (interactive "P") 
  (setq buffer-auto-save-file-name 
        (and (if (null arg) 
		 (not buffer-auto-save-file-name) 
	       (or (eq arg t) (listp arg) (and (integerp arg) (> arg 0)))) 
	     (if (and buffer-file-name auto-save-visited-filename 
		      (not buffer-read-only)) 
		 buffer-file-name 
	       (make-auto-save-file-name))))) 
 
(defun make-auto-save-file-name () 
  "Return file name to use for auto-saves of current buffer. 
Does not consider auto-save-visited-filename; that is checked 
before calling this function. 
This is a separate function so your .emacs file or site-init.el can redefine t." 
  (if buffer-file-name 
      (concat (file-name-directory buffer-file-name) 
	      "#" 
	      (file-name-nondirectory buffer-file-name)) 
    (expand-file-name (concat "#%" (buffer-name))))) 
 
(defconst list-directory-brief-switches "-CF" 
  "*Switches for list-directory to pass to `ls' for brief listing,") 
(defconst list-directory-verbose-switches "-l" 
  "*Switches for list-directory to pass to `ls' for verbose listing,") 
 
(defun list-directory (dirname &optional verbose) 
  "Display a list of files in or matching DIRNAME, a la `ls'. 
DIRNAME is globbed by the shell if necessary. 
Prefix arg (second arg if noninteractive) means supply -l switch to `ls'. 
Actions controlled by variables list-directory-brief-switches 
 and list-directory-verbose-switches." 
  (interactive (let ((pfx current-prefix-arg)) 
		 (list (read-file-name (if pfx "List directory (verbose): " 
					 "List directory (brief): ") 
				       nil default-directory nil) 
		       pfx))) 
  (let ((switches (if verbose list-directory-verbose-switches 
		    list-directory-brief-switches)) 
	full-dir-p) 
    (or dirname (setq dirname default-directory)) 
    (if (file-directory-p dirname) 
	(progn 
	 (setq full-dir-p t) 
	 (or (string-match "/$" dirname) 
	     (setq dirname (concat dirname "/"))))) 
    (setq dirname (expand-file-name dirname)) 
    (with-output-to-temp-buffer "*Directory*" 
      (buffer-flush-undo standard-output) 
      (princ "Directory ") 
      (princ dirname) 
      (terpri) 
      (if full-dir-p 
	  (call-process "/bin/ls" nil standard-output nil 
			switches dirname) 
	(let ((default-directory (file-name-directory dirname))) 
	  (call-process shell-file-name nil standard-output nil 
			"-c" (concat "exec /bin/ls " 
				     switches " " 
				     (file-name-nondirectory dirname)))))))) 
 
(defun save-buffers-kill-emacs () 
  "Offer to save each buffer, then kill this Emacs fork." 
  (interactive) 
  (save-some-buffers) 
  (kill-emacs)) 
 
(define-key ctl-x-map "\^f" 'find-file) 
(define-key ctl-x-map "\^q" 'toggle-read-only) 
(define-key ctl-x-map "\^r" 'find-file-read-only) 
(define-key ctl-x-map "\^v" 'find-alternate-file) 
(define-key ctl-x-map "\^s" 'save-buffer) 
(define-key ctl-x-map "s" 'save-some-buffers) 
(define-key ctl-x-map "\^w" 'write-file) 
(define-key ctl-x-map "i" 'insert-file) 
(define-key esc-map "~" 'not-modified) 
(define-key ctl-x-map "\^d" 'list-directory) 
(define-key ctl-x-map "\^c" 'save-buffers-kill-emacs) 
 
(defvar ctl-x-4-map (make-keymap) 
  "Keymap for subcommands of ^X 4") 
(fset 'ctl-x-4-prefix ctl-x-4-map) 
(define-key ctl-x-map "4" 'ctl-x-4-prefix) 
(define-key ctl-x-4-map "f" 'find-file-other-window) 
(define-key ctl-x-4-map "\^f" 'find-file-other-window) 
(define-key ctl-x-4-map "b" 'pop-to-buffer) 
