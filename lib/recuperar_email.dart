import 'package:flutter/material.dart';



class RecuperarEmail extends StatefulWidget {
  const RecuperarEmail({
    super.key,
  });

  @override
  State<RecuperarEmail> createState() => _RecuperarEmailState();
}

class _RecuperarEmailState extends State<RecuperarEmail> {
  void _incrementCounter() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    return Scaffold(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        body: Stack(alignment: Alignment.center, children: [
          //texto beauty scanner
          Positioned(
            top: 95,
            left: 25,
            child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back_ios,
                    color: Color.fromRGBO(88, 0, 221, 1))),
          ),
          const Positioned(
            top: 100,
            left: 80,
            child: Text(
              'Encontre sua conta',
              style: TextStyle(
                  color: Color.fromRGBO(88, 0, 221, 1), // Defina a cor do texto
                  fontSize: 30),
            ), // Define a cor do texto
          ),
          const Positioned(
            top: 170,
            left: 30,
            child: Text(
              'Insira seu e-mail para recuperar a conta.',
              style: TextStyle(
                  color: Color.fromRGBO(4, 4, 5, 1), // Defina a cor do texto
                  fontSize: 16),
            ), // Define a cor do texto
          ),
          Positioned(
              top: 200,
              //right: 25,
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 350,
                    height: 50,
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromRGBO(227, 227, 227, 0.751),
                        hintText: ' Email',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(227, 227, 227, 1))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(227, 227, 227, 1))),
                      ),
                    ),
                  ))),
          Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                  top: 300,
                  child: ElevatedButton(
                    onPressed: () {
                      // Lógica quando o botão é pressionado
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
                    child: const Text('Procurar'),
                  )),
            ],
          ),
        ]));
  }
}
