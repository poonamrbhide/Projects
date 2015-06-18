
;;; TractorTrailer.rkt

#lang racket

(require "interfaces.rkt")
(require "Vehicles.rkt")

(require rackunit)
(require rackunit/text-ui)

(require 2htdp/image)

(provide TractorTrailer%)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; A TractorTrailer is a (new TractorTrailer% [pos Number] 
;;                          [img Scene])
;;                                             
;; Interpretation: represents a TractorTrailer,
;; TractorTrailer is an Object of Class TractorTrailer% that inherits Vehicle% 
;; which implements  StatefulWorldObj<%>

;; TractorTrailer is like Vehicle but with its some the fields having different 
;  value.

;; containing pos : X co-ordinate of Center of TractorTrailer
;;                 (inherited from Vehicle%)
;;           img : Image of TractorTrailer which are inherited from Vehicle%; 
;; Other fields used in the Constructor of Superclass are inherited from 
;; Vehicle%
;;


(define TractorTrailer%
  (class* Vehicle% (Vehicle<%>)
    
      ;; here are fields of the superclass that we need.
    (inherit-field pos img);; inherited from Vehicle%
    ;; pos : X co-ordinate of Center of TractorTrailer
    ;; img : Image of the TractorTrailer
    
    (super-new
      ;; width: width of TractorTrailer
     [width TRAILER-WIDTH]
     ;; height: height of TractorTrailer
     [height TRAILER-HEIGHT]
       ;; color : color of TractorTrailer
     [color TRAILER-COLOR]
     ;; img : Image of TractorTrailer
     [img (above (above TRAILER-TOP TRAILER-BODY) TRAILER-WHEELS)]
      ;; max-vel : maximum Velocity of TractorTrailer
     [max-vel MAX-TRAILER-VEL]
      ;; acc : acceleration of TractorTrailer
     [acc TRAILER-ACCLR]
     ;; vel : Velocity of TractorTrailer
     [vel 0])
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    
    ;; add-to-scene : Scene -> Scene
    ;; GIVEN a scene of Street
    ;; RETURNS : scene depicting the updated world with TractorTrailer.
    ;; Example : See Tests
    ;; Strategy : Domain Knowledge
    
    (define/override (add-to-scene scn)
      (place-image img pos HALF-CANVAS-HEIGHT scn))
    
    ))