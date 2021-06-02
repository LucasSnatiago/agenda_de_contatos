import 'package:agenda_de_contatos/camera/camera.dart';
import 'package:agenda_de_contatos/providers/auth.dart';
import 'package:agenda_de_contatos/providers/contatos.dart';
import 'package:agenda_de_contatos/registro/login.dart';
import 'package:agenda_de_contatos/registro/registrar.dart';
import 'package:agenda_de_contatos/telas/editar_contato.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';

import 'telas/inicio.dart';

void main() async {
  // Iniciando o FireBase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Iniciando o App
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider.value(value: Auth()),
      ChangeNotifierProxyProvider<Auth, Contatos>(
        create: (context) => Contatos(),
        update: (context, value, previous) => Contatos.id(value.id),
      ),
    ], child: BuildMaterialApp());
  }
}

class BuildMaterialApp extends StatelessWidget {
  const BuildMaterialApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda de Contatos',
      home: Consumer<Auth>(
        builder: (context, auth, child) => auth.estaLogado
            ? Inicio()
            : FutureBuilder(
                future: auth.autologin(),
                builder: (context, snapshot) =>
                    snapshot.connectionState == ConnectionState.waiting
                        ? BuildSplashScreen()
                        : Login(),
              ),
      ),
      theme: ThemeData.dark(),
      routes: {
        Inicio.routeName: (ctx) => Inicio(),
        NovoContato.routeName: (ctx) => NovoContato(),
        Login.routeName: (ctx) => Login(),
        Registrar.routeName: (ctx) => Registrar(),
      },
    );
  }
}

class BuildSplashScreen extends StatelessWidget {
  const BuildSplashScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
