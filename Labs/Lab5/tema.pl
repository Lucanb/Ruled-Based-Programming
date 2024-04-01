% Define the list of digits from 0 to 9
digits([0,1,2,3,4,5,6,7,8,9]).

% Define predicates for validating digits and starting digits
validStart(X) :- member(X,[1,2,3,4,5,6,7,8,9]).

% Predicate to assign digits to letters in the list
assign([]).
assign([H|T]) :- digits(D), member(H, D), assign(T), \+ member(H, T).

% Predicate to convert a list of digits to a number
convert([T],T).
convert([H|T],Num) :- convert(T, Rest), length(T, Len), Num is H * 10^Len + Rest.

% Predicate to check if a verbal arithmetic puzzle is solved
verbalArithmetic(WordList,[H1|Tail1],[H2|Tail2],Word3) :- 
    validStart(H1), 
    validStart(H2), 
    assign(WordList), 
    convert([H1|Tail1],Num1),
    convert([H2|Tail2],Num2), 
    convert(Word3,Num3), 
    Sum is Num1 + Num2, 
    Num3 = Sum.