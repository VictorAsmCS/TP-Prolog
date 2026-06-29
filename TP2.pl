:- encoding(utf8).

%! completar(+S)
% Indica que se debe completar el predicado. Siempre falla.
completar(S) :- write("COMPLETAR: "), write(S), nl, fail.

%--------------- Vocabulario ---------------------------------------------------

sustantivoMasc(alfajor).
sustantivoMasc(iglú).
sustantivoMasc(pitufo).

sustantivoFem(persona).
sustantivoFem(gaviota).
sustantivoFem(mermelada).

determinanteFem(una).
determinanteMasc(un).

pronombrePersonal(alonso).
pronombrePersonal(matilde).
pronombrePersonal(charlyGarcía).
pronombrePersonal(doctorDoom).

verboTrans(hechiza).
verboTrans(molesta).
verboTrans(admira).

preposición(a).

verboIntrans(vuela).
verboIntrans(estudia).
verboIntrans(come).

negación(no).
negación(niAhí).

condicional(si).
condicional(cuando).

consecuente(entonces).
consecuente(luego).

%----------- Operadores (para hacer mas legible una formula proposicional) -----
:- op(900, yfx, >).         % implicación
:- op(800, yfx, &).         % conjunción
:- op(750,  fy, ~).         % negación

%------------ Ejercicio 1 ------------------------------------------------------

% parsea(-Frase,-Semántica).
parsea(Frase, Semántica) :- frase(Semántica, Frase, []).

% Frase → Condicional Oración Consecuente Oración
frase(Semantica1 > Semantica2, [Condicion | XS], Salida) :-
    condicional(Condicion),
    oracion(Semantica1, XS, [Consecuente | XS2]),
    consecuente(Consecuente),
    oracion(Semantica2, XS2, Salida).

% Frase → Oración
frase(Sem, Entrada, Salida) :- oracion(Sem, Entrada, Salida).

% Oración → Sujeto Predicado
oracion(SemanticaSujeto & SemanticaPredicado, Entrada, Salida) :-
    sujeto(SemanticaSujeto, Entrada, Resto),
    predicado(SemanticaPredicado, Resto, Salida).

% Sujeto → DeterminanteFem SustantivoFem
sujeto(SustantivoFem, [DeterminanteFem, SustantivoFem | Salida], Salida) :-
    determinanteFem(DeterminanteFem),
    sustantivoFem(SustantivoFem).

% Sujeto → DeterminanteMasc SustantivoMasc
sujeto(SustantivoMasc, [DeterminanteMasc, SustantivoMasc | Salida], Salida) :-
    determinanteMasc(DeterminanteMasc),
    sustantivoMasc(SustantivoMasc).

% Sujeto → PronombrePersonal
sujeto(PronombrePersonal, [PronombrePersonal | Salida], Salida) :-
    pronombrePersonal(PronombrePersonal).

% Predicado → VerboTrans Preposición Sujeto
predicado(VerboTrans & SemanticaSujeto, [VerboTrans, Preposición | Resto1], Salida) :-
    verboTrans(VerboTrans),
    preposición(Preposición),
    sujeto(SemanticaSujeto, Resto1, Salida).

% Predicado → Negación VerboTrans Preposición Sujeto
predicado(~(VerboTrans & SemanticaSujeto), [Neg, VerboTrans, Preposición | Resto1], Salida) :-
    negación(Neg),
    verboTrans(VerboTrans),
    preposición(Preposición),
    sujeto(SemanticaSujeto, Resto1, Salida).

% Predicado → VerboIntrans
predicado(VerboIntrans, [VerboIntrans | Salida], Salida) :-
    verboIntrans(VerboIntrans).

% Predicado → Negación VerboIntrans
predicado(~VerboIntrans, [Negación, VerboIntrans | Salida], Salida) :-
    negación(Negación),
    verboIntrans(VerboIntrans).

%------------ Ejercicio 2 ------------------------------------------------------

