import 'dart:io';

import 'package:agenda_de_contatos/models/contato.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Contatos with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _firestorage = FirebaseStorage.instance;
  final _colecaoNome = 'usuarios';
  final _colecaoContatos = 'contatos';
  final _colecaoImgContatos = 'fotosPerfil';

  List<Contato> _contatos = [];
  String _id;

  Contatos();
  Contatos.id(this._id);

  List<Contato> get itens => [...this._contatos];

  Contato encontrarID(String t) =>
      this._contatos.firstWhere((element) => element.telefone == t);

  Future<void> inserir(String nome, String email, String endereco, String cep,
      String telefone, File photo, String aniversario) async {
    // Salvando a foto na nuvem
    var url = '';

    // Adicionando novo elemento na lista do provider
    String id = DateTime.now().toIso8601String();

    if (photo != null && photo.existsSync()) {
      final imgPointer = this
          ._firestorage
          .ref()
          .child(this._colecaoImgContatos)
          .child(this._id + id + '.jpg');

      await imgPointer.putFile(photo);
      url = await imgPointer.getDownloadURL();
    }

    Contato tmp =
        Contato(id, nome, email, endereco, cep, telefone, url, aniversario);

    print(tmp.id);

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
      String cep, String telefone, File photo, String aniversario) async {
    // Atualizando contato
    int contPos = this._contatos.indexWhere((element) => element.id == id);
    if (contPos == -1) return; // Elemento não foi encontrado

    // Atualizando a foto na nuvem
    var url = '';

    if (photo != null && photo.existsSync()) {
      final imgPointer = this
          ._firestorage
          .ref()
          .child(this._colecaoImgContatos)
          .child(this._id + id + '.jpg');

      await imgPointer.putFile(photo);
      url = await imgPointer.getDownloadURL();
    } else
      url = this._contatos[contPos].photo;

    Contato cont =
        Contato(id, nome, email, endereco, cep, telefone, url, aniversario);

    print(cont.id);

    await this
        ._firestore
        .collection(this._colecaoNome)
        .doc(this._id)
        .collection(this._colecaoContatos)
        .doc(cont.id)
        .update(cont.toMap);

    this._contatos[contPos] = cont;

    // Alertando para atualização
    notifyListeners();
  }

  // Excluir
  Future<void> excluir(String id) async {
    int contatoIndex = this._contatos.indexWhere((element) => element.id == id);
    this._contatos.removeAt(contatoIndex);

    await this
        ._firestore
        .collection(this._colecaoNome)
        .doc(this._id)
        .collection(this._colecaoContatos)
        .doc(id)
        .delete();

    if (Uri.tryParse(this._contatos[contatoIndex].photo) != null)
      await this
          ._firestorage
          .ref()
          .child(this._colecaoImgContatos)
          .child(this._id + id + '.jpg')
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
      return Contato.fromMap(e.data());
    }).toList();

    notifyListeners();
  }

  List<Contato> get aniversariantes => this
      ._contatos
      .where((element) => DateTime.tryParse(element.aniversario) != null)
      .toList();
}
