(defun insertion-sort-func (lst &key (key #'identity) (test #'<))
	(labels ((insert (x sorted)
				(if (null sorted)
					(list x)
					(let ((x-key (funcall key x))
					(head-key (funcall key (car sorted))))
						(if (funcall test x-key head-key)
							(cons x sorted)
							(cons (car sorted) (insert x (cdr sorted)))
						)
					)
				)
			 )
			)
		(reduce (lambda (sorted x) (insert x sorted)) lst :initial-value nil)
	)
)

(defun test-insertion-sort (ins-sort-function)
  (assert (equal (funcall ins-sort-function '()) '())) ;empty
  (assert (equal (funcall ins-sort-function '(1)) '(1))) ;one element
  (assert (equal (funcall ins-sort-function '(1 2 3 4 5)) '(1 2 3 4 5))) ;sorted
  (assert (equal (funcall ins-sort-function '(5 4 3 2 1)) '(1 2 3 4 5))) ;reversed
  (assert (equal (funcall ins-sort-function '(3 1 4 1 5 9)) '(1 1 3 4 5 9))) ;random
  (assert (equal (funcall ins-sort-function '(10 9 8 8 7 7 6 6 5)) '(5 6 6 7 7 8 8 9 10))) ;duplicates
)

(defun replacer (what to &key (test #'eql) count)
	(let ((remaining (if count count most-positive-fixnum)))
		(lambda (current result)
			(if (and (> remaining 0) (funcall test current what))
				(progn
					(decf remaining)
					(cons to result)
				)
				(cons current result)
			)
		)
	)
)

(defun test-replacer ()
	;; Тести без ключів
	(assert (equal (reduce (replacer 1 2) '(1 1 1 4) :from-end t :initial-value nil) '(2 2 2 4)))
	(assert (equal (reduce (replacer 3 9) '(3 3 3 5) :from-end t :initial-value nil) '(9 9 9 5)))
	(assert (equal (reduce (replacer 5 0) '(1 2 3 4) :from-end t :initial-value nil) '(1 2 3 4)))

	;; Тести з count
	(assert (equal (reduce (replacer 1 2 :count 2) '(1 1 1 4) :from-end t :initial-value nil) '(1 2 2 4)))
	(assert (equal (reduce (replacer 3 9 :count 2) '(3 3 3 5) :from-end t :initial-value nil) '(3 9 9 5)))
	(assert (equal (reduce (replacer 1 0 :count 2) '(1 1 1 1) :from-end t :initial-value nil) '(1 1 0 0)))

	;; Тести з test
	(assert (equal (reduce (replacer 2 8 :test #'(lambda (x y) (< x y))) '(1 2 3 4) :from-end t :initial-value nil) '(8 2 3 4)))
	(assert (equal (reduce (replacer 0 99 :test #'(lambda (x y) t)) '(1 2 3 4) :from-end t :initial-value nil) '(99 99 99 99)))
)

