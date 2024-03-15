(deftemplate Tara
    (multislot nume (type STRING))
)

(deftemplate Culori
    (multislot culori (type STRING))
)

(deftemplate Vecini
    (multislot vecini (type STRING))
)

(deffacts initial
    (done-reading-neighbors false)
)

(defrule Citeste-Tara
    (not (exists (Tara)))
    =>
    (printout t "Introduceti numele tarilor separate prin spatiu: ")
    (bind ?input (readline))
    (assert (Tara (nume ?input)))
)

(defrule Citeste-Culori
    (not (exists (Culori)))
    =>
    (printout t "Introduceti culorile separate prin spatiu: ")
    (bind ?input (readline))
    (assert (Culori (culori ?input)))
)

(defrule Citeste-Vecini
    (not (exists (Vecini)))
    =>
    (printout t "Introduceti vecinii tarii separate prin perechi de tari despartite de virgula si perechi separate de spatiu: ")
    (bind ?input (readline))
    (assert (Vecini (vecini ?input)))
    (assert (done-reading-neighbors true))
)

; (deffunction afiseaza-tari ()
;     (printout t "Lista tarilor: ")
;     (printout t (implode$ (get-fact-list (Tara)) " ") crlf)
; )

; (deffunction afiseaza-culori ()
;     (printout t "Lista culorilor: ")
;     (printout t (implode$ (get-fact-list (Culori)) " ") crlf)
; )

; (deffunction afiseaza-vecini ()
;     (printout t "Lista vecinilor: ")
;     (printout t (implode$ (get-fact-list (Vecini)) " ") crlf)
; )

; (defrule asociaza-culoare
;     (done-reading-neighbors)
;     ?t <- (Tara (nume ?tara))
;     ?c <- (Culori (culori $?culori))
;     (not (asociere ?tara ?c))
;     (not (exists (Vecini (vecini $?vecini))))
;     (test (member$ ?tara ?vecini))
;     =>
;     (assert (asociere ?tara ?c))
;     (retract ?t)
;     (assert (done-color-association))
; )

; (defrule afiseaza-asociatii
;     (done-color-association)
;     ?a <- (asociere ?tara ?culoare)
;     =>
;     (printout t "Tara " ?tara " are culoarea " ?culoare crlf)
; )

; (defrule no-solution
;     (exists (Tara (nume ?tara)))
;     (not (exists (Culori)))
;     =>
;     (printout t "Nicio solutie gasita pentru tara: " ?tara crlf)
;     (retract (Tara (nume ?tara)))
; )