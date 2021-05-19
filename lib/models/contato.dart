import 'package:flutter/foundation.dart';

class Contato with ChangeNotifier {
  int _id;
  String _nome, _email, _endereco, _cep, _telefone;

  // Constructor
  Contato(this._nome, this._email, this._endereco, this._cep, this._telefone);

  // Sets
  set id(int i) => this._id = i;
  set nome(String n) => this._nome = n;
  set email(String e) => this._email = e;
  set endereco(String e) => this._cep = e;
  set cep(String c) => this._cep = c;
  set telefone(String t) => this._telefone = t;

  // Gets
  int get id => this._id;
  String get nome => this._nome;
  String get email => this._email;
  String get endereco => this._endereco;
  String get cep => this._cep;
  String get telefone => this._telefone;
}
