import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc_flutter_7/menu_navegacao.dart';

class CadastroEmpresa extends StatefulWidget {
  const CadastroEmpresa({
    super.key,
  });

  @override
  State<CadastroEmpresa> createState() => _CadastroEmpresaState();
}

TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
TextEditingController _confirmarPasswordController = TextEditingController();
TextEditingController _nomeEmpresaController = TextEditingController();
TextEditingController _urlEmpresaController = TextEditingController();
TextEditingController _cnpjController = TextEditingController();
TextEditingController _telefoneController = TextEditingController();

Future<void> registerUser(String email, String password, String nome,
    String url, int cnpj, int phone, BuildContext context) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // O usuário foi criado com sucesso
    print('Empresa registrada com sucesso: ${userCredential.user?.uid}');

    // Agora, vamos adicionar as informações adicionais ao Firestore
    await FirebaseFirestore.instance
        .collection('companys')
        .doc(userCredential.user?.uid)
        .set({
      'tipo': "empresa",
      'nome': nome,
      'url': url,
      'cnpj': cnpj,
      'phone': phone
    });
    // Redirecione o usuário para a tela principal ou qualquer outra tela apropriada
    Navigator.push(context,
        MaterialPageRoute(builder: (context) =>  MenuNavegacao(user: usuario)));
  } catch (e) {
    // Tratar erros de registro
    print('Erro de registro: $e');
  }
}

class _CadastroEmpresaState extends State<CadastroEmpresa> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    return Scaffold(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        body: Stack(alignment: Alignment.center, children: [
          Positioned(
            top: 100,
            left: 25,
            child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back_ios,
                    color: Color.fromRGBO(88, 0, 221, 1))),
          ),
          //texto beauty scanner
          const Positioned(
            top: 100,
            right: 65,
            child: Text(
              'Beauty Scanner',
              style: TextStyle(
                  color: Color.fromRGBO(88, 0, 221, 1), // Defina a cor do texto
                  fontSize: 37),
            ),
            // Define a cor do texto
          ),
          //nome
          Positioned(
              top: 170,
              //right: 25,
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 350,
                    height: 50,
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromRGBO(227, 227, 227, 0.5),
                        hintText: ' Nome da empresa',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(227, 227, 227, 0.5))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(227, 227, 227, 0.5))),
                      ),
                      controller: _nomeEmpresaController,
                    ),
                  ))),

          //CNPJ
          Positioned(
              top: 230,
              //right: 25,
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 350,
                    height: 50,
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromRGBO(227, 227, 227, 0.5),
                        hintText: ' CNPJ ',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(227, 227, 227, 0.5))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(227, 227, 227, 0.5))),
                      ),
                      controller: _cnpjController,
                    ),
                  ))),

          //Telefone
          Positioned(
              top: 290,
              //right: 25,
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 350,
                    height: 50,
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromRGBO(227, 227, 227, 0.5),
                        hintText: ' Telefone',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(227, 227, 227, 0.5))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(227, 227, 227, 0.5))),
                      ),
                      controller: _telefoneController,
                    ),
                  ))),

          //Site da empresa
          Positioned(
              top: 350,
              //right: 25,
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 350,
                    height: 50,
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromRGBO(227, 227, 227, 0.5),
                        hintText: ' Site da empresa ',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(227, 227, 227, 0.5))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(227, 227, 227, 0.5))),
                      ),
                      controller: _urlEmpresaController,
                    ),
                  ))),

          //email
          Positioned(
              top: 410,
              //right: 25,
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
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
                                color: Color.fromRGBO(227, 227, 227, 0.5))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(227, 227, 227, 0.5))),
                      ),
                      controller: _emailController,
                    ),
                  ))),

          //senha
          Positioned(
              top: 470,
              //right: 25,
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
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
                                color: Color.fromRGBO(227, 227, 227, 0.5))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(227, 227, 227, 0.5))),
                      ),
                      controller: _passwordController,
                    ),
                  ))),

          //confirmar senha
          Positioned(
              top: 530,
              //right: 25,
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
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
                                color: Color.fromRGBO(227, 227, 227, 0.5))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(227, 227, 227, 0.5))),
                      ),
                      controller: _confirmarPasswordController,
                    ),
                  ))),

          //texto Loja Fisica
          const Positioned(
            top: 610,
            right: 290,
            child: Text(
              'Loja física',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(0, 0, 0, 1), // Defina a cor do texto
                  fontSize: 20),
            ),
          ),

//sessão Loja fisica
//FALTA COLOCAR ICONE NAS LOCALIZAÇÕES
          /* child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        Image.asset('assets/localizacao.png', width: 12.0, height: 12.0),
        SizedBox(width: 8.0),*/

          //Rua Cosme
          Positioned(
              top: 630,
              //right: 285,
              child: ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromRGBO(255, 255, 255, 1).withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.only(top: 0),
                  textStyle: const TextStyle(
                    fontSize: 15.0,
                  ), // Define o tamanho da fonte // Defina o raio de canto desejado
                ),
                /*  child: Row
                (
                  mainAxisAlignment: MainAxisAlignment.center,                     
                  children: <Widget>[
                  Image.asset('/assets/localizacao.png', width: 12.0, height: 12.0),  // Substitua pelo caminho da imagem no seu computador 
                  SizedBox(width: 8.0),  // Espaçamento entre o ícone e o texto
                  Text('Botão com Ícone'),  // Texto do botão
                ],
                ),*/
                child: const Text(
                  '    R. Cosme...    ',
                  style: TextStyle(color: Color.fromARGB(161, 0, 0, 0)),
                ),
              )),

          //Rua maria
          Positioned(
              top: 630,
              right: 170,
              child: ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromRGBO(255, 255, 255, 1).withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.only(top: 0),
                  textStyle: const TextStyle(
                    fontSize: 15.0,
                  ), // Define o tamanho da fonte // Defina o raio de canto desejado
                ),
                child: const Text('    R. Maria...    ',
                    style: TextStyle(color: Color.fromARGB(161, 0, 0, 0))),
              )),

          //+
          Positioned(
              top: 630,
              right: 120,
              child: Container(
                  width: 35,
                  child: ElevatedButton(
                    onPressed: () {
                      // Lógica quando o botão é pressionado
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromRGBO(255, 255, 255, 1).withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      padding:
                          const EdgeInsets.only(left: 1, top: 1, bottom: 1, right: 1),
                      textStyle: const TextStyle(
                        fontSize: 15.0,
                      ), // Define o tamanho da fonte // Defina o raio de canto desejado
                    ),
                    child: const Text(
                      '+',
                      style: TextStyle(color: Color.fromARGB(161, 0, 0, 0)),
                    ),
                  ))),
          //botao cadastrar
          Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                  top: 720,
                  child: ElevatedButton(
                    onPressed: () {
                      // Lógica de cadastro de empresa
                      String email = _emailController.text;
                      String senha = _passwordController.text;
                      String confirmarSenha = _confirmarPasswordController.text;
                      String nome = _nomeEmpresaController.text;
                      String url = _urlEmpresaController.text;
                      int cnpj = int.parse(_cnpjController.text);
                      int telefone = int.parse(_telefoneController.text);

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
                        registerUser(email, senha, nome, url, cnpj,
                            telefone, context);
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
                    child: const Text('    Cadastrar    '),
                  )),
            ],
          )
        ]));
  }
}
