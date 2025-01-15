<p align="center"><b>МОНУ НТУУ КПІ ім. Ігоря Сікорського ФПМ СПіСКС</b></p>
<p align="center">
<b>Звіт з лабораторної роботи 4</b><br/>
"Функції вищого порядку та замикання"<br/>
дисципліни "Вступ до функціонального програмування"
</p>

<p align="right"> 
<b>Студент</b>: 
<em> Лабазов Володимир КВ-11</em></p>

<p align="right"><b>Рік</b>: <em>2025</em></p>

## Загальне завдання
Завдання складається з двох частин:
1. Переписати функціональну реалізацію алгоритму сортування з лабораторної
роботи 3 з такими змінами:
- використати функції вищого порядку для роботи з послідовностями (де це
доречно);
- додати до інтерфейсу функції (та використання в реалізації) два ключових
параметра: key та test , що працюють аналогічно до того, як працюють
параметри з такими назвами в функціях, що працюють з послідовностями. При
цьому key має виконатись мінімальну кількість разів.
2. Реалізувати функцію, що створює замикання, яке працює згідно із завданням за
варіантом (див. п 4.1.2). Використання псевдо-функцій не забороняється, але, за
можливості, має бути мінімізоване.

## Варіант першої частини (4)

Алгоритм сортування вставкою №2 (з лінійним пошуком справа) за незменшенням.

### Лістинг реалізації першої частини завдання

```lisp
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
```

### Тестові набори та утиліти першої частини

```lisp
(defun test-insertion-sort (ins-sort-function)
  (assert (equal (funcall ins-sort-function '()) '())) ;empty
  (assert (equal (funcall ins-sort-function '(1)) '(1))) ;one element
  (assert (equal (funcall ins-sort-function '(1 2 3 4 5)) '(1 2 3 4 5))) ;sorted
  (assert (equal (funcall ins-sort-function '(5 4 3 2 1)) '(1 2 3 4 5))) ;reversed
  (assert (equal (funcall ins-sort-function '(3 1 4 1 5 9)) '(1 1 3 4 5 9))) ;random
  (assert (equal (funcall ins-sort-function '(10 9 8 8 7 7 6 6 5)) '(5 6 6 7 7 8 8 9 10))) ;duplicates
)
```

### Тестування першої частини

```lisp
CL-USER> (test-insertion-sort #'insertion-sort-func)
NIL
```

## Варіант другої частини (12)
Написати функцію replacer , яка має два основні параметри what і to та два
ключові параметри — test та count . repalcer має повернути функцію, яка при
застосуванні в якості першого аргументу reduce робить наступне: при обході списку з
кінця, кожен елемент списка-аргумента reduce , для якого функція test , викликана з
цим елементом та значенням what , повертає значення t (або не nil ), заміняється
на значення to . Якщо count передане у функцію, заміна виконується count разів.
Якщо count не передане тоді обмежень на кількість разів заміни немає. test має
значення за замовчуванням #'eql . Обмеження, які накладаються на використання
функції-результату replacer при передачі у reduce визначаються розробником (тобто,
наприклад, необхідно чітко визначити, якими мають бути значення ключових параметрів
функції reduce from-end та initial-value ).

```lisp
CL-USER> (reduce (replacer 1 2)
'(1 1 1 4)
:from-end ...
:initial-value ...)
(2 2 2 4)
CL-USER> (reduce (replacer 1 2 :count 2)
'(1 1 1 4)
:from-end ...
:initial-value ...)
(1 2 2 4)
```

### Лістинг реалізації другої частини завдання

```lisp
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
```

### Тестові набори та утиліти другої частини

```lisp
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
```

### Тестування другої частини

```lisp
CL-USER> (test-replacer)
NIL
```
