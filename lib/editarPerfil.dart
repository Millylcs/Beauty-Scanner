import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:tcc_flutter_7/Tag.dart';
import 'package:tcc_flutter_7/Usu%C3%A1rio.dart';
import 'package:tcc_flutter_7/pesquisa_ingrediente.dart';

class EditarPerfil extends StatefulWidget {
  Usuario user;
  EditarPerfil({super.key, required this.user});

  @override
  _PerfilUsuarioState createState() => _PerfilUsuarioState();
}

class _PerfilUsuarioState extends State<EditarPerfil> { 

  Future<void> reautenticarUsuario(String email, String senhaAtual) async {
    try {
      User? u = FirebaseAuth.instance.currentUser;
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: senhaAtual);
      await u?.reauthenticateWithCredential(credential);
      uid = u?.uid;
      print('Reautenticação bem-sucedida');
    } catch (e) {
      print('Erro ao reautenticar: $e');
    }
  }

  Future<void> alterarSenha(String novaSenha) async {
    try {
      User? u = FirebaseAuth.instance.currentUser;
      await u?.updatePassword(novaSenha);
      print('Senha atualizada com sucesso');
    } catch (e) {
      print('Erro ao atualizar a senha: $e');
    }
  }

  Future<void> substituirCamposUsuario(String? uid, String nome, List<Tag> alergias) async {
    try {
      List<Map<String, dynamic>> alergiasMapList;
      if(alergias.isEmpty!)
       alergiasMapList = alergias.map((tag) => tag.toMap()).toList();
      else alergiasMapList = [];

      await FirebaseFirestore.instance.collection('users').doc(uid).update({'nome': nome, 'alergias': alergiasMapList});
      print('Campos do usuário substituídos com sucesso.');
    } catch (e) {
      print('Erro ao substituir campos do usuário: $e');
    }
  }
 
  String img = 'assets/user.png';
  File? image;
  String nome = '';
  String email = '';
  String senha = '';
  List<Tag> alergias = [];
  String? uid = '';

  // Função para abrir a galeria e selecionar uma imagem
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        image =
            File(pickedFile.path); // Esconder o botão após selecionar a imagem
      }
    });
  }

  SizedBox espaco = const SizedBox(width: 30);
  SizedBox margem = const SizedBox(height: 30);
  Color roxo = const Color(0xFF5800DD);
  Container titulo(String txt) {
    return Container(
        margin: const EdgeInsets.only(left: 20),
        alignment: Alignment.topLeft,
        child: Text(
          txt,
          style: const TextStyle(
              color: Color.fromRGBO(114, 113, 113, 16), fontSize: 18),
        ));
  }

  bool first = true;
  void pesquisarBanco(Usuario user) {
    if (first) {
      nome = user.nome;
      email = user.email;
      senha = user.senha;
      List<Tag> alerg = [];
      for (String al in user.alergias) {
        alerg.add(Tag(al, 114, 113, 113, 1));
      }
      alergias = alerg;
      first = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Container dado(String txt, int lines, String tipo, bool pass) {
      return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(top: 15, bottom: 15, left: 20),
          margin: const EdgeInsets.only(left: 15, right: 15),
          decoration: BoxDecoration(
              color: Colors.grey[100], borderRadius: BorderRadius.circular(50)),
          child: TextField(
            obscureText: pass,
            controller: TextEditingController(text: txt),
            decoration: null,
            maxLines: lines,
            onChanged: (value) {
              switch (tipo) {
                case 'nome':
                  nome = value;
                  break;
                case 'email':
                  email = value;
                  break;
                case 'senha':
                  senha = value;
                  break;
              }
            },
          ));
    }

    pesquisarBanco(widget.user);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: roxo,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            espaco,
            Text(
              'Editar Perfil',
              style: TextStyle(color: roxo),
            ),
            espaco
          ],
        ),
        titleTextStyle: const TextStyle(
          color: Color(0xFF5800dd),
          fontSize: 25,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              margem,
              Container(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    if (image != null)
                      ClipOval(
                          child: Image.file(
                        File(image!.path),
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ))
                    else
                      ClipOval(
                        child: Image.asset(
                          img,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: const Color.fromARGB(120, 35, 35, 35)),
                        height: 200,
                        width: 200,
                        alignment: Alignment.center,
                        child: IconButton(
                            icon: const Icon(Icons.add_photo_alternate,
                                color: Colors.grey),
                            onPressed: _pickImage)),
                  ],
                ),
              ),
              titulo('Nome'),
              dado(nome, 1, 'nome', false),
              // titulo('Email'),
              // dado(email, 1, 'email', false),
              titulo('Senha'),
              dado(senha, 1, 'senha', true),
              margem,
              Column(
                children: [
                  Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 150, top: 10),
                    child: Row(
                      children: [
                        const Text(
                          'alergias',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 5),
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Color.fromRGBO(229, 227, 227, 1),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.add,
                              size: 15,
                              color: Color.fromRGBO(97, 95, 95, 1),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PesquisaIngrediente(
                                      lista: alergias, tipo: 'ingredientes'),
                                ),
                              ).then((retorno) {
                                if (retorno != null) {
                                  setState(() {
                                    alergias = retorno['lista'];
                                  });
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left:5, right: 5, top:10),
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: alergias.map((tag) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              //margin: EdgeInsets.only(top: 0),
                              height: 35,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(229, 227, 227, 1),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 22,
                                    margin: const EdgeInsets.only(left: 8),
                                    child: Container(
                                      padding: EdgeInsets.zero,
                                      decoration: const ShapeDecoration(
                                        color: Colors.red,
                                        shape: CircleBorder(),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                          size: 8,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            alergias.remove(tag);
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        const EdgeInsets.only(right: 13, left: 5),
                                    child: Text(
                                      tag.descricao,
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        color: Color.fromRGBO(114, 113, 113, 1),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              margem,
              ElevatedButton(
                  onPressed: () {
                    // AQUIIIIIIIIIIIIIIIIIIIIIIII
                    bool isPasswordValid(String senha) {
                      bool hasUppercase = false;
                      bool hasLowercase = false;
                      bool hasNumber = false;
                      bool lenght = false;

                      for (int i = 0; i < senha.length; i++) {
                        if (senha[i].contains(RegExp(r'[A-Z]'))) {
                          hasUppercase = true;
                        } else if (senha[i].contains(RegExp(r'[a-z]'))) {
                          hasLowercase = true;
                        } else if (senha[i].contains(RegExp(r'[0-9]'))) {
                          hasNumber = true;
                        }
                      }
                      if (senha.length >= 8) lenght = true;

                      return hasUppercase && hasLowercase && hasNumber && lenght;
                    }

                    if (!isPasswordValid(senha))
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text('Defina uma senha com mais de 8 caracteres, com pelo menos uma letra maiúscula, uma minúscula e um número.'),
                            );
                          },
                        );
                    else{
                      reautenticarUsuario(email, widget.user.senha);
                      alterarSenha(senha);
                      substituirCamposUsuario(uid, nome, alergias);
                    }
                // else
                  // registerUser(email, senha, nome, alergias, recomendacoes, context);





                    // showDialog(
                    //   context: context,
                    //   builder: (BuildContext context) {
                    //     return AlertDialog(
                    //       title: const Text('Teste Navegação'),
                    //       content: Text(
                    //           '$nome\n$email\n$senha\n$image\n${alergias.toString()}'),
                    //     );
                    //   },
                    // );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: roxo,
                      padding: const EdgeInsets.only(
                          top: 15, bottom: 15, left: 15, right: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      )),
                  child: const Text(
                    'Salvar',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
