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
    (assert (arbore E ruleE)))

(defrule ruleR1
    ?a <- (input R $?x)
=>
    (retract ?a)
    (assert (input + E))
    (assert (lastinput R $?x))
    (assert (arbore R ruleR1)))

(defrule ruleR2
    ?a <- (input R $?x)
=>
    (retract ?a)
    (assert (input $?x))
    (assert (arbore R ruleR2)))

(defrule ruleT
    ?a <- (input T $?x)
=>
    (retract ?a)
    (assert (input F S $?x))
    (assert (arbore T ruleT)))

(defrule ruleS1
    ?a <- (input S $?x)
=>
    (retract ?a)
    (assert (input * T $?x))
    (assert (lastinput S $?x))
    (assert (arbore S ruleS1)))

(defrule ruleS2
    ?a <- (input S $?x)
=>
    (retract ?a)
    (assert (input $?x))
    (assert (arbore S ruleS2)))

(defrule ruleF
    ?a <- (input F $?x)
=>
    (retract ?a)
    (assert (input n $?x))
    (assert (arbore F ruleF)))

(defrule notTerminal
    ?b <- (input ?y $?x)
    ?a <- (output ?y $?w)
    ?c <- (resolved $?z)
=>
    (retract ?a ?c ?b)
    (assert (resolved $?z ?y))
    (assert (output $?w))
    (assert (input $?x))
    (assert (arbore ?y notTerminal)))

(defrule notTerminalFalse
    ?p <- (input ?y $?x)
    (output ?z $?a)
    ?w <- (lastinput ? $?b)
    (test (neq ?y ?z))
=>
    (retract ?w ?p)
    (assert (lastinput $?b))
    (assert (input $?b))
    (assert (arbore ?y notTerminalFalse)))

(defrule finish
    (input $)
=>
    (printout t "Finish" crlf))