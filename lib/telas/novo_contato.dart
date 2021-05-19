import 'package:agenda_de_contatos/providers/contatos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NovoContato extends StatefulWidget {
  static const routeName = 'telas/novo_contato';

  @override
  _NovoContatoState createState() => _NovoContatoState();
}

class _NovoContatoState extends State<NovoContato> {
  final _globalKey = GlobalKey<FormState>();
  var _formValues = {};

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
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text('Entre com os dados do contato'),
                  SizedBox(
                    height: 2.0,
                  ),
                  TextFormField(
                    autocorrect: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'O nome não pode ser vazio!';
                      }
                      return '';
                    },
                    onSaved: (nome) => _formValues['nome'] = nome,
                    decoration: InputDecoration(
                        labelText: 'Email', border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                  ElevatedButton(
                      onPressed: () => addContato(),
                      child: Text('Salvar Contato'))
                ],
              ),
            )),
      ),
    );
  }

  addContato() {
    Provider.of<Contatos>(context, listen: false)
        .inserir('nome', 'email', 'endereco', 'cep', 'telefone');
  }
}