% variables(+Fórmula,-Variables)
% variables(Fórmula, Variables) :- esListaDeVariables(Fórmula, VariablesRepetidos), sort(VariablesRepetidos, Variables).
% Podemos usar sort para ordenar la lista y quitar repetidos. Desconocia si se puede 

variables(Fórmula, Variables) :- esListaDeVariables(Fórmula, VariablesRepetidos), sinRepetidos(VariablesRepetidos, Variables).

esListaDeVariables(X, [X]) :- atom(X).
esListaDeVariables(~F, Vars) :- esListaDeVariables(F, Vars).
esListaDeVariables(Sem1 & Sem2, Vars) :- esListaDeVariables(Sem1, Vars1), esListaDeVariables(Sem2, Vars2), append(Vars1, Vars2, Vars).
esListaDeVariables(Sem1 > Sem2, Vars) :- esListaDeVariables(Sem1, Vars1), esListaDeVariables(Sem2, Vars2), append(Vars1, Vars2, Vars).

sinRepetidos([], []).
sinRepetidos([H | XS], L) :- member(H, XS), sinRepetidos(XS, L).
sinRepetidos([H | XS], [H | RL]) :- not(member(H, XS)), sinRepetidos(XS, RL).

%------------ Ejercicio 3 ------------------------------------------------------

% valuación(+Variables, -Valuación)
valuación(Variables, Valuación) :- listaDeValuaciones(Variables, Valuación).

listaDeValuaciones([], []).
listaDeValuaciones([X | XS], [(X, t) | XT]) :- listaDeValuaciones(XS, XT).
listaDeValuaciones([X | XS], [(X, f) | XT]) :- listaDeValuaciones(XS, XT).

%------------ Ejercicio 4 ------------------------------------------------------

% esVálida(+Fórmula, +Valuación)
esVálida(Fórmula, Valuación) :- esFormulaValida(Fórmula, Valuación).

esFormulaValida(Variable, Valuación) :- 
    atom(Variable),
    member((Variable, t), Valuación).

esFormulaValida(~F, Valuación) :- not(esFormulaValida(F, Valuación)).

esFormulaValida(F1 & F2, Valuación) :- 
    esFormulaValida(F1, Valuación),
    esFormulaValida(F2, Valuación).

esFormulaValida(F1 > _, Valuación) :- 
    not(esFormulaValida(F1, Valuación)).

esFormulaValida(F1 > F2, Valuación) :- 
    esFormulaValida(F1, Valuación),
    esFormulaValida(F2, Valuación).

%------------ Ejercicio 5 ------------------------------------------------------

% modelo(+Fórmula, -Valuación)
modelo(Fórmula, Valuación) :- 
    variables(Fórmula, Variables),
    valuación(Variables, Valuación),
    esVálida(Fórmula, Valuación).

%------------ Ejercicio 6 ------------------------------------------------------

% mejorModelo(+Fórmula, -Valuación)
mejorModelo(Fórmula, Valuación) :- 
    modelo(Fórmula, Valuación),
    cantidadDeVariablesVerdaderas(Valuación, Cantidad),
    not((modelo(Fórmula, Valuación2),
        cantidadDeVariablesVerdaderas(Valuación2, Cantidad2),
        Cantidad2 > Cantidad)).

% cantidadDeVariablesVerdaderas(+Modelo, -Cantidad)
cantidadDeVariablesVerdaderas([], 0).
cantidadDeVariablesVerdaderas([(_, t) | XS], C) :- 
    cantidadDeVariablesVerdaderas(XS, SubC),
    C is SubC + 1.
cantidadDeVariablesVerdaderas([(_, f) | XS], C) :- 
    cantidadDeVariablesVerdaderas(XS, C).

%------------ Ejercicio 7 ------------------------------------------------------

% subvaluación(+Valuación1, +Valuación2)
subvaluación([],_).
subvaluación([(X,V), XS], Valuación2) :- member((X,V), Valuación2), subvaluación(XS, Valuación2) .

% extiende(+Valuación1, +Fórmula, -Valuación2)
extiende(Valuación1, Fórmula, Valuación2) :- subvaluación(Valuación1, Valuación2), modelo(Formula, Valuación2).

