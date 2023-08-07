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
   (= (weigthbox b1) 1)
   (= (weigthbox b2) 1)
   (= (weigthbox b3) 1)
   (= (weigthbox b4) 1)
   (= (weigthbox b5) 1)
   (= (weigthcarrier c1) 6)
   (= (weigthcontent medicine) 1)
   (= (weigthcontent food) 2)
   (= (weigthcontent tools) 3)
   (= (moveduration) 5)
   (= (loadduration) 3)
   (= (fillduration) 2)
   (emptybox b1)
   (emptybox b2)
   (emptybox b3)
   (emptybox b4)
   (emptybox b5)
   (emptyplace place1)
   (emptyplace place2)
   (emptyplace place3)
   (emptyplace place4)
   (freeagent a1)
   (in a1 depot)
   (in c1 depot)
   (in b1 depot)
   (in b2 depot)
   (in b3 depot)
   (in b4 depot)
   (in b5 depot)
   (placeoncarrier place1 c1)
   (placeoncarrier place2 c1)
   (placeoncarrier place3 c1)
   (placeoncarrier place4 c1)
   
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
   
   (needall p1)
   (needall p2)
   (needall p3)
)

  (:goal
    (and (has p1 food) (has p1 medicine) (has p2 medicine) (has p3 food))
  )
)
