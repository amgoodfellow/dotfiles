(defun my/add-junit-test (name type actual expected)
  "Interactively adds junit test for given feature"
  (interactive "sTest Name: \nsAssert Type: \nsActual: \nsExpected: \n")
  (insert (message "@Test\nprivate void %s(){\n\tassert%s(%s, %s);\n}" name type actual expected)))

(defun my/java-wrap-in-try (e)
  (interactive "sException: \n")
  (insert (concat "try {\n"
  (filter-buffer-substring (region-beginning)(region-end))
  "\} catch("e"Exception e) {\n\n}") (delete-region (region-beginning) (region-end))))

(defun my/delimiter-switcher (str current desired)
  "Takes a list of values and adds a delimiter to them"
  (interactive "sString Value: \nsCurrent Delimiter: \nsDesired Delimiter: \n")
  (insert (replace-regexp-in-string current desired str)))

(defun my/markdown-codify (lang)
  "Yank a region of code and wrap it in markdown code format"
  (interactive "sLanguage: \n")
  (kill-new (concat "```" lang "\n"
   (filter-buffer-substring (region-beginning)(region-end))
   "\n```")))

(defun my/surround-with-tag (word)
  "Surround region with specified param"
  (interactive "sWord: \n")
  (insert (concat "<" word ">"
                  (filter-buffer-substring (region-beginning) (region-end))
                  "</" word ">")
          (delete-region (region-beginning) (region-end))))

(defun my/javadoc-comment (param return)
  "Create a simple Javadoc comment"
  (interactive "sParam: \nsReturn: \n")
  (insert (concat "/**\n*\n*\n*\n* @param " param "\n* @return " return "\n*/")))

(defun my/stringify-region (start end)
  "Transforms a line like `<line>` to `\"<line>\" +`"
  (interactive "r")
  (narrow-to-region start end)

  (goto-char (point-min))
  (while (< (point) end)
    (beginning-of-line)
    (insert "\"")
    (end-of-line)
    (insert " \"  +")
    (forward-line 1))
  (backward-char 1)
  (delete-char 1)
  (insert ");")
  (widen))
