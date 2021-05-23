import 'package:agenda_de_contatos/models/contato.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Contatos with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _colecaoNome = 'usuarios';
  final _colecaoContatos = 'contatos';

  List<Contato> _contatos = [];
  String _id;

  Contatos();
  Contatos.id(this._id);

  List<Contato> get itens => [...this._contatos];

  Contato encontrarID(String t) =>
      this._contatos.firstWhere((element) => element.telefone == t);

  Future<void> inserir(String nome, String email, String endereco, String cep,
      String telefone) async {
    // Adicionando novo elemento na lista do provider

    String id = DateTime.now().toIso8601String();
    Contato tmp = Contato(id, nome, email, endereco, cep, telefone);

    this._contatos.add(tmp);

    await this
        ._firestore
        .collection(this._colecaoNome)
        .doc(this._id)
        .collection(this._colecaoContatos)
        .doc(id)
        .set(tmp.toMap);

    // Alertando para nova inserção
    notifyListeners();
  }

  Future<void> atualizar(String id, String nome, String email, String endereco,
      String cep, String telefone) async {
    Contato cont = Contato(id, nome, email, endereco, cep, telefone);

    int contPos = this._contatos.indexWhere((element) => element.id == id);
    if (contPos == -1) return; // Elemento não foi encontrado
    // Atualizando contato

    await this
        ._firestore
        .collection(this._colecaoNome)
        .doc(this._id)
        .collection(this._colecaoContatos)
        .doc(id)
        .update(cont.toMap);

    this._contatos[contPos] = cont;

    // Alertando para atualização
    notifyListeners();
  }

  // Excluir
  Future<void> excluir(String id) async {
    this._contatos.removeWhere((element) => element.id == id);

    await this
        ._firestore
        .collection(this._colecaoNome)
        .doc(this._id)
        .collection(this._colecaoContatos)
        .doc(id)
        .delete();

    // Alertando para remoção
    notifyListeners();
  }

  Future<void> pegarContatosUsuarioFirebase() async {
    final dadosFirebase = await this
        ._firestore
        .collection(this._colecaoNome)
        .doc(this._id)
        .collection(this._colecaoContatos)
        .get();

    final listaDocumentos = dadosFirebase.docs;
    if (listaDocumentos.length == 0) return;

    this._contatos = listaDocumentos.map((e) {
      Map<String, dynamic> dadosContato = e.data();

      return Contato(
        e.id,
        dadosContato['nome'],
        dadosContato['email'],
        dadosContato['endereco'],
        dadosContato['cep'],
        dadosContato['telefone'],
      );
    }).toList();

    notifyListeners();
  }
}
