import 'package:agenda_de_contatos/providers/contatos.dart';
import 'package:agenda_de_contatos/registro/login.dart';
import 'package:agenda_de_contatos/registro/registrar.dart';
import 'package:agenda_de_contatos/telas/editar_contato.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'telas/inicio.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider.value(value: Contatos())],
        child: MaterialApp(
          title: 'Agenda de Contatos',
          home: Login(),
          theme: ThemeData.dark(),
          routes: {
            Inicio.routeName: (ctx) => Inicio(),
            NovoContato.routeName: (ctx) => NovoContato(),
            Login.routeName: (ctx) => Login(),
            Registrar.routeName: (ctx) => Registrar(),
          },
        ));
  }
}
