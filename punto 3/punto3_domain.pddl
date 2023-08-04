(define (domain punto1)
 (:requirements :strips :typing :durative-actions :numeric-fluents)
 
 (:types
  ;food - content
  ;medicine - content
  ;tools - content
  content
  location
  person
  agent
  box
  carrier
  place ;posto sul carrier per la box
)

(:functions
     (weigth_box ?box)
     (weigth_carrier ?carrier)
     (weigth_content ?content)
     (move_duration)
     (fill_duration)
     (load_duration)
)

 (:constants
     
 )

 (:predicates
   (in ?o - object ?l - location)
   (need  ?p - person ?c - content)
   (has ?p - person ?c - content)
   (hasSomething ?p - person) ;gestione or
   (inBox ?b - box ?c - content)
   (emptyBox ?b - box)
   (boxOnPlace ?b - box ?p - place) 
   (emptyPlace ?p - place) ;per gestire la load
   (fullPlace ?p - place) ;per gestire l'unload
   (placeOnCarrier ?p - place ?c - carrier)
   (freeAgent ?g - agent) ;Ci dice se l'agent g è libero oppure no
   (needAll ?p - person) ;gestione or
   (needSomething ?p - person)
   
  )

 (:durative-action move
     :parameters (?a - agent ?c - carrier ?from ?to - location)
     :duration (= ?duration (* (weigth_carrier ?c) (move_duration))) 
     :condition (and 
     		    (at start (in ?a ?from))
     		    (at start (in ?c ?from))
     		    (at start (freeAgent ?a))
     		)
     :effect (and
     	       (at start (not(freeAgent ?a))) 
               (at start (not (in ?a ?from))) 
               (at start (not (in ?c ?from))) 
               (at end (in ?a ?to)) 
               (at end (in ?c ?to)) 
               (at end (freeAgent ?a))
             )
 );end move

 (:durative-action load
     :parameters (?a - agent ?c - carrier ?p - place ?b - box ?l - location)
     :duration (= ?duration (* (weigth_box ?b) (load_duration)))
     :condition (and 
        	    (at start (freeAgent ?a))
                    (over all (in ?a ?l)) 
                    (over all (in ?c ?l))
                    (over all (in ?b ?l)) 
                    (over all(placeOnCarrier ?p ?c)) 
                    (at start(emptyPlace ?p)) 
                )
     :effect (and
     		    (at start (not(freeAgent ?a)))                
                    (at start(not(in ?b ?l))) 
                    (at end(boxOnPlace ?b ?p))
                    (at end(not(emptyPlace ?p))) 
                    (at end(fullPlace ?p))
                    (at end (increase (weigth_carrier ?c) (weigth_box ?b)))
                    (at end(freeAgent ?a))
               ) 
);load


(:durative-action unload
     :parameters (?a - agent ?c - carrier ?p - place ?b - box ?l - location)
     :duration (= ?duration (* (weigth_box ?b) (load_duration)))
     :condition (and 
        	    (at start (freeAgent ?a))
                    (over all(in ?a ?l)) 
                    (over all(in ?c ?l)) 
                    (at start(boxOnPlace ?b ?p)) 
                    (over all(placeOnCarrier ?p ?c)) 
                    (at start(fullPlace ?p)) 
               )
     :effect (and 
        	    (at start (not(freeAgent ?a)))
                    (at start(in ?b ?l)) 
                    (at end(not (boxOnPlace ?b ?p))) 
                    (at end(not (fullPlace ?p))) 
                    (at end(emptyPlace ?p))
                    (at end (decrease (weigth_carrier ?c) (weigth_box ?b)))
                    (at end (freeAgent ?a))
               )
);unload


(:durative-action vent
     :parameters (?a - agent ?b - box ?c - content ?p - person ?l - location)
     :duration (= ?duration (* (weigth_content ?c) (fill_duration)))
     :condition (and 
     		    (at start (freeAgent ?a))
                    (at start (inBox ?b ?c)) 
                    (over all (in ?a ?l)) 
                    (over all (in ?b ?l)) 
                    (over all (in ?p ?l))
                    (at start (need ?p ?c)) 
                    (over all (needAll ?p)) 
               )
     :effect (and 
     		    (at start (not(freeAgent ?a)))
                    (at end (not (inBox ?b ?c))) 
                    (at end (emptyBox ?b)) 
                    (at end (not (need ?p ?c))) 
                    (at end (has ?p ?c))
                    (at end (decrease (weigth_box ?b) (weigth_content ?c)))
                    ;(at end (assign ()))
                    (at end (freeAgent ?a))
               )
);vent

;(:action ventOr ;gestione or
;     :parameters (?a - agent ?b - box ?c - content ?p - person ?l - location)
;     :precondition (and (inBox ?b ?c) (in ?a ?l) (in ?b ?l) (in ?p ?l) (need ?p ?c) (needSomething ?p))
;     :effect (and (not (inBox ?b ?c)) (emptyBox ?b) (not (need ?p ?c)) (not (needSomething ?p)) (hasSomething ?p) )
;)

(:durative-action fill
     :parameters (?a - agent ?b - box ?c - content ?l - location)
     :duration (= ?duration (* (weigth_content ?c) (fill_duration)))
     :condition (and 
     		    (at start (freeAgent ?a))
                    (at start(emptyBox ?b)) 
                    (over all(in ?a ?l)) 
                    (over all(in ?b ?l)) 
                    (over all(in ?c ?l))
               )
     :effect (and 
     	       (at start (not(freeAgent ?a))) 
               (at end (not(emptyBox ?b))) 
               (at end (inBox ?b ?c))
               (at end (increase (weigth_box ?b) (weigth_content ?c)))
               (at end (freeAgent ?a))
          )
);fill

)