%------------ Ejercicio 8 ------------------------------------------------------
"Si es reversible, porque si Valuacion1 no fuera definida, el resultado de subvaluacion(-Valuacion1,+Valuación2) serian todas las subvaluaciones posibles de Valuación2"

%------------ Ejercicio 9 ------------------------------------------------------

% consecuencia(+Fórmula1, +Fórmula2)
consecuencia(Fórmula1, Fórmula2) :- completar("Ejercicio 9").

% equivalentes(+Formula1, +Fórmula2)
equivalentes(Fórmula1, Fórmula2) :- completar("Ejercicio 9").

% contradictorias(+Fórmula1, +Fórmula2)
contradictorias(Fórmula1, Fórmula2) :- completar("Ejercicio 9").

% modeloÚnico(+Fórmula, -Valuación)
modeloÚnico(Fórmula, Valuación) :- completar("Ejercicio 9").


%%%%%%%%%%%
%% TESTS %%
%%%%%%%%%%%

multiconjuntos_iguales(L1, L2) :- msort(L1, M), msort(L2, M).
existe_resultado_igual(Resultados, S) :- member(R, Resultados), multiconjuntos_iguales(R, S).
contiene_soluciones(Resultados, Soluciones) :- maplist(existe_resultado_igual(Resultados), Soluciones).

% Se espera que completen con las subsecciones de tests que crean necesarias, más allá de las puestas en estos ejemplos

cantidadTestsParsea(11).
testParsea(1) :- parsea([si, una, persona, hechiza, a, una, gaviota, entonces, un, alfajor, hechiza, a, una, mermelada], persona & (hechiza & gaviota) > alfajor & (hechiza & mermelada)).
testParsea(2) :- parsea([si, una, persona, hechiza, a, una, gaviota, entonces, un, alfajor, hechiza, a, un, iglú], persona & (hechiza & gaviota) > alfajor & (hechiza & iglú)).
testParsea(3) :- parsea([si, una, persona, hechiza, a, una, gaviota, entonces, un, alfajor, hechiza, a, un, pitufo], persona & (hechiza & gaviota) > alfajor & (hechiza & pitufo)).
testParsea(4) :- parsea([matilde, no, hechiza, a, una, gaviota], matilde & ~(hechiza & gaviota)).
testParsea(5) :- parsea([un, pitufo, come], pitufo & come).
testParsea(6) :- parsea([una, persona, niAhí, admira, a, alonso], persona & ~(admira & alonso)).
testParsea(7) :- parsea([cuando, doctorDoom, no, estudia, luego, matilde, vuela], (doctorDoom & ~estudia) > (matilde & vuela)).
testParsea(8) :- parsea([si, un, iglú, niAhí, vuela, entonces, una, mermelada, molesta, a, charlyGarcía], (iglú & ~vuela) > (mermelada & (molesta & charlyGarcía))).
testParsea(9) :- not(parsea([el, pitufo, come], _)). % "el" no esta en la gramatica
testParsea(10) :- not(parsea([un, pitufo, a, come], _)). % mal uso preposicion
testParsea(11) :- parsea([charlyGarcía, come], charlyGarcía & come).

cantidadTestsVariables(6).
testVariables(1) :- findall(V, variables(persona & (hechiza & gaviota) > alfajor & (hechiza & mermelada), V), Vs), length(Vs, 1), contiene_soluciones(Vs, [[persona, hechiza, gaviota, alfajor, mermelada]]).
testVariables(2) :- findall(V, variables(~a & (b > (~a & c)), V), Vs), length(Vs, 1), contiene_soluciones(Vs, [[a, b, c]]).
testVariables(3) :- findall(V, variables(pitufo, V), Vs), length(Vs, 1), contiene_soluciones(Vs, [[pitufo]]).
testVariables(4) :- findall(V, variables(a > a, V), Vs), length(Vs, 1), contiene_soluciones(Vs, [[a]]).
testVariables(5) :- findall(V, variables(a & (b & (c & (d & e))), V), Vs), length(Vs, 1), contiene_soluciones(Vs, [[a, b, c, d, e]]).
testVariables(6) :- findall(V, variables(~(~a), V), Vs), length(Vs, 1), contiene_soluciones(Vs, [[a]]).

