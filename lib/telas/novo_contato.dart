import 'package:agenda_de_contatos/providers/contatos.dart';
import 'package:agenda_de_contatos/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:via_cep_flutter/via_cep_flutter.dart';

class NovoContato extends StatefulWidget {
  static const routeName = 'telas/novo_contato';

  @override
  _NovoContatoState createState() => _NovoContatoState();
}

class _NovoContatoState extends State<NovoContato> {
  final _globalKey = GlobalKey<FormState>();
  var _formValues = {};

  var _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar novo Contato'),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _globalKey,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  Text(
                    'Entre com os dados do contato',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  TextFormField(
                    autocorrect: true,
                    keyboardType: TextInputType.name,
                    validator: (value) =>
                        value.isEmpty ? 'O nome não pode ser vazio!' : '',
                    onSaved: (nome) => _formValues['nome'] = nome,
                    decoration: InputDecoration(
                        labelText: 'Nome', border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                  TextFormField(
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => !isValidEmail(value)
                        ? 'É necessário inserir um email válido'
                        : '',
                    onSaved: (email) => _formValues['email'] = email,
                    decoration: InputDecoration(
                        labelText: 'Email', border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                  TextFormField(
                    autocorrect: false,
                    keyboardType: TextInputType.phone,
                    validator: (value) => value.isEmpty
                        ? 'O número de telefone não pode ser vazio!'
                        : '',
                    onSaved: (telefone) => _formValues['telefone'] = telefone,
                    decoration: InputDecoration(
                        labelText: 'Telefone', border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                  TextFormField(
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    maxLength: 8,
                    validator: (value) =>
                        value.isEmpty ? 'O CEP não pode estar vazio!' : '',
                    onSaved: (cep) => _formValues['cep'] = cep,
                    decoration: InputDecoration(
                        labelText: 'CEP', border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                  TextFormField(
                    autocorrect: true,
                    validator: (value) =>
                        value.isEmpty ? 'O endereço não pode ser vazio!' : '',
                    onSaved: (endereco) => _formValues['endereco'] = endereco,
                    decoration: InputDecoration(
                        labelText: 'Endereço', border: OutlineInputBorder()),
                  ),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       print(getNomeRua('05653-070'));
                  //     },
                  //     child: Text('Verificar CEP')),
                  // SizedBox(
                  //   height: 2.0,
                  // ),
                  // TextFormField(
                  //   controller: _controller,
                  //   readOnly: true,
                  //   decoration: InputDecoration(
                  //       labelText: 'Rua', border: OutlineInputBorder()),
                  // ),
                  // SizedBox(
                  //   height: 40,
                  // ),
                  ElevatedButton(
                    onPressed: () => addContato(),
                    child: Text('Salvar Contato'),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Future<String> getNomeRua(String cep) async {
    if (cep == null || cep.length < 8) return null;
    final result = await readAddressByCep(cep);
    return result.street;
  }

  addContato() {
    _globalKey.currentState.save();

    if (_globalKey.currentState.validate()) {
      return '';
    }

    Provider.of<Contatos>(context, listen: false).inserir(
        _formValues['nome'],
        _formValues['email'],
        _formValues['endereco'],
        _formValues['cep'],
        _formValues['telefone']);
  }
}
