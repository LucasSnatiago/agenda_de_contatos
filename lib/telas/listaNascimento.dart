import 'package:agenda_de_contatos/models/contato.dart';
import 'package:agenda_de_contatos/providers/contatos.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';

const List<String> mesesAno = const [
  'Janeiro',
  'Fevereiro',
  'Março',
  'Abril',
  'Maio',
  'Junho',
  'Julho',
  'Agosto',
  'Setembro',
  'Outubro',
  'Novembro',
  'Dezembro'
];

class ListaAniversariantes extends StatelessWidget {
  static const routeName = 'telas/listaAniversario';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(''),
        ),
        body: Consumer<Contatos>(
          builder: (context, contatos, _) => contatos.itens.length == 0
              ? Center(
                  child: Text('Você não possui nenhum contato!'),
                )
              : _buildListaContatos(context, contatos.aniversariantes),
        ));
  }

  Widget _buildListaContatos(context, List<Contato> contato) {
    return GroupedListView<Contato, DateTime>(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      elements: contato,
      groupBy: (element) => DateTime.parse(element.aniversario),
      groupSeparatorBuilder: (value) => Text(mesesAno[value.month - 1]),
      groupComparator: (value1, value2) => value1.month.compareTo(value2.month),
      itemBuilder: (context, cont) => _buildContact(context, cont),
    );
  }

  ListTile _buildContact(BuildContext context, Contato cont) {
    return ListTile(
      trailing: GestureDetector(
        child: Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
      leading: _buildUserPhoto(),
      title: Text(cont.nome),
    );
  }

  CircleAvatar _buildUserPhoto() => CircleAvatar();
}
