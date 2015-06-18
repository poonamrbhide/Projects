#lang racket

(require rackunit)
(require rackunit/text-ui)

(require 2htdp/universe)  ;; for key=?

(require "interfaces.rkt")

(require "TrafficLight.rkt")
(require "Car.rkt")
(require "Truck.rkt")
(require "TractorTrailer.rkt")

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
