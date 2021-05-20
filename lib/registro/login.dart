import 'package:agenda_de_contatos/utils/utils.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
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
                    : '',
                decoration: InputDecoration(
                    labelText: 'Endereço', border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 2,
              ),
              TextFormField(
                autocorrect: false,
                obscureText: true,
                onSaved: (newValue) => _formValues['senha'] = newValue,
                validator: (value) => (value.length < 8)
                    ? 'Insira uma senha de no mínimo 8 digitos'
                    : '',
                decoration: InputDecoration(
                    labelText: 'Endereço', border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 5,
              ),
              ElevatedButton(
                  onPressed: () => entrar(), child: Text('Entrar na conta')),
            ],
          ),
        ),
      ),
    );
  }

  entrar() {
    _globalKey.currentState.save();

    if (!_globalKey.currentState.validate()) return;
  }
}
