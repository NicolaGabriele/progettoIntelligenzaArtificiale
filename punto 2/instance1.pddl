(define (problem instance1)
  (:domain punto1)

  (:objects
   a1 - agent
   c1 - carrier
   place1 place2 place3 place4 - place
   depot l1 l2 - location
   p1 p2 p3 - person
   b1 b2 b3 b4 b5 - box
   food medicine tools - content
  )

  (:init
   (emptyBox b1)
   (emptyBox b2)
   (emptyBox b3)
   (emptyBox b4)
   (emptyBox b5)
   (emptyPlace place1)
   (emptyPlace place2)
   (emptyPlace place3)
   (emptyPlace place4)
   
   (in a1 depot)
   (in c1 depot)
   (in b1 depot)
   (in b2 depot)
   (in b3 depot)
   (in b4 depot)
   (in b5 depot)
   (placeOnCarrier place1 c1)
   (placeOnCarrier place2 c1)
   (placeOnCarrier place3 c1)
   (placeOnCarrier place4 c1)
   
   (in food depot)
   (in medicine depot)
   (in tools depot)
   
   (in p1 l1)
   (in p2 l1)
   (in p3 l2)

   (need p1 food)
   (need p1 medicine)
   (need  p2 medicine)
   (need  p3 food)
   
   (needAll p1)
   (needAll p2)
   (needAll p3)
)

  (:goal
    (and (has p1 food) (has p1 medicine) (has p2 medicine) (has p3 food))
  )
)