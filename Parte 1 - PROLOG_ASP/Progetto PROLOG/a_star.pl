costo(sud, 1).  
costo(ovest, 1).
costo(nord, 1).
costo(est, 1).

prova(ListaAz):-
  iniziale(Start),
  confrontoeuristico(Start, Costo_Euristica),
  aStar([node(Start, Costo_Euristica, [])], [], ListaAz),
  reverse(SolOrd, ListaAz),
  costoPassi(SolOrd, CostoNpassi),
  write(SolOrd),
  write(CostoNpassi).

%-------------------------------------------------------------------------------
%Caso 1: la psoizione attuale è quella finale
aStar([node(Start, _, AzioniEseguite)|_], _, AzioniEseguite):-finale(Start).

% Caso 2:  ricerca di tutte le azioni applicabili-> a partire dal node con costo minore -> chiamata ricorsiva 
aStar([node(Start, CostoFinale, AzioniEseguite)|Coda], Visitati, SolParziale):-
    findall(Azione, applicabile(Azione,Start), Applicabili),
    nuoviFigli(node(Start, CostoFinale, AzioniEseguite), Applicabili, [Start|Visitati], Coda, NuovaCoda),
    aStar(NuovaCoda, [Start|Visitati], SolParziale).

%Caso 3: ricerca vuota nessuna soluzione
aStar([], _, _):-write('Nessun percorso trovato').

nuoviFigli(_, [], _, Coda, Coda).

nuoviFigli(node(Start, CostoFinale, AzioniEseguitePerS), [Azione|AltreAzioniEseguite], Visitati, Coda, NuovaCoda):-
    trasforma(Azione, Start, NuovaPos),    
    \+member(NuovaPos, Visitati),       
    costoPassi(AzioniEseguitePerS, CostoPassi),   
    confrontoeuristico(NuovaPos, H),    
    CostoFinaleTotale is CostoPassi + H,      
    inCoda(node(NuovaPos, CostoFinaleTotale, [Azione|AzioniEseguitePerS]), Coda, CodaParziale),  
    nuoviFigli(node(Start, CostoFinale, AzioniEseguitePerS), AltreAzioniEseguite, Visitati, CodaParziale, NuovaCoda). 

nuoviFigli(node(Start, CostoFinale, AzioniEseguitePerS), [_|AltreAzioniEseguite], Visitati, Coda, NuovaCoda):-
    nuoviFigli(node(Start, CostoFinale, AzioniEseguitePerS), AltreAzioniEseguite, Visitati, Coda, NuovaCoda).

%Euclidea
disteu(pos(X1, Y1), pos(Xfinale, Yfinale), Distanza):-
  Distanza is sqrt((X1 - Xfinale)^2 + (Y1 - Yfinale)^2).
  %Manatthan
  %Distanza is abs(X1-Xfinale) + abs(Y1-Yfinale).  


costoPassi([], 0).

costoPassi([Azione|AltreAzioniEseguite], CostoPassi_totale):-
  costoPassi(AltreAzioniEseguite, CostoPassi_parziale),
  costo(Azione, CostoPassi),
  CostoPassi_totale is CostoPassi_parziale + CostoPassi.

inCoda(node(Start, CostoFinale, AzioniEseguite), CodaAttuale, NuovaCoda):-
  nonIncoda(Start, CodaAttuale),
  inCodaNuovo(node(Start, CostoFinale, AzioniEseguite), CodaAttuale, NuovaCoda).

inCoda(node(Start, CostoFinale, AzioniEseguite), CodaAttuale, NuovaCoda):-
  \+nonIncoda(Start, CodaAttuale),
  confrontoNodi(node(Start, CostoFinale, AzioniEseguite), CodaAttuale, CodaParziale),
  inCodaNuovo(node(Start, CostoFinale, AzioniEseguite), CodaParziale, NuovaCoda).

inCodaNuovo(node(Start, CostoFinale, AzioniEseguite), [], [node(Start, CostoFinale, AzioniEseguite)]).

inCodaNuovo(node(Start, CostoFinale, AzioniEseguite),
                [node(TestaInzio, CostoFinale_minimo, Azionitesta) | RestoCoda],
                [node(Start, CostoFinale, AzioniEseguite), node(TestaInzio, CostoFinale_minimo, Azionitesta) | RestoCoda]) :-
  CostoFinale =< CostoFinale_minimo.

inCodaNuovo(node(Start, CostoFinale, AzioniEseguite),
                [node(TestaInzio, CostoFinale_minimo, Azionitesta) | RestoCodaParziale],
                [node(TestaInzio, CostoFinale_minimo, Azionitesta) | RestoCoda]) :-
  inCodaNuovo(node(Start, CostoFinale, AzioniEseguite), RestoCodaParziale, RestoCoda).

confrontoNodi(node(Start, CostoFinale, _),
                    [node(TestaInzio, CostoFinale_testa, _) | RestoCoda],
                    RestoCoda) :-
  confrontoPosizione(Start, TestaInzio),
  CostoFinale < CostoFinale_testa.

confrontoNodi(node(Start, CostoFinale, _),
                    [node(TestaInzio, CostoFinale_testa, _) | RestoCoda],
                    [node(TestaInzio, CostoFinale_testa, _) | RestoCodaNuova]) :-
  \+confrontoPosizione(Start, TestaInzio),
  confrontoNodi(node(Start, CostoFinale, _), RestoCoda, RestoCodaNuova).

nonIncoda(_, []).

nonIncoda(NuovaPos, [node(TestaInzio, _, _) | RestoCoda]):-
  \+confrontoPosizione(NuovaPos, TestaInzio),
  nonIncoda(NuovaPos, RestoCoda).

confrontoPosizione(pos(X1, Y1), pos(X2, Y2)):-
  X1 = X2,
  Y1 = Y2.

confrontoeuristico(Attuale, H):-
  findall(Finale, finale(Finale), ListaGoal),
  calcoloDistEuristicaMigliore(Attuale, ListaGoal, H).

calcoloDistEuristicaMigliore(Attuale, [UscitaCorrente], H):-
  disteu(Attuale, UscitaCorrente, H).

calcoloDistEuristicaMigliore(Attuale, [UscitaCorrente|RestoUscite], Hcorrente):-
  calcoloDistEuristicaMigliore(Attuale, RestoUscite, HMiglioreparziale),
  disteu(Attuale, UscitaCorrente, Hcorrente),
  Hcorrente < HMiglioreparziale.

calcoloDistEuristicaMigliore(Attuale, [UscitaCorrente|RestoUscite], HMiglioreParziale):-
  calcoloDistEuristicaMigliore(Attuale, RestoUscite, HMiglioreParziale),
  disteu(Attuale, UscitaCorrente, Hcorrente),
  Hcorrente >= HMiglioreParziale.