;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname a04q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;;
;; **********************************************
;;    Yuhan Sun  (21114768)
;;    CS 115       Winter 2026
;;    Assignment 04, Question 1
;; **********************************************
;;


;; (select-numbers lst) produces a list of all the numbers in lst.
;; select-numbers: (listof Any) -> (listof Num)
;; Requires: lst is a list containing numbers, strings,
;;           symbols and booleans.

;; Examples:
(check-expect
 (select-numbers
  (cons 4(cons 'red(cons "hello" (cons 5(cons 1/2 empty))))))
  (cons 4 (cons 5 (cons 1/2 empty))))
(check-expect
 (select-numbers (cons "a" (cons 'b (cons true empty))))
   empty)

(define (select-numbers lst)
  (cond
    [(empty? lst) empty]
    [(number? (first lst))
     (cons (first lst) (select-numbers (rest lst)))]
    [else
     (select-numbers (rest lst))]))

;; Tests:
(check-expect (select-numbers empty) empty)
(check-expect (select-numbers (cons 0 (cons -3 (cons "x" empty))))
              (cons 0 (cons -3 empty)))
(check-expect (select-numbers (cons false (cons 'hi (cons 7 empty))))
              (cons 7 empty))


;; (product-helper lst prod found?) produces the product of all the
;;   numbers in lst multiplied into prod,
;;   and produces false if found? is false when lst is empty.
;; product-helper: (listof Any) Num Bool -> (anyof Num false)
;; Requires: lst is a list containing numbers,
;;           strings, symbols and booleans.
;;           prod is a number.
;;           found? is a boolean.

;; Examples:
(check-expect
 (product-helper
  (cons 4 (cons 'red (cons "hello" (cons 5 (cons 1/2 empty)))))
                 1 false)
                 10)
(check-expect
 (product-helper
  (cons true (cons "abc" empty))
        1 false)
        false)

(define (product-helper lst prod found?)
  (cond
    [(empty? lst)
     (cond
       [found? prod]
       [else false])]
    [(number? (first lst))
     (product-helper (rest lst) (* prod (first lst)) true)]
    [else
     (product-helper (rest lst) prod found?)]))


;; (multiply-numbers lst) produces the product of all
;;   the numbers in lst.
;;   If there are no numbers in lst, the function produces false.
;; multiply-numbers: (listof Any) -> (anyof Num false)
;; Requires: lst is a list containing numbers, strings,
;;           symbols and booleans.

;; Examples:
(check-expect
 (multiply-numbers
  (cons 4 (cons 'red (cons "hello" (cons 5 (cons 1/2 empty))))))
   10)
(check-expect
 (multiply-numbers
  (cons true
   (cons false (cons "abc" (cons 'red empty)))))
    false)

(define (multiply-numbers lst)
  (product-helper lst 1 false))

;; Tests:
(check-expect (multiply-numbers empty) false)
(check-expect (multiply-numbers
               (cons 2 (cons 3 (cons 4 empty)))) 24)
(check-expect (multiply-numbers
               (cons "a" (cons 'b (cons false empty)))) false)
(check-expect (multiply-numbers
               (cons -2 (cons "x" (cons 5 (cons true empty))))) -10)