cantidadTestsValuación(4).
testValuación(1) :- findall(V, valuación([mermelada, gaviota], V), Vs), length(Vs, 4), contiene_soluciones(Vs, [[(mermelada, t), (gaviota, t)], [(mermelada, t), (gaviota, f)], [(mermelada, f), (gaviota, t)], [(mermelada, f), (gaviota, f)]]).
testValuación(2) :- findall(V, valuación([a], V), Vs), length(Vs, 2), contiene_soluciones(Vs, [[(a, t)], [(a, f)]]).
testValuación(3) :- findall(V, valuación([], V), Vs), length(Vs, 1), contiene_soluciones(Vs, [[]]).
testValuación(4) :- findall(V, valuación([a, b, c], V), Vs), length(Vs, 8).

cantidadTestsEsVálida(7).
testEsVálida(1) :- not(esVálida(persona & (hechiza & gaviota), [(persona, f), (hechiza, t), (gaviota, f)])).
testEsVálida(2) :- esVálida(gaviota, [(gaviota, t)]).
testEsVálida(3) :- esVálida(a > b, [(a, f), (b, f)]).
testEsVálida(4) :- esVálida(a > b, [(a, t), (b, t)]).
testEsVálida(5) :- not(esVálida(a > b, [(a, t), (b, f)])).
testEsVálida(6) :- esVálida(~(~a), [(a, t)]).
testEsVálida(7) :- esVálida(a > a, [(a, f)]).

cantidadTestsModelo(4).
testModelo(1) :- findall(M, modelo(gaviota > mermelada, M), Ms), length(Ms, 3), contiene_soluciones(Ms, [[(gaviota, t), (mermelada, t)], [(gaviota, f), (mermelada, t)], [(gaviota, f), (mermelada, f)]]).
testModelo(2) :- findall(M, modelo(~a & a, M), Ms), length(Ms, 0).
testModelo(3) :- findall(M, modelo(a > a, M), Ms), length(Ms, 2), contiene_soluciones(Ms, [[(a, t)], [(a, f)]]).
testModelo(4) :- findall(M, modelo(~(a & b), M), Ms), length(Ms, 3), contiene_soluciones(Ms, [[(a, t), (b, f)], [(a, f), (b, t)], [(a, f), (b, f)]]).

cantidadTestsMejorModelo(5).
testMejorModelo(1) :- findall(M, mejorModelo(~a > a, M), Ms), length(Ms, 1), contiene_soluciones(Ms, [[(a, t)]]).
testMejorModelo(2) :- findall(M, mejorModelo(~(~a & b) > (a & ~b), M), Ms), length(Ms, 2), contiene_soluciones(Ms, [[(a, t), (b, f)], [(a, f), (b, t)]]).
testMejorModelo(3) :- findall(M, mejorModelo(a & b, M), Ms), length(Ms, 1), contiene_soluciones(Ms, [[(a, t), (b, t)]]).
testMejorModelo(4) :- findall(M, mejorModelo(~(a & b), M), Ms), length(Ms, 2), contiene_soluciones(Ms, [[(a, t), (b, f)], [(a, f), (b, t)]]).
testMejorModelo(5) :- findall(M, mejorModelo(~a & ~b, M), Ms), length(Ms, 1), contiene_soluciones(Ms, [[(a, f), (b, f)]]).

cantidadTestsSubvaluación(5).
testSubvaluación(1) :- subvaluación([(gaviota, t)], [(gaviota, t), (mermelada, f)]).
testSubvaluación(2) :- not(subvaluación([(gaviota, t)], [(gaviota, f), (mermelada, f)])).
testSubvaluación(3) :- subvaluación([], [(a, t)]).
testSubvaluación(4) :- not(subvaluación([(a, t)], [(a, f)])).
testSubvaluación(5) :- subvaluación([(a, t)], [(a, t)]).

