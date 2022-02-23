import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mt;
import 'package:notificacoes_push_android/controllers/notification/notification_controller.dart';
import 'package:notificacoes_push_android/controllers/notification/notification_status.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = NotificationController();
  final GlobalKey<FormState> keyTitulo = GlobalKey<FormState>();
  final GlobalKey<FormState> keyDesc = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      setState(() {});
      if (controller.status == NotificationStatus.camposVazios) {
        mostraAlerta(
            titulo: 'Por favor preencher todos os campos',
            descricao: 'Titulo e Descrição');
      } else if (controller.status == NotificationStatus.error) {
        mostraAlerta(
            titulo: 'Opsss...',
            descricao: 'Não consegui enviar a notificação. Tente novamente.');
      } else if (controller.status == NotificationStatus.success) {
        mostraAlerta(
            titulo: 'Sucesso',
            descricao: 'Notificação envida!',
            textBotao: 'Obrigado :)');
      }
    });
  }

  void mostraAlerta(
      {required String titulo,
      required String descricao,
      String textBotao = 'Entendido'}) {
    showDialog(
      context: context,
      builder: (context) {
        return ContentDialog(
          title: Text(
            titulo,
            style: TextStyle(fontSize: 14),
          ),
          content: Text(descricao),
          actions: [
            Button(
              style: ButtonStyle(
                backgroundColor: ButtonState.all(Colors.blue),
                elevation: ButtonState.all(5),
                shadowColor: ButtonState.all(Colors.blue),
              ),
              child: Center(
                child: Text(
                  textBotao,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Acrylic(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Form(
                  key: keyTitulo,
                  child: TextFormBox(
                    header: 'Título',
                    validator: (text) {
                      if (text == null || text.isEmpty)
                        return 'Digite um título';
                      return null;
                    },
                    placeholder: 'Título da Notificação',
                    onSaved: (value) {
                      controller.titulo = value!;
                    },
                    prefix: const Padding(
                      padding: EdgeInsetsDirectional.only(start: 8.0),
                      child: Icon(FluentIcons.title),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Form(
                  key: keyDesc,
                  child: TextFormBox(
                    header: 'Descrição',
                    validator: (text) {
                      if (text == null || text.isEmpty)
                        return 'Digite uma descrição';
                      return null;
                    },
                    placeholder: 'Descrição da Notificação',
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 1,
                    onSaved: (value) {
                      controller.descricao = value!;
                    },
                    prefix: const Padding(
                      padding: EdgeInsetsDirectional.only(start: 8.0),
                      child: Icon(FluentIcons.list),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            controller.status == NotificationStatus.empty ||
                    controller.status == NotificationStatus.success ||
                    controller.status == NotificationStatus.error ||
                    controller.status == NotificationStatus.camposVazios
                ? Button(
                    style: ButtonStyle(
                      backgroundColor: ButtonState.all(Colors.blue),
                      elevation: ButtonState.all(5),
                      shadowColor: ButtonState.all(Colors.blue),
                    ),
                    child: Center(
                      child: Text(
                        'Enviar Notificação',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if ((!keyTitulo.currentState!.validate()) ||
                          (!keyDesc.currentState!.validate())) {
                        return;
                      }

                      keyTitulo.currentState!.save();
                      keyDesc.currentState!.save();

                      await controller.enviarNotificacao();
                    },
                  )
                : Center(
                    child: Container(
                      height: 30,
                      width: 30,
                      child: mt.CircularProgressIndicator(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
