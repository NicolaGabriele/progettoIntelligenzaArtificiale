(define (problem test1)
  (:domain punto1)

  (:objects
   a1 - agent
   c1 - carrier
   place1 place2 place3 place4 - place
   l1 l2 - location
   p1 - person
   b1 b2 b3 b4 - box
   f - food
   m1 m2 - medicine
   t - tools)

  (:init
   (in a1 l1)
   (in c1 l1)
   (in b1 l1)
   (in b2 l1)
   (in b3 l1)
   (in b4 l1)
   (placeOnCarrier place1 c1)
   (placeOnCarrier place2 c1)
   (placeOnCarrier place3 c1)
   (placeOnCarrier place4 c1)
   
   (in f l1)
   (in m1 l1)
   (in m2 l1)
   (in t l1)
   
   (in p1 l2)
   
   (emptyBox b1)
   (emptyBox b2)
   (emptyBox b3)
   (emptyBox b4)

   (need p1 m1)
   (need  p1 f)
   (need  p1 m2)
   (need p1 t)
)

;; the task is to move all containers to locations l2
;; ca and cc in pile p2, the rest in q2
  (:goal
    (and (has p1 f) (has p1 m1) (has p1 m2) (has p1 t))
  )
)