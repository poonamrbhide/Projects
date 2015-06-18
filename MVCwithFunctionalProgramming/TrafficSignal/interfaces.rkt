;;; interfaces.rkt :

#lang racket
 
(require 2htdp/image)


(provide StatefulWorldObj<%> Street<%> TrafficLight<%> Vehicle<%>)

;; Constants

(provide MAX-PROXIMITY-VEHICLES CAR-WIDTH CAR-HEIGHT HALF-CAR-WIDTH TRUCK-WIDTH
TRUCK-HEIGHT HALF-TRUCK-WIDTH
TRAILER-WIDTH
TRAILER-HEIGHT
HALF-TRAILER-WIDTH
MAX-VEL-FIRST-HALF
MAX-VEL-SECOND-HALF
 MAX-PROXIMITY-VEHICLES
 CAR-ACCLR
 TRUCK-ACCLR
 TRAILER-ACCLR 
 MAX-CAR-VEL
 MAX-TRUCK-VEL
MAX-TRAILER-VEL
 CAR-COLOR
 TRUCK-COLOR
 TRAILER-COLOR
CANVAS-WIDTH
 CANVAS-HEIGHT
 HALF-CANVAS-WIDTH
 HALF-CANVAS-HEIGHT
 EMPTY-CANVAS
 STREET-START
 STREET-END
 STREET-MID
STREET-COLOR
HASH-TOP
HASH-BOTTOM
STREET-IMG
TRAFFIC-SIGNAL-SIDE
HALF-TRAFFIC-SIGNAL-SIDE
MAX-PROXIMITY-TRAFFIC-SIGNAL
TICKS-TO-CHANGE-COLOR-OF-TRAFFIC-LIGHTS
LIST-TRAFFIC-LIGHT-COLORS
CAR-WHEELS
CAR-TOP
CAR-BODY
TRUCK-WHEELS
TRUCK-TOP
TRUCK-BODY
TRAILER-WHEELS
TRAILER-TOP
TRAILER-BODY)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DATA DEFINITIONS

;; Nat is a non-negative number


