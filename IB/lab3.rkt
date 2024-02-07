(define-syntax trace-ex 
  (syntax-rules ()
    ((trace-ex x) (let ((res x)) (begin 
                                   (write 'x) 
                                   (display "=>") 
                                   (display res) 
                                   (newline) 
                                   res)))))
(define-syntax test
  (syntax-rules ()
    ((test exp ret)
     (list (car '(exp)) '(ret)))))
(define (run-test test)
  (begin (write (car test))
         (let ((x (eval (car test) (interaction-environment))))
           (if (= x (caadr test))
               (begin (display " ok\n") #t)
               (begin (display " FAIL\n") (display "  Expected: ") (write (caadr test))
                      (newline) (display "  Returned: ") (write x)(newline) #f)))))
(define (fin xs) (and (car xs) (fin (cdr xs))))
(define (run-tests xs)
  (if (or (equal? (car xs) #f) (equal? (car xs) #t))
      (fin xs)
      (run-tests (append (cdr xs) `(,(run-test (car xs)))))))
(define  (my-flatten lst) (cond ((null? lst) '())
                                ((list? (car lst)) (append (my-flatten (car lst)) (my-flatten (cdr lst))))
                                (else (cons (car lst) (my-flatten (cdr lst))))))
(define (obr li a b)
  (define (obr1 li1 li2 a1 b1 c1) (if (<= c1 b1)
                                      (obr1 li1 (cons (list-ref li1 c1) li2) a1 b1 (+ c1 1))
                                      (reverse li2))) (obr1 li '() a b a))
(define (refli ob k nb)
  (my-flatten (cons (cons (obr ob 0 (- k 1))
                          (cons nb '())) (obr ob k (- (length ob) 1)))))
(define-syntax ref (syntax-rules()
                     ((ref ob k)(cond ((list? ob) (and (< k (length ob)) (list-ref ob k)))
                                      ((vector? ob) (and (< k (length (vector->list ob)))
                                                         (vector-ref ob k)))
                                      (else
                                       (if (< k (length (string->list ob))) (list-ref (string->list ob) k)))))
                     ((ref ob k nb)
                      (cond ((list? ob) (and (< k (length ob)) (refli ob k nb)))
                            ((vector? ob) (and (< k (length (vector->list ob)))
                                               (list->vector (refli (vector->list ob) k nb))))
                            (else (and (<= k (length (string->list ob))) (char? nb)
                                       (list->string (refli (string->list ob) k nb))))))))
(define (factorize form)
  (define zn (car form))
  (define step (car(cdr(cdr(car(cdr form))))))
  (define a (car(cdr(car(cdr form)))))
  (define b (car(cdr(car(cdr(cdr form))))))
  (if (equal? step 2)
      (and (equal? zn '-)
           `(* (- ,a ,b) (+ ,a ,b)))
      (if (equal? zn '-)
          `(* (- ,a ,b) (+ (expt ,a 2) (* ,a ,b) (expt ,b 2)))
          `(* (+ ,a ,b) (+ (expt ,a 2) (- (* ,a ,b)) (expt ,b 2))))))
(define (zip . xss)
  (if (or (null? xss)
          (null? (trace-ex (car xss)))) ; Здесь...
      '()
      (cons (map car xss)
            (apply zip (map cdr (trace-ex xss)))))) ; ... и здесь
(define (signum x)
  (cond
    ((< x 0) -1)
    ((= x 0)  1) ; Ошибка здесь!
    (else     1)))
(define the-tests
  (list (test (signum -2) -1)
        (test (signum  0)  0)
        (test (signum  2)  1)))