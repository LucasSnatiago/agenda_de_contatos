import 'package:agenda_de_contatos/providers/auth.dart';
import 'package:agenda_de_contatos/registro/registrar.dart';
import 'package:agenda_de_contatos/telas/inicio.dart';
import 'package:agenda_de_contatos/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  static const routeName = 'registro/login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _globalKey = GlobalKey<FormState>();
  var _formValues = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entrar na conta'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Text(
                  'Insira os dados de login',
                  style: TextStyle(fontSize: 26),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  autocorrect: true,
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (newValue) => _formValues['email'] = newValue,
                  validator: (value) => (value.isEmpty || !isValidEmail(value))
                      ? 'Insira um email válido!'
                      : null,
                  decoration: InputDecoration(
                      labelText: 'Email', border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 2,
                ),
                TextFormField(
                  autocorrect: false,
                  obscureText: true,
                  onSaved: (newValue) => _formValues['senha'] = newValue,
                  validator: (value) => value.length < 8
                      ? 'Insira uma senha de no mínimo 8 digitos'
                      : null,
                  decoration: InputDecoration(
                      labelText: 'Senha', border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 5,
                ),
                ElevatedButton(
                    onPressed: () => entrar(context),
                    child: Text('Entrar na conta')),
                ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(Registrar.routeName),
                    child: Text('Registrar-se')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  entrar(context) async {
    _globalKey.currentState.save();

    if (!_globalKey.currentState.validate()) return;

    bool sucessoLogin = await Provider.of<Auth>(context, listen: false)
        .logar(_formValues['email'], _formValues['senha']);

    if (!sucessoLogin)
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível fazer o login!')));
  }
}
