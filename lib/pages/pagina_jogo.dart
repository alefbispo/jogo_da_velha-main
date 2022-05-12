import 'package:flutter/material.dart';
import 'package:jogo_da_velha/controllers/game_controller.dart';
import 'package:jogo_da_velha/core/constantes.dart';
import 'package:jogo_da_velha/enums/tipo_jogador.dart';
import 'package:jogo_da_velha/enums/tipo_vencedor.dart';
import 'package:jogo_da_velha/widgets/custom_dialog.dart';

class PaginaDoJogo extends StatefulWidget {
  @override
  _PaginaDoJogo createState() => _PaginaDoJogo();
}

int placarX = 0;
int placarO = 0;

class _PaginaDoJogo extends State<PaginaDoJogo> {
  final _controller = GameController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: const Text(TITULO_JOGO),
      centerTitle: true,
    );
  }

  _buildBody() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _txtJogadorDaVez(),
          _buildBord(),
          _buildPlacar(),
          _buildPlayerMode(),
          _buildResetButton(),
        ],
      ),
    );
  }

  _buildPlacar() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: const Text(
            'Placar',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text('X = $placarX    O = $placarO',
            style: TextStyle(
              fontSize: 35,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 3
                ..color = Colors.red[700]!,
            ))
      ],
    );
  }

  _txtJogadorDaVez() {
    return Container(
      alignment: Alignment.center,
      child:
          Text(
        _controller.jogadorDaVez(),
        style: TextStyle(
          fontSize: 35,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3
            ..color = Colors.red[700]!,
        ),
      ),
      // Solid text as fill.
    );
  }

  _limparPlacar() {
    placarO = 0;
    placarX = 0;
  }

  _buildResetButton() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        child: const Text(BOTAO_RESET_LABEL),
        onPressed: _onResetGameBtn,
      ),
    );
  }

  _buildBord() {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: TAMANHO_TABULEIRO,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: _buidTitle,
      ),
    );
  }

  Widget _buidTitle(context, index) {
    return GestureDetector(
      onTap: () => _onMarkTitle(index),
      child: Container(
        color: _controller.campos[index].color,
        child: Center(
          child: Text(
            _controller.campos[index].symbol,
            style: const TextStyle(
              fontSize: 72.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  _onResetGame() {
    setState(() {
      _controller.reset();
    });
  }

  _onResetGameBtn() {
    setState(() {
      _limparPlacar();
      _controller.reset();
    });
  }

  _onMarkTitle(index) {
    if (!_controller.campos[index].disponivel) return;

    setState(() {
      _controller.marcarTabuleiroNoIndice(index);
    });
    _checkWinner();
  }

  _checkWinner() {
    var winner = _controller.checarVencedor();
    if (winner == TipoVencedor.nenhum) {
      if (!_controller.hasMoves) {
        _showTiedDialog();
      } else if (_controller.isSinglePlayer &&
          _controller.jogadorAtual == TipoJogador.jogador2) {
        final index = _controller.movimentoAutomatico();
        _onMarkTitle(index);
      }
    } else {
      String symbol =
          winner == TipoVencedor.jogador1 ? JOGADOR1_SIMBOLO : JOGADOR2_SIMBOLO;
      _showWinnerDialog(symbol);
      winner == TipoVencedor.jogador1 ? placarX++ : placarO++;
    }
  }

  _showWinnerDialog(String symbol) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialog(TITULO_GANHADOR.replaceAll('[SIMBOLO]', symbol),
            MENSAGEM_DIALOG, _onResetGame);
      },
    );
  }

  _showTiedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialog(
          TITULO_EMPATADO,
          MENSAGEM_DIALOG,
          _onResetGame,
        );
      },
    );
  }

  _buildPlayerMode() {
    return SwitchListTile(
      title: Text(_controller.isSinglePlayer ? 'JOGO SOLO' : 'DOIS JOGADORES'),
      secondary: Icon(_controller.isSinglePlayer ? Icons.person : Icons.group),
      value: _controller.isSinglePlayer,
      onChanged: (value) {
        setState(() {
          _controller.isSinglePlayer = value;
          _limparPlacar();
          _controller.reset();
        });
      },
    );
  }
}
