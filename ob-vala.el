;;; ob-vala.el --- org-babel functions for Vala evaluation

;; Copyright (C) 2017 Christian Garbs <mitch@cgarbs.de>

;; Author: Christian Garbs <mitch@cgarbs.de>
;; Keywords: literate programming, reproducible research
;; Homepage: http://orgmode.org
;; Version: 0.01

;;; License:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; ob-vala.el provides Babel support for the Vala language
;; (see http://live.gnome.org/Vala for details)

;;; Requirements:

;; - Vala compiler binary (valac)
;; - Vala development environment (Vala libraries etc.)
;;
;; vala-mode.el is nice to have for code formatting, but is not needed
;; for ob-vala.el

;;; Code:
(require 'ob)
(require 'ob-ref)
(require 'ob-comint)
(require 'ob-eval)

;; file extension
(add-to-list 'org-babel-tangle-lang-exts '("vala" . "vala"))

;; header arguments empty by default
(defvar org-babel-default-header-args:vala '())

(defvar org-babel-vala-compiler "valac"
  "Command used to compile a Vala source code file into an
executable.")

(defun org-babel-expand-body:vala (body params &optional processed-params)
  "Expand BODY: does nothing, returns original BODY while ignoring PARAMS."
  body ;; TODO: expand PARAMS?
  )

;; This is the main function which is called to evaluate a code
;; block.
;;
;; - run Vala compiler and create a binary in a temporary file
;;   - compiler/linker flags can be set via :flags header argument
;; - if compilation succeeded, run the binary
;;   - commandline parameters to the binary can be set via :cmdline
;;     header argument
;;   - stdout will be parsed as RESULT (control via :result-params
;;     header argument)
;;
;; There is no session support because Vala is a compiled language.
;;
;; This function is heavily based on ob-C.el (licensed under GPL 3+).
(defun org-babel-execute:vala (body params)
  "Execute a block of Vala code with org-babel.
This function is called by `org-babel-execute-src-block'"
  (message "executing Vala source code block")
  (let* ((tmp-src-file (org-babel-temp-file
			"vala-src-"
			".vala"))
         (tmp-bin-file (org-babel-temp-file "vala-bin-" org-babel-exeext))
         (cmdline (cdr (assoc :cmdline params)))
         (flags (cdr (assoc :flags params)))
         (full-body (org-babel-expand-body:vala body params))
         (compile
	  (progn
	    (with-temp-file tmp-src-file (insert full-body))
	    (org-babel-eval
	     (format "%s %s -o %s %s"
		     org-babel-vala-compiler
		     (mapconcat 'identity
				(if (listp flags) flags (list flags)) " ")
		     (org-babel-process-file-name tmp-bin-file)
		     (org-babel-process-file-name tmp-src-file)) "")))
	 )
    (if (file-executable-p tmp-bin-file)
	(let ((results
	       (org-babel-trim
		(org-babel-eval
		 (concat tmp-bin-file (if cmdline (concat " " cmdline) "")) ""))))
	  (org-babel-reassemble-table
	   (org-babel-result-cond (cdr (assoc :result-params params))
	     (org-babel-read results)
	     (let ((tmp-file (org-babel-temp-file "vala-")))
	       (with-temp-file tmp-file (insert results))
	       (org-babel-import-elisp-from-file tmp-file)))
	   (org-babel-pick-name
	    (cdr (assoc :colname-names params)) (cdr (assoc :colnames params)))
	   (org-babel-pick-name
	    (cdr (assoc :rowname-names params)) (cdr (assoc :rownames params)))
	   ))
      )))

(defun org-babel-prep-session:vala (session params)
  "This function does nothing as Vala is a compiled language with no
support for sessions"
  (error "Vala is a compiled language -- no support for sessions"))

(defun org-babel-vala-var-to-vala (var)
  "Convert an elisp var into a string of vala source code
specifying a var of the same value."
  (format "%S" var))

(defun org-babel-vala-table-or-string (results)
  "If the results look like a table, then convert them into an
Emacs-lisp table, otherwise return the results as a string."
  )

(defun org-babel-vala-initiate-session (&optional session)
  "If there is not a current inferior-process-buffer in SESSION then create.
Return the initialized session."
  (unless (string= session "none")
    ))

(provide 'ob-vala)
;;; ob-vala.el ends here
