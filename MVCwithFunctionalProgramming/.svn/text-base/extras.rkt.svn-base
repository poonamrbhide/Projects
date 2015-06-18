#lang racket

(provide provide rename-out struct-out check-error)

(require rackunit)
(require rackunit/text-ui)

(define-syntax (check-error stx)
  (syntax-case stx ()
    [(_ code . msg) #`(check-exn exn:fail? (lambda () code) . msg)]))
