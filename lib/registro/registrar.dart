import 'package:agenda_de_contatos/utils/utils.dart';
import 'package:flutter/material.dart';

class Registrar extends StatefulWidget {
  static const routeName = 'registro/registrar';

  @override
  _RegistrarState createState() => _RegistrarState();
}

class _RegistrarState extends State<Registrar> {
  final _globalKey = GlobalKey<FormState>();
  var _formValues = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar conta'),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _globalKey,
            child: Column(
              children: [
                Text(
                  'Insira os dados para se registrar',
                  style: TextStyle(fontSize: 26),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  autocorrect: true,
                  keyboardType: TextInputType.name,
                  initialValue: _formValues['nome'],
                  onSaved: (value) => _formValues['nome'] = value,
                  validator: (value) => (value.isEmpty || value.length < 4)
                      ? 'O nome precisa ter pelo menos 4 caracteres!'
                      : '',
                  decoration: InputDecoration(
                      labelText: 'Nome', border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 2,
                ),
                TextFormField(
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  initialValue: _formValues['email'],
                  onSaved: (newValue) => _formValues['email'] = newValue,
                  validator: (value) => (value.isEmpty || !isValidEmail(value))
                      ? 'É necessário um email válido!'
                      : '',
                  decoration: InputDecoration(
                      labelText: 'Email', border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 2,
                ),
                TextFormField(
                  autocorrect: false,
                  initialValue: _formValues['senha'],
                  obscureText: false,
                  onSaved: (newValue) => _formValues['senha'] = newValue,
                  validator: (value) => value.length < 8
                      ? 'A senha precisa ter no mínimo 8 caracteres'
                      : '',
                  decoration: InputDecoration(
                      labelText: 'Endereço', border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 2,
                ),
                TextFormField(
                  autocorrect: false,
                  initialValue: _formValues['confirmar_senha'],
                  obscureText: false,
                  onSaved: (newValue) =>
                      _formValues['confirmar_senha'] = newValue,
                  validator: (value) => value.length < 8
                      ? 'A senha precisa ter no mínimo 8 caracteres'
                      : '',
                  decoration: InputDecoration(
                      labelText: 'Endereço', border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 5,
                ),
                ElevatedButton(
                    onPressed: () => registrar(), child: Text('Registrar')),
              ],
            )),
      ),
    );
  }

  registrar() {
    _globalKey.currentState.save();

    if (!_globalKey.currentState.validate()) return;
  }
}
