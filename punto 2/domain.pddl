(define (domain punto1)
 (:requirements :strips :typing)
 
 (:types
  content
  location
  person
  agent
  box
  carrier
  place 
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
   (needAll ?p - person) ;gestione or
   (needSomething ?p - person) 
  )

 (:action move
     :parameters (?a - agent ?c - carrier ?from ?to - location)
     :precondition (and (in ?a ?from) (in ?c ?from))
     :effect (and (in ?a ?to) (in ?c ?to) (not (in ?a ?from)) (not (in ?c ?from)))
 )

 (:action load
     :parameters (?a - agent ?c - carrier ?p - place ?b - box ?l - location)
     :precondition (and (in ?a ?l) (in ?c ?l) (in ?b ?l) (placeOnCarrier ?p ?c) (emptyPlace ?p) )
     :effect (and(boxOnPlace ?b ?p) (not(in ?b ?l)) (not(emptyPlace ?p)) (fullPlace ?p) ) 
)


(:action unload
     :parameters (?a - agent ?c - carrier ?p - place ?b - box ?l - location)
     :precondition (and (in ?a ?l) (in ?c ?l) (boxOnPlace ?b ?p) (placeOnCarrier ?p ?c) (fullPlace ?p) )
     :effect (and (not (boxOnPlace ?b ?p)) (in ?b ?l) (not (fullPlace ?p)) (emptyPlace ?p) )
)


(:action vent
     :parameters (?a - agent ?b - box ?c - content ?p - person ?l - location)
     :precondition (and (inBox ?b ?c) (in ?a ?l) (in ?b ?l) (in ?p ?l) (need ?p ?c) (needAll ?p) )
     :effect (and (not (inBox ?b ?c)) (emptyBox ?b) (not (need ?p ?c)) (has ?p ?c))
)

(:action ventOr ;gestione or
     :parameters (?a - agent ?b - box ?c - content ?p - person ?l - location)
     :precondition (and (inBox ?b ?c) (in ?a ?l) (in ?b ?l) (in ?p ?l) (need ?p ?c) (needSomething ?p))
     :effect (and (not (inBox ?b ?c)) (emptyBox ?b) (not (need ?p ?c)) (not (needSomething ?p)) (hasSomething ?p) )
)

(:action fill
     :parameters (?a - agent ?b - box ?c - content ?l - location)
     :precondition (and (emptyBox ?b) (in ?a ?l) (in ?b ?l) (in ?c ?l))
     :effect (and (not(emptyBox ?b)) (inBox ?b ?c))
)

)