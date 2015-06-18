;;; interfaces.rkt :

#lang racket
 
(require 2htdp/image)
(require rackunit)
(require rackunit/text-ui)

(require 2htdp/image)
(require 2htdp/universe)


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
;; Street


(provide Street%)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; A Street is a (new Street% [vehicles Listof<Vehicle<%>>] 
;;                            [traffic-lights Listof<TrafficLight<%>>])
;;                          
;;                                             
;; Interpretation: represents a Street,
;; Street is an Object of Class Street% that implements Street<%>
;

;; containing vehicles which is Listof<Vehicle<%>>
;;           traffic-lights which is  Listof<TrafficLight<%>>

(define Street%
  (class* object% (StatefulWorldObj<%> Street<%>)
    
    (init-field 
     ;; INTP : Represent the Vehicles present in Street
     vehicles 
     ;; INTP : Represent the Traffic-Lights present in Street
     traffic-lights)
    ;; INTP : Counter for traffic lights
    (field [counter-trafficlight 0])
    
    (super-new)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; on-tick : -> Void
    ;; EFFECT:  Updates Vehicles and TrafficLight on tick. 
    ;; Advances vehicles on street with its
    ;; velocity without crossing the maximum limit & without bumping vehicle at
    ;; front
    ;; Changes the color of Traffic Lights after some specific TimeInterval
    ;; Example :(send (new Street% [vehicles (list (Car% [pos 20])]
    ;;           [traffic-lights (list (TrafficLight% [x 60][color "green"])])
    ;; on-tick)=>  Street% [vehicles (list (Car% [pos 40])]
    ;;           [traffic-lights (list (TrafficLight% [x 60][color "green"])
    ;;  [height 15] [color "blue"] [img (above (above CAR-TOP CAR-BODY) 
    ;; CAR-WHEELS)])
    ;; Strategy : HOFC +SD on this
    
    (define/public (on-tick)
     (begin
       (set! traffic-lights (send this get-traffic-lights))
       (for-each
       ;; TrafficLight<%> -> Void
       ;; GIVEN the TrafficLight in traffic-lights
       ;; EFFECT: updates this Traffic-light to its state following the given
       ;; tick;
        (lambda (obj) (send obj on-tick))
        traffic-lights)
       (for-each
       ;; Vehicle<%> -> Void
       ;; GIVEN the  Vehicle in vehicles
       ;; EFFECT: updates this Vehicle to its state following the given
       ;; tick;
        (lambda (obj) (send obj on-tick))
        vehicles)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
  
    ;; on-mouse: Nat Nat TrafficLightMouseEvent -> Void
    ;; EFFECT: updates this Street  with its TrafficLights selected,dragged,
    ;; dropped following the given TrafficLightMouseEvent;
    ;; Example : See the tests.
    ;; Strategy : HOFC +SD on this
    
     (define/public (on-mouse new-mx new-my mev)
      (for-each
       ;; TrafficLight<%> -> Void
       ;; GIVEN the TrafficLight in traffic-lights
       ;; EFFECT: updates this Traffic-light to its state following the given
       ;; mouse event;
       (lambda (obj) (send obj on-mouse-fn new-mx new-my mev traffic-lights))
       traffic-lights))
       
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;; on-key : StreetKeyEvent -> Void
    ;; EFFECT: updates this Street with new Vehicles added or TrafficLights 
    ;; deleted following the 
    ;; Example : See the tests.
    ;; Strategy : SD on StreetKeyEvent kev
    
    (define/public (on-key kev)
    (cond
        [(key=? kev "c") (add-vehicle (create-new-vehicle Car%))]
        [(key=? kev "t") (add-vehicle (create-new-vehicle Truck%))]
        [(key=? kev "u") (add-vehicle (create-new-vehicle TractorTrailer%))]
        [(key=? kev "l") (find-legal-pos-and-add-traffic-light STREET-MID)]
        [(key=? kev "x") (filter-selected-lights)]
        [else this] ))
       
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
  
    ;; on-scene :  Scene -> Scene
    ;; RETURNS : scene depicting the updated Street.
    ;; Example : See the tests.
    ;; Strategy : HOFC +SD on this
    
    
    (define/public  (add-to-scene scn)
      (foldr                    
       ;; TrafficLight<%> Scene -> Void
       ;; GIVEN the TrafficLight ,partial scene 
       ;; RETURNS a scene with this TrafficLight added to scene

       (lambda (obj scene) 
         (send obj add-to-scene scene))
             (foldr            
                ;; Vehicle<%> Scene -> Void
                ;; GIVEN the Vehicle ,partial scene 
                ;; RETURNS a scene with this Vehicle added to scene
                (lambda (trf-obj trf-scn) 
                (send trf-obj add-to-scene trf-scn))
                 scn
                 traffic-lights)
             vehicles)) 
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
     ;; get-vehicles :-> ListOf< Vehicle<%> >   
     ;; RETURNS: the list of vehicles on the street.
     ;; Example : See the tests.
     ;; Strategy : HOFC +SD on this

     (define/public (get-vehicles) 
       (filter 
         ;; Vehicle<%>  -> Boolean
         ;; GIVEN the Vehicle
         ;; RETURNS true if this Vehicle lies inside street
        (lambda (obj)
                 (or
                  (<= STREET-START (send obj get-front) STREET-END)
                  (<= STREET-START (send obj get-rear) STREET-END)))
                 vehicles))
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    ;; get-traffic-lights : -> ListOf< TrafficLight<%> >
    ;; RETURNS: the list of traffic lights on the street.
    ;; Example : See the tests.
    ;; Strategy : HOFC +SD on this

    (define/public (get-traffic-lights)
      (filter 
         ;; TrafficLight<%>  -> Boolean
         ;; GIVEN the TrafficLight
         ;; RETURNS true if this TrafficLight lies inside street
       (lambda (obj) (<= (- STREET-START HALF-TRAFFIC-SIGNAL-SIDE)
                                (send obj get-x)
                                (+ STREET-END HALF-TRAFFIC-SIGNAL-SIDE)))
              traffic-lights)) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    
    ;; filter-selected-lights : -> Void
    ;; EFFECT : Filters the selected traffic light and deletes it.
    ;; Example : See the tests.
    ;; Strategy : HOFC +SD on this
  
    (define/public (filter-selected-lights)
    (local
      ((define selected-tl (filter 
                            ;; TrafficLight<%>  -> Boolean
                            ;; GIVEN the TrafficLight
                            ;; RETURNS true if this TrafficLight is selected
                            (lambda (x) (send x selected-for-dragging?))
                            traffic-lights)))
      (if (empty? selected-tl) 
          this
          (begin
           (delete-traffic-light 
            (send (first selected-tl) get-serial-number))))))
      
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    
    ;; calc-legal-pos-for-traffic-light : Integer -> Number
    ;; GIVEN A position on the street
    ;; RETURNS: the first legal position for the traffic light to be placed beginnig
    ;; from the Mid Street Position
    ;; Legal position means two traffic lights should be separated by atleast a
    ;; distance of 60
    ;; Example : See the tests.
    ;; TERMINATION ARGUMENT: When the legal position is obtained 
    ;; it returns the same position. 
    ;; Strategy : General Recursion
    
    (define/public (calc-legal-pos-for-traffic-light ini-pos)
      (if
        (not (ormap 
               ;; TrafficLight<%>  -> Boolean
                ;; GIVEN the TrafficLight
                ;; RETURNS true if this position overlaps with the TrafficLight
               (lambda (obj) (send obj does-it-overlap? ini-pos)) 
               traffic-lights)) ini-pos
        (calc-legal-pos-for-traffic-light (+ ini-pos 1))))
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ;; find-legal-pos-and-add-traffic-light : Integer -> Void
    ;; GIVEN A position on the street
    ;; EFFECT: Finds out the legal position and adds the Traffic light there.
    ;; Example : See the tests.
    ;; Strategy : HOFC + SD on this

     (define/public (find-legal-pos-and-add-traffic-light pos) 
        (local
          ((define next-legal-pos (calc-legal-pos-for-traffic-light pos))
           (define new-traffic-light-obj (add-traffic-light next-legal-pos)))
          (begin
               (set! counter-trafficlight (+ counter-trafficlight 1))
               (set! traffic-lights (cons new-traffic-light-obj traffic-lights))
               (for-each
                        ;; Vehicle<%>  -> Void
                        ;; GIVEN the Vehicle
                        ;  Subscribes Vehicle to new TrafficLight
                (lambda (obj) (send new-traffic-light-obj 
                                    add-vehicles-for-subs obj))
                vehicles))))
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
    ;; add-traffic-light: Nat -> TrafficLight<%>
    ;; GIVEN: a legal position on the street
    ;; WHERE : the given position is a legal position on the street
    ;; where a new Traffic light can be created without violating the
    ;; minimum spacing rule with any of the existing traffic lights.
    ;; EFFECT: creates a new traffic light and puts it on the street
    ;; in the first legal position to the right of the given one.
    ;; RETURNS: the new traffic light
    ;; Examples : Please see tests
    ;; Strategy: Domain Knowledge
    
    (define/public (add-traffic-light pos)
           (new TrafficLight% [serial-number counter-trafficlight] [x pos]))
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

     ;; delete-traffic-light: Nat -> Void
     ;; GIVEN: a serial number
     ;; EFFECT: removes the traffic light with that serial number from
     ;; the street.  If there is no such traffic light, has no effect.
     ;; Examples : Please see tests
     ;; Strategy: Domain Knowledge
    
    
    (define/public (delete-traffic-light serial-no)
      (set! traffic-lights (filter (lambda (x)
                                     (not (= (send x get-serial-number)
                                             serial-no))) traffic-lights)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

     ;; add-vehicle: Vehicle<%> -> Void
     ;; GIVEN: A vehicle
     ;; WHERE: the vehicle is to the left of all the vehicles on the
     ;; street
     ;; EFFECT: places the vehicle on the street at its position.
     ;; If the vehicle cannot be placed at that position, it is placed
     ;; in the first legal position to the left of the desired one.
     ;; Examples : Please see tests
     ;; Strategy: Function Composition
    
     (define/public (add-vehicle nv)
      (if (empty? vehicles)
       (begin  
        (send nv set-ini-pos)
        (set! vehicles (append vehicles (list nv)))
        (add-veh-for-subscription nv)
        (publish-traffic-lights-if-red))
       (begin     
        (send (last vehicles) subscribe-vehicle-at-rear nv)
        (send (last vehicles) publish-rear-pos)
        (send nv set-ini-pos)
        (set! vehicles (append vehicles (list nv)))
        (add-veh-for-subscription nv)
        (publish-traffic-lights-if-red))))
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


     ;; add-veh-for-subscription: Vehicle<%> -> Void
     ;; GIVEN: A vehicle
     ;; EFFECT:Subscribes itself to all Traffic Lights
     ;; Examples : Please see tests
     ;; Strategy: HOFC + SD on this
    
(define/public (add-veh-for-subscription nv)
      (for-each 
                ; TrafficLight<%>  -> Boolean
                ;; GIVEN the TrafficLight
                ;; Subscribes the new vehicle to itself.
                (lambda (obj) (send obj add-vehicles-for-subs nv))
                traffic-lights))
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

     ;; publish-traffic-lights-if-red:  -> Void
     ;; EFFECT: All traffic lights publish to their subscribed vehicles if 
     ;;  they are red
     ;; Examples : Please see tests
     ;; Strategy: HOFC + SD on this
    
(define/public (publish-traffic-lights-if-red)
      (for-each 
                 ; TrafficLight<%>  -> Boolean
                ;; GIVEN the TrafficLight
                ;; Publishes value its  x if it is red to 
                ;;all subscribed vehicles.
                
                (lambda (obj) (send obj publish-if-red-trafic-light))
                traffic-lights))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;; create-new-vehicle: Vehicle<%>  -> Vehicle<%>
     ;; Given : a Vehicle 
     ;; Where : Vehicle must be inherited from Vehicle%
     ;; Examples : Please see tests
     ;; Strategy:Domain Knowledge
  
(define/public (create-new-vehicle type)
       (new type [pos 0]))
    
     ;; Methods for Testing
    
    (define/public (get-all-traffic-lights)
      traffic-lights)
    
    (define/public (get-all-vehicles)
      vehicles)
    ))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Traffic Lights


(provide TrafficLight%)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; absolute-val :  Number -> absolute-val
;; GIVEN : a Number 
;; RETURNS : the magitude of the Number
;; Example : (send (new-rectangle 20 20 10) is-inside? 21 21)=>true 
;; Strategy : Domain Knowledge

(define (absolute-val num)
  (if (negative? num) (- num) num))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; A TrafficLight% is a (new TrafficLight% 
;;                          [serial-number Integer]
;;                          [x Integer] 
;;                          [mx Nat]
;;                          [my Nat]
;;                          [colors TLList]
;;                          [sel? Boolean] 
;;                          [time-left-for-color-chng Integer])
;; Interpretation: represents a TrafficLight,
;; TrafficLight is an Object of Class TrafficLight% that implements 
;; StatefulWorldObj<%> TrafficLight<%>

(define TrafficLight%
  (class* object% (StatefulWorldObj<%> TrafficLight<%>)
    
    (init-field 
                ;INTP: serial-number of TrafficLight which is unique.
             serial-number 
                ;INTP : X Co-ordinate of center of TrafficLight;
             x    
                ;INTP : X Co-ordinate of mouse
             [mx 0]
                ;INTP :Y Co-ordinate of mouse
             [my 0] 
                ;INTP: List of Colors.First color in the list is the list of
                ;      TrafficSignal
             [colors LIST-TRAFFIC-LIGHT-COLORS]
                ;INTP : True if TrafficSignal is selected else false
             [sel? false]
                ;INTP : Time left for color change of TrafficSignal
             [time-left-for-color-chng TICKS-TO-CHANGE-COLOR-OF-TRAFFIC-LIGHTS])
    
    ;; INTP: Represents the list of Vehicles that have subscribed to the
    ;;       TrafficLight
    (field [vehicle-subscribers empty])
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    
    (super-new)
    
    ;; on-tick : -> Void
    ;; EFFECT:  Updates the TrafficLight on tick. 
    ;; Changes the color of Traffic Lights after some specific TimeInterval
    ;; Example : See tests
    ;; Strategy : HOFC +SD on this
    
    (define/public (on-tick)
      (if sel? this
      (if (zero? time-left-for-color-chng)
          (begin
            (send this change-colors)
            (if (and (equal? (first colors) "red") (not sel?))
                (for-each
                 ;; Vehicle<%> -> void
                 ;; GIVEN : Vehicle
                 ;; Publishes the x co-ordinate of this TraffcLight to Vehicle
                 (lambda (obj) (send obj add-pos-of-red-traffic-light x))
                 vehicle-subscribers)
                (for-each
                ;; Vehicle<%> -> void
                ;; GIVEN : Vehicle
                ;; Unsubscribes the x co-ordinate of this TraffcLight
                 (lambda (obj) (send obj remove-pos-of-red-traffic-light x)) 
                 vehicle-subscribers)
                ))
          (set! time-left-for-color-chng (- time-left-for-color-chng 1)))))
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
    
    
    ;; change-colors: -> Void
    ;; EFFECT: rotate the list of colors, and reset time-left
    ;; Example : See tests
    ;; Strategy : Domain Knowledge
    (define/public (change-colors)
      (set! colors (append (rest colors) (list (first colors))))
      (set! time-left-for-color-chng TICKS-TO-CHANGE-COLOR-OF-TRAFFIC-LIGHTS))
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
    
    ;; on-mouse: Nat Nat TrafficLightMouseEvent -> Void
    ;; EFFECT: updates this Street  with its TrafficLights selected,dragged,
    ;; dropped following the given TrafficLightMouseEvent;
    ;; Example : See the tests.
    ;; Strategy : Domain Knowledge
    
    
    (define/public (on-mouse new-mx new-my mev)
      this)
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    
    ;; on-mouse-fn: Nat Nat TrafficLightMouseEvent  ListOf<TrafficSignal<%>>
    ;;             -> Void
    ;; EFFECT: updates this Street  with its TrafficLights selected,dragged,
    ;; dropped following the given TrafficLightMouseEvent;
    ;; Example : See the tests.
    ;; Strategy : SD on TrafficLightMouseEvent :mev
    
    (define/public (on-mouse-fn new-mx new-my mev traffic-lights)
      (cond
        [(mouse=? "button-down" mev) (send this button-down new-mx new-my)]  
        [(mouse=? "drag" mev) (send this drag new-mx new-my)]
        [(mouse=? "button-up" mev) (send this button-up traffic-lights)]
        [else this]))
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; is-inside? : Number Number -> Boolean
    ;; GIVEN : X Co-ordinate and Y Co-ordinate of mouse 
    ;; RETURNS : true if mouse inside Traffic Light else false
    ;; Example : See Tests
    ;; Strategy : Domain Knowledge
    
    
    (define/public (is-inside? new-mx new-my)  
      (and 
       (<= (- x HALF-TRAFFIC-SIGNAL-SIDE) 
           new-mx 
           (+ x HALF-TRAFFIC-SIGNAL-SIDE))
       (<= (- HALF-CANVAS-HEIGHT HALF-TRAFFIC-SIGNAL-SIDE)
           new-my 
           (+ HALF-CANVAS-HEIGHT HALF-TRAFFIC-SIGNAL-SIDE))))
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    
    ;; button-down: Nat Nat -> Void
    ;; GIVEN : X Co-ordinate and Y Co-ordinate of mouse 
    ;; EFFECT : If mouse co-ordinates are inside TrafficSignal,selects the 
    ;;         TrafficSignal
    ;; Example : See Tests
    ;; Strategy : HOFC + SD on this
    
    
    (define/public (button-down new-mx new-my)
      (if (send this is-inside? new-mx new-my)
          (begin
            (set! sel? true)
            (set! mx new-mx)
            (set! my new-my)
            (for-each
             ;; Vehicle<%> -> void
             ;; GIVEN : Vehicle
             ;; Unsubscribes the x co-ordinate of this TraffcLight to Vehicle
             (lambda (obj) (send obj remove-pos-of-red-traffic-light x))
             vehicle-subscribers))
          this))
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

       
    ;; drag-rect : Nat Nat  ListOf<TrafficSignal<%>> -> Void
    ;; GIVEN : current X Co-ordinate and Y Co-ordinate of mouse 
    ;; EFFECT : Sets  mouse positions to new values and 
    ;;          Places the TrafficLight at the first legal position
    ;; Example : See Tests
    ;; Strategy : Domain Knowledge
    (define/public (drag new-mx new-my)
      (if sel?
          (begin
            (set! x (send this calc-new-x-after-drag new-mx))
            (set! mx new-mx)
            (set! my new-my))
          this))
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;; calc-new-x-after-drag : Nat  -> Number
    ;; GIVEN : current  a mouse co-ordinate 
    ;; RETURNS : A probable value of X after drag
    ;; Example : See Tests
    ;; Strategy : Domain Knowledge
    (define/public (calc-new-x-after-drag new-mx)
      (+ x (- new-mx mx)))
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    
    ;; calc-legal-pos-after-drag : Integer ListOf<TrafficSignal<%>> -> Number
    ;; GIVEN A position on the street
    ;; RETURNS: false if there is no legal position on the street else the 
    ;; next legal position for traffic light.
    ;; Legal position means two traffic lights should be separated by atleast a
    ;; distance of 60
    ;; Example : See the tests.
    ;; TERMINATION ARGUMENT: When the legal position is obtained 
    ;; it returns the same position. 
    ;; Strategy : General Recursion
    
    
    (define/public (calc-legal-pos-after-drag dropped-pos traffic-lights)
      (if (not (ormap 
                ;; TrafficLight<%>  -> Boolean
                ;; GIVEN the TrafficLight
                ;; RETURNS true if this position overlaps with the TrafficLight
                (lambda (n) (send n does-it-overlap? dropped-pos))
                      traffic-lights))
          dropped-pos
          (calc-legal-pos-after-drag (+ dropped-pos 1) traffic-lights)))
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ;; button-up-rect :  ListOf<TrafficSignal<%>> -> Void
    ;; EFFECT : Updates the sel? this rectangle as false and places the 
    ;; Traffic light at the legal position to the right of original position.
    ;; Example : See Tests
    ;; Strategy : HOFC + SD on this
    
    (define/public (button-up traffic-lights)
      (begin
        (if sel?
            (begin
              (set! x (calc-legal-pos-after-drag
                       (limit-drag-outside-street x)
                       (filter
                        ;; TrafficLight<%>  -> Boolean
                        ;; GIVEN the TrafficLight
                        ;;RETURNS true for every other TrafficLight than this
                        (lambda (obj) (not (equal? obj this)))
                                 traffic-lights)))
              (set! sel? false)
              (if (equal? (first colors) "red")
                  (for-each
                   ;; TrafficLight<%>  -> Void 
                   ;; Given a TrafficLight, 
                   ;; Publishes the position of itself to all vehicles that
                   ;; are subscribed.
                    
                   (lambda (obj) (send obj add-pos-of-red-traffic-light x))
                   vehicle-subscribers)
                  this))
            this)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
    
    
    ;; limit-drag-outside-street : Number -> Number
    ;; GIVEN : a position on street
    ;; RETURNS: position that should be set,if the TrafficLight is going out.
    ;; Example : See Tests
    ;; Strategy : Domain Knowledge
    
    
    (define/public (limit-drag-outside-street pos)
      (if (< pos (+ STREET-START HALF-TRAFFIC-SIGNAL-SIDE))
          (+ STREET-START HALF-TRAFFIC-SIGNAL-SIDE)
          (if (> pos (- STREET-END HALF-TRAFFIC-SIGNAL-SIDE))
              (- STREET-END HALF-TRAFFIC-SIGNAL-SIDE)
              pos)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  

    ;; on-key : -> Void
    ;; EFFECT: updates this Rectangle to its state following a keyevent.
    ;; Example : See Tests 
    ;; Strategy :Domain Knowledge
    (define/public (on-key) this)
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
 
    
    ;; add-to-scene: Scene -> Scene
    ;; GIVEN : a partial screen 
    ;; Returns a Scene like the given one, but with this TrafficLight drawn
    ;; on it.
    ;; Example : See Tests
    ;; Strategy : Domain Knowledge
    (define/public (add-to-scene scene)
      (place-image
       (square TRAFFIC-SIGNAL-SIDE
               (if sel? "solid" "outline")
               (first colors))
       x HALF-CANVAS-HEIGHT scene))
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
   
    ;; get-serial-number: -> Nat 
    ;; RETURNS: a serial number that uniquely identifies this traffic light
    ;; Example : See Tests
    ;; Strategy : Domain Knowledge
    
    (define/public (get-serial-number)
      serial-number) 
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

    ;; get-x: -> Nat
    ;; RETURNS: the position of the center of traffic light on the street
    ;; Example : See Tests
    ;; Strategy : Domain Knowledge
    (define/public (get-x) x)
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
    
     ;; get-color:  -> TrafficLightColor
     ;; RETURNS: the current color of the traffic light
     ;; Example : See Tests
     ;; Strategy : Domain Knowledge
    (define/public (get-color) (first colors))
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
    
    ;; selected-for-dragging? : -> Boolean
    ;; RETURNS: true iff the traffic light is currently selected for
    ;; dragging. 
    ;; Example : See Tests
    ;; Strategy : Domain Knowledge
    
    (define/public (selected-for-dragging?) sel?) 
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
 
       
     ;; add-vehicles-for-subs : Vehicle<%> -> Void
     ;; EFFECT : Given a Vehicle adds it to it's vehicle-subscribers
     ;; Example : See Tests
     ;; Strategy : Domain Knowledge
    
    (define/public (add-vehicles-for-subs veh)
      (set! vehicle-subscribers (cons veh vehicle-subscribers)))
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

    ;; selected-for-dragging? : Number -> Boolean
    ;; GIVEN : a position on street
    ;; RETURNS: true iff the traffic light would overlap on given position
    ;; Example : See Tests
    ;; Strategy : Domain Knowledge
    
    (define/public (does-it-overlap? pos)
      (< (absolute-val (- x pos)) MAX-PROXIMITY-TRAFFIC-SIGNAL))
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
  
     ;; publish-if-red-trafic-light:  -> Void
     ;; EFFECT : If the TrafficLight is Red it would publish it's x to all
     ;; subscribed vehicles
     ;; Example : See Tests
     ;; Strategy : Domain Knowledge
    (define/public (publish-if-red-trafic-light)
      (if (and (equal? (first colors) "red") (not sel?))
          (for-each
           (lambda (obj) (send obj add-pos-of-red-traffic-light x))
           vehicle-subscribers)
          void
          ))
    
    ;; Methods for Testing
    (define/public (get-mx)
      mx)
    (define/public (get-my)
      my)
    (define/public (get-time-left-for-color-chng)
      time-left-for-color-chng)
    
    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Vehicles

(require rackunit)
(require rackunit/text-ui)
(require "extras.rkt")

(provide Vehicle%)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; RedTLLightList is a  ListOf<Number>  is either
;  -- Empty (intp:There are no X-Coordinates of center of TrafficLights in list)
;; -- (cons Number RedTLLightList)(intp: There is atleast one X-Coordinates of 
;;                                       center of TrafficLights in list)

;;Template 
;; lortl-fn: RedTLLightList -> ??
;; (define (lortl-fn rtl)
;;   (cond
;;    [(empty? rtl)...]
;;    [else (...
;;              (first rtl)
;;              (lortl-fn (rest rtl)))]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; A MaybeNumber is one of:
;; -- Integer
;; -- false

;; ;; TEMPLATE:
;; (define (mbnum-fn MaybeNumber)
;;   (cond
;;     [(number? MaybeNumber) ...]
;;     [else ...]))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; A Vehcicle is a  Vehicle% with  [pos Intger] 
;;                          [vel  Integer]
;;                          [max-vel Integer]
;;                          [acc Integer]
;;                          [width Number]
;;                          [height Number] 
;;                          [color TrafficLightColor]
;;                          [img Scene]

;;                                             )
;; Interpretation: represents a Vehicle,
;; Vehicle% is abstract class that implements Vehicle<%>. Classes that will
;; inherit Vehicle% would implement the abstract methods of Vehicle%

(define Vehicle%
  (class* object% (Vehicle<%>)
    
    
    ;(pos : Integer 
    ;Represents the  X Co-ordinate of center of Vehicle)
    (init-field pos)
    
    ;vel : Integer 
    ;Represents the velocity of Vehicle)
    (init-field vel)
    
    ; max-vel : Integer 
    ; Represents the maximum velocity of Vehicle
    (init-field max-vel)
    
    ; acc : Integer 
    ; Represents the acceleration of Vehicle
    (init-field acc) 
    
    ;width : Number
    ;Represents width of Vehicle
    (init-field width)
    
    ;height : Number
    ;Represents height of Vehicle
    (init-field height)
    
    ;color : String
    ;Represents color of Vehicle
    (init-field color)
   
    ;;img : Scene
    ; Represents the image of Vehicle
    (init-field img)
    
    
    ;;following-veh : Vehicle<%>
    ;; Represents the Vehicle coming from behind
    (field [following-veh null])
    
    
    ;; front-veh-rear-pos : Number
    ;; Represents the position of Vehicle at the front
    (field [front-veh-rear-pos null])

    
    ;; front-veh-vel : Number
    ;; Represents the Velocity of Vehicle at the front
    (field [front-veh-vel null])

    ;; lst-of-pos-red-traffic-lights : RedTLLightList
    ;; Represents the List of current Red traffic lights position. 
    (field [lst-of-pos-red-traffic-lights empty])
    
    (super-new)
    
    ;;; Algorithm
    
    ;; when we see the next position of the vehicle after tick
    ;; 1. if the traffic light is red ahead
    ;; 2. if there is a vehicle ahead
    ;; 3. there is nothing ahead
    
    ;; Solution : Steps of execution
    ;; 1. check the next position for the given vehicle
    ;; 1.1 a) if there is a traffic light ahead then place yourself
    ;;        at the min pos of (vel+acc) or(pos of the start of traffic light)
    ;;     b) if there is a vehicle ahead then place yourself
    ;;        at min pos of (vel+acc)(pos just behind next veh)
    ;; Make two methods
    ;; I) about-to-cross-traffic-light-ahead?
    ;; II) another-veh-ahead?
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
    ;; on-tick : -> Void
    ;; EFFECT:  Updates Vehicle on tick. Advances vehicle on street with its
    ;; velocity without crossing the maximum limit & without bumping vehicle at
    ;; front
    ;; Example :(send (new Car% [pos 20] [vel 20] [max-vel 20] [acc 0]  
    ;; [width 15] [height 15] [color "blue"] [img (above (above CAR-TOP CAR-BODY) 
    ;; CAR-WHEELS)])
    ;; on-tick)=> Car% [pos 40] [vel 20] [max-vel 20] [acc 0] [width 15] 
    ;;  [height 15] [color "blue"] [img (above (above CAR-TOP CAR-BODY) 
    ;; CAR-WHEELS)])
    ;; Strategy : Function Composition
    
    (define/public (on-tick)
        (cond
          [(send this about-to-cross-a-red-light?)
           (send this set-veh-pos-to-tl-rear)]
          [(send this about-to-cross-veh?)
         (send this set-veh-pos-to-next-veh-proximity)]
          [else
         (send this set-veh-normal-next-pos)]))
      
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;; get-next-velocity : -> Integer
    ;; RETURNS: The next velocity 
    ;; Example :(send (new Car% [pos 20] [vel 20] [max-vel 20] [acc 0]
    ;; [width 15]  [height 15] [color "blue"] 
    ;;[img (above (above CAR-TOP CAR-BODY) CAR-WHEELS)])
    ;; get-next-velocity) => 20
    ;; Strategy : Function Composition
    
    (define/public (get-next-velocity)
      (min (+ vel acc) max-vel (send this get-max-permissible-vel)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ;; get-max-permissible-vel : -> Integer
    ;; RETURNS: The next velocity 
    ;; Example :(send (new Car% [pos 20] [vel 20] [max-vel 20] [acc 0]
    ;; [width 15]  [height 15] [color "blue"] 
    ;;[img (above (above CAR-TOP CAR-BODY) CAR-WHEELS)])
    ;; get-max-permissible-vel) => 20
    ;; Strategy : Function Composition
    
    (define/public (get-max-permissible-vel)
     (if (<= (send this get-front) STREET-MID) MAX-VEL-FIRST-HALF
         MAX-VEL-SECOND-HALF)) 
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     
    ;; next-front-position : -> Integer
    ;; RETURNS: The next velocity 
    ;; Example :(send (new Car% [pos 20] [vel 20] [max-vel 20] [acc 0]
    ;; [width 20]  [height 15] [color "blue"] 
    ;;[img (above (above CAR-TOP CAR-BODY) CAR-WHEELS)])
    ;; next-front-position) => 30
    ;; Strategy : Function Composition   
 
      (define/public (next-front-position)
        (+ (send this get-next-velocity) (send this get-front)))
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ;; get-front-traffic-lights : -> RedTLLightList
    ;; RETURNS: The list of front x-co-ordinate positions red traffic lights.
    ;; Example :(send (new Car% [pos 20] [vel 20] [max-vel 20] [acc 0]
    ;; [width 20]  [height 15] [color "blue"] 
    ;; [img (above (above CAR-TOP CAR-BODY) CAR-WHEELS)]
    ;; [lst-of-pos-red-traffic-lights 35]) get-front-traffic-lights)
    ;; => Sets lst-of-pos-red-traffic-lights to (list 25)
    ;; Strategy :HOFC + SD on this
      (define/public (get-front-traffic-lights)
      (map        
       ;; Number -> Number
       ;; GIVEN: Center position of Traffic Lights returns its front position
       
       (lambda(x) (- x HALF-TRAFFIC-SIGNAL-SIDE))
           lst-of-pos-red-traffic-lights))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ;; get-min-pos-of-next-traffic-signal : -> MaybeNumber
    ;; RETURNS: The the x-co-ordinate of red traffic,which is placed next to 
    ;; this vehicle.If it does not exist it returns false
    ;; Example :(send (new Car% [pos 20] [vel 20] [max-vel 20] [acc 0]
    ;; [width 20]  [height 15] [color "blue"] 
    ;; [img (above (above CAR-TOP CAR-BODY) CAR-WHEELS)]
    ;; [lst-of-pos-red-traffic-lights 40 90]) get-min-pos-of-next-traffic-signal)
    ;; => 40
    ;; Strategy : HOFC + SD on this 

    (define/public (get-min-pos-of-next-traffic-signal)
      (local
        ((define traffic-lights-ahead-of-this
           (filter 
            ;; Number -> Boolean
            ;; GIVEN : Front of TrafficLight Returns true if front of this
            ;; vehicle is less than that of TrafficLight
            (lambda(m) (>= m (send this get-front)))
                   (send this get-front-traffic-lights))))
        
        (if (empty? traffic-lights-ahead-of-this)
            false
           (foldr min (first traffic-lights-ahead-of-this)
                  (rest traffic-lights-ahead-of-this)))))
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;; about-to-cross-a-red-light? : -> Boolean
    ;; RETURNS: True if it is going to cross a red light on next tick, False
    ;; otherwise
    ;; Example :(send (new Car% [pos 20] [vel 20] [max-vel 20] [acc 0]
    ;; [width 20]  [height 15] [color "blue"] 
    ;; [img (above (above CAR-TOP CAR-BODY) CAR-WHEELS)]
    ;; [lst-of-pos-red-traffic-lights 39 90]) about-to-cross-a-red-light?)
    ;; => True
    ;; Strategy : Function Composition 
    
     (define/public (about-to-cross-a-red-light?)
       ;;get min position of red lights > this  
        (local
        ((define pos-of-immediate-tl
           (send this get-min-pos-of-next-traffic-signal)))
       (cond
         [(false? pos-of-immediate-tl) false]
         [else
          (> (send this next-front-position) pos-of-immediate-tl)])))
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     

    ;; about-to-cross-veh? : -> Boolean
    ;; RETURNS: True if it is going to cross another vehicle on next tick, False
    ;; otherwise
    ;; Example :(send (new Car% [pos 20] [vel 20] [max-vel 20] [acc 0]
    ;; [width 20]  [height 15] [color "blue"] 
    ;; [img (above (above CAR-TOP CAR-BODY) CAR-WHEELS)]
    ;; [front-veh-rear-pos 39]) about-to-cross-veh?)
    ;; => True
    ;; Strategy : Function Composition 
   
    (define/public (about-to-cross-veh?)
      (if (or (equal? front-veh-rear-pos null)
              (> front-veh-rear-pos STREET-END)) false
          (> (send this next-front-position)
             (- front-veh-rear-pos MAX-PROXIMITY-VEHICLES))))
      
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    

    ;; set-veh-pos-to-tl-rear : -> Void
    ;; EFFECT: Sets the fron position of this vehicle to the rear of
    ;; traffic light
    ;; Example :(send (new Car% [pos 20] [vel 20] [max-vel 20] [acc 0]
    ;; [width 20]  [height 15] [color "blue"] 
    ;; [img (above (above CAR-TOP CAR-BODY) CAR-WHEELS)]
    ;; [lst-of-pos-red-traffic-lights 39]) set-veh-pos-to-tl-rear)
    ;; => Would set position to 39 
    ;; Strategy : Function Composition 
    
    (define/public (set-veh-pos-to-tl-rear)
      (begin
        (set! vel 0)
        (set! pos (- (send this get-min-pos-of-next-traffic-signal)
                     (/ width 2)))
        (send this publish-values-to-rear-veh)))
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
    
    
    ;; set-veh-pos-to-next-veh-proximity : -> Void
    ;; EFFECT: Sets the fron position of this vehicle to the 5 pixel rear of
    ;; vehicle at the front
    ;; Example :(send (new Car% [pos 20] [vel 20] [max-vel 20] [acc 0]
    ;; [width 20]  [height 15] [color "blue"] 
    ;; [img (above (above CAR-TOP CAR-BODY) CAR-WHEELS)]
    ;; [front-veh-rear-pos 40]) set-veh-pos-to-tl-rear)
    ;; => Would set position to 35 Velocity = velocity of vehicle at front
    ;; Strategy : Function Composition 
    
    (define/public (set-veh-pos-to-next-veh-proximity)
      (begin
        (set! vel front-veh-vel)
        (set! pos (- front-veh-rear-pos MAX-PROXIMITY-VEHICLES (/ width 2)))
        (send this publish-values-to-rear-veh)))
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
      
    ;; set-veh-normal-next-pos : -> Void
    ;; EFFECT: Sets the front position of this vehicle to the next position
    ;;
    ;; Example :(send (new Car% [pos 20] [vel 20] [max-vel 20] [acc 0]
    ;; [width 20]  [height 15] [color "blue"] 
    ;; [img (above (above CAR-TOP CAR-BODY) CAR-WHEELS)]
    ;; ) set-veh-pos-to-tl-rear)
    ;; => Would set position to 40 Velocity = velocity of vehicle at front
    ;; Strategy : Function Composition   
    
     (define/public (set-veh-normal-next-pos)
       (begin
         (set! vel (send this get-next-velocity))
         (set! pos (+ pos vel))
         (send this publish-values-to-rear-veh)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
 
    ;; publish-values-to-rear-veh : -> Void
    ;; EFFECT: Publishes value of rear position and velocity of this to the
    ;; Vehicle following it.
    ;; Example :(send (new Car% [pos 20] [vel 20] [max-vel 20] [acc 0]
    ;; [width 10]  [height 15] [color "blue"] 
    ;; [img (above (above CAR-TOP CAR-BODY) CAR-WHEELS)]
    ;; ) publish-values-to-rear-veh)
    ;; => Publishes 10 i.e. rear of this and the velocity 30
    ;; Strategy : Function Composition     
    
    (define/public (publish-values-to-rear-veh)
      (if (not (equal? following-veh null))
          (begin
            (send this publish-rear-pos)
            (send this publish-vel))
          this))
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
 
    ;; set-ini-pos : -> Void
    ;; EFFECT: Sets the initial position of the vehicle.
    ;; Here the vehicles get queued up one after other maintaining the 5 pixels
    ;; distance if created immediately.
    ;; Example :(send (new Car% [pos 0] [vel 20] [max-vel 20] [acc 0]
    ;; [width 10]  [height 15] [color "blue"] 
    ;; [img (above (above CAR-TOP CAR-BODY) CAR-WHEELS)]
    ;; ) set-ini-pos)
    ;; => Sets position pos to -5
    ;; Strategy : Domain Knowledge  
    
    (define/public (set-ini-pos)
      (if (equal? front-veh-rear-pos null)
          (set! pos (- STREET-START (/ width 2)))
          (if (>= (- front-veh-rear-pos MAX-PROXIMITY-VEHICLES) STREET-START)
              (set! pos (- STREET-START (/ width 2)))
              (set! pos (- front-veh-rear-pos MAX-PROXIMITY-VEHICLES 
                           (/ width 2))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
   
    
 ;; Abstract function for drawing the vehicles on the scene. 
 ;; To be implemented by the vehicles inheriting Vehicle%
    (abstract add-to-scene)
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
    
    ;; get-front: -> Integer
    ;; RETURNS: the x-position of the front bumper of the vehicle.
    ;; Example : (send (new Car% [pos 40] [vel 20] [max-vel 20] [acc 0]
    ;; [width 10]  [height 15] [color "blue"] 
    ;; [img (above (above CAR-TOP CAR-BODY) CAR-WHEELS)]
    ;; ) get-front)
    ;; => 45
    ;; Strategy : Domain Knowledge  

    (define/public (get-front)
      (+ pos (/ width 2)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
        
    ;; get-rear -> Integer
    ;; RETURNS: the x-position of the rear bumper of the vehicle.
    ;; Example : (send (new Car% [pos 40] [vel 20] [max-vel 20] [acc 0]
    ;; [width 10]  [height 15] [color "blue"] 
    ;; [img (above (above CAR-TOP CAR-BODY) CAR-WHEELS)]
    ;; ) get-rear)
    ;; => 35
    ;; Strategy : Domain Knowledge  

    (define/public (get-rear)
      (- pos (/ width 2)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  

    ;; get-vel -> Integer
    ;; RETURNS: the velocity of the vehicle.
    ;; Example : (send (new Car% [pos 40] [vel 20] [max-vel 20] [acc 0]
    ;; [width 10]  [height 15] [color "blue"] 
    ;; [img (above (above CAR-TOP CAR-BODY) CAR-WHEELS)]
    ;; ) get-rear)
    ;; => 20
    ;; Strategy : Domain Knowledge 
    
    (define/public (get-vel)
      vel)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ;; subscribe-vehicle-at-rear: Vehicle<%> -> Void
    ;; EFFECT : Sets the following vehicle to given vehicle..i.e Subscribes the
    ;; vehicle.
    ;; Example : (send (new Car% [pos 40] [vel 20] [max-vel 20] [acc 0]
    ;; [width 10]  [height 15] [color "blue"] 
    ;; [img (above (above CAR-TOP CAR-BODY) CAR-WHEELS)]
    ;; ) subscribe-vehicle-at-rear  (new Car% [pos 10] [vel 20] [max-vel 20] 
    ;; [acc 0] [width 10]  [height 15] [color "blue"] 
    ;; [img (above (above CAR-TOP CAR-BODY) CAR-WHEELS))
    ;; => Car at pos=10 is set to a following vehicle of car with pos= 40
    ;; Strategy : Domain Knowledge 

    (define/public (subscribe-vehicle-at-rear veh)
      (set! following-veh veh))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
    ;; publish-rear-pos : -> Void
    ;; EFFECT: Publishes value of rear position of this position to its
    ;;        subscriber.
    ;; Example :(send (new Car% [pos 20] [vel 20] [max-vel 20] [acc 0]
    ;; [width 10]  [height 15] [color "blue"] 
    ;; [img (above (above CAR-TOP CAR-BODY) CAR-WHEELS)]
    ;; ) publish-rear-pos)
    ;; => Publishes 15 i.e. rear of this to its following vehicle.
    ;; i.e. sets front-veh-rear-pos of following-vehicle to the rear of this
    ;; Strategy : Function Composition     
    
    (define/public (publish-rear-pos)
      (send following-veh capture-front-veh-rear-pos (send this get-rear)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

     
    ;; capture-front-veh-rear-pos : Integer -> Void
    ;; GIVEN : A rear position of vehicle at the front
    ;; EFFECT:  Sets the given value to front-veh-rear-pos
    ;; Example :(send (new Car% [pos 20] [vel 20] [max-vel 20] [acc 0]
    ;; [width 10]  [height 15] [color "blue"] 
    ;; [img (above (above CAR-TOP CAR-BODY) CAR-WHEELS)]
    ;; ) capture-front-veh-rear-pos 35)
    ;; => Sets front-veh-rear-pos to 35
    ;; Strategy : Domain Knowledge    
   
    (define/public (capture-front-veh-rear-pos npos)
      (set! front-veh-rear-pos npos)) 
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ;; publish-vel : -> Void
    ;; EFFECT: Publishes velocity of this vehicle position to its
    ;;        subscriber.
    ;; Example :(send (new Car% [pos 20] [vel 20] [max-vel 20] [acc 0]
    ;; [width 10]  [height 15] [color "blue"] 
    ;; [img (above (above CAR-TOP CAR-BODY) CAR-WHEELS)]
    ;; ) publish-vel)
    ;; => Publishes 20 i.e. velocity to its following vehicle.
    ;; i.e. sets velocity of following-vehicle to velocity of this
    ;; Strategy : Function Composition
    
    (define/public (publish-vel)
      (send following-veh capture-front-veh-vel (send this get-vel)))
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
        
    ;; capture-front-veh-vel : Integer -> Void
    ;; GIVEN : A velocity of vehicle at the front
    ;; EFFECT:  Sets the given value to front-veh-rear-pos
    ;; Example :(send (new Car% [pos 20] [vel 20] [max-vel 20] [acc 0]
    ;; [width 10]  [height 15] [color "blue"] 
    ;; [img (above (above CAR-TOP CAR-BODY) CAR-WHEELS)]
    ;; ) capture-front-veh-vel 0)
    ;; => Sets front-veh-vel to 0
    ;; Strategy : Domain Knowledge   
    
    (define/public (capture-front-veh-vel front-vel)
      (set! front-veh-vel front-vel)) 
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
            
    ;; add-pos-of-red-traffic-light : Integer -> Void
    ;; GIVEN : A position of Traffic Light
    ;; EFFECT:  Adds the value to lst-of-pos-red-traffic-lights
    ;; Example :(send (new Car% [pos 20] [vel 20] [max-vel 20] [acc 0]
    ;; [width 10]  [height 15] [color "blue"] 
    ;; [img (above (above CAR-TOP CAR-BODY) CAR-WHEELS)]
    ;; ) add-pos-of-red-traffic-light 500)
    ;; => Adds 500 to lst-of-pos-red-traffic-lights
    ;; Strategy : Domain Knowledge 
    
    (define/public (add-pos-of-red-traffic-light x)
      (set! lst-of-pos-red-traffic-lights 
            (cons x lst-of-pos-red-traffic-lights)))
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;; remove-pos-of-red-traffic-light : Integer -> Void
    ;; GIVEN : A position of Traffic Light
    ;; EFFECT:  Removes the value to lst-of-pos-red-traffic-lights
    ;; Example :(send (new Car% [pos 20] [vel 20] [max-vel 20] [acc 0]
    ;; [width 10]  [height 15] [color "blue"] 
    ;; [img (above (above CAR-TOP CAR-BODY) CAR-WHEELS)]
    ;; ) remove-pos-of-red-traffic-light 500)
    ;; => Removes 500 from lst-of-pos-red-traffic-lights
    ;; Strategy : Domain Knowledge 
    
    (define/public (remove-pos-of-red-traffic-light x)
      (set! lst-of-pos-red-traffic-lights
            (filter 
             ;; Integer - > Boolean
             ;; Given a X -Cordinate of Center of traffic light
             ;; Returns true if it is the same one as the given one
             ;; Else false
             (lambda (n) (not (equal? n x)))
                    lst-of-pos-red-traffic-lights)))
    
    
        ;; Methods for Testing
    
    (define/public (get-pos)
      pos)
    
    (define/public (get-max-vel)
      max-vel)
    
    (define/public (get-acc)
      acc)
    
    (define/public (get-width)
      width)
    
    (define/public (get-height)
      height)
    
    (define/public (get-color)
      color)
    
    
    (define/public (set-vel new-vel)
      (set! vel new-vel))
    
    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Cars
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Truck


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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TractorTrailer

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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Top

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
  
