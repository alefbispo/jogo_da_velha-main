import 'package:flutter/material.dart';

class Tabuleiro{
  final int id;
  String symbol;
  Color color;
  bool disponivel;

  Tabuleiro(
      this.id, {
        this.symbol = '',
        this.color = Colors.black26,
        this.disponivel = true,
  });
}