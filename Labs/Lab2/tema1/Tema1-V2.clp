(defrule citeste-tari
    =>
    (printout t "Introduceti lista de tari:" crlf)
    (assert (tari (explode$ (readline))))
)

(defrule tari-null
    ?a <- (tari)
    =>
    (printout t "Lista de tari nu poate sa fie goala." crlf)
    (printout t "Introduceti lista de tari:" crlf)
    (assert (tari (explode$ (readline))))
    (retract ?a)
)

(defrule citeste-culori
    =>
    (printout t "Introduceti lista de culori:" crlf)
    (assert(culori (explode$ (readline))))
)

(defrule culori-null
    ?a <- (culori)
    =>
    (printout t "Lista de culori nu poate sa fie goala." crlf)
    (printout t "Introduceti lista de culori:" crlf)
    (assert(culori (explode$ (readline))))
    (retract ?a)
)

(defrule citeste-vecini
    (tari $? ?tara $?)
    => 
    (printout t "Introduceti vecinii pentru " ?tara ":" crlf)
    (assert (vecini ?tara (explode$ (readline))))
)

(defrule verifica-vecini
    (tari $? ?tara $?)
    (vecini ?tara $? ?vecin $?)
    (not (tari $? ?vecin $?))
    =>
    (printout t "Vecinii introdusi nu se afla in lista de tari." crlf)
    (printout t "Reintroduceti vecinii pentru " ?tara ":" crlf)
    (assert (vecini ?tara (explode$ (readline))))
)

(defrule creeaza-vecin
    (vecini ?tara1 $? ?tara2 $?)
    => 
    (assert (vecin ?tara1 ?tara2))
)

(defrule creeaza-domenii
    (tari $? ?tara $?)
    (culori $?x)
    =>
    (assert (domeniu ?tara $?x))
)

(defrule verifica-domenii-done
    (tari $?)
    (forall (tari $? ?tara $?) (domeniu ?tara $?))
    => 
    (assert (done domenii))
)

(defrule verifica-vecini-done
    (tari $?)
    (forall (tari $? ?tara $?) (vecini ?tara $?))
    =>
    (assert(done vecini))
    (assert(asignare))
)

(defrule elimina-vecini
    (done vecini)
    ?a <- (vecini $?)
    =>
    (retract ?a)
)

(defrule colorare-tara
    (done domenii)
    (done vecini)
    (or (asignare) (and (asignare $? ?ultima-tara) (modifica domenii done ?ultima-tara)))
    (tari $? ?tara $?)
    ?a <- (asignare $?x)
    (not (culoare ?tara $?))
    (domeniu ?tara $? ?cul $?)
    => 
    (assert (culoare ?tara ?cul))
    (retract ?a)
    (assert (asignare $?x ?tara))
)

(defrule modifica-domenii
    (tari $? ?tara $?)
    (culoare ?tara ?cul)
    (vecin ?tara ?vecin)
    ?a <- (domeniu ?vecin $?x ?cul $?y)
    => 
    (retract ?a)
    (assert (domeniu ?vecin $?x $?y))
)

(defrule modifica-domenii-done
    (tari $? ?tara $?)
    (culoare ?tara ?cul)
    (forall (vecin ?tara ?vecin) (not(domeniu ?vecin $? ?cul $?)))
    => 
    (assert (modifica domenii done ?tara))
)

(defrule colorare-done
    (tari $?)
    (forall (tari $? ?tara $?) (culoare ?tara $?))
    =>
    (assert (done colorare))
)

(defrule verifica-colorare
    (tari $? ?tara $?)
    (domeniu ?tara)
    (not (culoare ?tara $?))
    =>
    (assert (coloration impossible))
    (printout t "Colorarea este imposibila." crlf)
)

(defrule afiseaza-colorare
    (not (coloration impossible))
    (culoare ?tara ?cul)
    =>
    (printout t "Tara: " ?tara " e colorata cu: " ?cul crlf)
)