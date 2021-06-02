import 'package:flutter/foundation.dart';

class Contato with ChangeNotifier {
  String _id;
  String _nome, _email, _endereco, _cep, _telefone, _photoUrl, _aniversario;

  // Constructor
  Contato(this._id, this._nome, this._email, this._endereco, this._cep,
      this._telefone, this._photoUrl, this._aniversario);

  // Sets
  set id(String i) => this._id = i;
  set nome(String n) => this._nome = n;
  set email(String e) => this._email = e;
  set endereco(String e) => this._cep = e;
  set cep(String c) => this._cep = c;
  set telefone(String t) => this._telefone = t;
  set photo(String p) => this._photoUrl = p;
  set aniversario(String a) => this._aniversario = a;

  // Gets
  String get id => this._id;
  String get nome => this._nome;
  String get email => this._email;
  String get endereco => this._endereco;
  String get cep => this._cep;
  String get telefone => this._telefone;
  String get photo => this._photoUrl;
  String get aniversario => this._aniversario;

  Map<String, dynamic> get toMap => {
        'id': this._id,
        'nome': this._nome,
        'email': this._email,
        'endereco': this._endereco,
        'cep': this._cep,
        'telefone': this._telefone,
        'photoUrl': this._photoUrl,
        'aniversario': this._aniversario,
      };

  factory Contato.fromMap(Map<String, dynamic> cont) => Contato(
      cont['id'],
      cont['nome'],
      cont['email'],
      cont['endereco'],
      cont['cep'],
      cont['telefone'],
      cont['photoUrl'],
      cont['aniversario']);
}
