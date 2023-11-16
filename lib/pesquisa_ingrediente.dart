import 'package:flutter/material.dart';
import 'package:tcc_flutter_7/Tag.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


// ignore: must_be_immutable
class PesquisaIngrediente extends StatefulWidget {
  List<Tag> lista = [];
  String tipo;
  PesquisaIngrediente({super.key, required this.lista, required this.tipo});

  @override
  State<PesquisaIngrediente> createState() => _PesquisaIngredienteState();
}

class _PesquisaIngredienteState extends State<PesquisaIngrediente> {

  Future<List<DocumentSnapshot>> searchIngredients(String searchTerm) async {
  final QuerySnapshot ingredientes = await FirebaseFirestore.instance
      .collection(tipo)
      .where('nome', isGreaterThanOrEqualTo: searchTerm)
      .get();
    // List<String> teste = [];

    print(ingredientes.docs);

    // for(DocumentSnapshot ing in ingredientes.docs)
    // {
    //   print(ing);
    //   teste.add(ing.get('nome'));
    // }
  return ingredientes.docs;
}

  List<String> allItems = [];
  List<DocumentSnapshot> items = [];
  String tipo = '';
  var searchHistory = [];
  String selected = '';
  final TextEditingController searchController = TextEditingController();
  // ignore: non_constant_identifier_names
  List<Tag> Tags = [];

  /*preencher() {
    allItems.add('methylparaben');
    allItems.add('ethylparaben');
    allItems.add('propylparaben');
    allItems.add('dibutyl phthalate');
    allItems.add('formaldehyde');
    allItems.add('sodium lauryl sulfate');
  }*/

  @override
  void initState() {
    //preencher();
    super.initState();
    searchController.addListener(queryListenner);
  }

  @override
  void dispose() {
    searchController.removeListener(queryListenner);
    searchController.dispose();
    super.dispose();
  }

  void queryListenner() {
    // ignore: unnecessary_null_comparison
    if (searchController.text != "" || searchController.text != null) {
      search(searchController.text);
    }
  }

  int index = 0;
  void search(String query) async {
    print(query);
    if (query.isEmpty) {
      items = List.empty();
    } else {
      String searchTerm = query;
      List<DocumentSnapshot> ingredientesEncontrados =
          await searchIngredients(searchTerm);
          items = ingredientesEncontrados;

      // for (DocumentSnapshot ingrediente in ingredientesEncontrados) {
      //   // Faça o que quiser com os documentos encontrados
      //   String nome = ingrediente.get('nome');
      //   //items.add(nome);
      //   items.add(nome);
      //   print(nome);
      // }
    }
  }

  final SearchController controller = SearchController();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    tipo = widget.tipo;
    Tags = widget.lista;
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 40),
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Column(children: <Widget>[
                  // const SizedBox(
                  //   height: 0,
                  // ),
                  SearchAnchor(
                      searchController: controller,
                      isFullScreen: false,
                      suggestionsBuilder:
                          (BuildContext context, searchController) {
                        search(searchController.text);
                        if (items.isNotEmpty) {
                          return List<Widget>.generate(items.length, (index) {
                            final DocumentSnapshot item = items[index];
                            return ListTile(
                              title: Text(item.get('nome')),
                              onTap: () {
                                selected = item.get('nome');
                                print('a adicionar: $selected');
                                var qts = Tags.where((e) =>
                                    e.descricao.toLowerCase() ==
                                    selected.toLowerCase()).toList();
                                if (qts.isEmpty) {
                                  if(widget.tipo == 'ingredientes')
                                  {
                                    Tags.add(Tag(selected, 100, 100, 100, 80));
                                  }
                                  else{
                                    Tags.add(Tag(selected, item.get('red').toInt(), item.get('green').toInt(), item.get('blue').toInt(), 1.toDouble()));
                                  }
                                }
                                searchController.closeView(selected);
                                setState(() {});
                              },
                            );
                          });
                        } else {
                          return List<Widget>.generate(1, (index) {
                            return const ListTile(
                              title: Text(" "),
                            );
                          });
                        }
                      },
                      builder:
                          (BuildContext context, SearchController controller) {
                        return SearchBar(
                            controller: controller,
                            onTap: () {
                              controller.openView();
                            },
                            onChanged: (_) {
                              //searchController.openView();
                              controller.openView();
                              //setState(() {});
                            },
                            leading: const IconButton(
                                onPressed: null, icon: Icon(Icons.search)),
                            // trailing: [
                            //   IconButton(
                            //       onPressed: () {}, icon: const Icon(Icons.filter_list))
                            // ],
                            textStyle:
                                MaterialStateProperty.resolveWith<TextStyle?>(
                                    ((states) {
                              return const TextStyle(fontSize: 17);
                            })),
                            hintText: 'Pesquisar $tipo',
                            hintStyle:
                                MaterialStateProperty.resolveWith<TextStyle?>(
                                    ((states) {
                              return const TextStyle(
                                  color: Color.fromARGB(255, 154, 151, 151),
                                  fontSize: 17);
                            })));
                      }),
                  Container(
                      margin: const EdgeInsets.only(top: 50, left: 10),
                      alignment: Alignment.topLeft,
                      child: Wrap(
                        direction: Axis
                            .horizontal, // Define a direção da "embalagem" (horizontal no seu caso)
                        spacing: 8.0, // Espaçamento horizontal entre os itens
                        runSpacing:
                            8.0, // Espaçamento vertical entre as linhas de itens
                        children: Tags.map((tag) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Alinhe os itens à esquerda
                            children: [
                              Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              height: 35,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(
                                    tag.red.toInt(), tag.green.toInt(), tag.blue.toInt(), 220),
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
                                            Tags.remove(tag);
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
                                        color: Color.fromRGBO(tag.red.toInt(),
                                            tag.green.toInt(), tag.blue.toInt(), tag.opacity),
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
                      )),
                ]),
              ),
            ),
            Positioned(
              //alignment: Alignment.center,
              bottom: 10,
              left: 100,
              right: 100,
              //margin: EdgeInsets.only(bottom:10,),
              //color: Colors.pink,
              // EdgeInsets.all(20),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'lista': Tags, // Passa a lista Alergias de volta
                    });
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
                  child: const Text('Adicionar'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
