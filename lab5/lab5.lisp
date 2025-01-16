(defun mapconcat (function list separator)
	"Застосовує FUNCTION до кожного елемента LIST і об'єднує результати через SEPARATOR."
	(if list
		(reduce (lambda (a b) (concatenate 'string a separator b)) (mapcar function list))
		""
	)
)

(defun split-string (string delimiter)
	"Розділяє рядок на частини за заданим роздільником."
	(loop for start = 0 then (1+ end)
	for end = (position delimiter string :start start)
		collect (subseq string start end)
		while end
	)
)

(defun parse-csv-line (line)
	"Розбирає рядок CSV у список значень."
	(split-string line #\,)
)

(defun read-lines (filename)
	"Зчитує всі рядки з файлу."
	(with-open-file (stream filename)
		(loop for line = (read-line stream nil)
			while line
			collect line
		)
	)
)

(defun read-csv-table (filename)
	"Читає таблицю з CSV-файлу та повертає список асоціативних списків."
	(let* ((lines (read-lines filename)) (headers (parse-csv-line (first lines))))
		(mapcar (lambda (line) (create-record headers (parse-csv-line line)))(rest lines))
	)
)

(defun create-record (headers row)
	"Створює асоціативний список із заголовків та рядка даних."
	(mapcar #'(lambda (header value) 
			(cons (intern header) value)
		)
		headers
		row
	)
)

(defun select (filename &optional filter-fn)
	"Повертає лямбда-вираз для вибірки записів з таблиці."
	(let ((records (read-csv-table filename)))
		(lambda (&rest args)
			(remove-if-not
				(lambda (record)
					(if filter-fn
						(funcall filter-fn record args)
						t
					)
				)
			records)
		)
	)
)

(defun write-csv (filename records)
	"Записує вибірку (список записів) у CSV-файл."
	(with-open-file (stream filename :direction :output :if-exists :supersede)
		(write-line (mapconcat #'symbol-name (mapcar #'car (first records)) ",") stream)
		(dolist (record records)
			(write-line (mapconcat #'cdr record ",") stream)
		)
	)
)

(defun assoc-to-hash (assoc-list)
  "Конвертує асоціативний список у геш-таблицю."
    (let ((hash (make-hash-table)))
		(dolist (pair assoc-list)
			(setf (gethash (car pair) hash) (cdr pair))
		)
		hash
	)
)

(defun hash-to-assoc (hash)
  "Конвертує геш-таблицю у асоціативний список."
	(loop for key being the hash-keys of hash
		collect (cons key (gethash key hash))
	)
)

(defun pretty-print-records (records)
	"Друкує список асоціативних списків у красивому форматі."
	(dolist (record records)
		(dolist (pair record)
		  (format t "~a: ~a, " (car pair) (cdr pair)))
		(terpri) ;; Перехід на новий рядок після кожного запису
	)
)

(defun run-tests ()
  "Запускає тестування функцій зчитування, конвертації та вибірки."
	(let* (
		 (spacecraft-select-fn nil)
		 (company-select-fn nil)
		 (result nil)
		 (spacecraft-table-path "lab5/spacecraft.csv")
		 (companies-table-path "lab5/companies.csv")
		 )

		;; Тест зчитування першого запису з spacecrafts.csv
		(setf result (read-csv-table spacecraft-table-path))
		(format t "First Record (Spacecrafts): ~a~%" (first result))

		;; Тест зчитування першого запису з companies.csv
		(setf result (read-csv-table companies-table-path))
		(format t "First Record (Companies): ~a~%" (first result))

		;; Тест конвертації асоціативного списку в геш-таблицю і назад
		(let* ((assoc-record (first (read-csv-table spacecraft-table-path)))
			   (hash-record (assoc-to-hash assoc-record))
			   (converted-back (hash-to-assoc hash-record)))
		  (format t "Test Assoc to Hash: ~a~%" 
				  (equal assoc-record (hash-to-assoc hash-record)))
		  (format t "Test Hash to Assoc: ~a~%" 
				  (equal converted-back assoc-record)))

		;; Тест вибірки з spacecrafts.csv
		(setf spacecraft-select-fn 
			  (select spacecraft-table-path
					  #'(lambda (record &rest args)
						(equal (cdr (assoc (intern "name") record)) "Blue Moon"))))
		(setf result (funcall spacecraft-select-fn))
		(format t "Select with Filter by name - Blue Moon (Spacecrafts): ~a~%" (first result))

		;; Тест вибірки з companies.csv
		(setf company-select-fn 
			  (select companies-table-path 
					  #'(lambda (record &rest args)
						(equal (cdr (assoc (intern "headquarters") record)) "Hawthorne"))))
		(setf result (funcall company-select-fn))
		(format t "Select with Filter by headquaters - Hawthorne (Companies): ~a~%" (first result))
	)
)