cantidadTestsExtiende(4).
testExtiende(1) :- findall(V, extiende([(a,t)], ~a > b, V), Vs), length(Vs, 2), contiene_soluciones(Vs, [[(a, t), (b, t)], [(a, t), (b, f)]]).
testExtiende(2) :- findall(V, extiende([(a,f)], ~a > b, V), Vs), length(Vs, 1), contiene_soluciones(Vs, [[(a, f), (b, t)]]).
testExtiende(3) :- findall(V, extiende([(a, t)], a & ~a, V), Vs), length(Vs, 0).
testExtiende(4) :- findall(V, extiende([], a > b, V), Vs), length(Vs, 3).

cantidadTestsConsecuencia(6).
testConsecuencia(1) :- consecuencia(a, a).
testConsecuencia(2) :- consecuencia(a & b, a).
testConsecuencia(3) :- not(consecuencia(a, a & b)).
testConsecuencia(4) :- not(consecuencia(a, a > b)).
testConsecuencia(5) :- consecuencia(a, b > a).
testConsecuencia(6) :- consecuencia(~a & a, b).

cantidadTestsEquivalentes(4).
testEquivalentes(1) :- equivalentes(a, a).
testEquivalentes(2) :- equivalentes(~(~a), a).
testEquivalentes(3) :- equivalentes(a > b, ~(a & ~b)).
testEquivalentes(4) :- not(equivalentes(a & b, a)).

cantidadTestsContradictorias(4).
testContradictorias(1) :- contradictorias(a, ~a).
testContradictorias(2) :- contradictorias(a & b, ~(a & b)).
testContradictorias(3) :- not(contradictorias(a, b)).
testContradictorias(4) :- contradictorias(a > b, a & ~b).

cantidadTestsModeloÚnico(4).
testModeloÚnico(1) :- modeloÚnico(a, [(a, t)]).
testModeloÚnico(2) :- modeloÚnico(a & b, [(a, t), (b, t)]).
testModeloÚnico(3) :- not(modeloÚnico(a > b, _)).
testModeloÚnico(4) :- not(modeloÚnico(a & ~a, _)).

tests(parsea) :- cantidadTestsParsea(M), forall(between(1,M,N), testParsea(N)).
tests(variables) :- cantidadTestsVariables(M), forall(between(1,M,N), testVariables(N)).
tests(valuación) :- cantidadTestsValuación(M), forall(between(1,M,N), testValuación(N)).
tests(esVálida) :- cantidadTestsEsVálida(M), forall(between(1,M,N), testEsVálida(N)).
tests(modelo) :- cantidadTestsModelo(M), forall(between(1,M,N), testModelo(N)).
tests(mejorModelo) :- cantidadTestsMejorModelo(M), forall(between(1,M,N), testMejorModelo(N)).
tests(subvaluación) :- cantidadTestsSubvaluación(M), forall(between(1,M,N), testSubvaluación(N)).
tests(extiende) :- cantidadTestsExtiende(M), forall(between(1,M,N), testExtiende(N)).
tests(consecuencia) :- cantidadTestsConsecuencia(M), forall(between(1,M,N), testConsecuencia(N)).
tests(equivalentes) :- cantidadTestsEquivalentes(M), forall(between(1,M,N), testEquivalentes(N)).
tests(contradictorias) :- cantidadTestsContradictorias(M), forall(between(1,M,N), testContradictorias(N)).
tests(modeloÚnico) :- cantidadTestsModeloÚnico(M), forall(between(1,M,N), testModeloÚnico(N)).

tests(todos) :-
  tests(parsea),
  tests(variables),
  tests(valuación),
  tests(esVálida), 
  tests(modelo), 
  tests(mejorModelo),
  tests(subvaluación), 
  tests(extiende),
  tests(consecuencia),
  tests(equivalentes), 
  tests(contradictorias),
  tests(modeloÚnico).

tests :- tests(todos).