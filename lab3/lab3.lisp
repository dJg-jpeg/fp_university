(defun insertion-sort-func (lst)
	(labels (
		(insert (x sorted)
			(cond 
				((null sorted) (list x))
				((<= x (car sorted)) (cons x sorted))
				(t (cons (car sorted) (insert x (cdr sorted))))
			)
		)
		)
		(if (null lst)
			nil
			(insert (car lst) (insertion-sort-func (cdr lst)))
		)
	)
)

(defun insertion-sort-imp (lst)
	(let ((copy (copy-list lst)))
		(loop for i from 1 below (length copy)
			do (let ((current (nth i copy)) (j i))
					(loop while (and (> j 0) (> (nth (- j 1) copy) current))
						do (progn
							(setf (nth j copy) (nth (- j 1) copy))
							(decf j))
					)
				   (setf (nth j copy) current)
				)
		)
		copy
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
