import 'package:agenda_de_contatos/models/contato.dart';
import 'package:agenda_de_contatos/providers/contatos.dart';
import 'package:agenda_de_contatos/telas/editar_contato.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum Pagina { sugestoes, resultado }

class ProcurarContato extends SearchDelegate<Contato> {
  Pagina paginaAtual = Pagina.sugestoes;
  Contato selecionado;

  @override
  String get searchFieldLabel => 'Pesquisar contato';

  @override
  List<Widget> buildActions(BuildContext context) {
    return this.paginaAtual == Pagina.sugestoes
        ? [
            IconButton(
              onPressed: () => query = '',
              icon: Icon(Icons.clear),
            )
          ]
        : [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          if (this.paginaAtual == Pagina.resultado) {
            this.paginaAtual = Pagina.sugestoes;
            showSuggestions(context);
          } else
            Navigator.of(context).pop();
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              'Visualizando contato:',
              style: TextStyle(fontSize: 26),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text('Nome: ${selecionado.nome}'),
          SizedBox(
            height: 2.0,
          ),
          Text('Telefone: ${selecionado.telefone}'),
          SizedBox(
            height: 2.0,
          ),
          Text('Email: ${selecionado.email}'),
          SizedBox(
            height: 2.0,
          ),
          Text('CEP: ${selecionado.cep}'),
          SizedBox(
            height: 2.0,
          ),
          Text('Endereço: ${selecionado.endereco}'),
          SizedBox(
            height: 5.0,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute<void>(
                  builder: (context) => NovoContato(
                    editarContato: selecionado,
                  ),
                ));
              },
              child: Text('Editar contato')),
          SizedBox(
            height: 2.0,
          ),
          ElevatedButton(
              onPressed: () async {
                await Provider.of<Contatos>(context, listen: false)
                    .excluir(selecionado.id);

                this.paginaAtual = Pagina.sugestoes;
                showSuggestions(context);
              },
              child: Text('Deletar contato')),
        ],
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Consumer<Contatos>(
      builder: (context, contato, child) {
        List<Contato> listSugestoes = [];

        if (query.isNotEmpty)
          listSugestoes = contato.itens
              .where((element) =>
                  element.nome.toUpperCase().contains(query.toUpperCase()))
              .toList();
        else
          listSugestoes = contato.itens;

        if (listSugestoes.length > 0 && query.isNotEmpty)
          this.selecionado = listSugestoes.first;

        return ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: listSugestoes.length,
          itemBuilder: (context, index) => ListTile(
            trailing: GestureDetector(
              onTap: () async => Provider.of<Contatos>(context, listen: false)
                  .excluir(listSugestoes[index].id),
              child: Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
            onTap: () {
              this.selecionado = listSugestoes[index];
              showResults(context);
            },
            leading: CircleAvatar(),
            title: Text(listSugestoes[index].nome),
          ),
        );
      },
    );
  }
}
