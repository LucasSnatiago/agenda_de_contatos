import 'package:agenda_de_contatos/models/contato.dart';
import 'package:flutter/foundation.dart';

class Contatos with ChangeNotifier {
  List<Contato> _contatos = [];

  List<Contato> get itens => [...this._contatos];
  Contato encontrarID(String t) =>
      this._contatos.firstWhere((element) => element.telefone == t);

  inserir(
      String nome, String email, String endereco, String cep, String telefone) {
    // Adicionando novo elemento na lista do provider
    this._contatos.add(Contato(nome, email, endereco, cep, telefone));
    // Alertando para nova inserção
    notifyListeners();
  }

  atualizar(int id, String nome, String email, String endereco, String cep,
      String telefone) {
    Contato cont = Contato(nome, email, endereco, cep, telefone);

    int contPos = this._contatos.indexWhere((element) => element.id == id);
    if (contPos == -1) return; // Elemento não foi encontrado
    // Atualizando contato
    this._contatos[contPos] = cont;
    // Alertando para atualização
    notifyListeners();
  }

  // Excluir
  excluir(int id) {
    this._contatos.removeWhere((element) => element.id == id);
    // Alertando para remoção
    notifyListeners();
  }
}
