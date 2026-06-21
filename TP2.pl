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

%----------- Operadores (para hacer más legible una formula proposicional) -----
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
subvaluación(Valuación1, Valuación2) :- completar("Ejercicio 7").

% extiende(+Valuación1, +Fórmula, -Valuación2)
extiende(Valuación1, Fórmula, Valuación2) :- completar("Ejercicio 7").

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

cantidadTestsParsea(4). % Actualizar con la cantidad de tests que entreguen
testParsea(1) :- parsea([si, una, persona, hechiza, a, una, gaviota, entonces, un, alfajor, hechiza, a, una, mermelada], persona & (hechiza & gaviota) > alfajor & (hechiza & mermelada)).
testParsea(2) :- parsea([si, una, persona, hechiza, a, una, gaviota, entonces, un, alfajor, hechiza, a, un, iglu], persona & (hechiza & gaviota) > alfajor & (hechiza & iglu)).
testParsea(3) :- parsea([si, una, persona, hechiza, a, una, gaviota, entonces, un, alfajor, hechiza, a, un, pitufo], persona & (hechiza & gaviota) > alfajor & (hechiza &pitufo)).
testParsea(4) :- parsea([matilde, no, hechiza, a, una, gaviota], matilde & ~(hechiza & gaviota)).
% % Agregar más tests

cantidadTestsVariables(1). % Actualizar con la cantidad de tests que entreguen
testVariables(1) :- findall(V, variables(persona & (hechiza & gaviota) > alfajor & (hechiza & mermelada), V), Vs), length(Vs, 1), contiene_soluciones(Vs, [[persona, hechiza, gaviota, alfajor, mermelada]]).
% Agregar más tests

cantidadTestsValuación(1). % Actualizar con la cantidad de tests que entreguen
testValuación(1) :- findall(V, valuación([mermelada, gaviota], V), Vs), length(Vs, 4), contiene_soluciones(Vs, [[(mermelada, t), (gaviota, t)], [(mermelada, t), (gaviota, f)], [(mermelada, f), (gaviota, t)], [(mermelada, f), (gaviota, f)]]).
% Agregar más tests

cantidadTestsEsVálida(2). % Actualizar con la cantidad de tests que entreguen
testEsVálida(1) :- not(esVálida(persona & (hechiza & gaviota), [(persona, f), (hechiza, t), (gaviota, f)])).
testEsVálida(2) :- esVálida(gaviota, [(gaviota, t)]).
% Agregar más tests

cantidadTestsModelo(1). % Actualizar con la cantidad de tests que entreguen
testModelo(1) :- findall(M, modelo(gaviota > mermelada, M), Ms), length(Ms, 3), contiene_soluciones(Ms, [[(gaviota, t), (mermelada, t)], [(gaviota, f), (mermelada, t)], [(gaviota, f), (mermelada, f)]]).
% Agregar más tests

cantidadTestsMejorModelo(2). % Actualizar con la cantidad de tests que entreguen
testMejorModelo(1) :- findall(M, mejorModelo(~a > a, M), Ms), length(Ms, 1), contiene_soluciones(Ms, [[(a, t)]]).
testMejorModelo(2) :- findall(M, mejorModelo(~(~a & b) > (a & ~b), M), Ms), length(Ms, 2), contiene_soluciones(Ms, [[(a, t), (b, f)], [(a, f), (b, t)]]).
% Agregar más tests

cantidadTestsSubvaluación(2). % Actualizar con la cantidad de tests que entreguen
testSubvaluación(1) :- subvaluación([(gaviota, t)], [(gaviota, t), (mermelada, f)]).
testSubvaluación(2) :- not(subvaluación([(gaviota, t)], [(gaviota, f), (mermelada, f)])).
% Agregar más tests

cantidadTestsExtiende(2). % Actualizar con la cantidad de tests que entreguen
testExtiende(1) :- findall(V, extiende([(a,t)], ~a > b, V), Vs), length(Vs, 2), contiene_soluciones(Vs, [[(a, t), (b, t)], [(a, t), (b, f)]]).
testExtiende(2) :- findall(V, extiende([(a,f)], ~a > b, V), Vs), length(Vs, 1), contiene_soluciones(Vs, [[(a, f), (b, t)]]).
% Agregar más tests

cantidadTestsConsecuencia(1). % Actualizar con la cantidad de tests que entreguen
testConsecuencia(1).
% Agregar más tests

cantidadTestsEquivalentes(1). % Actualizar con la cantidad de tests que entreguen
testEquivalentes(1).
% Agregar más tests

cantidadTestsContradictorias(1). % Actualizar con la cantidad de tests que entreguen
testContradictorias(1).
% Agregar más tests

cantidadTestsModeloÚnico(1). % Actualizar con la cantidad de tests que entreguen
testModeloÚnico(1).
% Agregar más tests

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