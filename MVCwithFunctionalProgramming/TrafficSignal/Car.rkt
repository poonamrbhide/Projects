
;;; Car.rkt

#lang racket

(require "interfaces.rkt")
(require "Vehicles.rkt")

(require rackunit)
(require rackunit/text-ui)

(require 2htdp/image)

(provide Car%)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; A Car is a (new Car% [pos Number] 
;;                          [img Scene])
;;                                             
;; Interpretation: represents a Car,
;; Car is an Object of Class Car% that inherits Vehicle% which implements 
;  StatefulWorldObj<%>
;; Car is like Vehicle but with its some the fields having different value.

;; containing pos :X co-ordinate of Center of Car (inherited from Vehicle%)
;;           img : Image of Car% which are inherited from Vehicle%; 
;; Other fields used in the Constructor of Superclass are inherited from 
;; Vehicle%
;;

(define Car%
  (class* Vehicle% (Vehicle<%>)
    
      ;; here are fields of the superclass that Vehicle%.
    (inherit-field pos img) ;; inherited from Vehicle%
    ;; pos : X co-ordinate of Center of Car
    ;; img : Image of the Car
    
    (super-new
     ;; width: width of Car
     [width CAR-WIDTH]
     ;; height: height of Car
     [height CAR-HEIGHT]
     ;; color : color of Car
     [color CAR-COLOR]
     ;; img : Image of Car
     [img (above (above CAR-TOP CAR-BODY) CAR-WHEELS)]
     ;; max-vel : maximum Velocity of Car
     [max-vel MAX-CAR-VEL]
     ;; acc : acceleration of Car
     [acc CAR-ACCLR]
     ;; vel : Velocity of Car
     [vel 0])

    ;; add-to-scene : Scene -> Scene
    ;; GIVEN a scene of Street
    ;; RETURNS : scene depicting the updated world with Car.
    ;; Example : See Tests
    ;; Strategy : Domain Knowledge
    (define/override (add-to-scene scn)
      (place-image img pos HALF-CANVAS-HEIGHT scn))
    
    ))