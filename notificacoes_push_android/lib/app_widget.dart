import 'package:fluent_ui/fluent_ui.dart';
import 'package:notificacoes_push_android/pages/home/home_page.dart';
import 'package:notificacoes_push_android/pages/home/test_page.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      debugShowCheckedModeBanner: false,
      title: 'Notificações Push Android',
      initialRoute: '/',
      routes: {
        '/': (_) => HomePage(),
      },
    );
  }
}
