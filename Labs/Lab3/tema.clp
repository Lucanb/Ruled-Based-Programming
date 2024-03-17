(deftemplate student
   (slot nume)
   (slot prenume )
   (slot laborator (default 0))
   (slot examen (default 0))
   (slot proiect (default 0))
   (slot medie (default 0))
)

(deffacts fapte_initiale
   (meniu)
)

(defrule afiseaza_meniu
   ?a<-(meniu)
   =>
   (retract ?a)
   (printout t "1. Adaugă un student" crlf)
   (printout t "2. Adaugă punctaje la laborator pentru un student" crlf)
   (printout t "3. Adaugă punctaj la examen pentru un student" crlf)
   (printout t "4. Adaugă punctaj la proiect pentru un student" crlf)
   (printout t "5. Afișează situație student" crlf)
   (printout t "6. Afișează studenții promovați și cei nepromovați" crlf)
   (printout t "7. Ieșire" crlf)
   (printout t "Dati optiunea. " crlf)
   (assert (optiune (read)))
)

(defrule adauga_student
   ?a<-(optiune 1)
   =>
   (retract ?a)
   (printout t "Dati numele studentului : " crlf)
   (bind ?nume (read))
   (printout t "Dati prenumele studentului : " crlf)
   (bind ?prenume (read))
   (assert (student (nume ?nume) (prenume ?prenume)))
   (assert (meniu))
)

(defrule not_student
   (not (student (nume ?n) (prenume ?p)))
   =>
   (printout t "Niciun student inserat. " crlf)
   (assert (meniu))
)

(defrule student_ales
      (or (optiune 2) (optiune 3) (optiune 4) (optiune 5))
=>
      (printout t "Introduceti numele studentului : " crlf)
      (bind ?nume (read))
      (assert (nume_ales ?nume))
)

(defrule not_exist_student
   (or (optiune 2) (optiune 3) (optiune 4) (optiune 5))
   ?a <- (optiune ?)
   ?x <- (nume_ales ?nume)
   (not (student (nume ?nume)))
   =>
   (retract ?x)
   (retract ?a)
   (assert (meniu))
   (printout t "Studentul nu exista. Ati fost reintrodus in meniu. " crlf)
)

(defrule adauga_puncte_laborator
   ?a<-(optiune 2)
      ?x<-(nume_ales ?nume)
   ?b<-(student (nume ?nume))
   =>
   (retract ?x)
   (retract ?a)
   (printout t "Dati punctaje : " crlf)
   (bind ?puncte (read))
   (modify ?b (laborator ?puncte))
   (assert (meniu))
)

(defrule adauga_puncte_examen
   ?a<-(optiune 3)
   ?x<-(nume_ales ?nume)
   ?b<-(student (nume ?nume))
   =>
   (retract ?x)
   (retract ?a)
   (printout t "Dati punctajul la examen : " crlf)
   (bind ?punctaj (read))
   (modify ?b (examen ?punctaj))
   (assert (meniu))
)

(defrule adauga_puncte_proiect
   ?a<-(optiune 4)
   ?x<-(nume_ales ?nume)
   ?b<-(student (nume ?nume))
   =>
   (retract ?x)
   (retract ?a)
   (printout t :"Dati punctajul la proiect : " crlf)
   (bind ?punctaj (read))
   (modify ?b (proiect ?punctaj))
   (assert (meniu))
)

(defrule modifica_medie
   (declare (salience 1))
   (optiune 6)
   ?a<-(student (nume ?x)(laborator ?y)(examen ?z)(proiect ?w))
   
   (student (nume ?x)(medie 0))
   =>
   (bind ?m (/ (+ ?y ?z ?w) 3))
   (modify ?a (medie ?m))
)

(defrule afiseaza_situatie_student
   ?a<-(optiune 5)
   ?x<-(nume_ales ?nume)
   ?b<-(student (nume ?nume) (prenume ?prenume) (laborator ?lab) (examen ?ex) (proiect ?pr) (medie ?med))
   =>
   (retract ?a)
   (retract ?x)
   (printout t "Nume: " ?nume crlf)
   (printout t "Prenume: " ?prenume crlf)
   (printout t "Punctaje laborator: " ?lab crlf)
   (printout t "Punctaj examen: " ?ex crlf)
   (printout t "Punctaj proiect: " ?pr crlf)
   (printout t "Media: " ?med crlf)
   (assert (meniu))
)

(defrule afiseaza-promovati
  ?optiune <- (optiune 6)
  (student (nume ?n) (medie ?m))
  (test (>= ?m 5))
  =>
  (printout t "Studentul " ?n " este promovat cu media " ?m crlf)
)

(defrule afiseaza-nepromovati
  ?optiune <- (optiune 6)
  (student (nume ?n) (medie ?m))
  (test (< ?m 5))
  =>
  (printout t "Studentul " ?n " nu este promovat, avand media " ?m crlf)
)

(defrule sfarsit-optiune (declare (salience -1))
  ?optiune <- (optiune 6)
  =>
  (retract ?optiune)
  (assert (meniu))
) 
