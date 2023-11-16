import 'package:flutter/material.dart';
import 'package:tcc_flutter_7/Tag.dart';
import 'package:tcc_flutter_7/pesquisa_ingrediente.dart';
import 'package:tcc_flutter_7/menu_navegacao.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CadastroUsuario extends StatefulWidget {
  const CadastroUsuario({Key? key}) : super(key: key);

  @override
  State<CadastroUsuario> createState() => _CadastroUsuarioState();
}

TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
TextEditingController _confirmarPasswordController = TextEditingController();
TextEditingController _nomeController = TextEditingController();

Future<void> registerUser(String email, String password, String nome,
    List<Tag> alergias, List<Tag> recomendacoes, BuildContext context) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // O usuário foi criado com sucesso
    print('Usuário registrado com sucesso: ${userCredential.user?.uid}');

    List<Map<String, dynamic>> alergiasMapList =
        alergias.map((tag) => tag.toMap()).toList();
    List<Map<String, dynamic>> recomendacoesMapList =
        recomendacoes.map((tag) => tag.toMap()).toList();

    // Agora, vamos adicionar as informações adicionais ao Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user?.uid)
        .set({
      'tipo': "usuario",
      'nome': nome,
      'alergias': alergiasMapList,
      'recomendacoes': recomendacoesMapList,
      'favoritos': []
    });
    // Redirecione o usuário para a tela principal ou qualquer outra tela apropriada
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MenuNavegacao(user: usuario)));
  } catch (e) {
    // Tratar erros de registro
    print('Erro de registro: $e');
  }
}

class _CadastroUsuarioState extends State<CadastroUsuario> {
  List<Tag> Alergias = [];
  List<Tag> Recomendacoes = [];
  SizedBox espaco = const SizedBox(
    width: 30,
  );
  Color roxo = const Color(0xFF5800DD);
  SizedBox margem = const SizedBox(height: 15);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(mainAxisSize: MainAxisSize.min, children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: roxo,
              )),
          Text(
            'Beauty Scanner',
            style: TextStyle(color: roxo, fontSize: 35),
          ),
          espaco
        ]),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          //alignment: Alignment.topCenter,
          children: [
            margem,
            SizedBox(
              width: 350,
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromRGBO(227, 227, 227, 0.5),
                  hintText: 'Nome',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(227, 227, 227, 0.5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(227, 227, 227, 0.5),
                    ),
                  ),
                ),
                controller: _nomeController,
              ),
            ),
            margem,
            SizedBox(
              width: 350,
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromRGBO(227, 227, 227, 0.5),
                  hintText: 'Email',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(227, 227, 227, 0.5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(227, 227, 227, 0.5),
                    ),
                  ),
                ),
                controller: _emailController,
              ),
            ),
            margem,
            SizedBox(
              width: 350,
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromRGBO(227, 227, 227, 0.5),
                  hintText: 'Senha',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(227, 227, 227, 0.5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(227, 227, 227, 0.5),
                    ),
                  ),
                ),
                controller: _passwordController,
                obscureText: true,
              ),
            ),
            margem,
            SizedBox(
              width: 350,
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromRGBO(227, 227, 227, 0.5),
                  hintText: 'Confirmar senha',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(227, 227, 227, 0.5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(227, 227, 227, 0.5),
                    ),
                  ),
                ),
                controller: _confirmarPasswordController,
                obscureText: true,
              ),
            ),
            margem,
            Column(
              children: [
                Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 150, top: 10),
                  child: Row(
                    children: [
                      const Text(
                        'Alergias',
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
                                    lista: Alergias, tipo: 'ingredientes'),
                              ),
                            ).then((retorno) {
                              if (retorno != null) {
                                setState(() {
                                  Alergias = retorno['lista'];
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
            margem,
            Wrap(
              direction: Axis.horizontal,
              spacing: 8.0,
              runSpacing: 8.0,
              children: Alergias.map((tag) {
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
                                        Alergias.remove(tag);
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
            margem,
            Column(
              children: [
                Container(
                  width: 300,
                  child: Row(
                    children: [
                      Container(
                        width: 250,
                        child: const Text(
                          'Quais produtos você deseja ser recomendado?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
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
                                    lista: Recomendacoes, tipo: 'tags'),
                              ),
                            ).then((retorno) {
                              if (retorno != null) {
                                setState(() {
                                  Recomendacoes = retorno['lista'];
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
              margin: EdgeInsets.only(left:25, right: 25, top:5),
              child: Wrap(
                direction: Axis.horizontal,
                spacing: 8.0,
                runSpacing: 8.0,
                children: Recomendacoes.map((tag) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            //margin: EdgeInsets.only(top: 0),
                            height: 35,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(tag.red.toInt(),
                                  tag.green.toInt(), tag.blue.toInt(), 220),
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
                                          Recomendacoes.remove(tag);
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
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Color.fromRGBO(
                                          tag.red.toInt(),
                                          tag.green.toInt(),
                                          tag.blue.toInt(),
                                          tag.opacity),
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
            margem,
            ElevatedButton(
              onPressed: () {
                // Lógica de cadastro de usuário
                String email = _emailController.text;
                String senha = _passwordController.text;
                String confirmarSenha = _confirmarPasswordController.text;
                String nome = _nomeController.text;
                List<Tag> alergias = Alergias;
                List<Tag> recomendacoes = Recomendacoes;

                bool isPasswordValid(String senha) {
                  bool hasUppercase = false;
                  bool hasLowercase = false;
                  bool hasNumber = false;

                  for (int i = 0; i < senha.length; i++) {
                    if (senha[i].contains(RegExp(r'[A-Z]'))) {
                      hasUppercase = true;
                    } else if (senha[i].contains(RegExp(r'[a-z]'))) {
                      hasLowercase = true;
                    } else if (senha[i].contains(RegExp(r'[0-9]'))) {
                      hasNumber = true;
                    }
                  }

                  return hasUppercase && hasLowercase && hasNumber;
                }

                if (senha != confirmarSenha)
                  print("Senhas não estão iguais!");
                else if (senha.length < 8)
                  print(
                      "Senha menor que 8 caracteres. Defina uma senha com mais de 8 caracteres, pelo menos uma letra maiúscula e um número.");
                else if (!isPasswordValid(senha))
                  print(
                      "Defina uma senha com mais de 8 caracteres, com pelo menos uma letra maiúscula, uma minúscula e um número.");
                else
                  registerUser(
                      email, senha, nome, alergias, recomendacoes, context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(88, 0, 221, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: const EdgeInsets.all(15.0),
                textStyle: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
              child: const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
