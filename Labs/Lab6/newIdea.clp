(deffacts initial-input
   (input n + n * n $)
)

(deffacts grammar
    (production E (create$ T R))
    (production R (create$ ε))
    (production R (create$ + E))
    (production T (create$ F S))
    (production S (create$ ε))
    (production S (create$ * T))
    (production F (create$ n))
    (production F (create$ ( E )))
)

(deffacts parsing-table
    (parse E n (create$ T R))
    (parse E ( (create$ T R))
    (parse R + (create$ + E))
    (parse R ) (create$ ε))
    (parse R $ (create$ ε))
    (parse T n (create$ F S))
    (parse T ( (create$ F S))
    (parse S * (create$ * T))
    (parse S ) (create$ ε))
    (parse S $ (create$ ε))
    (parse F n (create$ n))
    (parse F ( (create$ ( E ))))
)

(deffacts initial-stacks
    (todo E $)
    (matched)
)

(defrule match-terminal
   ?f <- (todo ?t ?rest)
   ?input-fact <- (input ?t $?after)
   =>
   (retract ?f)
   (assert (matched ?t))
   (assert (todo ?rest))
   (retract ?input-fact)
   (if (not (eq $?after ())) then
      (assert (input $?after)))
)

(defrule expand-nonterminal
    ?f <- (todo ?n ?rest)
    ?input-fact <- (input ?lookahead $?)
    ?p <- (parse ?n ?lookahead ?production)
    =>
    (retract ?f)
    (assert (todo (explode$ ?production) ?rest))
    (retract ?p)
)

(defrule syntax-error
    (todo ?n ?rest)
    (input ?lookahead $?)
    (not (parse ?n ?lookahead ?))
    =>
    (printout t "Syntax error at token: " ?lookahead crlf)
)
