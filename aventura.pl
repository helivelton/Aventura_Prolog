start :-


  assertz(lugar_atual(cozinha)),
  assertz(posicao(mesa, quarto)),
  assertz(posicao(lanterna, mesa)),
  assertz(posicao(cafe, cozinha)),
  assertz(posicao(pia,cozinha)),
  assertz(posicao(vela,pia)),
  assertz(posicao(isqueiro,pia)),
  assertz(posicao(lavadoura, area)),
  assertz(posicao(celular, quarto)),
  assertz(posicao(chaves, lavadoura)),
  assertz(posicao(quadro, corredor)),
  assertz(posicao(televisor, sala)),
  assertz(posicao(sofa, sala)),
  assertz(fixo(sofa)),
  assertz(fixo(televisor)),  
  assertz(fixo(chaves)),
  assertz(fixo(pia)),
  assertz(fixo(mesa)),
  assertz(escuro(area)),
  assertz(fixo(lavadoura)),
  assertz(possui(celular)),!.
  
  
instrucoes:-
  write('           |------------------------|'),nl,
  write('           |           WHERE        |'),nl,
  write('           |          ARE MY        |'),nl,
  write('           |           KEYS?        |'),nl,
  write('           |------------------------|'),nl,
  write('         Digite "ajuda." para intruncoes'),nl,!.
  
  
