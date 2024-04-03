% Verifica daca un numar este cifra
este_cifra(X) : - X >= 0, X =< 9.

% Verifica daca o lista este lista de cifre
lista_de_cifre([]).
lista_de_cifre([V|Rest]) :- este_cifra(V), lista_de_cifre(Rest).

% Verifica daca un set are elemente unice
elem_unice(List) :- conv_lista_in_mult_ordonata(List, Set), length(List, L), length(Set, L).

% Gaseste cifra de inceput
cifra_de_inceput([H|_]) :- H > 0.
% Verifica daca o lista are cifra de inceput nenula
cifra_de_inceput_nenula([], [H|_]) :- H > 0.
cifra_de_inceput_nenula([H|T], S) :- cifra_de_inceput(H), cifra_de_inceput_nenula(T, S).

% Transforma toate cifrele intr-un singur numar
creare_numar([], K, K).
creare_numar([H|T], K, Number) :- length([H|T], N),
                                       Np is K + H * 10**(N-1),
                                       creare_numar(T, Np, Number).
                                       
conv_lista_cifre_in_lista_numere([], []).
conv_lista_cifre_in_lista_numere([H|T], [J|K]) :- creare_numar(H, 0, J),
                                   conv_lista_cifre_in_lista_numere(T, K).

suma_lista([], R, R).
suma_lista([H|T], R, K) :- Rp is R + H, suma_lista(T, Rp, K).

diferenta_lista([], R, R).
diferenta_lista([H|T], R, K) :- Rp is R - H, diferenta_lista(T, Rp, K).

produs_lista([], R, R).
produs_lista([H|T], R, K) :- Rp is R * H, produs_lista(T, Rp, K).

impartire_lista([], R, R).
impartire_lista([H|T], R, K) :- Rp is R / H, impartire_lista(T, Rp, K).

% Scriere expresie din continutul listei
scrie_expresie([]) :- !.
scrie_expresie([T], _, _) :- write(T), !.
scrie_expresie([T], Op, Last) :- write(T), !.
scrie_expresie([H|T], Op, Last) :- nth0(0, T, Next),
                                      Op = '+',
                                      write(H), write(' + '),
                                      scrie_expresie(T, Op, H),
                                      !.
scrie_expresie([H|T], Op, Last) :- nth0(0, T, Next),
                                      Op = '-',
                                      write(H), write(' - '),
                                      scrie_expresie(T, Op, H),
                                      !.
scrie_expresie([H|T], Op, Last) :- nth0(0, T, Next),
                                      Op = '*',
                                      write(H), write(' * '),
                                      scrie_expresie(T, Op, H),
                                      !.
scrie_expresie([H|T], Op, Last) :- nth0(0, T, Next),
                                      Op = '/',
                                      write(H), write(' / '),
                                      scrie_expresie(T, Op, H),
                                      !.
                                
dlists_to_nums(Dlist) :- conv_lista_in_mult_ordonata(Dlist, Num_list),
                         lista_de_cifre(Num_list), elem_unice(Num_list).

% Rezolvarea propriu-zisa a expresiei                         
rezolvare_suma(Dlist, Sum) :- dlists_to_nums(Dlist), conv_lista_cifre_in_lista_numere(Dlist, Int_list),
                         suma_lista(Int_list, 0, Sum).

rezolvare_diferenta(Dlist, Diff) :- dlists_to_nums(Dlist), conv_lista_cifre_in_lista_numere(Dlist, Int_list),
                           diferenta_lista(Int_list, 0, Diff).

rezolvare_produs(Dlist, Prod) :- dlists_to_nums(Dlist), conv_lista_cifre_in_lista_numere(Dlist, Int_list),
                           produs_lista(Int_list, 1, Prod).

rezolvare_impartire(Dlist, Div) :- dlists_to_nums(Dlist), conv_lista_cifre_in_lista_numere(Dlist, Int_list),
                         impartire_lista(Int_list, 1, Div).

% Afisarea solutiei
afisare_solutie(Dlist, Sum) :- conv_lista_cifre_in_lista_numere(Dlist, Intlist),
                              creare_numar(Sum, 0, S),
                              scrie_expresie(Intlist),
                              write(' = '), write(S), nl.

afisare_solutie(Dlist, Diff) :- conv_lista_cifre_in_lista_numere(Dlist, Intlist),
                               creare_numar(Diff, 0, D),
                               scrie_expresie(Intlist),
                               write(' = '), write(D), nl.

afisare_solutie(Dlist, Prod) :- conv_lista_cifre_in_lista_numere(Dlist, Intlist),
                               creare_numar(Prod, 0, P),
                               scrie_expresie(Intlist),
                               write(' = '), write(P), nl.

afisare_solutie(Dlist, Div) :- conv_lista_cifre_in_lista_numere(Dlist, Intlist),
                              creare_numar(Div, 0, D),
                              scrie_expresie(Intlist),
                              write(' = '), write(D), nl.


% Rezolvarea si afisarea solutiei
rezolvare_si_afisare(ListList,Sum) :- rezolvare_suma(ListList, Sum),
                                 afisare_solutie(ListList, Sum).

rezolvare_si_afisare(ListList,Diff) :- rezolvare_diferenta(ListList, Diff),
                                  afisare_solutie(ListList, Diff).

rezolvare_si_afisare(ListList,Prod) :- rezolvare_produs(ListList, Prod),
                                  afisare_solutie(ListList, Prod).

rezolvare_si_afisare(ListList,Div) :- rezolvare_impartire(ListList, Div),
                                 afisare_solutie(ListList, Div).
                