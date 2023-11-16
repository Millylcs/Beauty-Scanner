import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tcc_flutter_7/Marca.dart';
import 'package:tcc_flutter_7/Produto.dart';
import 'package:tcc_flutter_7/Usu%C3%A1rio.dart';
import 'package:tcc_flutter_7/VisuProduto.dart';

class ExibirMarca extends StatefulWidget {
  final Marca marca;
  ExibirMarca({super.key, required this.marca});

  @override
  State<ExibirMarca> createState() => _ExibirMarcaState();
}

class _ExibirMarcaState extends State<ExibirMarca> {
  bool corpo = true;
  String descricaoExibirMarca = "";
  FontWeight fonte1 = FontWeight.normal;
  FontWeight fonte2 = FontWeight.bold;
  SizedBox espaco = const SizedBox(width: 25);
  List<Produto> produtos = [];
  late Usuario user;

  void bsucarProdutosMarca(String nomeMarca) async {
    final QuerySnapshot prods = await FirebaseFirestore.instance
        .collection('produtos')
        .where('marca', isGreaterThanOrEqualTo: nomeMarca)
        .get();

    print(prods.docs.length);
    List<Produto> listProdutos = [];
    for (QueryDocumentSnapshot produtoDoc in prods.docs) {
      final String nome = produtoDoc.get('nome');
      final int nota = produtoDoc.get('nota').toInt();
      final String quantidade = produtoDoc.get('quantidade');
      final String alerta = produtoDoc.get('alerta');
      final String descricao = produtoDoc.get('descricao');
      final String marca = produtoDoc.get('marca');
      String imagem = produtoDoc.get('url');
      String codigo = produtoDoc.get('codigo');
      List<String> ingrediente = produtoDoc.get('ingredientes');
      print(nome);

      Produto produto = Produto(nome, nota, quantidade, imagem, alerta,
          descricao, marca, ingrediente, codigo);
      listProdutos.add(produto);
    }
    setState(() {
      produtos = listProdutos;
    });
  }

  @override
  Widget build(BuildContext context) {
    bsucarProdutosMarca(widget.marca.nome);
    SingleChildScrollView descricao = SingleChildScrollView(
      child: Container(
          margin: const EdgeInsets.all(20),
          child: Text(
            descricaoExibirMarca,
            style: const TextStyle(fontSize: 17),
          )),
    );
    Container tal = Container(
        margin: const EdgeInsets.only(top: 10),
        alignment: Alignment.topLeft,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Wrap(
              direction: Axis
                  .horizontal, // Define a direção da "embalagem" (horizontal no seu caso)
              spacing: 8.0, // Espaçamento horizontal entre os itens
              runSpacing: 8.0, // Espaçamento vertical entre as linhas de itens
              children: produtos.map((currItem) {
                print(produtos.toString());
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) =>
                                VisuProduto(produto: currItem, user: user)));
                  },
                  child: Container(
                      width: 180,
                      height: 200,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF1c1c1c),
                            blurRadius: 2,
                            spreadRadius: 0.3,
                            offset: Offset(
                              1.5,
                              1.5,
                            ),
                          )
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            alignment: Alignment.topCenter,
                            child: Stack(children: [
                              Image(
                                image: NetworkImage(currItem.imagem),
                                height: 400,
                                alignment: Alignment.topCenter,
                              ),
                              Positioned(
                                bottom: 110,
                                left: 80,
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 13, right: 13, top: 5, bottom: 5),
                                  margin: const EdgeInsets.only(
                                      top: 40, left: 30, right: 10),
                                  decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                        stops: [0.18, 0.6],
                                        colors: [
                                          Color(0xFF4b0194),
                                          Color(0xFF5500dd)
                                        ],
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0))),
                                  child: Text('${currItem.nota}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                ),
                              )
                            ]),
                          ),
                          Column(
                            children: [
                              Container(
                                  margin:
                                      const EdgeInsets.only(left: 15, top: 140),
                                  child: SizedBox(
                                      width: 180, child: Text(currItem.nome))),
                              Container(
                                margin: const EdgeInsets.only(left: 15),
                                child: Row(
                                  children: [
                                    Text(currItem.marca),
                                    Text(', ${currItem.quantidade} ml')
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      )),
                );
              }).toList(),
            ),
          ),
        ));
    descricaoExibirMarca = widget.marca.descricao;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Column(
          children: [
            Container(
                height: 100,
                alignment: Alignment.center,
                child: Image(
                  image: NetworkImage(widget.marca.imagem),
                )),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  child: Text(
                    'Produtos',
                    style: TextStyle(
                        fontWeight: fonte1, color: Colors.black, fontSize: 22),
                  ),
                  onPressed: () {
                    setState(() {
                      corpo = true;
                      fonte1 = FontWeight.bold;
                      fonte2 = FontWeight.normal;
                    });
                  },
                ),
                espaco,
                const Text('|'),
                espaco,
                TextButton(
                  child: Text(
                    'ExibirMarca',
                    style: TextStyle(
                        fontWeight: fonte2, color: Colors.black, fontSize: 22),
                  ),
                  onPressed: () {
                    setState(() {
                      corpo = false;
                      fonte1 = FontWeight.normal;
                      fonte2 = FontWeight.bold;
                    });
                  },
                ),
              ],
            ),
            if (corpo) tal else descricao,
          ],
        )));
  }
}
