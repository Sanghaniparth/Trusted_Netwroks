breed [clients client]
breed [servers server]

clients-own [
  similarity  ;; Similarity threshold
  trust-level ;; Trust behavior
  risk        ;; Risk assessment
]

servers-own [
  trust-level ;; Trust behavior
  similarity ;; Similarity
  risk ;; Risk
]

to setup
  clear-all
  create-clients 50 [
    setxy random-xcor random-ycor
   ;set similarity 0.7
   set trust-level 0.6
   ;set risk random-float 0.7

  ]
  create-servers 10 [
    setxy random-xcor random-ycor
    ;set trust-level 0.3
    set similarity 0.9

    set risk random-float 0.7
  ]
  reset-ticks
end

to go
  ask clients
  [

    let target one-of servers
    if target != nobody
    [
      move-to target

      ; Calculate Euclidean distance as a measure of similarity
      let dist distance target
      let max-dist max-pxcor * 2 ; Max possible distance in the world

      ; Calculate similarity score based on distance
      let similarity-score 1 - (dist / max-dist)

      ; Assess trust based on similarity and risk
      ifelse similarity-score > [similarity] of target and [risk] of target < 0.4
      [
        ; If similarity is high and risk is low, trust the server

        set trust-level trust-level
        print (word "Client trusts Server at " [xcor] of target ", " [ycor] of target)
      ]
      [
        ; If either similarity is low or risk is high, do not trust
        set trust-level 0
        print (word "Client does not trust Server at " [xcor] of target ", " [ycor] of target)

        ; Simulate network attacks based on trust
        ;if trust-level < 0.5
        ;[
          ; For simplicity, we'll just print a message
         ; print "Client may be under attack!"
        ;]
      ]
    ]
  ]
  tick
end
;to attack
  ;let target one-of servers
  ;if target != nobody [
  ;  print (word "Server at " [xcor] of target ", " [ycor] of target " is under attack!")
 ; ]
;end
to trustlevel
  ask clients [
    print (word "Client at " xcor " " ycor " has trust level: " trust-level )
    ifelse trust-level < 0.5
    [
      print "Client may be under attack"
    ]
    [
      print  "Client is safe "
    ]
  ]
end

to iterate-go
  repeat 10 [go]
end

;setup
;iterate-go
