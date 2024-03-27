limba(armeana).
limba(persana).
limba(greaca).
limba(aramaica).

salal(X,Y) :- limba(X), limba(Y), X\==Y, X\=persana, Y\=persana, X\=armeana ; limba(X), limba(Y), X\==Y, X\=persana, Y\=persana, X\=aramica ; limba(X), limba(Y), X\==Y, X\=persana, Y\=persana, Y\=aramica ; limba(X), limba(Y), X\==Y, X\=persana, Y\=persana, Y\=armeana.
eber(aramaica,Y) :- limba(Y), Y \== aramaica.
zamam(X,Y) :- limba(X), limba(Y), X\==Y, X \==aramaica, Y\==aramaica.
atar(X,Y) :- limba(X), limba(Y), X\==Y, X\== aramaica ; limba(X), limba(Y), X\==Y, Y\== aramaica ; limba(X), limba(Y), X\==Y, X\== armeana ; limba(X), limba(Y), X\==Y, Y\== armeana.
regula1(salal(X, _), eber(X, _)).
regula2(salal(_, Y), atar(_, Y)).
regula3(eber(aramaica, Y), zamam(_, Y)).
regula4(salal(X, Y), atar(W, Z)) :- X == W ; X == Z ; Y == W ; Y == Z.
regula5(salal(X, Y), zamam(W, Z)) :- X == W ; X == Z ; Y == W ; Y == Z.
regula6(atar(X, Y), zamam(W, Z)) :- X == W ; X == Z ; Y == W ; Y == Z.