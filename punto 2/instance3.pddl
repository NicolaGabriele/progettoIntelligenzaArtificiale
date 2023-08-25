(define (problem instance3)
  (:domain punto1)

  (:objects
   a1 a2 - agent
   c1 c2 - carrier
   place1 place2 place3 place4 - place
   depot l1 l2 l3 l4 l5 l6 l7 - location
   p1 p2 p3 p4 p5 p6 p7 p8 - person
   b1 b2 b3 b4 - box
   food medicine tools - content
  )

  (:init
   (emptyBox b1)
   (emptyBox b2)
   (emptyBox b3)
   (emptyBox b4)
   (emptyPlace place1)
   (emptyPlace place2)
   (emptyPlace place3)
   (emptyPlace place4)
  
   
   (in a1 depot)
   (in a2 depot)
   (in c1 depot)
   (in c2 depot)
   (in b1 depot)
   (in b2 depot)
   (in b3 depot)
   (in b4 depot)
   (placeOnCarrier place1 c1)
   (placeOnCarrier place2 c1)
   (placeOnCarrier place3 c2)
   (placeOnCarrier place4 c2)
   
   (in food depot)
   (in medicine depot)
   (in tools depot)
   
   (in p1 l1)
   (in p2 l1)
   (in p3 l2)
   (in p4 l3)
   (in p5 l4)
   (in p6 l5)
   (in p7 l6)
   (in p8 l7)

   (need p1 food)
   (need p1 tools) 
   (need p2 medicine)
   (need p3 medicine)
   (need p4 medicine)
   (need p4 food)
   (need p5 medicine)
   (need p5 food)
   (need p5 tools)
   (need p6 medicine)
   (need p6 food)
   (need p6 tools)
   (need p7 medicine)
   (need p7 food)
   (need p7 tools)
   (need p8 medicine)
   (need p8 food)
   (need p8 tools)
   
   (needSomething p1)
   (needAll p2)
   (needAll p3)
   (needAll p4)
   (needAll p5)
   (needAll p6)
   (needAll p7)
   (needAll p8)
)

  (:goal
    (and (hasSomething p1) (has p2 medicine) (has p3 medicine) (has p4 medicine) (has p4 food)
    (has p5 food) (has p5 medicine) (has p5 tools)
    (has p6 food) (has p6 medicine) (has p6 tools)
    (has p7 food) (has p7 medicine) (has p7 tools)
    (has p8 food) (has p8 medicine) (has p8 tools)) ;pddl1.2 supporta or in preconditions e goal
  )
  
)