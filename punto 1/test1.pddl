(define (problem test1)
  (:domain punto1)

  (:objects
   a1 - agent
   c1 - carrier
   l1 l2 l3 - location
   p1 p2 - person
   b1 b2 - box
   f - food
   m - medicine)

  (:init
   (in a1 l1)
   (in c1 l1)
   (in b1 l1)
   (in b2 l1)
   (in p1 l2)
   (in f l1)
   (in m l1)
   (in p2 l3)
   (empty b1)
   (empty b2)
   (need  p1 f)
   (need  p2 m)
)

;; the task is to move all containers to locations l2
;; ca and cc in pile p2, the rest in q2
  (:goal
    (and (has p1 f) (has p2 m))
  )
)