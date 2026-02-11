;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname a04q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;;
;; **********************************************
;;    Yuhan Sun  (21114768)
;;    CS 115       Winter 2026
;;    Assignment 04, Question 2
;; **********************************************
;;


;; A Driver-Result is a (listof (anyof Int 'DNF))
;; Where:
;; * A positive integer gives the driver's placement in a race
;; * A negative integer indicates the driver had the fastest lap in a race
;;   and the absolute value gives their placement in that race
;; * The symbol 'DNF indicates the driver did not finish a race


;; (place-pts p) produces the placement points for finishing p-th.
;; place-pts: Nat -> Nat
;; Requires: p > 0

;; Examples:
(check-expect (place-pts 1) 12)
(check-expect (place-pts 6) 1)

(define (place-pts p)
  (cond
    [(= p 1) 12]
    [(= p 2) 9]
    [(= p 3) 5]
    [(= p 4) 2]
    [(and (>= p 5) (<= p 10)) 1]
    [else 0]))


;; (race-pts r) produces the points earned for a single race result r.
;; race-pts: (anyof Int 'DNF) -> Nat
;; Requires: r is an integer or the symbol 'DNF

;; Examples:
(check-expect (race-pts 'DNF) 0)
(check-expect (race-pts -4) 4)

(define (race-pts r)
  (cond
    [(and (symbol? r) (symbol=? r 'DNF)) 0]
    [(< r 0)
     (+ (place-pts (abs r))
        (cond
          [(<= (abs r) 10) 2]
          [else 1]))]
    [else
     (place-pts r)]))


;; (all-finished? driver-info) produces true if driver-info has no 'DNF.
;; all-finished?: Driver-Result -> Bool
;; Requires: driver-info is non-empty

;; Examples:
(check-expect (all-finished? (cons 1 empty)) true)
(check-expect (all-finished? (cons 'DNF empty)) false)

(define (all-finished? driver-info)
  (cond
    [(empty? driver-info) true]
    [(and (symbol? (first driver-info))
          (symbol=? (first driver-info) 'DNF))
     false]
    [else
     (all-finished? (rest driver-info))]))


;; (sum-pts driver-info) produces the total points from the races only.
;; sum-pts: Driver-Result -> Nat
;; Requires: driver-info is non-empty

;; Examples:
(check-expect (sum-pts (cons -4 empty)) 4)
(check-expect (sum-pts (cons 'DNF (cons 1 empty))) 12)

(define (sum-pts driver-info)
  (cond
    [(empty? driver-info) 0]
    [else
     (+ (race-pts (first driver-info))
        (sum-pts (rest driver-info)))]))


;; (driver-points driver-info) produces the total season points earned.
;; driver-points: Driver-Result -> Nat
;; Requires: driver-info is non-empty

;; Examples:
(check-expect (driver-points (cons -4 empty)) 9)
(check-expect
 (driver-points
  (cons 3 (cons 2 (cons -1 (cons 4 (cons 8 empty))))))
 36)
(check-expect
 (driver-points
  (cons 1
   (cons -1
    (cons 4
     (cons -7
      (cons 'DNF
       (cons -11 (cons 14 empty))))))))
 32)

(define (driver-points driver-info)
  (cond
    [(all-finished? driver-info)
     (+ (sum-pts driver-info) 5)]
    [else
     (sum-pts driver-info)]))


;; Tests:
(check-expect (driver-points (cons 'DNF empty)) 0)
(check-expect (driver-points (cons 3 (cons 2 (cons 8 empty)))) 20)
(check-expect (driver-points (cons 11 empty)) 5)
(check-expect (driver-points (cons -4 empty)) 9)
(check-expect (driver-points (cons -11 empty)) 6)
(check-expect (driver-points (cons 2 (cons 'DNF empty))) 9)