(require 'company)


(defun companygen--grab-symbol ()
  (buffer-substring (point) (save-excursion (skip-syntax-backward "w_.")
                                            (point))))


;; Name should be optional as it may be inferred from the candidates function


(defmacro gencompletion-engine (fun &optional name)
  ""
  (if (not name)
      (setq name (slugify (sym2str fun))))

  (let ((cand)))

  `(progn ,@body))

;; gen is like def but it generates the name 

(gencompletion-engine 'company-pen-filetype--candidates)
(gencompletion-engine (gencandidatesfunction company-pen-filetype--candidates))


;; This is provided, not generated  
(defun company-pen-filetype--candidates (prefix)
  (let* ((preceding-text (str (buffer-substring (point) (max 1 (- (point) 1000)))))
         (endspace)
         (preceding-text-endspaceremoved)
         (response
          (pen-pf-generic-file-type-completion (detect-language) preceding-text))
         ;; Take only the first line for starters
         ;; Do not only take the first line. That's kinda useless.
         ;; (line (car (str2lines response)))
         ;; (line response)
         (res
          (if (>= (prefix-numeric-value current-prefix-arg) 8)
              (list response)
            ;; Just generate a few
            ;; (pen-pf-generic-file-type-completion (detect-language) preceding-text)
            ;; (pen-pf-generic-file-type-completion (detect-language) preceding-text))
            (str2lines (snc "monotonically-increasing-tuple-permutations.py" (car (str2lines response)))))))
    ;; Generate a list
    ;; (setq res '("testing" "testing123"))
    (mapcar (lambda (s) (concat (company-pen-filetype--prefix) s))
            res)))



(defun company-pen-filetype--prefix ()
  "Grab prefix at point."
  (or (companygen--grab-symbol)
      'stop))

(defun company-pen-filetype (command &optional arg &rest ignored)
  (interactive (list 'interactive))
  (cl-case command
    (interactive (company-begin-backend 'company-pen-filetype))
    (prefix (company-pen-filetype--prefix))
    (candidates (company-pen-filetype--candidates arg))
    ;; TODO doc-buffer may contain info on the completion in the future
    ;; (doc-buffer (company-pen-filetype--doc-buffer arg))
    ;; TODO annotation may contain the probability in the future
    ;; (annotation (company-pen-filetype--annotation arg))
    ))

(provide 'companygen)