import 'package:agenda_de_contatos/models/contato.dart';
import 'package:agenda_de_contatos/providers/contatos.dart';
import 'package:agenda_de_contatos/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:via_cep_flutter/via_cep_flutter.dart';

class NovoContato extends StatefulWidget {
  static const routeName = 'telas/novo_contato';
  final Contato editarContato;

  NovoContato({this.editarContato});

  @override
  _NovoContatoState createState() => _NovoContatoState();
}

class _NovoContatoState extends State<NovoContato> {
  final _globalKey = GlobalKey<FormState>();
  var _formValues = {};

  bool update = false;
  var _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.editarContato != null) {
      this.update = true;

      _controller.text = widget.editarContato.endereco;

      _formValues['nome'] = widget.editarContato.nome;
      _formValues['email'] = widget.editarContato.email;
      _formValues['endereco'] = widget.editarContato.endereco;
      _formValues['cep'] = widget.editarContato.cep;
      _formValues['telefone'] = widget.editarContato.telefone;
    }
  }

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
                    this.update
                        ? 'Edite seu contato'
                        : 'Entre com os dados do contato',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  TextFormField(
                    initialValue: _formValues['nome'],
                    autocorrect: true,
                    keyboardType: TextInputType.name,
                    validator: (value) =>
                        value.isEmpty ? 'O nome não pode ser vazio!' : null,
                    onSaved: (nome) => _formValues['nome'] = nome,
                    decoration: InputDecoration(
                        labelText: 'Nome', border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                  TextFormField(
                    initialValue: _formValues['email'],
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => !isValidEmail(value)
                        ? 'É necessário inserir um email válido'
                        : null,
                    onSaved: (email) => _formValues['email'] = email,
                    decoration: InputDecoration(
                        labelText: 'Email', border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                  TextFormField(
                    initialValue: _formValues['telefone'],
                    autocorrect: false,
                    keyboardType: TextInputType.phone,
                    validator: (value) => value.isEmpty
                        ? 'O número de telefone não pode ser vazio!'
                        : null,
                    onSaved: (telefone) => _formValues['telefone'] = telefone,
                    decoration: InputDecoration(
                        labelText: 'Telefone', border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                  TextFormField(
                    initialValue: _formValues['cep'],
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    maxLength: 8,
                    validator: (value) =>
                        value.isEmpty ? 'O CEP não pode estar vazio!' : null,
                    onSaved: (cep) => _formValues['cep'] = cep,
                    decoration: InputDecoration(
                        labelText: 'CEP', border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                  TextFormField(
                    controller: _controller,
                    autocorrect: true,
                    validator: (value) =>
                        value.isEmpty ? 'O endereço não pode ser vazio!' : null,
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

  addContato() async {
    _globalKey.currentState.save();

    if (!_globalKey.currentState.validate()) {
      return '';
    }

    if (!this.update)
      await Provider.of<Contatos>(context, listen: false).inserir(
          _formValues['nome'],
          _formValues['email'],
          _formValues['endereco'],
          _formValues['cep'],
          _formValues['telefone']);
    else
      await Provider.of<Contatos>(context, listen: false).atualizar(
          widget.editarContato.id,
          _formValues['nome'],
          _formValues['email'],
          _formValues['endereco'],
          _formValues['cep'],
          _formValues['telefone']);

    Navigator.of(context).pop();
  }
}
