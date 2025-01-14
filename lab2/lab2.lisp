(defun remove-thirds-and-reverse (lst &optional (count 1) (acc '()))
	(cond
		((null lst) acc)
		((= (mod count 3) 0)
			(remove-thirds-and-reverse (cdr lst) (1+ count) acc)
		)
		(t
			(remove-thirds-and-reverse (cdr lst) (1+ count) (cons (car lst) acc))
		)
	)
)


(defun list-set-difference-3 (lst1 lst2 lst3 &optional (acc '()))
	(cond
		((null lst1) acc)
		((or (member (car lst1) lst2)(member (car lst1) lst3))
			(list-set-difference-3 (cdr lst1) lst2 lst3 acc)
		)
		(t
			(list-set-difference-3 (cdr lst1) lst2 lst3 (cons (car lst1) acc))
		)
	)
)

(defun test-remove-thirds-and-reverse ()
	(assert (equal (remove-thirds-and-reverse '(a b c d e f g)) '(g e d b a)))
	(assert (equal (remove-thirds-and-reverse '(1 2 3 4 5 6 7 8 9)) '(8 7 5 4 2 1)))
	(assert (equal (remove-thirds-and-reverse '()) '()))
)

(defun test-list-set-difference-3 ()
	(assert (equal (list-set-difference-3 '(1 2 3 4) '(4 5 6) '(2 5 7)) '(3 1)))
	(assert (equal (list-set-difference-3 '(a b c d) '(d e f) '(b f g)) '(c a)))
	(assert (equal (list-set-difference-3 '() '(1 2 3) '(4 5 6)) '()))
 )
