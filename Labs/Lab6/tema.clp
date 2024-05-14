(deffacts fapte_initiale
    (nonterminals E R T S F)
    (output n + n * n $)
    (input E $)
    (resolved $)
    (arbore E))

(defrule ruleE
    ?a <- (input E $?x)
=>
    (retract ?a)
    (assert (input T R))
    (assert (arbore E "E -> T R")))

(defrule ruleR1
    ?a <- (input R $?x)
=>
    (retract ?a)
    (assert (input + E))
    (assert (lastinput R $?x))
    (assert (arbore R "R -> + E")))

(defrule ruleR2
    ?a <- (input R $?x)
=>
    (retract ?a)
    (assert (input $?x))
    (assert (arbore R "R -> R expandat")))

(defrule ruleT
    ?a <- (input T $?x)
=>
    (retract ?a)
    (assert (input F S $?x))
    (assert (arbore T "T -> F S")))

(defrule ruleS1
    ?a <- (input S $?x)
=>
    (retract ?a)
    (assert (input * T $?x))
    (assert (lastinput S $?x))
    (assert (arbore S "S -> * T")))

(defrule ruleS2
    ?a <- (input S $?x)
=>
    (retract ?a)
    (assert (input $?x))
    (assert (arbore S "S -> S expandat")))

(defrule ruleF
    ?a <- (input F $?x)
=>
    (retract ?a)
    (assert (input n $?x))
    (assert (arbore F "F -> n")))

(defrule notTerminal
    ?b <- (input ?y $?x)
    ?a <- (output ?y $?w)
    ?c <- (resolved $?z)
=>
    (retract ?a ?c ?b)
    (assert (resolved $?z ?y))
    (assert (output $?w))
    (assert (input $?x))
    (assert (arbore ?y (str-cat ?y " procesat"))))

(defrule notTerminalFalse
    ?p <- (input ?y $?x)
    (output ?z $?a)
    ?w <- (lastinput ? $?b)
    (test (neq ?y ?z))
=>
    (retract ?w ?p)
    (assert (lastinput $?b))
    (assert (input $?b))
    (assert (arbore ?y (str-cat ?y " nerespectat"))))

(defrule finish
    (input $)
=>
    (printout t "Finalizat" crlf))
