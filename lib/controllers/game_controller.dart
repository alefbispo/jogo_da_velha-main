import 'dart:math';

import 'package:jogo_da_velha/core/constantes.dart';
import 'package:jogo_da_velha/core/regras_ganhador.dart';
import 'package:jogo_da_velha/enums/tipo_jogador.dart';
import 'package:jogo_da_velha/enums/tipo_vencedor.dart';
import 'package:jogo_da_velha/models/tabuleiro.dart';

class GameController {
  List<Tabuleiro> campos = [];
  List<int> movimentosJogador1 = [];
  List<int> movimentosJogador2 = [];
  TipoJogador jogadorAtual = TipoJogador.jogador2;
  bool isSinglePlayer = false;

  bool get hasMoves =>
      (movimentosJogador1.length + movimentosJogador2.length) !=
      TAMANHO_TABULEIRO;

  GameController() {
    _iniciar();
  }

  jogadorDaVez() {
    String vez;
    if (jogadorAtual.index == 0) {
      vez = "Rodada do X";
    } else {
      vez = "Rodada do O";
    }
    return vez;
  }

  void _iniciar() {
    movimentosJogador1.clear();
    movimentosJogador2.clear();
    jogadorAtual = TipoJogador.jogador1;
    isSinglePlayer = false;
    campos = List<Tabuleiro>.generate(
        TAMANHO_TABULEIRO, (index) => Tabuleiro(index + 1));
  }

  reset() {
    movimentosJogador1.clear();
    movimentosJogador2.clear();
    jogadorAtual = TipoJogador.jogador1;
    campos = List<Tabuleiro>.generate(
        TAMANHO_TABULEIRO, (index) => Tabuleiro(index + 1));
  }

  void marcarTabuleiroNoIndice(index) {
    final campo = campos[index];
    if (jogadorAtual == TipoJogador.jogador1) {
      _marcarTabuleiroComJogador1(campo);
    } else {
      _marcarTabuleiroComJogador2(campo);
    }

    campo.disponivel = false;
  }

  void _marcarTabuleiroComJogador1(Tabuleiro campo) {
    campo.symbol = JOGADOR1_SIMBOLO;
    campo.color = JOGADOR1_COR;
    movimentosJogador1.add(campo.id);
    jogadorAtual = TipoJogador.jogador2;
  }

  void _marcarTabuleiroComJogador2(Tabuleiro campo) {
    campo.symbol = JOGADOR2_SIMBOLO;
    campo.color = JOGADOR2_COR;
    movimentosJogador2.add(campo.id);
    jogadorAtual = TipoJogador.jogador1;
  }

  bool _chegarJogadorGanhador(List<int> movimento) {
    return regrasVitoria.any((regra) =>
        movimento.contains(regra[0]) &&
        movimento.contains(regra[1]) &&
        movimento.contains(regra[2]));
  }

  TipoVencedor checarVencedor() {
    if (_chegarJogadorGanhador(movimentosJogador1)) {
      return TipoVencedor.jogador1;
    }

    if (_chegarJogadorGanhador(movimentosJogador2)) {
      return TipoVencedor.jogador2;
    }

    return TipoVencedor.nenhum;
  }

  int movimentoAutomatico() {
    var lista = List.generate(9, (i) => i + 1);
    lista.removeWhere((element) => movimentosJogador1.contains(element));
    lista.removeWhere((element) => movimentosJogador2.contains(element));

    // instanciando metodo random
    var random = Random();

    // escolhando um index aleatorio do tamanho do tabuleiro
    var index = random.nextInt(lista.length - 1);

    // usando randon para ocupar um campo livre no tabuleiro
    return campos.indexWhere((campo) => campo.id == lista[index]);
  }
}