ajuda:-
  write('|-------------------------------------------------------------------|'),nl,
  write('|status. - descreve o ambiente atual                                |'),nl,
  write('|ir_para(Lugar) - muda de ambiente, se acessivel                    |'),nl,
  write('|pegar(Objeto) - adiciona um objeto do ambiente atual ao inventario |'           KEYS?        |'),nl,
  write('           |------------------------|'),nl,
  write('         Digite "ajuda." para intruncoes'),nl,!.

  

lugar(cozinha).
lugar(sala).
lugar(corredor).
lugar(area).
lugar(quarto).



olhar_em(lavadoura):-
	lugar_atual(area),	
	retract(fixo(chaves)),
	mostrar_coisas(lavadoura),!.

combinar(vela,isqueiro):-
	possui(vela),
	possui(isqueiro),
	retract(escuro(area)),!.
	
combinar(isqueiro,vela):-
	possui(vela),
	possui(isqueiro),
	retract(escuro(area)),!.

ligar(lanterna):-
	possui(lanterna),
	retract(escuro(area)),!.
	
ligar(X):-
	possui(X),
	write('Acao invalida para esse objeto!'),nl,!.
	
ligar(X):-
	not(possui(X)),
	write('Voce nao possui um(a) '), write(X),write('!'),nl,!.

combinar(X,Y):-
	not(possui(X)),
	write('Voce nao possui um(a) '), write(X),write('!'),nl,
	not(possui(Y)),
	write('Voce nao possui um(a) '), write(Y),write('!'),nl,!.

combinar(X,Y):-
	possui(X),
	not(possui(Y)),
	write('Voce nao possui um(a) '), write(Y),write('!'),nl,!.	

combinar(X,Y):-
	possui(Y),
	not(possui(X)),
	write('Voce nao possui um(a) '), write(X),write('!'),nl,!.	
	
combinar(X,Y):-
	possui(X),
	possui(Y),
	write('Combinacao invalida '),write('!'),nl,!.
	

	
porta(quarto,corredor).
porta(cozinha,quarto).
porta(corredor,sala).
porta(cozinha,area).
porta(sala,cozinha).

comestivel(cafe).

ligacao(X,Y):-
  porta(X,Y).
ligacao(X,Y):-
  porta(Y,X).

 
mostrar_coisas(Lugar) :-  
  posicao(X, Lugar),
  tab(2),
  write(X),
  nl,
  fail.
mostrar_coisas(_).
  
mostrar_lugares(Lugar) :-
  ligacao(Lugar, X),
  tab(2),
  write(X),
  nl,
  fail.


status :-
  not(objetivo),
  lugar_atual(Lugar),
  write('Voce esta na(o) '), write(Lugar), nl,
  write('Coisas na(o) '),write(Lugar), write(':'), nl,
  mostrar_coisas(Lugar),
  write('Voce pode ir para:'), nl,
  mostrar_lugares(Lugar).
  
 
olhar_em(Lugar) :-
  posicao(_,Lugar),
  lugar_atual(Local),
  posicao(Lugar,Local),
  write('Coisas na(o) '),write(Lugar),write(':'), nl,
  mostrar_coisas(Lugar),!.
olhar_em(Lugar) :-
  posicao(_,Lugar),
  lugar_atual(Lugar),
  write('Coisas na(o) '),write(Lugar),write(':'), nl,
  mostrar_coisas(Lugar),!.
olhar_em(Lugar):-
  lugar_atual(Local),
  not(posicao(Lugar,Local)),
  write('Nao ha '),write(Lugar),write(' aqui!'),!.  
olhar_em(Lugar):-
  write('Nao ha nada na(o)'),write(Lugar),write('.'),!.
  
comida(Coisas,Lugar) :-  
  posicao(Coisas,Lugar),
  comestivel(Coisas).
  
ir_para(X):-
  possivel_ir(X),
  andar(X),
  status.

 
possivel_ir(Lugar):-
  not(escuro(Lugar)),
  lugar_atual(X),
  ligacao(X, Lugar),!.


  
possivel_ir(Lugar):-
  write('Nao eh possivel ir para '), write(Lugar), write(' a partir daqui'), nl,
  fail,!.
  
possivel_ir(Lugar):-
  lugar_atual(X),
  ligacao(X, Lugar),
  escuro(Lugar),
  write('Esta Escuro la!'),nl,
  fail,!.

andar(Lugar):-
  retract(lugar_atual(X)),
  asserta(lugar_atual(Lugar)),!.
  

pegar(Coisa):-
  possivel_pegar(Coisa),
  pegar_coisa(Coisa),
  objetivo,!.

  
possivel_pegar(Coisa):-
  not(fixo(Coisa)),
  lugar_atual(Lugar),
  posicao(Coisa,Lugar),!.
  
possivel_pegar(Coisa):-
  not(fixo(Coisa)),
  lugar_atual(Lugar),
  posicao(Movel,Lugar),
  posicao(Coisa,Movel),!.
  
possivel_pegar(Coisa):-
  write('Nao ha '),write(Coisa),write(' aqui, ou eh um objeto fixo.'),
  nl,
  fail,!.
  
pegar_coisa(Coisa):-
  
  retract(posicao(Coisa,X)),
  
  asserta(possui(Coisa)),
  write('pegou '),write(Coisa),write('.'),
  nl,!.

  
inventario:-  
  possui(Coisa),
  write('Inventario:'),
  nl,
  listar_inventario,!.
inventario:-
  not(possui(Coisa)),
  write('Inventario vazio!'),
  nl,!.

listar_inventario:-
  possui(Coisa),
  tab(2),write(Coisa),
  nl,
  fail,!.
 
jogar(Coisa):-
  possui(Coisa),
  retract(possui(Coisa)),
  lugar_atual(X),
  asserta(posicao(Coisa,X)),
  write('removido!'),!.
 
objetivo:-
  possui(chaves),
  write('Voce encontrou suas chaves!'),
  nl,
  nl,
  nl,
write('  ad8888888888ba'),nl,
write(' dP-         ||8b,'),nl,
write(' 8  ,aaa,       |Y888a     .aaaa.     .aa.   .aa. '),nl,
write(' 8  8   8           "88baadP""""YbaaadP"""YbdP""Yb'),nl,
write(' 8  8   8              ^^^        ^^^      ^^    8b'),nl,
write(' 8  8. .8         ,aaaaaaaaaaaaaaaaaaaaaaaaddddd88P'),nl,
write(' 8  `aaa.       .d8||'),nl,
write(' Yb,         .ad8.'),nl,
write('  aY8888888888Pa'),nl.
