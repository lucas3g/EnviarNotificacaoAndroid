import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mt;
import 'package:get_it/get_it.dart';
import 'package:notificacoes_push_android/layers/presentation/controllers/notification_controller.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = GetIt.I.get<NotificationController>();

  final GlobalKey<FormState> keyTitulo = GlobalKey<FormState>();
  final GlobalKey<FormState> keyDesc = GlobalKey<FormState>();
  final tituloController = TextEditingController();
  final descricaoController = TextEditingController();

  Future<void> getAllNotifications() async {
    await controller.getAllNotifications();
  }

  @override
  void initState() {
    super.initState();

    getAllNotifications();

    controller.addListener(() async {
      setState(() {});
      // if (controller.status == NotificationStatus.camposVazios) {
      //   mostraAlerta(
      //       titulo: 'Por favor preencher todos os campos',
      //       descricao: 'Titulo e Descrição');
      // } else if (controller.status == NotificationStatus.error) {
      //   mostraAlerta(
      //       titulo: 'Opsss...',
      //       descricao: 'Não consegui enviar a notificação. Tente novamente.');
      // } else if (controller.status == NotificationStatus.success) {
      //   mostraAlerta(
      //       titulo: 'Sucesso',
      //       descricao: 'Notificação enviada!',
      //       textBotao: 'Obrigado :)');
      // }
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
          child: GridView.count(
            crossAxisCount: 2,
            children: [
              Column(
                children: [
                  Form(
                    key: keyTitulo,
                    child: TextFormBox(
                      controller: tituloController,
                      header: 'Título',
                      validator: (text) {
                        if (text == null || text.isEmpty)
                          return 'Digite um título';
                        return null;
                      },
                      placeholder: 'Título da Notificação',
                      onSaved: (title) {
                        controller.copyWith(title: title);
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
                      controller: descricaoController,
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
                      onSaved: (description) {
                        controller.copyWith(description: description);
                      },
                      prefix: const Padding(
                        padding: EdgeInsetsDirectional.only(start: 8.0),
                        child: Icon(FluentIcons.list),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Button(
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

                      if (await controller.createNotification()) {
                        print('criou');
                      } else {
                        print('nao criou');
                      }
                      ;
                    },
                  )
                  // : Center(
                  //     child: Container(
                  //       height: 30,
                  //       width: 30,
                  //       child: mt.CircularProgressIndicator(),
                  //     ),
                  //   ),
                ],
              ),
              Row(
                children: [
                  mt.VerticalDivider(),
                  Expanded(
                    child: Container(
                      child: ListView.separated(
                        itemBuilder: (_, int index) {
                          return mt.ListTile(
                            onTap: () {
                              tituloController.text = controller
                                  .listNotificationEntity[index].title;
                              descricaoController.text = controller
                                  .listNotificationEntity[index].description;
                            },
                            title: Text(
                                controller.listNotificationEntity[index].title),
                            subtitle: Text(controller
                                .listNotificationEntity[index].description),
                            trailing: GestureDetector(
                              child: Icon(FluentIcons.delete),
                              onTap: () async {},
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => SizedBox(height: 10),
                        itemCount: controller.listNotificationEntity.length,
                      ),
                    ),
                  )
                  // : Expanded(
                  //     child: Center(
                  //       child: Container(
                  //         child: mt.CircularProgressIndicator(),
                  //       ),
                  //     ),
                  //   ),
                ],
              )
            ],
          )),
    );
  }
}
