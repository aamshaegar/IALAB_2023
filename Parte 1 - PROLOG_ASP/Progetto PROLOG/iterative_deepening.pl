costo(sud, 1).  
costo(ovest, 1).
costo(nord, 1).
costo(est, 1).
costoPassi([], 0).

costoPassi([Azione|AltreAzioni], G_costo_totale):-
    costoPassi(AltreAzioni, G_costo_parziale),
    costo(Azione, G_costo),
    G_costo_totale is G_costo_parziale + G_costo.

prova(ListaAz):-
  id(ListaAz, 0).

id(ListaAz, Soglia):-
  depth_limit_search(ListaAz, Soglia),
  costoPassi(ListaAz, CostoCammino),
  write(CostoCammino).

id(ListaAz, Soglia):-
  NuovaSoglia is Soglia + 1,
  num_righe(NR),
  num_colonne(NC),
  SogliaMax is (NR * NC) / 2,
  NuovaSoglia < SogliaMax,
  id(ListaAz, NuovaSoglia).

depth_limit_search(ListaAz, Soglia):-
  iniziale(S),
  dfs_aux(S, ListaAz, [S], Soglia).

dfs_aux(S,[],_,_):-
  finale(S).

dfs_aux(S,[Azione|AzioniTail], Visitati, Soglia):-
    Soglia>0,
    applicabile(Azione,S),
    trasforma(Azione,S,SNuovo),
    \+member(SNuovo,Visitati),
    NuovaSoglia is Soglia-1,
    dfs_aux(SNuovo, AzioniTail,[SNuovo|Visitati], NuovaSoglia).