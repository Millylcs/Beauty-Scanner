// ignore: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:tcc_flutter_7/Produto.dart';
import 'package:tcc_flutter_7/Usu%C3%A1rio.dart';

// ignore: must_be_immutable
class VisuProduto extends StatefulWidget {
  Produto produto;
  Usuario user;
  VisuProduto({super.key, required this.produto, required this.user});

  @override
  State<VisuProduto> createState() => _VisuProdutoState();
}

class _VisuProdutoState extends State<VisuProduto> {
  Future<void> searchIngredients(String searchTerm) async {
    final QuerySnapshot ingredientes = await FirebaseFirestore.instance
        .collection("ingredientes")
        .where('nome', isEqualTo: searchTerm)
        .get();
    // List<String> teste = [];

    bool exists = false;
    for (DocumentSnapshot i in ingredientes.docs) {
      int note = i.get('nota').toInt();
      if (note <= 5) {
        nota += note * 3;
      } else {
        nota += note;
      }
      quantosIng++;
    }
  }

  //String nome = widget.produto.nome;
  //int quantidade = 100;
  //String imagem = "assets/testeProduto.png";
  //String alerta = "alergia e tal tal tal";
  //String descricao = "";
  int nota = 0;
  int nota2 = 0;
  int quantosIng = 0;
  String marca = "Bioré";
  var ingredientes = [];
  final gradientColors = [
    Colors.blue,
    Colors.green,
  ];
  bool curtida = false;
  bool _visible = false;
  String novoAlerta = "";
  Icon vazio = const Icon(Icons.favorite_border, color: Colors.white, size: 30);
  Icon cheio = const Icon(Icons.favorite, color: Colors.white, size: 30);
  Icon icone = const Icon(
    Icons.favorite_border,
    color: Colors.white,
    size: 30,
  );
  bool first = true;
  bool temAlergia(List<String> ingredientes, List<String> alergias) {
    bool retorno = false;
    if (first) {
      for (String ingred in ingredientes) {
        if (alergias.contains(ingred)) {
          novoAlerta +=
              ". Você contém alergia ao ingrediente $ingred presente nesse produto. ";
        }
        retorno = true;
      }
    }
    first = false;
    return retorno;
  }

  void setIcon() {
    setState(() {
      if (curtida) {
        icone = vazio;
        curtida = false;
        //descurtir no bd
        widget.produto.alerta;
      } else {
        icone = cheio;
        curtida = true;
        //curtir no bd
      }
    });
  }

  void calcularNota() async {
    for (String ing in widget.produto.ingredientes) {
      await searchIngredients(ing);
    }
    setState(() {});
  }

  int setNota(int rank) {
    if (quantosIng > 0) {
      int n;
      if (_visible) {
        n = rank ~/ quantosIng;
        n -= (n * 30 ~/ 100);
      } else
        n = rank ~/ quantosIng;

      print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAA $n");

      return n;
    } else {
      return rank;
    }
  }

  @override
  Widget build(BuildContext context) {
    _visible = temAlergia(widget.produto.ingredientes, widget.user.alergias);
    calcularNota();
    nota2 = widget.produto.nota;
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              // Where the linear gradient begins and ends
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              // Add one stop for each color. Stops should increase from 0 to 1
              stops: [0.18, 0.6],
              colors: [
                // Colors are easy thanks to Flutter's Colors class.
                Color(0xFF4b0194),
                Color(0xFF5500dd)
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                  top: 40,
                  left: 20,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white, size: 30),
                  )),
              Positioned(
                  top: 40,
                  right: 30,
                  child: Container(
                    width: 65,
                    height: 65,
                    decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF1c1c1c),
                            blurRadius: 8,
                            spreadRadius: 0.4,
                            offset: Offset(1, 1),
                          )
                        ],
                        color: Color.fromRGBO(255, 255, 255, 1),
                        borderRadius: BorderRadius.all(Radius.circular(50.0))),
                    child: Container(
                        //padding: const EdgeInsets.only(left: 20, top: 8),
                        alignment: Alignment.center,
                        child: GradientText(
                          setNota(nota).toString(),
                          style: const TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 40.0,
                          ),
                          colors: const [
                            Color(0xFF5500dd),
                            Color(0xFFA26BFA),
                            Color(0xFFA26BFA),
                          ],
                        )),
                  )),
              // ignore: sized_box_for_whitespace
              Center(
                  child: Container(
                //decoration: new BoxDecoration(color: Colors.white),
                margin: const EdgeInsets.only(bottom: 250),
                width: 350,
                //alignment: Alignment.center,
                child: Image(image: NetworkImage(widget.produto.imagem)),
              )),
              Positioned(
                  top: 400,
                  right: 25,
                  child: TextButton(
                    child: icone,
                    onPressed: () {
                      setIcon();
                    },
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 460, left: 15, right: 15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(margin: const EdgeInsets.only(left: 15)),
                          SizedBox(
                            width: 270,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(widget.produto.nome,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.bold,
                                      wordSpacing: 0,
                                      fontSize: 20)),
                            ),
                          ),
                          const Text("|",
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Color(0xFFA26BFA),
                                  fontSize: 20)),
                          Container(
                            margin: const EdgeInsets.only(left: 5),
                            child: Text(
                              '${widget.produto.quantidade} ml',
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.none,
                                  fontSize: 20),
                            ),
                          )
                        ],
                      ),
                      Container(
                        //width: 1000,
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 3, left: 15),
                        child: GestureDetector(
                          onTap: () {},
                          child: Text(
                            textAlign: TextAlign.start,
                            widget.produto.marca,
                            style: const TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.normal,
                                fontSize: 18),
                          ),
                        ),
                      ),
                      Container(
                        // width: 1000,
                        alignment: Alignment.topLeft,
                        height: 200,
                        margin: const EdgeInsets.only(top: 20, left: 15),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Text(
                            textAlign: TextAlign.start,
                            "${widget.produto.descricao}\r\n\r\n",
                            style: const TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.normal,
                                fontSize: 18),
                          ),
                        ),
                      )
                    ],
                  )),
              Positioned(
                bottom: 25,
                right: 50,
                left: 50,
                child: AnimatedOpacity(
                  opacity: _visible ? 1.0 : 0.0,
                  duration: const Duration(minutes: 1),                  
                  child: Container(
                    width: 300,
                    //height: 80,
                    decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF1c1c1c),
                            blurRadius: 8,
                            spreadRadius: 0.4,
                            offset: Offset(1.5, 1.5),
                          )
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Row(children: [
                      const Padding(
                        padding: EdgeInsets.only(
                            right: 20, left: 20, top: 15, bottom: 15),
                        child: Icon(Icons.info_outlined,
                            color: Color(0xFFde8806), size: 30),
                      ),
                      Container(
                        margin: EdgeInsets.all(5),
                        width: 200,
                        child: Text(
                          widget.produto.alerta + novoAlerta,
                          style: const TextStyle(
                              color: Color(0xFFde8806),
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.normal,
                              fontSize: 15),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
