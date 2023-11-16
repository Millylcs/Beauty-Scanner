// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tcc_flutter_7/Usu%C3%A1rio.dart';
import 'package:tcc_flutter_7/favoritos.dart';
import 'package:tcc_flutter_7/home.dart';
import 'package:tcc_flutter_7/novoProduto.dart';
import 'package:tcc_flutter_7/pesquisa_ingrediente.dart';
//import 'package:tcc_flutter_5/login.dart';
//import 'package:tcc_flutter_7';
import 'package:tcc_flutter_7/scanner_codigo.dart';
import 'package:tcc_flutter_7/perfil_usuario.dart';
import 'package:tcc_flutter_7/teste.dart';
import 'package:tcc_flutter_7/testeimagemlaura.dart';

class MenuNavegacao extends StatefulWidget {
  final Usuario user;
  const MenuNavegacao({super.key, required this.user});

  @override
  State<MenuNavegacao> createState() => _MenuNavegacaoState();
}

late Usuario usuario;

class _MenuNavegacaoState extends State<MenuNavegacao> {
  int _indiceAtual = 1;
  static //const
      final List<Widget> _widgetOptions = <Widget>[
    PerfilUsuario(user: usuario),
    Home(user: usuario),
    ScannerCodigo(user: usuario),
    Favoritos(user: usuario)
  ];

  @override
  Widget build(BuildContext context) {
    usuario = widget.user;
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_indiceAtual),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _indiceAtual,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          onTap: onTabTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_sharp),
                label: '',
                backgroundColor: Color.fromRGBO(88, 0, 221, 1)),
            BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: '',
                backgroundColor: Color.fromRGBO(88, 0, 221, 1)),
            BottomNavigationBarItem(
                icon: Icon(Icons.qr_code_scanner),
                label: '',
                backgroundColor: Color.fromRGBO(88, 0, 221, 1)),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: '',
                backgroundColor: Color.fromRGBO(88, 0, 221, 1)),
          ],
          selectedItemColor: Color.fromARGB(255, 182, 134, 240),
          backgroundColor: const Color.fromRGBO(88, 0, 221, 1)),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _indiceAtual = index;
    });
  }
}
