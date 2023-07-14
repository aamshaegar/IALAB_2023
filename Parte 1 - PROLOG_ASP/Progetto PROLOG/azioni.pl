applicabile(est, pos(Riga, Colonna)):-
  num_colonne(NC),
  Colonna < NC,
  NuovaColonna is Colonna + 1,
  \+occupata(pos(Riga, NuovaColonna)).

applicabile(sud, pos(Riga, Colonna)):-
  num_righe(NR),
  Riga < NR,
  NuovaRiga is Riga + 1,
  \+occupata(pos(NuovaRiga, Colonna)).

applicabile(ovest, pos(Riga, Colonna)):-
  Colonna > 1,
  NuovaColonna is Colonna - 1,
  \+occupata(pos(Riga, NuovaColonna)).

applicabile(nord, pos(Riga, Colonna)):-
  Riga > 1,
  NuovaRiga is Riga - 1,
  \+occupata(pos(NuovaRiga, Colonna)).

trasforma(est, pos(Riga, Colonna), pos(Riga, NuovaColonna)):-
  NuovaColonna is Colonna + 1.

trasforma(sud, pos(Riga, Colonna), pos(NuovaRiga, Colonna)):-
  NuovaRiga is Riga + 1.

trasforma(ovest, pos(Riga, Colonna), pos(Riga, NuovaColonna)):-
  NuovaColonna is Colonna - 1.

trasforma(nord, pos(Riga, Colonna), pos(NuovaRiga, Colonna)):-
  NuovaRiga is Riga - 1.
