import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tcc_flutter_7/Usu%C3%A1rio.dart';
import 'package:tcc_flutter_7/cadastro_usuario.dart';
import 'package:tcc_flutter_7/menu_navegacao.dart';
import 'package:tcc_flutter_7/recuperar_email.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({
    super.key,
  });

  @override
  State<Login> createState() => _LoginState();
}

TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();

Future<void> loginUser(
    String email, String password, BuildContext context) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // // ignore: use_build_context_synchronously
    // Navigator.push(context,
    //     MaterialPageRoute(builder: (context) => MenuNavegacao(user: user)));

    print('Login realizado com sucesso: ${userCredential.user?.uid}');

    String? e = userCredential.user?.email;

    await otherInformations(userCredential.user?.uid, e, password);
  } catch (e) {
    // Tratar erros de login
    print('Erro de login: $e');
  }
}

Future<void> otherInformations(
    String? uid, String? email, String password) async {
  final QuerySnapshot users = await FirebaseFirestore.instance
      .collection('users')
      .where(FieldPath.documentId, isEqualTo: uid)
      .get();

  print(users.docs.isEmpty);

  for (QueryDocumentSnapshot userDoc in users.docs) {
    final String nome = userDoc.get('nome');
    // Obtenha a lista dinâmica
    final List<dynamic> alergiasDynamic = userDoc.get('alergias');
    // Converta a lista dinâmica para uma lista de strings (extraindo o atributo 'nome')
    final List<String> alergias = alergiasDynamic.map((dynamic item) {
      if (item.containsKey('descricao')) {
        return item['descricao'].toString();
      } else {
        // Pode tratar o caso em que o objeto de recomendação não possui o atributo 'nome'
        return ''; // ou outra ação de fallback
      }
    }).toList();

    // Obtenha a lista dinâmica
    final List<dynamic> recomendacoesDynamic = userDoc.get('recomendacoes');
    // Converta a lista dinâmica para uma lista de strings (extraindo o atributo 'nome')
    final List<String> recomendacoes = recomendacoesDynamic.map((dynamic item) {
      if (item.containsKey('descricao')) {
        return item['descricao'].toString();
      } else {
        // Pode tratar o caso em que o objeto de recomendação não possui o atributo 'nome'
        return ''; // ou outra ação de fallback
      }
    }).toList();

    List<dynamic> favoritosDynamic = userDoc.get('favoritos');
    // Converta a lista dinâmica para uma lista de strings
    List<String> favoritos = favoritosDynamic.map((dynamic item) {
      return item.toString();
    }).toList();

    user =
        Usuario(nome, email!, password, alergias, recomendacoes, favoritos, '');
  }
}

Usuario user = Usuario('', '', '', [], [], [], '');

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    return Scaffold(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        body: Stack(alignment: Alignment.center, children: [
          Positioned(
            top: 100,
            //bottom: 100, // Posição vertical a partir da parte inferior
            //margin: EdgeInsets.only(top:10),
            //right: 60, // Posição horizontal a partir da direita
            child: Image.asset(
              'assets/LogoEstampada_BeautyScanner.png',
              height: 250,
            ),
          ),
          Positioned(
              top: 370,
              //right: 25,
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 350,
                    height: 50,
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromRGBO(227, 227, 227, 1),
                        hintText: '  Email',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(227, 227, 227, 1))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(227, 227, 227, 1))),
                      ),
                      controller: _emailController,
                    ),
                  ))),
          Positioned(
              top: 430,
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 350,
                    height: 50,
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromRGBO(227, 227, 227, 1),
                        hintText: '  Senha',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(227, 227, 227, 1))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(227, 227, 227, 1))),
                      ),
                      controller: _passwordController,
                      obscureText: true,
                    ),
                  ))),
          Positioned(
              top: 600,
              //right: 155,
              child: ElevatedButton(
                onPressed: () async {
                  String email = _emailController.text;
                  String password = _passwordController.text;

                  await loginUser(email, password, context);
                  print(user.email);

                  // LOGIN
                  // ignore: use_build_context_synchronously
                  if (user.email != '') {
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => MenuNavegacao(user: user)));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(88, 0, 221, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.all(15.0),
                  textStyle: const TextStyle(
                    fontSize: 18.0,
                  ), // Define o tamanho da fonte // Defina o raio de canto desejado
                ),
                child: const Text('    Entrar    '),
              )),
          Positioned(
            top: 680,
            //right: 145,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RecuperarEmail()));
              },
              child: const Text(
                'Esqueci minha senha',
                style: TextStyle(
                  color: Color.fromRGBO(24, 24, 25, 1), // Defina a cor do texto
                ),
              ),
            ),
          ),
          Positioned(
            top: 700,
            //right: 185,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CadastroUsuario()));
              },
              child: const Text(
                'Cadastrar',
                style: TextStyle(
                  color: Color.fromRGBO(88, 0, 221, 1), // Defina a cor do texto
                ),
              ),
            ),
          )
        ]));
  }
}
