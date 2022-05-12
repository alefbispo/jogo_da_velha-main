import 'package:flutter/material.dart';
import 'package:jogo_da_velha/core/constantes.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final Function onPressed;

  const CustomDialog(this.title, this.message, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onPressed();
          },
          child: const Text(BOTAO_RESET_LABEL),
        )
      ],
    );
  }
}
