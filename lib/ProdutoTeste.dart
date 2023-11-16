import 'dart:typed_data';
import 'package:flutter/material.dart';

// ignore_for_file: file_names
class ProdutoTeste {
  final String nome;
  final int nota;
  final String quantidade;
  final AssetImage imagem;
  final String alerta;
  final String descricao;
  final String marca;
  var ingredientes = [];

  ProdutoTeste(this.nome, this.nota, this.quantidade, this.imagem, this.alerta,
      this.descricao, this.marca, this.ingredientes);
}