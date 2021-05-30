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
  var _cepController = TextEditingController();
  var _ruaController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.editarContato != null) {
      this.update = true;

      this._cepController.text = widget.editarContato.cep;

      this._formValues['nome'] = widget.editarContato.nome;
      this._formValues['email'] = widget.editarContato.email;
      this._formValues['endereco'] = widget.editarContato.endereco;
      this._formValues['cep'] = widget.editarContato.cep;
      this._formValues['telefone'] = widget.editarContato.telefone;
    }
  }

  @override
  void dispose() {
    super.dispose();

    this._cepController.dispose();
    this._ruaController.dispose();
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
                    controller: this._cepController,
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
                  ElevatedButton(
                      onPressed: () async {
                        var endereco =
                            await getEnderecoByCep(this._cepController.text);
                        setState(() {
                          this._ruaController.text = endereco['street'];
                          _formValues['endereco'] = endereco['street'] +
                              ', ' +
                              endereco['neighborhood'] +
                              ', ' +
                              endereco['city'] +
                              ', ' +
                              endereco['state'];
                        });
                      },
                      child: Text('Verificar CEP')),
                  TextFormField(
                    controller: this._ruaController,
                    enabled: false,
                    decoration: InputDecoration(
                        labelText: 'Nome da rua', border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                  TextFormField(
                    initialValue: this._formValues['endereco'],
                    autocorrect: true,
                    validator: (value) =>
                        value.isEmpty ? 'O endereço não pode ser vazio!' : null,
                    onSaved: (endereco) => _formValues['endereco'] = endereco,
                    decoration: InputDecoration(
                        labelText: 'Endereço', border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 40,
                  ),
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

  Future<Map<String, dynamic>> getEnderecoByCep(String cep) async {
    if (cep == null || cep.length < 8) return null;
    final result = await readAddressByCep(cep);
    if (result.isEmpty)
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao encontrar endereço pelo CEP')));

    return result;
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
