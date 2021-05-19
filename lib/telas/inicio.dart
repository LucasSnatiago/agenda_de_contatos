import 'package:agenda_de_contatos/models/contato.dart';
import 'package:agenda_de_contatos/providers/contatos.dart';
import 'package:agenda_de_contatos/telas/novo_contato.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Inicio extends StatefulWidget {
  static const routeName = 'telas/inicio';

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda de Contatos'),
      ),
      body: Consumer<Contatos>(
        builder: (context, contatos, _) => contatos.itens.length == 0
            ? Center(
                child: Text('Você não possui nenhum contato!'),
              )
            : _buildListaContatos(context, contatos.itens),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context).pushNamed(NovoContato.routeName),
      ),
    );
  }

  Widget _buildListaContatos(context, List<Contato> contato) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: contato.length,
      itemBuilder: (context, index) => ListTile(
        leading: CircleAvatar(),
        title: Text(contato[index].nome),
      ),
    );
  }
}
