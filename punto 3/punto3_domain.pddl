(define (domain punto1)
 (:requirements :strips :typing :durative-actions :fluents)
 
 (:types
  ;food - content
  ;medicine - content
  ;tools - content
  content - localizable
  location - localizable
  person - localizable
  agent - localizable
  box - localizable
  carrier - localizable
  place - localizable ;posto sul carrier per la box
)


(:functions
     (weigthbox ?b - box)
     (weigthcarrier ?c - carrier)
     (weigthcontent ?c - content)
     (moveduration)
     (fillduration)
     (loadduration)
)


 (:predicates
   (in ?o - localizable ?l - location)
   (need  ?p - person ?c - content)
   (has ?p - person ?c - content)
   (hassomething ?p - person) ;gestione or
   (inbox ?b - box ?c - content)
   (emptybox ?b - box)
   (boxonplace ?b - box ?p - place) 
   (emptyplace ?p - place) ;per gestire la load
   (fullplace ?p - place) ;per gestire l'unload
   (placeoncarrier ?p - place ?c - carrier)
   (freeagent ?g - agent) ;ci dice se l'agent g è libero oppure no
   (needall ?p - person) ;gestione or
   (needsomething ?p - person)
   
  )

 (:durative-action move
     :parameters (?a - agent ?c - carrier ?from - location ?to - location)
     :duration (= ?duration (* (weigthcarrier ?c) (moveduration))) 
     :condition (and 
     		    (at start (in ?a ?from))
     		    (at start (in ?c ?from))
     		    (at start (freeagent ?a))
     		)
     :effect (and
     	     (at start (not(freeagent ?a))) 
               (at start (not (in ?a ?from))) 
               (at start (not (in ?c ?from))) 
               (at end (in ?a ?to)) 
               (at end (in ?c ?to)) 
               (at end (freeagent ?a))
             )
 );end move

 (:durative-action load
     :parameters (?a - agent ?c - carrier ?p - place ?b - box ?l - location)
     :duration (= ?duration (* (weigthbox ?b) (loadduration)))
     :condition (and 
        	     (at start (freeagent ?a))
               (over all (in ?a ?l)) 
               (over all (in ?c ?l))
               (over all (in ?b ?l)) 
               (over all(placeoncarrier ?p ?c)) 
               (at start(emptyplace ?p)) 
               )
     :effect (and
     	     (at start (not(freeagent ?a)))                
               (at end(not(in ?b ?l))) 
               (at start(not(emptyplace ?p))) 
               (at start(fullplace ?p))
               (at end(boxonplace ?b ?p))                    
               (at end (increase (weigthcarrier ?c) (weigthbox ?b)))
               (at end(freeagent ?a))
              ) 
);load


(:durative-action unload
     :parameters (?a - agent ?c - carrier ?p - place ?b - box ?l - location)
     :duration (= ?duration (* (weigthbox ?b) (loadduration)))
     :condition (and 
        	     (at start (freeagent ?a))
               (over all(in ?a ?l)) 
               (over all(in ?c ?l)) 
               (at start(boxonplace ?b ?p)) 
               (over all(placeoncarrier ?p ?c)) 
               (at start(fullplace ?p)) 
               )
     :effect (and 
        	     (at start (not(freeagent ?a)))
               (at start(in ?b ?l))                 
               (at start(not (fullplace ?p))) 
               (at start(emptyplace ?p))
               (at end(not (boxonplace ?b ?p)))
               (at end (decrease (weigthcarrier ?c) (weigthbox ?b)))
               (at end (freeagent ?a))
               )
);unload


(:durative-action vent
     :parameters (?a - agent ?b - box ?c - content ?p - person ?l - location)
     :duration (= ?duration (* (weigthcontent ?c) (fillduration)))
     :condition (and 
     		(at start (freeagent ?a))
               (at start (inbox ?b ?c)) 
               (over all (in ?a ?l)) 
               (over all (in ?b ?l)) 
               (over all (in ?p ?l))
               (at start (need ?p ?c)) 
               (over all (needall ?p)) 
               )
     :effect (and 
     		(at start (not(freeagent ?a)))
               (at start (emptybox ?b)) 
               (at start (not (need ?p ?c))) 
               (at end (not (inbox ?b ?c))) 
               (at end (has ?p ?c))
               (at end (decrease (weigthbox ?b) (weigthcontent ?c)))                
               (at end (freeagent ?a))
               )
);vent


(:durative-action fill
     :parameters (?a - agent ?b - box ?c - content ?l - location)
     :duration (= ?duration (* (weigthcontent ?c) (fillduration)))
     :condition (and 
     		(at start (freeagent ?a))
               (at start(emptybox ?b)) 
               (over all(in ?a ?l)) 
               (over all(in ?b ?l)) 
               (over all(in ?c ?l))
               )
     :effect (and 
     	     (at start (not(freeagent ?a))) 
               (at start (not(emptybox ?b))) 
               (at end (inbox ?b ?c))
               (at end (increase (weigthbox ?b) (weigthcontent ?c)))
               (at end (freeagent ?a))
          )
);fill

)
