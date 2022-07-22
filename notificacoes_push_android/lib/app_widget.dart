import 'package:flutter/material.dart';
import 'package:notificacoes_push_android/layers/presentation/ui/pages/home/home_page.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notificações',
      initialRoute: '/',
      routes: {
        '/': (_) => HomePage(),
      },
    );
  }
}
