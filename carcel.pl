% guardia(Nombre)
guardia(bennett).
guardia(mendez).
guardia(george).

% prisionero(Nombre, Crimen)
prisionero(piper, narcotrafico([metanfetaminas])).
prisionero(alex, narcotrafico([heroina])).
prisionero(alex, homicidio(george)).
prisionero(red, homicidio(rusoMafioso)).
prisionero(suzanne, robo(450000)).
prisionero(suzanne, robo(250000)).
prisionero(suzanne, robo(2500)).
prisionero(dayanara, narcotrafico([heroina, opio])).
prisionero(dayanara, narcotrafico([metanfetaminas])).

% controla(Controlador, Controlado)
controla(piper, alex).
controla(bennett, dayanara).
controla(Guardia, Otro):-
    prisionero(Otro,_), 
    guardia(Guardia),
    not(controla(Otro, Guardia)).
/*
controla(piper, alex).
controla(bennett, dayanara).
controla(Guardia, Otro):- prisionero(Otro,_), not(controla(Otro, Guardia)).

Es inversible solo para la variable Otro ya que en la funcion controla/2 primero define que Otro es un prisionero por lo que va a
poder usarse para hacer consultas y obtener los nombres de los prisioneros que son controlados por un guardia ya que antes de 
entrar al predicado not ya se liga a un atomo. En cambio Guardia se usa dentro de un not, es decir dentro de un predicado de orden 
superior y no entra ligada a nada, por lo que no se va a poder preguntar sobre que guardias controlan a un determinado prisionero.
Es decir es inversible para su segunda variable pero no para la primera.
Consultas que no pueden hacerse -> controla(Guardia, Otro), controla(Guardia, algunPrisionero)
Dejo arriba la implementacion corregida
*/

% Punto 2
/*
conflictoDeIntereses/2: relaciona a dos personas distintas (ya sean guardias o prisioneros) si no se controlan mutuamente y 
existe algún tercero al cual ambos controlan.
*/
% conflictoDeIntereses(UnaPersona, OtraPersona).
conflictoDeIntereses(UnaPersona, OtraPersona):-
    controla(UnaPersona, Otro),
    controla(OtraPersona, Otro),
    not(controla(UnaPersona, OtraPersona)),
    not(controla(OtraPersona, UnaPersona)),
    UnaPersona \= OtraPersona.

% Punto 3
/*
peligroso/1: Se cumple para un preso que sólo cometió crímenes graves.
Un robo nunca es grave.
Un homicidio siempre es grave.
Un delito de narcotráfico es grave cuando incluye al menos 5 drogas a la vez, o incluye metanfetaminas.

*/
% peligroso(Preso).
peligroso(Preso):-
    prisionero(Preso, _),
    forall(prisionero(Preso, Crimen), esGrave(Crimen)).
esGrave(homicidio(_)).
esGrave(narcotrafico(Drogas)):-
    length(Drogas, Cantidad),
    Cantidad >= 5.
esGrave(narcotrafico(Drogas)):-
    member(metanfetaminas, Drogas).
    
% Punto 4
% ladronDeGuanteBlanco/1: Aplica a un prisionero si sólo cometió robos y todos fueron por más de $100.000.
ladronDeGuanteBlanco(Preso):-
    prisionero(Preso, _),
    forall(prisionero(Preso, Crimen), roboImportante(Crimen)).
roboImportante(robo(Cantidad)):-
    Cantidad > 100000.

% Punto 5
/*
condena/2: Relaciona a un prisionero con la cantidad de años de condena que debe cumplir. Esto se calcula como la suma de los años 
que le aporte cada crimen cometido, que se obtienen de la siguiente forma:
La cantidad de dinero robado dividido 10.000.
7 años por cada homicidio cometido, más 2 años extra si la víctima era un guardia.
2 años por cada droga que haya traficado.
*/
% condena(Preso, Años).
condena(Preso, Condena):-
    prisionero(Preso, _),
    findall(Anio, (prisionero(Preso, Crimen), aniosPorCumplir(Crimen, Anio)), Anios),
    sumlist(Anios, Condena).

aniosPorCumplir(robo(Cantidad), Anios):-
    Anios is (Cantidad / 10000).
aniosPorCumplir(homicidio(Victima), 9):-
    guardia(Victima).
aniosPorCumplir(homicidio(Victima), 7):-
    not(guardia(Victima)).
aniosPorCumplir(narcotrafico(Drogas), Anios):-
    length(Drogas, Cantidad),
    Anios is (Cantidad * 2).

% Punto 6
/* 
capoDiTutiLiCapi/1: Se dice que un preso es el capo de todos los capos cuando nadie lo controla, pero todas las personas de la 
cárcel (guardias o prisioneros) son controlados por él, o por alguien a quien él controla (directa o indirectamente).
*/

esPersona(Persona):-
    prisionero(Persona, _).
esPersona(Persona):-
    guardia(Persona).

capoDiTutiLiCapi(Preso):-
    prisionero(Preso, _),
    not(controla(_, Preso)),
    forall((esPersona(Otro), Preso \= Otro), tieneControl(Preso, Otro)).

tieneControl(Persona, Otro):-
    controla(Persona, Otro).
tieneControl(Persona, Otro):-
    controla(Persona, Tercero),
    tieneControl(Tercero, Otro).




    
    




