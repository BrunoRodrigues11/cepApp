import 'package:cepapp/Model/endereco.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchService {
  final String baseurl = "https://viacep.com.br/ws/";

  Future<List<Endereco>> getEndereco(String cep) async {
    var url = Uri.parse("$baseurl$cep/json/");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var enderecoList = jsonData["endereco"] as List<dynamic>;

      List<Endereco> endereco =
          enderecoList.map((json) => Endereco.fromJson(json)).toList();

      print(jsonData);
      return endereco;
    } else {
      throw Exception("Erro ao buscar o CEP");
    }
  }
}