;; A TrafficLightColor is one of
;; -- "red"    INTP : Represents red color of  Traffic Light which 
;;                halts the vehicle.
;; -- "green"  INTP : Represents green color of  Traffic Light which 
;;                lets the vehicles pass through it.
;;; 
;; TEMPLATE:
;; tl-fn : TrafficLightColor -> ??
;; (define (tl-fn tl)
;;    (cond
;;      [(equal=? tl "green")..]
;;      [(equal=? tl "red")..]
;;      [else ...]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; TLList is Listof<TrafficLightColor> is Non-Empty list of TrafficLightColor
;; -- which contains exactly two distinct TrafficLightColor

;;Template 
;; tllist-fn: TLList -> ??
;; (define (tllist-fn t)
;;   (cond
;;    [(first t)...]
;;    [(second t)... ]))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; A RectKeyEvent is a KeyEvent, which is one of

;; "n" : Adds a new rectangle to the canvas, at the centre of target. 
;;  any other key : ignored

;; TEMPLATE:
;; rect-kev-fn : RectKeyEvent -> ??
;; (define (rect-kev-fn kev)
;;    (cond
;;      [(key=? kev "n")..]
;;      [else ...]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; A TrafficLightMouseEvent is a MouseEvent that is one of:

;; -- "button-down"(interp: The traffic light is selected for dragging and 
;;                  displayed in solid instead of outline.)
;; -- "drag"       (interp: While the traffic light is being dragged,everything 
;;                  else stops functioning, and resumes functioning as it left 
;;                  off when it is dropped.)
;; -- "button-up"  (interp: When button is released the TrafficSignal is 
;;                unselected and its state is resumed to the state before drag)
;; --  any other mouse event : (interp: Any other mouse event is ignored)

;; TEMPLATE:
;; tl-mev-fn : TrafficLightMouseEvent -> ??
;; (define (tl-mev-fn mev)
;;    (cond
;;      [(mouse=? mev "button-down") ...]
;;      [(mouse=? mev "drag")...]
;;      [(mouse=? mev "button-up") ...]
;;      [else ...]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; A StreetKeyEvent is a KeyEvent, which is one of

;; "c" : Adds a new car with it's front bumpers at position 0 of the street.
;; "t" : Adds a new truck with it's front bumpers at position 0 of the street.
;; "u" : Adds a new tractor-trailer with it's front bumpers at position 0 
;;       of the street.
;; "l" : Creates a traffic light at the center of roadway,if that is filled add
;;       it to right with 60 minimum distance between both the traffic lights.
;; "x" : Deletes a traffic light if it is selected.

;; TEMPLATE:
;; street-kev-fn : StreetKeyEvent -> ??
;; (define (street-kev-fn kev)
;;    (cond
;;      [(key=? kev "c")..]
;;      [(key=? kev "t")..]
;;      [(key=? kev "u")..]
;;      [(key=? kev "l")..]
;;      [(key=? kev "x")..]
;;      [else ...]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;  ListOf<Vehicle<%>>  is either
;  -- Empty (intp: There are no vehicles in the list)
;; -- (cons Vehicle<%>  Listof<Vehicle<%>>)(intp: There is atleast one 
;;                                                    Vehicle in the list)

;;Template 
;; lov-fn: ListOf<Vehicle<%>> -> ??
;; (define (lov-fn lov)
;;   (cond
;;    [(empty? lov)...]
;;    [else (...
;;              (first lov)
;;              (lov-fn (rest lov)))]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;  ListOf<TrafficSignal<%>>  is either
;  -- Empty (intp: There are no traffic signals in the list)
;; --(cons TrafficSignal<%> Listof<TrafficSignal<%>>)(intp: There is atleast one 
;;                                                   Traffic signal in the list)

;;Template 
;; lot-fn: ListOf<TrafficSignal<%>> -> ??
;; (define (lot-fn lov)
;;   (cond
;;    [(empty? lot)...]
;;    [else (...
;;              (first lot)
;;              (lot-fn (rest lot)))]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(define StatefulWorldObj<%>
  (interface ()
    ; ->  Void
    on-tick
    ; Nat Nat MouseEvent -> Void
    on-mouse 
    ; KeyEvent -> Void
    on-key
    ; Scene -> Scene
    add-to-scene))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(define Street<%>
  (interface
     (StatefulWorldObj<%>)    ; Street<%> includes StatefulWorldObj<%>

     ; -> ListOf< Vehicle<%> >   
     ;; RETURNS: the list of vehicles on the street. 
    get-vehicles       


     ; -> ListOf< TrafficLight<%> >
     ;; RETURNS: the list of traffic lights on the street.
     get-traffic-lights  

     ;; Nat -> TrafficLight<%>
     ;; GIVEN: a position on the street
     ;; EFFECT: creates a new traffic light and puts it on the street
     ;; in the first legal position to the right of the given one.
     ;; RETURNS: the new traffic light
     add-traffic-light 

     ;; Nat -> Void
     ;; GIVEN: a serial number
     ;; EFFECT: removes the traffic light with that serial number from
     ;; the street.  If there is no such traffic light, has no effect.
     delete-traffic-light 

     ;; Vehicle<%> -> Void
     ;; GIVEN: A vehicle
     ;; WHERE: the vehicle is to the left of all the vehicles on the
     ;; street
     ;; EFFECT: places the vehicle on the street at its position.
     ;; If the vehicle cannot be placed at that position, it is placed
     ;; in the first legal position to the left of the desired one.
     add-vehicle))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define TrafficLight<%>
  (interface
     (StatefulWorldObj<%>)    ; TrafficLight<%> includes StatefulWorldObj<%>
     
     ; -> Nat 
     ;; RETURNS: a serial number that uniquely identifies this traffic light
     get-serial-number 
    
     ; -> Nat
     ;; RETURNS: the position of the center of traffic light on the street
     get-x
    
     ; -> TrafficLightColor
     ;; RETURNS: the current color of the traffic light
     get-color     

    ; -> Boolean
     ;; RETURNS: true iff the traffic light is currently selected for
     ;; dragging. 
     selected-for-dragging? ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(define Vehicle<%>
  (interface ()
    
    ; -> Void  
    ;; EFFECT: updates this vehicle to its state after a tick.
     on-tick 

    ; Scene -> Scene
    ;; RETURNS: A scene like the given one, but with this vehicle
    ;; painted on it.
     add-to-scene
    
    ; -> Integer
    ;; RETURNS: the x-position of the front bumper of the vehicle
    get-front   

    ; -> Integer
    ;; RETURNS: the x-position of the rear bumper of the vehicle
    get-rear     
 
    ; -> Nat
    ;; RETURNS: the current horizontal velocity of the vehicle, in
    ;; pixels/tick 
    get-vel      
  ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Constants

(define CAR-WIDTH 15)
(define CAR-HEIGHT 10)
(define HALF-CAR-WIDTH (/ CAR-WIDTH 2))
(define TRUCK-WIDTH 20)
(define TRUCK-HEIGHT 10)
(define HALF-TRUCK-WIDTH (/ TRUCK-WIDTH 2))
(define TRAILER-WIDTH 30)
(define TRAILER-HEIGHT 10)
(define HALF-TRAILER-WIDTH (/ TRAILER-WIDTH 2))

(define MAX-VEL-FIRST-HALF 20)
(define MAX-VEL-SECOND-HALF 10)

(define MAX-PROXIMITY-VEHICLES 5)

(define CAR-ACCLR 20)
(define TRUCK-ACCLR 2)
(define TRAILER-ACCLR 2)

(define MAX-CAR-VEL 20)
(define MAX-TRUCK-VEL 15)
(define MAX-TRAILER-VEL 15)


(define CAR-COLOR "blue")
(define TRUCK-COLOR "red")
(define TRAILER-COLOR "brown")
(define CANVAS-WIDTH 1000)
(define CANVAS-HEIGHT 200)
(define HALF-CANVAS-WIDTH (/ CANVAS-WIDTH 2))
(define HALF-CANVAS-HEIGHT (/ CANVAS-HEIGHT 2))
(define EMPTY-CANVAS (empty-scene CANVAS-WIDTH CANVAS-HEIGHT))

(define STREET-START 0)
(define STREET-END CANVAS-WIDTH)
(define STREET-MID HALF-CANVAS-WIDTH)

(define STREET-COLOR "black")
(define HASH-TOP (- HALF-CANVAS-HEIGHT 7))
(define HASH-BOTTOM (+ HALF-CANVAS-HEIGHT 7))

(define STREET-IMG
  (add-line (add-line
             EMPTY-CANVAS STREET-START HALF-CANVAS-HEIGHT 
             STREET-END HALF-CANVAS-HEIGHT STREET-COLOR)
            STREET-MID HASH-TOP STREET-MID HASH-BOTTOM STREET-COLOR))

(define CAR-IMG
(rectangle CAR-WIDTH CAR-HEIGHT "outline" CAR-COLOR))
(define TRUCK-IMG
(rectangle TRUCK-WIDTH TRUCK-HEIGHT "outline" TRUCK-COLOR))
(define TRAILER-IMG
(rectangle TRAILER-WIDTH TRAILER-HEIGHT "outline" TRAILER-COLOR))

(define TRAFFIC-SIGNAL-SIDE 20)
(define HALF-TRAFFIC-SIGNAL-SIDE (/ TRAFFIC-SIGNAL-SIDE 2))

(define MAX-PROXIMITY-TRAFFIC-SIGNAL 60)

(define TICKS-TO-CHANGE-COLOR-OF-TRAFFIC-LIGHTS 8)

(define LIST-TRAFFIC-LIGHT-COLORS (list "green" "red"))

(define CAR-WHEELS (beside 
     (circle 3 "solid" "black")
     (rectangle 2 2 "solid" "white")
     (circle 3 "solid" "black")))

(define CAR-TOP (rectangle HALF-CAR-WIDTH (/ CAR-HEIGHT 2) 
                           "outline" CAR-COLOR))

(define CAR-BODY (rectangle CAR-WIDTH CAR-HEIGHT "outline" CAR-COLOR))

(define TRUCK-WHEELS (beside 
     (circle 4 "solid" "black")
     (rectangle 3 3 "solid" "white")
     (circle 4 "solid" "black")))

(define TRUCK-TOP (beside
     (rectangle HALF-TRUCK-WIDTH (/ TRUCK-HEIGHT 2) 
                "solid" "white")
     (rectangle HALF-TRUCK-WIDTH (/ TRUCK-HEIGHT 2) 
                "outline" TRUCK-COLOR)))

(define TRUCK-BODY (rectangle TRUCK-WIDTH TRUCK-HEIGHT 
                              "outline" TRUCK-COLOR))

(define TRAILER-WHEELS (beside 
     (circle 5 "solid" "black")
     (rectangle 3 3 "solid" "white")
     (circle 5 "solid" "black")))

(define TRAILER-TOP (beside
     (triangle HALF-TRAILER-WIDTH "outline" TRAILER-COLOR)
     (rectangle HALF-TRAILER-WIDTH (/ TRAILER-WIDTH 2) "outline" 
                TRAILER-COLOR)))

(define TRAILER-BODY (rectangle TRAILER-WIDTH TRAILER-HEIGHT "outline"
                                TRAILER-COLOR))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
