import 'package:agenda_de_contatos/models/contato.dart';
import 'package:agenda_de_contatos/providers/contatos.dart';
import 'package:agenda_de_contatos/telas/editar_contato.dart';
import 'package:agenda_de_contatos/telas/listaNascimento.dart';
import 'package:agenda_de_contatos/telas/procurar_contato.dart';
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
            ),
            onPressed: () =>
                showSearch(context: context, delegate: ProcurarContato()),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text('Lista de contatos')),
            ListTile(
              title: Text('Aniversariantes'),
              onTap: () => Navigator.of(context)
                  .pushNamed(ListaAniversariantes.routeName),
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: Provider.of<Contatos>(context, listen: false)
            .pegarContatosUsuarioFirebase(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<Contatos>(
                builder: (context, contatos, _) => contatos.itens.length == 0
                    ? Center(
                        child: Text('Você não possui nenhum contato!'),
                      )
                    : _buildListaContatos(context, contatos.itens),
              ),
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
        trailing: GestureDetector(
          onTap: () async => Provider.of<Contatos>(context, listen: false)
              .excluir(contato[index].id),
          child: Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
        onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (context) => NovoContato(
            editarContato: contato[index],
          ),
        )),
        leading: CircleAvatar(),
        title: Text(contato[index].nome),
      ),
    );
  }
}
