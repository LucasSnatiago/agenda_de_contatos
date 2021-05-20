import 'package:agenda_de_contatos/models/contato.dart';
import 'package:flutter/foundation.dart';

class Contatos with ChangeNotifier {
  List<Contato> _contatos = [];
  int id;

  Contatos() {
    this.id = 0;
  }

  List<Contato> get itens {
    this.id = this._contatos.length;
    return [...this._contatos];
  }

  Contato encontrarID(String t) =>
      this._contatos.firstWhere((element) => element.telefone == t);

  inserir(
      String nome, String email, String endereco, String cep, String telefone) {
    // Adicionando novo elemento na lista do provider
    Contato tmp = Contato(nome, email, endereco, cep, telefone);
    tmp.id = ++this.id;
    this._contatos.add(tmp);
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
