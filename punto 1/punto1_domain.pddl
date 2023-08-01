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
   (in ?o - object ?l - location)
   (need  ?p - person ?c - content)
   (has ?p - person ?c - content)
   (inBox ?b - box ?c - content)
   ;(emptyBox ?b - box)  
   (fullBox ?b - box)
   (boxOnPlace ?b - box ?p - place) 
   ;(fullCarrier ?c - carrier)
   ;(emptyCarrier ?c - carrier)
   (fullPlace ?p - place)
   (placeOnCarrier ?p - place ?c - carrier)
   
   (noPreference ?p - person) ;gestione or
   (hasSomething ?p - person) ;gestione or
   
  )

 (:action move
     :parameters (?a - agent ?c - carrier ?from ?to - location)
     :precondition (and (in ?a ?from) (in ?c ?from))
     :effect (and (in ?a ?to) (in ?c ?to) (not (in ?a ?from)) (not (in ?c ?from)))
 )

 (:action load
     :parameters (?a - agent ?c - carrier ?p - place ?b - box ?l - location)
     :precondition (and (in ?a ?l) (in ?c ?l) (in ?b ?l) (placeOnCarrier ?p ?c) (not (fullPlace ?p)) )
     :effect (and(boxOnPlace ?b ?p) (not(in ?b ?l)) (fullPlace ?p) ) 
)


(:action unload
     :parameters (?a - agent ?c - carrier ?p - place ?b - box ?l - location)
     :precondition (and (in ?a ?l) (in ?c ?l) (boxOnPlace ?b ?p) (placeOnCarrier ?p ?c) (fullPlace ?p) )
     :effect (and (not (boxOnPlace ?b ?p)) (in ?b ?l) (not (fullPlace ?p)) )
)


(:action vent
     :parameters (?a - agent ?b - box ?c - content ?p - person ?l - location)
     :precondition (and (inBox ?b ?c) (in ?a ?l) (in ?b ?l) (in ?p ?l) (need ?p ?c) (not (noPreference ?p)) )
     :effect (and (not (inBox ?b ?c)) (not (fullBox ?b)) (not (need ?p ?c)) (has ?p ?c))
)

(:action vent ;gestione or
     :parameters (?a - agent ?b - box ?c - content ?p - person ?l - location)
     :precondition (and (inBox ?b ?c) (in ?a ?l) (in ?b ?l) (in ?p ?l) (not (hasSomething ?p)) (need ?p ?c) (noPreference ?p))
     :effect (and (not (inBox ?b ?c)) (not (fullBox ?b)) (not (need ?p ?c)) (hasSomething ?p) )
)


(:action fill
     :parameters (?a - agent ?b - box ?c - content ?l - location)
     :precondition (and (not (fullBox ?b)) (in ?a ?l) (in ?b ?l) (in ?c ?l))
     :effect (and (fullBox ?b) (inBox ?b ?c))
)

)