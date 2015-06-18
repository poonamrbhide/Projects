
;;; Truck.rkt

#lang racket

(require "interfaces.rkt")
(require "Vehicles.rkt")

(require rackunit)
(require rackunit/text-ui)

(require 2htdp/image)

(provide Truck%)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; A Truck is a (new Truck% [pos Number] 
;;                          [img Scene])
;;                                             
;; Interpretation: represents a Truck,
;; Truck is an Object of Class Truck% that inherits Vehicle% which implements 
;  StatefulWorldObj<%>
;; Truck is like Vehicle but with its some the fields having different value.

;; containing pos :X co-ordinate of Center of Truck (inherited from Vehicle%)
;;           img : Image of Truck which are inherited from Vehicle%; 
;; Other fields used in the Constructor of Superclass are inherited from 
;; Vehicle%
;;

(define Truck%
  (class* Vehicle% (Vehicle<%>)
    
      ;; here are fields of the superclass that we need.
    (inherit-field pos img)  ;; inherited from Vehicle%
    ;; pos : X co-ordinate of Center of Car
    ;; img : Image of the Car
    
    (super-new
     ;; width: width of Truck
     [width TRUCK-WIDTH]
     ;; height : height of Truck
     [height TRUCK-HEIGHT]
      ;; Color : color of Truck
     [color TRUCK-COLOR]
     ;; img : Image of Truck
     [img (above (above TRUCK-TOP TRUCK-BODY) TRUCK-WHEELS)]
       ;; max-vel : maximum Velocity of Truck
     [max-vel MAX-TRUCK-VEL]
       ;; acc : acceleration of Truck
     [acc TRUCK-ACCLR]
     ;; vel : Velocity of Truck
     [vel 0])

    ;; add-to-scene : Scene -> Scene
    ;; GIVEN a scene of Street
    ;; RETURNS : scene depicting the updated world with Truck.
    ;; Example : See Tests
    ;; Strategy : Domain Knowledge 
    
    (define/override (add-to-scene scn)
      (place-image img pos HALF-CANVAS-HEIGHT scn))
    
    ))