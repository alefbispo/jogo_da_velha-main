import 'package:flutter/material.dart';
import 'package:jogo_da_velha/core/constantes.dart';
import 'package:jogo_da_velha/core/tema_app.dart';
import 'package:jogo_da_velha/pages/pagina_jogo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: TITULO_JOGO,
      theme: temaDoApp,
      home: PaginaDoJogo(),
    );
  }
}