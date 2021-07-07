;;; perl6-detect.el --- Perl 6 detection -*- lexical-binding: t; -*-

;;; Commentary:

;; Yes, we are adding to `magic-mode-alist' here. Perl 6 uses the same
;; file extensions as Perl 5, and we want the mode to work out of the box.
;; So for those files we look at the first line of code to determine
;; whether to call `perl6-mode' instead of `perl-mode'.

;;; Code:

;;;###autoload
(add-to-list 'interpreter-mode-alist '("perl6" . perl6-mode))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.p[lm]?6\\'" . perl6-mode))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.raku\\'" . perl6-mode))

;;;###autoload
(defconst perl6-magic-pattern
  (rx line-start
      (0+ space)
      (or (and "use" (1+ space) "v6")
          (and (opt (and (or "my" "our") (1+ space)))
               (or "module" "class" "role" "grammar" "enum" "slang" "subset")))))

;;;###autoload
(defun perl6-magic-matcher ()
  "Check if the current buffer is a Perl 6 file.

Only looks at a buffer if it has a file extension of .t, .pl, or .pm.

Scans the buffer (to a maximum of 4096 chars) for the first non-comment,
non-whitespace line.  Returns t if that line looks like Perl 6 code,
nil otherwise."
  (let ((case-fold-search nil))
    (when (and (stringp buffer-file-name)
               (string-match "\\.\\(?:t\\|p[lm]\\)\\'" buffer-file-name))
      (let ((keep-going t)
            (found-perl6 nil)
            (max-pos (min 4096 (point-max))))
        (while (and (< (point) max-pos)
                    keep-going)
          (if (looking-at "^ *\\(?:#.*\\)?$")
              (beginning-of-line 2)
            (setq keep-going nil
                  found-perl6 (looking-at perl6-magic-pattern))))
        found-perl6))))

;;;###autoload
(add-to-list 'magic-mode-alist '(perl6-magic-matcher . perl6-mode))

(provide 'perl6-detect)

;; Local Variables:
;; coding: utf-8
;; indent-tabs-mode: nil
;; End:

;;; perl6-detect.el ends here
