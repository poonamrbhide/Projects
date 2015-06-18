
#lang racket

(require "interfaces.rkt")
(require "Street.rkt")
(require "TrafficLight.rkt")
(require "Car.rkt")
(require "Truck.rkt")
(require "TractorTrailer.rkt")

(require rackunit)
(require rackunit/text-ui)

(require 2htdp/image)
(require 2htdp/universe)

(provide initial-street run new-car new-truck new-tractor-trailer)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; new-car: Integer -> Vehicle<%>
;; RETURN: a new car with its front bumper at
;; the given position.
;; Example : (new-car 30) => (new Car% [pos 22.5])
;; Strategy : Domain Knowledge

(define (new-car n)
  (new Car% [pos (- n HALF-CAR-WIDTH)]))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; new-truck: Integer -> Vehicle<%>
;; RETURN:a new truck, with its front bumper at
;; the given position.
;; Example : (new-truck 30) => (new Truck% [pos 20])
;; Strategy : Domain Knowledge

(define (new-truck n)
  (new Truck% [pos (- n HALF-TRUCK-WIDTH)]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; new-tractor-trailer : Integer -> Vehicle<%>
;; RETURN: a new car, truck, or tractor-trailer with its front bumper at
;; the given position.
;; Example : (new-tractor-trailer 50) => (new TractorTrailor% [pos 35])
;; Strategy : Domain Knowledge
(define (new-tractor-trailer n)
  (new TractorTrailer% [pos (- n HALF-TRAILER-WIDTH)]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; initial-street : -> Street<%>
;; RETURNS: an empty street, with no vehicles and no traffic lights
;; Example : (initial-street) => (new Street% [vehicles empty]  
;;                                        [traffic-lights empty])
;; Strategy : Domain Knowledge
(define (initial-street)
  (new Street% 
       [vehicles empty]
       [traffic-lights empty]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; run : Number -> Street<%>
;; Given a frame rate (in secs/tick), runs the traffic simulation,
;; starting with an empty street.The given farme rate is a non zero 
;; value.
;; Example: (run 0.5) would start the execution with frame rate of 0.5
;; Strategy :Function Composition
(define (run n)
  (big-bang 
   
   (initial-street)
   (on-tick
    (lambda (w) (send w on-tick) w)
    n)
   (on-mouse
    (lambda (w x y evt) (send w on-mouse x y evt) w))
   (on-draw
    (lambda (w) (send w add-to-scene STREET-IMG)))
   (on-key
    (lambda (w kev) (send w on-key kev) w))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Qualification Tests

;; this only tests to see if its argument evaluates successfully.
(define (check-provided val)
  (check-true true))

(define s1 (initial-street))
(define c1 (new-car 0))
(define t1 (new-truck 0))
(define tt1 (new-tractor-trailer 0))
(define tl1 (send s1 add-traffic-light 400))

(define-test-suite qualification-tests
  ;; this only tests to see if required functions were provided. This does not
  ;; completely test correctness.
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; All Tests


;; Functions for Testing Purpose

(define (convert-traffic-lights-to-flat-list lst-tl)
  (append
   (map (
         ;;
         ;;
         lambda (obj) (send obj get-x)) lst-tl)
   (map (
         ;;
         ;;
         lambda (obj) (send obj get-color)) lst-tl)
   
   (map (
         ;;
         ;;
         lambda (obj) (send obj selected-for-dragging?)) lst-tl)
   
   (map (
         ;;
         ;;
         lambda (obj) (send obj get-mx)) lst-tl)
   
   (map (
         ;;
         ;;
         lambda (obj) (send obj get-my)) lst-tl)
   
   (map (
         ;;
         ;;
         lambda (obj) (send obj get-time-left-for-color-chng)) lst-tl)
   
   ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (convert-vehicles-to-flat-list lst-veh)
  (append
   (map (
         ;;
         ;;
         lambda (obj) (send obj get-pos)) lst-veh)
   (map (
         ;;
         ;;
         lambda (obj) (send obj get-vel)) lst-veh)
   
   (map (
         ;;
         ;;
         lambda (obj) (send obj get-max-vel)) lst-veh)
   
   (map (
         ;;
         ;;
         lambda (obj) (send obj get-acc)) lst-veh)
   
   (map (
         ;;
         ;;
         lambda (obj) (send obj get-width)) lst-veh)
   
   (map (
         ;;
         ;;
         lambda (obj) (send obj get-height)) lst-veh)
   
   (map (
         ;;
         ;;
         lambda (obj) (send obj get-color)) lst-veh)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (check-if-streets-similar? str1 str2)
  (if (and (empty? (send str1 get-all-traffic-lights))
           (empty? (send str2 get-all-traffic-lights))
           (equal? (convert-vehicles-to-flat-list (send str1 get-all-vehicles))
           (convert-vehicles-to-flat-list (send str2 get-all-vehicles))))
      true
      (if (and (empty? (send str1 get-all-vehicles))
           (empty? (send str2 get-all-vehicles))
           (equal? (convert-traffic-lights-to-flat-list
            (send str1 get-all-traffic-lights))
           (convert-traffic-lights-to-flat-list
            (send str2 get-all-traffic-lights))))
          true
          (and 
           (equal? (convert-traffic-lights-to-flat-list
            (send str1 get-all-traffic-lights))
           (convert-traffic-lights-to-flat-list
            (send str2 get-all-traffic-lights)))
           (equal? (convert-vehicles-to-flat-list (send str1 get-all-vehicles))
           (convert-vehicles-to-flat-list (send str2 get-all-vehicles)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Constants for Testing the Street in different States

(define car-1 (new-car 0))
(define truck-1 (new-truck 0))
(define trailer-1 (new-tractor-trailer 60))
(define car-2 (new-car 120))

(define traffic-l1 (new TrafficLight%
                        [serial-number 1]
                        [x 70]
                        [mx 0]
                [my 0]
                [colors LIST-TRAFFIC-LIGHT-COLORS]
                [sel? false]
                [time-left-for-color-chng TICKS-TO-CHANGE-COLOR-OF-TRAFFIC-LIGHTS]))

(define car-1-afr-tick (new-car -23))
(define truck-1-afr-tick (new-truck 2))
(define trailer-1-afr-tick (new-tractor-trailer 60))
(define car-2-afr-tick (new-car 140))


(define traffic-l1-afr-tick (new TrafficLight%
                        [serial-number 1]
                        [x 70]
                        [mx 0]
                [my 0]
                [colors (list "red" "green")]
                [sel? false]
                [time-left-for-color-chng 7]))



(define street-1-before-tick
         (new Street%
              [vehicles (list (begin
                                (send car-2 subscribe-vehicle-at-rear trailer-1)
                                car-2)
                              (begin 
                                (send trailer-1 capture-front-veh-rear-pos 105)
                                (send trailer-1 capture-front-veh-vel 0)
                                (send trailer-1 subscribe-vehicle-at-rear truck-1)
                                trailer-1)
                              (begin
                                (send truck-1 set-ini-pos)
                                (send truck-1 capture-front-veh-rear-pos 30)
                                (send truck-1 capture-front-veh-vel 0)
                                (send truck-1 set-ini-pos)
                                (send truck-1 subscribe-vehicle-at-rear car-1)
                                truck-1)
                              (begin
                                (send car-1 capture-front-veh-rear-pos -20)
                                (send car-1 capture-front-veh-vel 0)
                                (send car-1 set-ini-pos)
                                car-1))]
              [traffic-lights (list
                               (begin
                                 (send traffic-l1 add-vehicles-for-subs car-2)
                                 (send traffic-l1 add-vehicles-for-subs trailer-1)
                                 (send traffic-l1 add-vehicles-for-subs truck-1)
                                 (send traffic-l1 add-vehicles-for-subs car-1)
                                 (send traffic-l1 change-colors)
                                 (send car-2 add-pos-of-red-traffic-light 70)
                                 (send trailer-1 add-pos-of-red-traffic-light 70)
                                 (send truck-1 add-pos-of-red-traffic-light 70)
                                 (send car-1 add-pos-of-red-traffic-light 70)
                                 traffic-l1))]))
                                 

(define street-1-after-tick
         (new Street%
              [vehicles (list (begin
                                (send car-2-afr-tick set-vel 20)
                                car-2-afr-tick)
                              (begin 
                                (send trailer-1-afr-tick capture-front-veh-rear-pos 125)
                                (send trailer-1-afr-tick capture-front-veh-vel 20)
                                trailer-1-afr-tick)
                              (begin
                                (send truck-1-afr-tick capture-front-veh-rear-pos 30)
                                (send truck-1-afr-tick capture-front-veh-vel 0)
                                (send truck-1-afr-tick set-vel 2)
                                truck-1-afr-tick)
                              (begin
                                (send car-1-afr-tick capture-front-veh-rear-pos -18)
                                (send car-1-afr-tick capture-front-veh-vel 2)
                                (send car-1-afr-tick set-vel 2)
                                car-1-afr-tick))]
              [traffic-lights (list traffic-l1-afr-tick)]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define car-3 (new-car 0))

(define new-car-3 (new-car -20))


(define traffic-l2 (new TrafficLight%
                        [serial-number 1]
                        [x 70]
                        [mx 0]
                [my 0]
                [colors (list "red" "green")]
                [sel? false]
                [time-left-for-color-chng TICKS-TO-CHANGE-COLOR-OF-TRAFFIC-LIGHTS]))

(define traffic-l2-added-new-veh (new TrafficLight%
                        [serial-number 1]
                        [x 70]
                        [mx 0]
                [my 0]
                [colors (list "red" "green")]
                [sel? false]
                [time-left-for-color-chng TICKS-TO-CHANGE-COLOR-OF-TRAFFIC-LIGHTS]))


(define street-2-before-add-car
         (new Street%
              [vehicles (list car-3)]
              [traffic-lights (list traffic-l2)]))
                                 

(define street-2-after-add-car
         (new Street%
              [vehicles (list car-3
                              (begin
                                (send new-car-3 remove-pos-of-red-traffic-light 70)
                                (send new-car-3 add-pos-of-red-traffic-light 70)
                                (send new-car-3 capture-front-veh-rear-pos -10)
                                (send new-car-3 capture-front-veh-vel 0)
                                new-car-3))]
              [traffic-lights (list traffic-l2-added-new-veh)]))


(define truck-3 (new-truck 0))

(define trailer-3 (new-tractor-trailer 0))

(define street-before-add-truck (initial-street))

(define street-before-add-trailer (initial-street))

(define street-after-add-truck
         (new Street%
              [vehicles (list truck-3)]
              [traffic-lights empty]))

(define street-after-add-trailer
         (new Street%
              [vehicles (list trailer-3)]
              [traffic-lights empty]))

(define street-before-add-trafic-l (new Street%
              [vehicles (list truck-3)]
              [traffic-lights empty]))

(define new-traffic-l (new TrafficLight%
                        [serial-number 1]
                        [x 500]
                        [mx 0]
                [my 0]
                [colors LIST-TRAFFIC-LIGHT-COLORS]
                [sel? false]
                [time-left-for-color-chng TICKS-TO-CHANGE-COLOR-OF-TRAFFIC-LIGHTS]))

(define new-traffic-l-2 (new TrafficLight%
                        [serial-number 1]
                        [x 560]
                        [mx 0]
                [my 0]
                [colors LIST-TRAFFIC-LIGHT-COLORS]
                [sel? false]
                [time-left-for-color-chng TICKS-TO-CHANGE-COLOR-OF-TRAFFIC-LIGHTS]))

(define street-after-add-trafic-l
         (new Street%
              [vehicles (list truck-3)]
              [traffic-lights (list new-traffic-l)]))

(define street-after-add-trafic-l-2
         (new Street%
              [vehicles (list truck-3)]
              [traffic-lights (list new-traffic-l-2 new-traffic-l)]))


(define sel-traffic-l (new TrafficLight%
                        [serial-number 1]
                        [x 500]
                        [mx 0]
                [my 0]
                [colors LIST-TRAFFIC-LIGHT-COLORS]
                [sel? true]
                [time-left-for-color-chng TICKS-TO-CHANGE-COLOR-OF-TRAFFIC-LIGHTS]))

(define unsel-traffic-l (new TrafficLight%
                        [serial-number 2]
                        [x 560]
                        [mx 0]
                [my 0]
                [colors LIST-TRAFFIC-LIGHT-COLORS]
                [sel? false]
                [time-left-for-color-chng TICKS-TO-CHANGE-COLOR-OF-TRAFFIC-LIGHTS]))

(define street-before-del-trafic-l
         (new Street%
              [vehicles empty]
              [traffic-lights (list sel-traffic-l unsel-traffic-l)]))

(define street-after-del-trafic-l
         (new Street%
              [vehicles empty]
              [traffic-lights (list unsel-traffic-l)]))


(define unsel-traffic-l-at-center (new TrafficLight%
                        [serial-number 1]
                        [x 500]
                        [mx 500]
                [my HALF-CANVAS-HEIGHT]
                [colors LIST-TRAFFIC-LIGHT-COLORS]
                [sel? false]
                [time-left-for-color-chng TICKS-TO-CHANGE-COLOR-OF-TRAFFIC-LIGHTS]))

(define sel-traffic-l-at-center (new TrafficLight%
                        [serial-number 1]
                        [x 500]
                        [mx 500]
                [my HALF-CANVAS-HEIGHT]
                [colors LIST-TRAFFIC-LIGHT-COLORS]
                [sel? true]
                [time-left-for-color-chng TICKS-TO-CHANGE-COLOR-OF-TRAFFIC-LIGHTS]))

(define street-before-button-down
         (new Street%
              [vehicles (list truck-3)]
              [traffic-lights (list unsel-traffic-l-at-center)]))

(define street-after-button-down
         (new Street%
              [vehicles (list truck-3)]
              [traffic-lights (list sel-traffic-l-at-center)]))

(define unsel-traffic-l-at-center-2 (new TrafficLight%
                        [serial-number 1]
                        [x 500]
                        [mx 500]
                [my HALF-CANVAS-HEIGHT]
                [colors LIST-TRAFFIC-LIGHT-COLORS]
                [sel? false]
                [time-left-for-color-chng TICKS-TO-CHANGE-COLOR-OF-TRAFFIC-LIGHTS]))

(define sel-traffic-l-at-center-2 (new TrafficLight%
                        [serial-number 1]
                        [x 500]
                        [mx 500]
                [my HALF-CANVAS-HEIGHT]
                [colors LIST-TRAFFIC-LIGHT-COLORS]
                [sel? true]
                [time-left-for-color-chng TICKS-TO-CHANGE-COLOR-OF-TRAFFIC-LIGHTS]))

(define street-before-button-up
         (new Street%
              [vehicles (list truck-3)]
              [traffic-lights (list sel-traffic-l-at-center-2)]))

(define street-after-button-up
         (new Street%
              [vehicles (list truck-3)]
              [traffic-lights (list unsel-traffic-l-at-center-2)]))


(define sel-traffic-l-at-center-3-before-drag (new TrafficLight%
                        [serial-number 1]
                        [x 500]
                        [mx 500]
                [my HALF-CANVAS-HEIGHT]
                [colors (list "red" "green")]
                [sel? true]
                [time-left-for-color-chng TICKS-TO-CHANGE-COLOR-OF-TRAFFIC-LIGHTS]))

(define unsel-traffic-l-at-center+60 (new TrafficLight%
                        [serial-number 1]
                        [x 560]
                        [mx 550]
                [my HALF-CANVAS-HEIGHT]
                [colors LIST-TRAFFIC-LIGHT-COLORS]
                [sel? false]
                [time-left-for-color-chng TICKS-TO-CHANGE-COLOR-OF-TRAFFIC-LIGHTS]))

(define unsel-traffic-l-at-center-3-after-drag (new TrafficLight%
                        [serial-number 1]
                        [x 620]
                        [mx 550]
                [my HALF-CANVAS-HEIGHT]
                [colors (list "red" "green")]
                [sel? false]
                [time-left-for-color-chng TICKS-TO-CHANGE-COLOR-OF-TRAFFIC-LIGHTS]))

(define street-before-drag-and-button-up
         (new Street%
              [vehicles (list truck-3)]
              [traffic-lights (list unsel-traffic-l-at-center+60
                                    sel-traffic-l-at-center-3-before-drag)]))

(define street-after-drag-and-button-up
         (new Street%
              [vehicles (list truck-3)]
              [traffic-lights (list unsel-traffic-l-at-center+60
                                    unsel-traffic-l-at-center-3-after-drag)]))

(define street-unsel-traffic-light-60
         (new Street%
              [vehicles (list truck-3)]
              [traffic-lights (list unsel-traffic-l-at-center+60)]))

(define truck-outside (new-truck 1010))

(define street-get-vehicles
         (new Street%
              [vehicles (list truck-3 truck-outside)]
              [traffic-lights (list unsel-traffic-l-at-center+60)]))


;;
;;(equal? (convert-vehicles-to-flat-list (send street-1-before-tick get-all-vehicles)) (convert-vehicles-to-flat-list (send street-1-after-tick get-all-vehicles)))
;;#t
;;> (equal? (convert-traffic-lights-to-flat-list (send street-1-before-tick get-all-traffic-lights)) (convert-traffic-lights-to-flat-list (send street-1-after-tick get-all-traffic-lights)))
;;#f
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-test-suite traffic-on-street-tests
  
  ;; Tests for Ontick
  (check-equal? (check-if-streets-similar? 
                 (begin 
                   (send street-1-before-tick on-tick)
                   street-1-before-tick)
                 street-1-after-tick)
                true
                "to Check the condition of the vehicles after the tick")
  
  ;; Tests for Keyevents
  (check-equal? (check-if-streets-similar? 
                 (begin 
                   (send street-2-before-add-car on-key "c")
                   street-2-before-add-car)
                 street-2-after-add-car)
                true
                "to add a new car to the existing street")
  (check-equal? (check-if-streets-similar?
                 (begin
                   (send street-before-add-truck on-key "t")
                   street-before-add-truck)
                 street-after-add-truck)
                true
                "to add a new truck to the existing street")
  
  (check-equal? (check-if-streets-similar?
                 (begin
                   (send street-before-add-trailer on-key "u")
                   street-before-add-trailer)
                 street-after-add-trailer)
                true
                "to add a new truck to the existing street")
  
  (check-equal? (check-if-streets-similar?
                 (begin
                   (send street-before-add-trafic-l on-key "l")
                   street-before-add-trafic-l)
                 street-after-add-trafic-l)
                true
                "to add a new traffic light to the existing street")
  
  (check-equal? (check-if-streets-similar?
                 (begin
                   (send street-before-add-trafic-l on-key "l")
                   street-before-add-trafic-l)
                 street-after-add-trafic-l-2)
                true
                "to add a another traffic light to the existing street")
  
  (check-equal? (check-if-streets-similar?
                 (begin
                   (send street-before-del-trafic-l on-key "x")
                   street-before-del-trafic-l)
                 street-after-del-trafic-l)
                true
                "to delete a selected traffic light from the existing street")
  
  (check-equal? (check-if-streets-similar?
                 (begin
                   (send street-unsel-traffic-light-60 on-key "x")
                   street-unsel-traffic-light-60)
                 street-unsel-traffic-light-60)
                true
                "to try deleting a selected traffic light from the street
with none selected")
  
  (check-equal? (check-if-streets-similar?
                 (begin
                   (send street-before-del-trafic-l on-key "b")
                   street-before-del-trafic-l)
                 street-before-del-trafic-l)
                true
                "to check the effect of some other key evenet")
  
  
  ;;; Mouse Keyevent Tests
  
  (check-equal? (check-if-streets-similar?
                 (begin
                   (send street-before-button-down on-mouse 500
                         HALF-CANVAS-HEIGHT "button-down")
                   street-before-button-down)
                 street-after-button-down)
                true
                "to check the effect of button-down mouseevent")
  
  (check-equal? (check-if-streets-similar?
                 (begin
                   (send street-before-button-up on-mouse 500
                         HALF-CANVAS-HEIGHT "button-up")
                   street-before-button-up)
                 street-after-button-up)
                true
                "to check the effect of button-up mouseevent")
  
  
  (check-equal? (check-if-streets-similar?
                 (begin
                   (send street-before-drag-and-button-up on-mouse 550
                         HALF-CANVAS-HEIGHT "drag")
                   (send street-before-drag-and-button-up on-mouse 550
                         HALF-CANVAS-HEIGHT "button-up")
                   street-before-drag-and-button-up)
                 street-after-drag-and-button-up)
                true
                "to check the effect of drag mouseevent")
  
  
  (check-equal? (send street-get-vehicles get-vehicles)
                (list truck-3 truck-outside)
                "to check the vehicles in the street")
 
  )

(run-tests traffic-on-street-tests)
  

