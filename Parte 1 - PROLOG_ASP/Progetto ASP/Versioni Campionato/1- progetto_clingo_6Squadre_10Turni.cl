% CALENDARIO DI UN CAMPIONATO SPORTIVO

% VINCOLI OBBLIGATORI 


% 1) Squadre
squadra(milan; 
        inter; 
        lazio; 
        juventus;
        fiorentina;
        sassuolo).


% 2) Giornate: andata, ritorno
turno(1..10).
turno_andata(1..5).
turno_ritorno(6..10).


% 5)
% Ogni squadra fa riferimento ad una città, che offre la struttura in cui la squadra gioca gli incontri in casa;
in_citta(
        milan, stadio_A;
        inter, stadio_A;
        lazio, stadio_B;
        juventus, stadio_C;
        fiorentina, stadio_D;
        sassuolo, stadio_E).


% 3)
% Ogni squadra si sfida all'andata e al ritorno un numero di volte pari al numero di squadre totali / 2 
3 {partita(andata, SquadraA, SquadraB, Citta, N):
    squadra(SquadraA), 
    squadra(SquadraB), 
    in_citta(SquadraA,Citta),
    SquadraA <> SquadraB} 3 :- turno_andata(N).


% le partite di ritorno sono speculari alle partite di andata ma in altre giornate
3 {partita(ritorno, SquadraA, SquadraB, Citta, N): 
    squadra(SquadraA), 
    squadra(SquadraB), 
    in_citta(SquadraA, Citta),
    partita(andata, SquadraB, SquadraA, Citta2, _),
    in_citta(SquadraB,Citta2)} 3:- turno_ritorno(N).



% Non può capitare che due squadre giocano 2 partite all'andata o al ritorno
:-  partita(_, SquadraA, SquadraB, _, N1), 
    partita(_, SquadraA, SquadraB, _, N2),
    N1 <> N2.


% Non può capitare che due squadre giocano andata e ritorno solo all'andata o solo al ritorno
:-  partita(Tipo, SquadraA, SquadraB, _, _), 
    partita(Tipo, SquadraB, SquadraA, _, _).


% Nella stessa giornata, una squadra non può giocare 2 volte
:-  squadra(Squadra), 
    turno(Turno),
    Numero_Partite_A = #count{SquadraA: partita(_,Squadra,SquadraA,_, Turno)}, 
    Numero_Partite_B = #count{SquadraB: partita(_,SquadraB,Squadra,_, Turno)}, 
    Numero_Partite_A + Numero_Partite_B <> 1.


% 4)
% Le giornate di andata e ritorno NON sono simmetriche
:-  partita(andata,SquadraA,SquadraB, _, T1), 
    partita(ritorno,SquadraB,SquadraA, _, T2), 
    T2 == T1 + 5.


% 6)
% Non può capitare che 2 squadre diverse giocano partite differenti nello stesso stadio nella stessa giornata
:-  partita(Tipo, Squadra1, _, C1, N), 
    partita(Tipo, Squadra2, _, C2, N),
    Squadra1 <> Squadra2,
    C1 == C2.




%  VINCOLI FACOLTATIVI

%7)  ciascuna squadra non deve giocare mai più di due partite consecutive in casa o fuori casa;
:-  partita(_, Squadra, _, _, T1),
    partita(_, Squadra, _, _, T1+1),
    partita(_, Squadra, _, _, T1+2).

:-  partita(_, _, Squadra, _, T1),
    partita(_, _, Squadra, _, T1+1),
    partita(_, _, Squadra, _, T1+2).



%*
8)  la distanza tra una coppia di gare di andata e ritorno è di almeno 10 giornate, (N squadre / 2)
    ossia se SquadraA vs SquadraB è programmata per la giornata 12, il ritorno
    SquadraB vs SquadraA verrà schedulato non prima dalla giornata 22.
*%

:-  partita(andata, SquadraA, SquadraB, _, T1),
    partita(ritorno, SquadraB, SquadraA, _, T2),
    T2 - T1 < 3.



#show partita/5.
