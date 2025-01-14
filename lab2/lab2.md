<p align="center"><b>МОНУ НТУУ КПІ ім. Ігоря Сікорського ФПМ СПіСКС</b></p>
<p align="center">
<b>Звіт з лабораторної роботи 2</b><br/>
"Рекурсія"<br/>
дисципліни "Вступ до функціонального програмування"
</p>

<p align="right"> 
<b>Студент</b>: 
<em> Лабазов Володимир КВ-11</em></p>

<p align="right"><b>Рік</b>: <em>2025</em></p>


## Загальне завдання

Реалізуйте дві рекурсивні функції, що виконують деякі дії з вхідним(и) списком(-ами), за
можливості/необхідності використовуючи різні види рекурсії. Функції, які необхідно
реалізувати, задаються варіантом (п. 2.1.1). Вимоги до функцій:
1. Зміна списку згідно із завданням має відбуватись за рахунок конструювання нового
списку, а не зміни наявного (вхідного).
2. Не допускається використання функцій вищого порядку чи стандартних функцій
для роботи зі списками, що не наведені в четвертому розділі навчального
посібника.
3. Реалізована функція не має бути функцією вищого порядку, тобто приймати функції
в якості аргументів.
4. Не допускається використання псевдофункцій (деструктивного підходу).
5. Не допускається використання циклів.
Кожна реалізована функція має бути протестована для різних тестових наборів. Тести
мають бути оформленні у вигляді модульних тестів (див. п. 2.3).

## Варіант 12

1. Написати функцію remove-thirds-and-reverse , яка видаляє зі списку кожен третій
елемент і обертає результат у зворотному порядку:

```lisp
CL-USER> (remove-thirds-and-reverse '(a b c d e f g))
(G E D B A)
```

2. Написати функцію list-set-difference-3 , яка визначає різницю трьох множин,
заданих списками атомів:

```lisp
CL-USER> (list-set-difference '(1 2 3 4) '(4 5 6) '(2 5 7))
(1 3) ; порядок може відрізнятись
```

## Лістинг функції remove-thirds-and-reverse

```lisp
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
```

### Тестові набори

```lisp
(defun test-remove-thirds-and-reverse ()
	(assert (equal (remove-thirds-and-reverse '(a b c d e f g)) '(g e d b a)))
	(assert (equal (remove-thirds-and-reverse '(1 2 3 4 5 6 7 8 9)) '(8 7 5 4 2 1)))
	(assert (equal (remove-thirds-and-reverse '()) '()))
)
```

### Тестування

```lisp
CL-USER> (test-remove-thirds-and-reverse)
NIL
```

## Лістинг функції remove-thirds-and-reverse

```lisp
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
```

### Тестові набори

```lisp
(defun test-list-set-difference-3 ()
	(assert (equal (list-set-difference-3 '(1 2 3 4) '(4 5 6) '(2 5 7)) '(3 1)))
	(assert (equal (list-set-difference-3 '(a b c d) '(d e f) '(b f g)) '(c a)))
	(assert (equal (list-set-difference-3 '() '(1 2 3) '(4 5 6)) '()))
 )
```

### Тестування

```lisp
CL-USER> (test-list-set-difference-3)
NIL
```
