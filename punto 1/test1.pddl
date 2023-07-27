(define (problem test1)
  (:domain punto1)

  (:objects
   a1 - agent
   c1 - carrier
   l1 l2 l3 - location
   p1 p2 p3 - person
   b1 b2 - box
   f - food
   m1 m2 - medicine
   t - tools)

  (:init
   (in a1 l1)
   (in c1 l1)
   (in b1 l1)
   (in b2 l1)
   
   (in f l1)
   (in m1 l1)
   (in m2 l1)
   (in t l1)
   
   (in p1 l2)
   (in p2 l3)
   (in p3 l3)
   
   (empty b1)
   (empty b2)
   
   (need p1 m1)
   (need  p1 f)
   (need  p2 m2)
   (need p3 t)
)

;; the task is to move all containers to locations l2
;; ca and cc in pile p2, the rest in q2
  (:goal
    (and (has p1 f) (has p1 m1) (has p2 m2) (has p3 t))
  )
)