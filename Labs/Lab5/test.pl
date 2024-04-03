% Predicate to check if each character in a word is different and matches a digit from 0 to 9
validWord([]).
validWord([X|Rest]) :-
    member(X, [0,1,2,3,4,5,6,7,8,9]),
    \+ member(X, Rest),
    validWord(Rest).

% Predicate to assign digits to letters in the list
assign([]).
assign([H|T]) :-
    write('Evaluare assign/1...'), nl, 
    digits(D),
    member(H, D),
    \+ member(H, T),
    assign(T).

% Predicate to convert a list of digits to a number
convert([], 0) :-
    write('Evaluare convert/1...'), nl. % Mesaj pentru confirmarea apelului predicatului convert/1.
convert([H|T], Num) :-
    write('Evaluare convert/1...'), nl, % Mesaj pentru confirmarea apelului predicatului convert/1.
    convert(T, Rest), 
    length(T, Len), 
    Exp is 10^Len,
    Num is H * Exp + Rest.

verbalArithmetic(WordList) :-
    % Mesaj pentru a confirma începutul evaluării predicatului
    write('Evaluare verbalArithmetic/1...'), nl,
    % Extragem cuvintele de adunat și rezultatul
    append(Numbers, [Result], WordList),
    % Mesaje pentru afișarea listei de cuvinte și a rezultatului
    write('Numbers: '), write(Numbers), nl,
    write('Result: '), write(Result), nl,
    % Continuăm cu codul existent...
    % Verificăm dacă fiecare cuvânt este valid
    maplist(validWord, Numbers),
    validWord(Result),
    % Afisăm valorile intermediare sau variabilele
    write('Verificări pentru cifrele de început au fost trecute cu succes.'), nl,
    write('Calculând rezultatul...'), nl,
    % Convertim fiecare cuvânt în număr
    maplist(convert, Numbers, NumbersAsNumbers),
    convert(Result, ResultAsNumber),
    % Afisăm valorile intermediare sau variabilele
    write('NumbersAsNumbers: '), write(NumbersAsNumbers), nl,
    write('ResultAsNumber: '), write(ResultAsNumber), nl,
    % Calculăm suma numerelor de adunat
    sum_list(NumbersAsNumbers, Sum),
    % Mesaj pentru confirmarea calculului sumei
    write('Sum: '), write(Sum), nl,
    % Verificăm dacă suma este egală cu rezultatul
    (Sum = ResultAsNumber ->
        write('Rezultatul este corect!'), nl;
        write('Rezultatul NU este corect!'), nl
    ),
    % Mesaj pentru evaluarea predicatului assign/1
    write('Evaluare assign/1...'), nl,
    % Verificăm asignarea corectă a cifrelor la litere în lista de cuvinte
    assign(WordList).
