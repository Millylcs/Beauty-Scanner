// ignore: file_names
class Usuario {
  final String nome;
  final String email;
  final String senha;
  final List<String> alergias;
  final List<String> recomendacoes;
  final List<String> favoritos;
  final String imagem;

  Usuario(this.nome, this.email, this.senha, this.alergias, this.recomendacoes,
      this.favoritos, this.imagem);

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'email': email,
      'senha': senha,
      'alergias': alergias,
      'recomendacoes': recomendacoes,
      'favoritos': favoritos,
      'url': imagem
    };
  }
}
