import 'package:cepapp/Model/endereco.dart';
import 'package:cepapp/config/api_service.dart';
import 'package:cepapp/config/therme.dart';
import 'package:cepapp/widgets/buttons.dart';
import 'package:cepapp/widgets/inputs.dart';
import 'package:cepapp/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formkey = GlobalKey<FormState>();
  final _cepController = TextEditingController();
  String cep = "";
  String endereco = "";
  String complemento = "";
  String bairro = "";
  String cidade = "";
  String uf = "";
  String ddd = "";
  bool isLoading = false;

  var maskFormatter = MaskTextInputFormatter(
    //18205-000
    mask: '#####-###',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  final cepService = SearchService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: _body(),
    );
  }

  _body() {
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          color: AppColors.primaryColor,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 10),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            "Busca CEP",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "De uma forma rápida e prática.",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[50],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.primaryBgCard,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Form(
                                key: _formkey,
                                child: Column(
                                  children: [
                                    InputDefault(
                                      "",
                                      false,
                                      TextInputType.number,
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.grey[600],
                                      ),
                                      "Digite seu CEP",
                                      [],
                                      validator: (cep) {
                                        if (cep == null || cep.isEmpty) {
                                          return "Por favor, informe seu cep";
                                        } else if (cep.length < 8) {
                                          return "Por favor, informe um cep válido.";
                                        }
                                        return null;
                                      },
                                      controller: _cepController,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    BtnDefaultLoading(
                                      "Buscar",
                                      true,
                                      isLoading,
                                      onPressed: () {
                                        setState(() {
                                          if (_formkey.currentState!
                                              .validate()) {
                                            cep = _cepController.text;
                                            isLoading = true;
                                          }
                                        });
                                        getEndereco(cep);
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.secundaryBgCard,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                          color: AppColors.primaryColor,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              TextTitle(
                                                  texto: "Resultado da busca")
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          TextSubtitle(texto: "Cep: "),
                                          TextBody(texto: cep)
                                        ],
                                      ),
                                      Divider(
                                        height: 20,
                                        thickness: 1,
                                        color: Colors.grey[350],
                                      ),
                                      Row(
                                        children: [
                                          TextSubtitle(texto: "Endereço: "),
                                          TextBody(texto: endereco)
                                        ],
                                      ),
                                      Divider(
                                        height: 20,
                                        thickness: 1,
                                        color: Colors.grey[350],
                                      ),
                                      Row(
                                        children: [
                                          TextSubtitle(texto: "Bairro: "),
                                          TextBody(texto: bairro)
                                        ],
                                      ),
                                      Divider(
                                        height: 20,
                                        thickness: 1,
                                        color: Colors.grey[350],
                                      ),
                                      Row(
                                        children: [
                                          TextSubtitle(texto: "Cidade: "),
                                          TextBody(texto: cidade)
                                        ],
                                      ),
                                      Divider(
                                        height: 20,
                                        thickness: 1,
                                        color: Colors.grey[350],
                                      ),
                                      Row(
                                        children: [
                                          TextSubtitle(texto: "UF: "),
                                          TextBody(texto: uf)
                                        ],
                                      ),
                                      Divider(
                                        height: 20,
                                        thickness: 1,
                                        color: Colors.grey[350],
                                      ),
                                      Row(
                                        children: [
                                          TextSubtitle(texto: "DDD: "),
                                          TextBody(texto: ddd)
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future getEndereco(String cep) async {
    var url = Uri.parse("https://viacep.com.br/ws/$cep/json/");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      setState(
        () {
          endereco = jsonData["logradouro"];
          complemento = jsonData["complemento"];
          bairro = jsonData["bairro"];
          cidade = jsonData["localidade"];
          uf = jsonData["uf"];
          ddd = jsonData["ddd"];

          isLoading = false;
        },
      );
    } else {
      throw Exception("Erro ao buscar o CEP");
    }
  }
}
