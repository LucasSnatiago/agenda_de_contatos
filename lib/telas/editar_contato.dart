import 'dart:io';

import 'package:agenda_de_contatos/camera/camera.dart';
import 'package:agenda_de_contatos/models/contato.dart';
import 'package:agenda_de_contatos/providers/contatos.dart';
import 'package:agenda_de_contatos/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  DateTime aniversario;
  File fotoUsuario;

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
      this._formValues['photoUrl'] = widget.editarContato.photo;

      if (DateTime.tryParse(widget.editarContato.aniversario) != null)
        this.aniversario = DateTime.parse(widget.editarContato.aniversario);
      else
        this.aniversario = DateTime.now();
    } else
      this.aniversario = DateTime.now();
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
        title:
            this.update ? Text('Editar Contato') : Text('Criar novo Contato'),
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
                  LigarCamera(
                    _setPhotoUrl,
                    previewImgUrl: _formValues['photoUrl'],
                  ),
                  SizedBox(
                    height: 5,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          onPressed: () => _selectDate(context),
                          child: Text('Selecione o dia de pagamento')),
                      Text(DateFormat('dd/MM/yyyy').format(this.aniversario)),
                    ],
                  ),
                  SizedBox(
                    height: 2,
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
                          _formValues['endereco'] = endereco['street'] +
                              ', ' +
                              endereco['neighborhood'] +
                              ', ' +
                              endereco['city'] +
                              ', ' +
                              endereco['state'];
                          this._ruaController.text = _formValues['endereco'];
                        });
                      },
                      child: Text('Verificar CEP')),
                  TextFormField(
                    controller: this._ruaController,
                    autocorrect: true,
                    enabled: false,
                    maxLines: 3,
                    validator: (value) =>
                        value.isEmpty ? 'O endereço não pode ser vazio!' : null,
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

  _setPhotoUrl(File fotoPerfil) {
    this.fotoUsuario = fotoPerfil;
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();

    final DateTime picked = await showDatePicker(
        locale: const Locale('pt', 'BR'),
        context: context,
        firstDate: now,
        lastDate: DateTime(now.year + 100),
        initialDate: now);
    if (picked != null && picked != this.aniversario)
      setState(() {
        this.aniversario = picked;
      });
  }

  addContato() async {
    _globalKey.currentState.save();

    if (!_globalKey.currentState.validate()) {
      return '';
    }

    print('AAAAAAAAAAAAAAAAAAAAAAAAA' + widget.editarContato.id);

    if (!this.update)
      await Provider.of<Contatos>(context, listen: false).inserir(
          _formValues['nome'],
          _formValues['email'],
          this._ruaController.text,
          _formValues['cep'],
          _formValues['telefone'],
          this.fotoUsuario,
          this.aniversario.toIso8601String());
    else
      await Provider.of<Contatos>(context, listen: false).atualizar(
          widget.editarContato.id,
          _formValues['nome'],
          _formValues['email'],
          this._ruaController.text,
          _formValues['cep'],
          _formValues['telefone'],
          this.fotoUsuario,
          this.aniversario.toIso8601String());

    Navigator.of(context).pop();
  }
}
