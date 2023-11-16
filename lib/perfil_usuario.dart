import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc_flutter_7/Tag.dart';
import 'package:tcc_flutter_7/Usu%C3%A1rio.dart';
import 'package:tcc_flutter_7/editarPerfil.dart';
import 'package:tcc_flutter_7/login.dart';
import 'package:tcc_flutter_7/menu_navegacao.dart';

class PerfilUsuario extends StatefulWidget {
  Usuario user;
  PerfilUsuario({super.key, required this.user});

  @override
  // ignore: library_private_types_in_public_api
  _PerfilUsuarioState createState() => _PerfilUsuarioState();
}

class _PerfilUsuarioState extends State<PerfilUsuario> {
  String image = '';
  String nome = '';
  List<Tag> alergias = [];

  String verficaImagem() {
    if (image.isEmpty || image == '') {
      return 'assets/user.png';
    } else {
      return image;
    }
  }

  void preencher(Usuario user)
  {
    image = user.imagem;
    nome = user.nome;
    List<Tag> alerg = [];
    for(String alergia in user.alergias)
    {
      alerg.add(Tag(alergia,255, 255, 100, 1));
    }
    alergias = alerg;
  }

  SizedBox espaco = const SizedBox(
    width: 30,
  );
  SizedBox margem = const SizedBox(
    height: 30,
  );

  @override
  Widget build(BuildContext context) {
    preencher(widget.user);
    image = verficaImagem();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
        children: [
          Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.only(right: 10, top: 30),
            child: IconButton(
              icon: const Icon(Icons.settings, color: Colors.grey, size: 30),
              onPressed: () {},
            ),
          ),
          margem,
          ClipOval(
              child: Image.asset(
            image,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          )),
          Text(
            nome,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          margem,
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => EditarPerfil(user: usuario)));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(88, 0, 221, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: const EdgeInsets.all(16.0),
              textStyle: const TextStyle(
                fontSize: 18.0,
              ), // Define o tamanho da fonte // Defina o raio de canto desejado
            ),
            child: const Text(
              'Editar Perfil',
              style: TextStyle(fontSize: 15),
            ),
          ),
          margem,
          const Text(
            'Alergias',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 150,
            child: SingleChildScrollView(
              child: Column(
                children: alergias.map((tag) {
                  return Container(
                    margin: const EdgeInsets.only(top: 5),
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(229, 227, 227, 1),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      tag.descricao,
                      style: const TextStyle(
                        fontSize: 15.0,
                        color: Color.fromRGBO(114, 113, 113, 1),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          margem,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.logout, color: Color(0xFF5800DD)),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => const Login()));
                },
              ),
              const Text('Sair',
                  style: TextStyle(
                      color: Color.fromARGB(255, 53, 52, 52), fontSize: 18))
            ],
          )
        ],
      )),
    );
  }
}
