import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class Auth with ChangeNotifier {
  FirebaseAuth _fauth = FirebaseAuth.instance;
  final _colecaoNome = 'usuarios';

  String _id, _nome, _email;
  bool _estaLogado = false;

  String get id => this._id;
  bool get estaLogado => this._estaLogado;
  Map<String, String> get user =>
      {'id': this._id, 'nome': this._nome, 'email': this._email};

  // Pegar dados de um usuário a partir de seu ID.
  Future<DocumentSnapshot> getFireStoreUserData(String userID) async =>
      await FirebaseFirestore.instance
          .collection(this._colecaoNome)
          .doc(userID)
          .get();

  // Logar na conta do usuário no sistema do Firebase
  Future<bool> logar(String email, String senha) async {
    UserCredential userCred = await this
        ._fauth
        .signInWithEmailAndPassword(email: email, password: senha);

    final user = userCred.user;
    if (user == null) return false;

    final firebaseData = await getFireStoreUserData(user.uid);
    final userData = firebaseData.data() as Map<String, dynamic>;

    this._nome = userData['nome'];
    this._email = email;
    this._estaLogado = true;
    this._id = user.uid;

    notifyListeners();

    return true;
  }

  // Registrar usuário no Firebase
  Future<bool> registrar(String email, String nome, String senha) async {
    UserCredential userCred = await this
        ._fauth
        .createUserWithEmailAndPassword(email: email, password: senha);

    final user = userCred.user;
    if (user == null) return false;

    await FirebaseFirestore.instance
        .collection(this._colecaoNome)
        .doc(user.uid)
        .set({'nome': nome, 'email': email});

    this._nome = nome;
    this._email = email;
    this._estaLogado = true;
    this._id = user.uid;

    notifyListeners();

    return true;
  }

  // Tentar autologar o usuário no Firebase;
  Future<bool> autologin() async {
    final user = this._fauth.currentUser;

    if (user == null) return false;
    if (!this._estaLogado) {
      final firebaseData = await getFireStoreUserData(user.uid);
      final userData = firebaseData.data() as Map<String, dynamic>;

      this._nome = userData['nome'];
      this._email = userData['email'];
      this._estaLogado = true;
      this._id = user.uid;
    }

    notifyListeners();
    return true;
  }

  // Deslogar o usuário do sistema do Firebase
  deslogar() {
    this._estaLogado = false;
    this._id = '';
    this._email = '';
    this._nome = '';

    this._fauth.signOut();
    notifyListeners();
  }
}
