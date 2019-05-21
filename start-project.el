;;; start-project.el --- An wrapper over cookiecutter

;; LastChange: Feb 18, 2017
;; Version:    0.1
;; Author:     Mohamed Aziz Knani <medazizknani@gmail.com>

;; This file is not part of GNU Emacs.

;; This is free software; you can redistribute it and/or modify it under
;; the terms of the GNU General Public License as published by the Free
;; Software Foundation; either version 2, or (at your option) any later
;; version.
;;
;; This is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
;; FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
;; for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation
;; 51 Franklin Street, Fifth Floor
;; Boston, MA 02110-1301
;; USA


(require 'helm)
(require 'cl)


(defun my-projects-cookie-cutters ()
  "returns the cookiecutters."
  (interactive)
  (remove-if-not
   '(lambda (x) (not (or (equal x ".") (equal x ".."))))
   (directory-files "~/.cookiecutters/")))

;; function from xah's blog.
(defun get-string-from-file (filePath)
  "Return filePath's file content."
  (with-temp-buffer
    (insert-file-contents filePath)
    (buffer-string)))

(defun my-projects-make-project (project)
  (progn
    (shell-command
     (format "cookiecutter --no-input  ~/.cookiecutters/%S %s" project
	     (mapconcat 'identity
			(loop for (key . value) in
			      (json-read-from-string (get-string-from-file (format "~/.cookiecutters/%s/cookiecutter.json" project)))
			      collect (format "%s=\"%s\"" key (read-string (format "[%s] : " key)))) " ")))
    (message "Done Master.")))

(setq helm-source-my-projects
      '((name . "Projects")
	(candidates . my-projects-cookie-cutters)
	(action . my-projects-make-project)))

;;;###autoload
(defun helm-start-project ()
  "My projects"
  (interactive)
  (helm :sources 'helm-source-my-projects
	:buffer "*helm-projects*"))

(provide 'start-project)
