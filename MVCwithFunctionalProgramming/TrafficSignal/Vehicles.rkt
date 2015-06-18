;;; Vehicles.rkt 

#lang racket

(require "interfaces.rkt")

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
;;                          [color String]
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
    
    ;; get-pos -> Number
    ;; RETURNS: the position of the vehicle.
    ;; Example : (send (new Car% [pos 40] [vel 20] [max-vel 20] [acc 0]
    ;; [width 10]  [height 15] [color "blue"] 
    ;; [img (above (above CAR-TOP CAR-BODY) CAR-WHEELS)]
    ;; ) get-pos)
    ;; => 40
    ;; Strategy : Domain Knowledge 
    
    (define/public (get-pos)
      pos)
    
    
    ;; get-max-vel -> Number
    ;; RETURNS: the max velocity of the vehicle.
    ;; Example : (send (new Car% [pos 40] [vel 20] [max-vel 20] [acc 0]
    ;; [width 10]  [height 15] [color "blue"] 
    ;; [img (above (above CAR-TOP CAR-BODY) CAR-WHEELS)]
    ;; ) get-max-vel)
    ;; => 20
    ;; Strategy : Domain Knowledge 
    (define/public (get-max-vel)
      max-vel)
    
    ;; get-acc -> Number
    ;; RETURNS: the acceleration of the vehicle.
    ;; Example : (send (new Car% [pos 40] [vel 20] [max-vel 20] [acc 0]
    ;; [width 10]  [height 15] [color "blue"] 
    ;; [img (above (above CAR-TOP CAR-BODY) CAR-WHEELS)]
    ;; ) get-acc)
    ;; => 20
    ;; Strategy : Domain Knowledge 
    (define/public (get-acc)
      acc)
    
    ;; get-width -> Number
    ;; RETURNS: the width of the vehicle.
    ;; Example : (send (new Car% [pos 40] [vel 20] [max-vel 20] [acc 0]
    ;; [width 10]  [height 15] [color "blue"] 
    ;; [img (above (above CAR-TOP CAR-BODY) CAR-WHEELS)]
    ;; ) get-width)
    ;; => 15
    ;; Strategy : Domain Knowledge 
    (define/public (get-width)
      width)
    
    ;; get-height -> Number
    ;; RETURNS: the height of the vehicle.
    ;; Example : (send (new Car% [pos 40] [vel 20] [max-vel 20] [acc 0]
    ;; [width 10]  [height 15] [color "blue"] 
    ;; [img (above (above CAR-TOP CAR-BODY) CAR-WHEELS)]
    ;; ) get-height)
    ;; => 15
    ;; Strategy : Domain Knowledge 
    (define/public (get-height)
      height)
    
      ;; get-color -> String
    ;; RETURNS: the height of the vehicle.
    ;; Example : (send (new Car% [pos 40] [vel 20] [max-vel 20] [acc 0]
    ;; [width 10]  [height 15] [color "blue"] 
    ;; [img (above (above CAR-TOP CAR-BODY) CAR-WHEELS)]
    ;; ) get-color)
    ;; => 15
    ;; Strategy : Domain Knowledge 
    (define/public (get-color)
      color)
    
          ;; new-vel : Number -> Void
    ;; RETURNS: Void.
    ;; EFFECT : Sets the new velocity for the veh
    ;; Example : (send (new Car% [pos 40] [vel 20] [max-vel 20] [acc 0]
    ;; [width 10]  [height 15] [color "blue"] 
    ;; [img (above (above CAR-TOP CAR-BODY) CAR-WHEELS)]
    ;; ) new-vel 30)
    ;; => void (update the vel to 30)
    ;; Strategy : Domain Knowledge 
    (define/public (set-vel new-vel)
      (set! vel new-vel))
    
    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


