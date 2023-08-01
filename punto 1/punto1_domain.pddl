(define (domain punto1)
 (:requirements :strips :typing)
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

 (:constants
 )

 (:predicates
   (in ?b - object ?l - location)
   (need  ?p - person ?c - content)
   (has ?p - person ?c - content)
   (inbox ?b - box ?c - content)
   (emptyBox ?b - box)  
   (on ?b - box ?c - carrier) 
   ;(fullCarrier ?c - carrier)
   ;(emptyCarrier ?c - carrier)
   (placeOccupied ?p - place)
   (placeOnCarrier ?p - place ?c - carrier)
  )

 (:action move
     :parameters (?a - agent ?c - carrier ?from ?to - location)
     :precondition (and (in ?a ?from) (in ?c ?from))
     :effect (and (in ?a ?to) (in ?c ?to) (not (in ?a ?from)) (not (in ?c ?from)))
 )

 (:action load
     :parameters (?a - agent ?c - carrier ?p - place ?b - box ?l - location)
     :precondition (and (in ?a ?l) (in ?c ?l) (in ?b ?l) (placeOnCarrier ?p ?c) (not (placeOccupied ?p)) )
     :effect (and(on ?b ?c) (not(in ?b ?l)) (placeOccupied ?p) ) ;; in merito a (empty e full ?c) per adesso assumiamo capacità unitaria
)


(:action unload
     :parameters (?a - agent ?c - carrier ?p - place ?b - box ?l - location)
     :precondition (and (in ?a ?l) (in ?c ?l) (on ?b ?c) (placeOnCarrier ?p ?c) (placeOccupied ?p) )
     :effect (and (not (on ?b ?c)) (in ?b ?l) (not (placeOccupied ?p)) )
)


(:action vent
     :parameters (?a - agent ?b - box ?c - content ?p - person ?l - location)
     :precondition (and (inbox ?b ?c) (in ?a ?l) (in ?b ?l) (need ?p ?c) (in ?p ?l))
     :effect (and (not (inbox ?b ?c)) (emptyBox ?b) (not (need ?p ?c)) (has ?p ?c))
)


(:action fill
     :parameters (?a - agent ?b - box ?c - content ?l - location)
     :precondition (and (emptyBox ?b) (in ?a ?l) (in ?b ?l) (in ?c ?l))
     :effect (and (not (emptyBox ?b)) (inbox ?b ?c))
)

)