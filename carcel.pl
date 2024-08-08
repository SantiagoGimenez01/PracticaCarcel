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
    prisionero(Preso, homicidio(_)).
peligroso(Preso):-
    prisionero(Preso, narcotrafico(Drogas)),
    length(Drogas, Cantidad),
    Cantidad >= 5.
peligroso(Preso):-
    prisionero(Preso, narcotrafico(Drogas)),
    member(metanfetaminas, Drogas).
    
    








