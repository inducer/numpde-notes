;; Adapted from https://github.com/mattduck/org-toggl-py/blob/085ff22ffab9c1aeec51fcda5336e4318875e1ee/org-export-json.el
;; which was based on the mailing post by Brett Viren: https://lists.gnu.org/archive/html/emacs-orgmode/2014-01/msg00338.html
(require 'json)

; from https://github.com/ludios/org-to-json

(defun org-document-as-json ()
  (let* ((tree (org-element-parse-buffer 'object nil)))
    (org-element-map tree (append org-element-all-elements
                                  org-element-all-objects '(plain-text))
      (lambda (x)
        ; Break circular references before encoding
        (if (org-element-property       :parent x)
            (org-element-put-property x :parent nil))
        (if (org-element-property       :structure x)
            (org-element-put-property x :structure nil))
        ))
    (json-encode tree)))

(defun cli-org-export-json ()
  (let ((org-file-path    (car command-line-args-left))
        (other-load-files (cdr command-line-args-left)))
    (mapc 'load-file other-load-files)
    (find-file org-file-path)
    (org-mode)
    (princ (org-document-as-json))))
