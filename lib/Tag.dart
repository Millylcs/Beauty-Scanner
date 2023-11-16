class Tag {
  final String descricao;
  final int red;
  final int blue;
  final int green;
  final double opacity;

  Tag(
    this.descricao,
    this.red,
    this.green,
    this.blue,
    this.opacity,
  );

  Map<String, dynamic> toMap() {
    return {
      'descricao': descricao,
      'red': red,
      'blue': blue,
      'green': green,
      'opacity': opacity,
    };
  }
}
