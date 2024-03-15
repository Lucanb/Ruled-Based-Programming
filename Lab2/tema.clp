(defrule citire-culori
    =>
    (printout t "Scire culoarea sau 'done': ")
    (bind ?color (read))
    (while (neq ?color done)
        (assert (culoare ?color))
        (printout t "Scrie alta culoare : ")
        (bind ?color (read))
    )
)

(defrule citire-tari
    =>
    (printout t "Scrie o tara sau 'done : ")
    (bind ?country (read))
    (while (neq ?country done)
        (assert (tara ?country))
        (printout t "Scrie alta tara sau 'done' : ")
        (bind ?country (read))
    )
)

(defrule citire-vecini
    =>
    (printout t "Scrie o tara sau 'done : ")
    (bind ?country (read))
    (while (neq ?country done)
        (printout t "Screi vecin " ?country " sau done : ")
        (bind ?neighbor (read))
        (if (neq ?neighbor done) then
            (assert (vecin ?country ?neighbor))
        )
        (printout t "Scrie o tara sau 'done' : ")
        (bind ?country (read))
    )
    (assert (terminat-vecini))
)


(defrule asociaza-culoare
    (terminat-vecini)
    ?t <- (tara ?tara)
    (culoare ?culoare)
    (not (asociere ?tara ?culoare))
    (not (asociere ?any ?culoare)) 
    (not (and (vecin ?tara ?vecin) (asociere ?vecin ?culoare)))
    =>
    (assert (asociere ?tara ?culoare))
    (retract ?t)
    (assert (done-color-association))
)

(defrule afiseaza-asociatii
    (done-color-association)
    (asociere ?tara ?culoare)
    =>
    (printout t "Tara " ?tara " are culoarea " ?culoare crlf)
)

(defrule no-solution
    ?t <- (tara ?tara)
    (not (culoare ?))
    =>
    (printout t "Nu avem solutie pt tara " ?tara crlf)
    (retract ?t)
)