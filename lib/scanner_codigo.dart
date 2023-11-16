import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/enum.dart';
import 'package:simple_barcode_scanner/screens/shared.dart';
// import 'package:simple_barcode_scanner/enum.dart';
// import 'package:simple_barcode_scanner/screens/shared.dart';
import 'package:tcc_flutter_7/Produto.dart';
import 'package:tcc_flutter_7/Usu%C3%A1rio.dart';
import 'package:tcc_flutter_7/VisuProduto.dart';
import 'package:tcc_flutter_7/home.dart';
import 'package:tcc_flutter_7/menu_navegacao.dart';
import 'package:tcc_flutter_7/novoProduto.dart';

class ScannerCodigo extends StatefulWidget {
  Usuario user;
  ScannerCodigo({super.key, required this.user});

  @override
  State<ScannerCodigo> createState() => _ScannerCodigoState();
}

late Usuario usuario;

class _ScannerCodigoState extends State<ScannerCodigo> {
  Produto encontrado = Produto(
      '', 0, '', 'imagem', 'alerta', 'descricao', 'marca', [], 'codigo');

  Future<bool> searchProducts(String searchTerm) async {
    print(searchTerm);
    final QuerySnapshot produtos = await FirebaseFirestore.instance
        .collection('produtos')
        .where('codigo', isEqualTo: searchTerm)
        .get();

    if (produtos.docs.isNotEmpty) {
      final String nome = produtos.docs[0].get('nome');
      final int nota = produtos.docs[0].get('nota').toInt();
      final String quantidade = produtos.docs[0].get('quantidade');
      final String alerta = produtos.docs[0].get('alerta');
      final String descricao = produtos.docs[0].get('descricao');
      final String marca = produtos.docs[0].get('marca');
      String imagem = produtos.docs[0].get('url');
      String codigo = produtos.docs[0].get('codigo');

      encontrado = Produto(
          nome, nota, quantidade, imagem, alerta, descricao, marca, [], codigo);
      // ignore: use_build_context_synchronously
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) => VisuProduto(produto: encontrado, user: widget.user)))
          .then((retorno) {
        Navigator.push(context,
            MaterialPageRoute(builder: (c) => MenuNavegacao(user: usuario)));
      });
      return true;
    } else {
      // ignore: use_build_context_synchronously
      return false;
    }
  }

  String result = "";
  @override
  Widget build(BuildContext context) {
    usuario = widget.user;
    return BarcodeScanner(
      lineColor: '#5500DD',
      cancelButtonText: 'voltar',
      isShowFlashIcon: false,
      scanType: ScanType.barcode,
      //appBarTitle: 'titulo',
      //centerTitle: true,
      onScanned: (res) async {
        result = res;
        bool tals = await searchProducts(result);
        if (!tals) {
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Container(
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(right: 5),
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: const Icon(Icons.close, color: Colors.grey),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) =>
                                            MenuNavegacao(user: usuario)));
                              },
                            )),
                        const Column(
                          children: [
                            Icon(
                              Icons.error,
                              color: Colors.red,
                            ),
                            Text(
                              'oops...',
                              style: TextStyle(color: Colors.red, fontSize: 20),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  content: const Text(
                      'O produto não pôde ser encontrado, talvez ele ainda não esteja em nossa base de dados, deseja cadastrá-lo?'),
                  actions: [
                    Container(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => const NovoProduto()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5800dd),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: const Text(
                          'Cadastrar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ]);
            },
          );
        }
      },
    );
  }
}
