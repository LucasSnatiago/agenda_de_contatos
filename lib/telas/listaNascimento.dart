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

  Widget _buildListaContatos(BuildContext context, List<Contato> contato) {
    return GroupedListView<Contato, int>(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      elements: contato,
      groupBy: (element) => DateTime.parse(element.aniversario).month,
      groupSeparatorBuilder: (group_by_value) =>
          Text(mesesAno[group_by_value - 1]),
      itemBuilder: (context, element) => _buildContact(context, element),
      groupComparator: (item1, item2) => item1.compareTo(item2),
      useStickyGroupSeparators: true,
      floatingHeader: true,
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
      leading: _buildUserPhoto(cont),
      title: Text(cont.nome),
    );
  }

  CircleAvatar _buildUserPhoto(Contato contato) {
    if (contato.photo != '')
      return CircleAvatar(
        backgroundImage: NetworkImage(contato.photo),
      );
    else
      return CircleAvatar();
  }
}
