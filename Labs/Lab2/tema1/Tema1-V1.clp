(deffacts coloring
    (countries)
    (colornumber)
    (neighbors)
    (res)
)

(defrule input_countries
    =>
    (printout t "Enter countries separated by spaces: " crlf)
    (assert (countries (explode$ (readline))))
)

(defrule input_neighbors
    =>
    (printout t "Enter neighbors separated by spaces, followed by 'done': " crlf)
    (assert (neighbors (explode$ (readline))))
)

(defrule neighbors_input_cont
    (neighbors ?c1 ?c2)
    =>
    (printout t "Neighbors: " ?c1 " " ?c2 crlf)
    (assert (neighbors (explode$ (readline))))
)

(defrule neighbors_input_done
    (neighbors done)
    =>
    (printout t "Done reading neighbors" crlf)
    ; (assert (all-neighbors-read))
)

; (defrule print_countries
;     (print-countries)
;     (countries $? ?c $?)
;     =>
;     (printout t "Countries: " ?c crlf)
; )


(defrule initialize_countries
    (countries $? ?c $?)
    =>
    (assert (res ?c 1))
)

(defrule input_colors
    =>
    (printout t "Enter number of colors " crlf)
    (assert (colornumber (read)))
    (assert (print-sol-dir))
    (assert (start-coloring))
    ; (assert (start-test))
    ; (assert (print-countries))
    ; (assert (print-sol-dir))
)

(defrule print_sol
    (res ?c ?col)
    ?a <- (print-sol-dir)
    =>
    (printout t "res: " ?c " " ?col crlf)
)


(defrule improve
    (start-coloring)
    (neighbors ?a ?b)
    (res ?a ?col)
    (res ?b ?col)
    =>
    (assert (increase ?a))
)

(defrule increase_color
    ?b<-(increase ?c1)
    ?a<-(res ?c1 ?col)
    (colornumber ?colnum&:(> ?colnum ?col))
    =>
    (retract ?a)
    (retract ?b)
    (bind ?newcol (+ ?col 1))
    (assert (res ?c1 ?newcol))
    (assert (print-sol-dir))
    ; (assert (print-sol-dir))
)

(defrule test-no-solution
    ?a<-(increase ?c1)
    (res ?c1 ?col)
    (not (colornumber ?colnum&:(> ?colnum ?col)))
    =>
    (printout t "coloring impossible" crlf)
    (retract ?a)
)








; (defrule print_countries
;     (all-neighbors-read)
;     (countries $? ?c $?)
;     =>
;     (printout t "Countries: " ?c crlf)
; )

; (defrule print_colors
;     (colors $? ?c $?)
;     =>
;     (printout t "colors: " ?c crlf)
; )

; (defrule test-start
;     (start-test)
;     =>
;     ; (printout t "start test by typing test-now" crlf)
;     (assert (test-now))
; )

; (defrule test
;     ?a<-(test-now)
;     =>
;     (retract ?a)
;     (assert (print-sol-dir))
;     (assert (increase A))
; )