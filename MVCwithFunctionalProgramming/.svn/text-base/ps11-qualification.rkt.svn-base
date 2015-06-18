#lang racket

;; Time-stamp: <2013-04-02 17:18:46 wand>

(require rackunit)
(require rackunit/text-ui)
(require 2htdp/image)
(require "top.rkt")

;; this only tests to see if its argument evaluates successfully.
(define (check-provided val)
  (check-true true))

(define s1 (initial-street))
(define c1 (new-car 0))
(define t1 (new-truck 0))
(define tt1 (new-tractor-trailer 0))
(define tl1 (send s1 add-traffic-light 400))

(define-test-suite qualification-tests
  ;; this only tests to see if required functions were provided. This does not completely test correctness.
  ;; the functions:


  ;; the methods
  ;; for Street<%>
  (check-true (list? (send s1 get-vehicles)))
  (check-true (list? (send s1 get-traffic-lights)))
  (check-provided (send s1 delete-traffic-light 1))
  (check-provided (send s1 add-vehicle c1))

  ;; for TrafficLight<%>
  (check-true (number? (send tl1 get-serial-number)))
  (check-true (number? (send tl1 get-x)))
  (check-true (string? (send tl1 get-color)))
  (check-true (boolean? (send tl1 selected-for-dragging?)))

  ;; for Vehicle<%>
  ;; this only checks to see that new-car returns a vehicle.
  ;; new-truck and new-tractor-trailer aren't checked
  (check-provided (send c1 on-tick))
  (check-true (image? (send c1 add-to-scene empty-image)))
  (check-true (number? (send c1 get-front)))
  (check-true (number? (send c1 get-rear)))
  (check-true (number? (send c1 get-vel)))

  )

"qualification tests" (run-tests qualification-tests)