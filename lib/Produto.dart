// ignore_for_file: file_names
class Produto {
  final String nome;
  final int nota;
  final String quantidade;
  final String imagem;
  final String alerta;
  final String descricao;
  final String marca;
  final String codigo;
  List<String> ingredientes = [];

  Produto(this.nome, this.nota, this.quantidade, this.imagem, this.alerta,
      this.descricao, this.marca, this.ingredientes, this.codigo);
}
