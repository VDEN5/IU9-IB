(define (my-flatten xs)
  (reverse (flatrec xs '())));O(n^2), reverse
(define (flatrec xs res)
    (cond ((null? xs) res)
        ((list? xs)(flatrec (cdr xs) (flatrec (car xs) res)))
           (else (cons xs res))))
(define (my-range a b d)
  (define (g s l)
    (if
     (> s b)
     (reverse l)
        (g (+ s d) (cons s l))))
  (g a '()));;O(n)
(define (my-element? x xs)
  (and (> (length xs) 0)
       (or (equal? x (car xs)) (my-element? x (cdr xs)))))
;;O(n^2), если я правильно понял вас, так как в начале функция с линейной
(define (my-filter pred? xs)
  (define (li xs1 xs2)
    (if
     (= (length xs1) 0)
     (reverse xs2)
        (if
         (pred? (car xs1))
         (li (cdr xs1) (cons (car xs1) xs2))
         (li (cdr xs1) xs2))))
  (li xs '()));;O(n^2)
(define (my-fold-left op xs)
  (define (g op1 xs1 res)
    (if
     (= (length xs1) 0);;O(n)
     res
     (g op1 (cdr xs1) (op1 res (car xs1)))))
  (g op (cdr xs) (car xs)));;O(n^2)
(define (ft op1 xs1 res)
    (if
     (= (length xs1) 1);;O(n)
     (op1 (car xs1) res)
(ft op1 (reverse (cdr (reverse xs1))) (op1 (car (reverse xs1)) res))));;O(n^4)
(define (my-fold-right op xs)
  (if
   (= (length xs) 1)
   (car xs)
   (ft op (reverse (cdr (reverse xs))) (car (reverse xs)))));;O(n^2)
(define (my-element? x xs)
  (and (> (length xs) 0)
       (or
        (equal? x (car xs))
        (my-element? x (cdr xs)))))
(define (list->set xs)
  (define
    (tg li se)
    (if
     (= (length li) 0) se
     (if
      (my-element? (car li) se)
      (tg (cdr li) se)
      (tg
       (cdr li)
       (cons (car li) se)))))
  (tg xs '()));;O(n^2) из-за предиката my-element?
(define (set? xs)
  (define (h li k)
    (if
     (= (length li) 0)
     k
     (if
      (my-element? (car li) (cdr li))
      (h (cdr li) (+ k 1))
      (h (cdr li) k))))
  (= (h xs 0) 0));;O(n^2)
(define (union xs ys)
  (define (ft xs1 ys1 zs1)
    (if
     (and (= (length xs1) 0) (= (length ys1) 0))
     (reverse zs1)
     (if
      (= (length xs1) 0)
      (if
       (my-element? (car ys1) zs1)
       (ft xs1 (cdr ys1) zs1)
       (ft xs1 (cdr ys1) (cons (car ys1) zs1)))
      (if
       (my-element? (car xs1) zs1)
       (ft (cdr xs1) ys1 zs1)
       (ft (cdr xs1) ys1 (cons (car xs1) zs1))))))
  (ft xs ys '()));;O(m*n^2)
(define (intersection xs ys)
  (define (ft xs1 ys1 zs1)
    (if
     (= (length xs1) 0)
     (cdr (reverse zs1))
     (if
      (my-element? (car xs1) ys1)
      (ft (cdr xs1) ys1 (cons (car xs1) zs1))
      (ft (cdr xs1) ys1 zs1))))
  (ft xs ys '(())));;O(m*n^2)
(define (difference xs ys)
  (define (ft xs1 ys1 zs1)
    (if
     (= (length xs1) 0)
     (cdr (reverse zs1))
     (if
      (not (my-element? (car xs1) ys1))
      (ft (cdr xs1) ys1 (cons (car xs1) zs1))
      (ft (cdr xs1) ys1 zs1))))
  (ft xs ys '(())));O(m*n)
(define (symmetric-difference xs ys)
  (union
   (difference xs ys)
   (difference ys xs)));O(m*n^2)
(define (set-eq? xs ys)
  (define (ft xs1 ys1 k)
    (if
     (= (length xs1) 0)
     k
     (if
      (my-element?
       (car xs1)
       ys1)
      (ft (cdr xs1) ys1 (+ k 1))
      (ft (cdr xs1) ys1 k))))
  (= (length xs) (length ys) (ft xs ys 0)));;O(m*n)
(define (frt index sizes)
  (if (> (length index) 1)
      (+ (* (apply * (cdr sizes)) (car index)))
      (frt (cdr index) (cdr sizes)))
  (car index))
(define (make-multi-vector sizes . fill)
  (vector 'mulvec sizes (if (null? fill)
                            (make-vector (apply * sizes))
                            (make-vector (apply * sizes) (car fill)))))
(define (multi-vector? mv)
  (and (vector? mv)(eq? (car (vector->list mv)) 'mulvec)))
(define (multi-vector-ref mv index)
  (vector-ref (vector-ref mv 2) (frt index (vector-ref mv 1))))
(define (multi-vector-set! mv index x)
  (vector-set! (vector-ref mv 2) (frt index (vector-ref mv 1)) x))
(define (o . fs)
  (define (o1 lis y)
  (if (= (length lis) 0) y
      (o1 (reverse (cdr (reverse lis))) ((car (reverse lis)) y))))
  (lambda (x) (o1 fs x)))
(define (list-trim-right lst)
  (rty lst '() '()))
(define (rty li spa nli)(if (null? li)
                            nli
                            (if (char-whitespace? (car li))
                                (rty (cdr li) (append spa (list (car li))) nli)
                                (rty (cdr li) '() (append nli spa (list (car li)))))));;O(n^2)