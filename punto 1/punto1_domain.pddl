(define (domain punto1)
 (:requirements :strips :typing  :negative-preconditions)
 (:types
  food - content
  medicine - content
  tools - content
  location
  person
  agent
  box
  carrier
)

 (:constants
  )

 (:predicates
   (in ?b - object ?l - location)
   (need  ?p - person ?c - content)
   (has ?p - person ?c - content)
   (inbox ?b - box ?c - content)
   (empty ?b - box)  
   (on ?b - box ?c - carrier) 
   (full ?c - carrier)
   )

 (:action move
     :parameters (?a - agent ?c - carrier ?from ?to - location)
     :precondition (and (in ?a ?from) (in ?c ?from))
     :effect (and (in ?a ?to) (in ?c ?to) (not (in ?a ?from)) (not (in ?c ?from)))
 )

 (:action load
     :parameters (?a - agent ?c - carrier ?b - box ?l - location)
     :precondition (and (in ?a ?l) (in ?c ?l) (in ?b ?l) (not (full ?c)))
     :effect (and(on ?b ?c) (not(in ?b ?l)) (full ?c)) ;; in merito a (full ?c) per adesso assumiamo capacità unitaria
)


(:action unload
     :parameters (?a - agent ?c - carrier ?b - box ?l - location)
     :precondition (and (in ?a ?l) (in ?c ?l) (full ?c) (on ?b ?c))
     :effect (and (not (on ?b ?c)) (in ?b ?l) (not(full ?c)))
)


(:action vent
     :parameters (?a - agent ?b - box ?c - content ?p - person ?l - location)
     :precondition (and (inbox ?b ?c) (in ?a ?l) (in ?b ?l) (need ?p ?c) (in ?p ?l))
     :effect (and (not (inbox ?b ?c)) (empty ?b) (in ?c ?l) (not (need ?p ?c)) (has ?p ?c))
)


(:action fill
     :parameters (?a - agent ?b - box ?c - content ?l - location)
     :precondition (and (empty ?b) (in ?a ?l) (in ?b ?l) (in ?c ?l))
     :effect (and (not (empty ?b)) (inbox ?b ?c))
)

)