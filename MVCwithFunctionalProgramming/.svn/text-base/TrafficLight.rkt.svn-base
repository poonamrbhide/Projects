;;; TrafficLight.rkt

#lang racket

(require rackunit)
(require rackunit/text-ui)
(require 2htdp/image)

(require 2htdp/universe)  

(require "interfaces.rkt")

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
          0
          ))
    
    ;; Methods for Testing
    (define/public (get-mx)
      mx)
    (define/public (get-my)
      my)
    (define/public (get-time-left-for-color-chng)
      time-left-for-color-chng)
    
    ))