import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mt;
import 'package:get_it/get_it.dart';
import 'package:notificacoes_push_android/layers/presentation/controllers/notification_controller.dart';
import 'package:notificacoes_push_android/layers/presentation/controllers/notification_status.dart';

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

    controller.addListener(() {
      setState(() {});
    });
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
                  controller.status != NotificationStatus.loading
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

                            if (await controller.sendNotification(
                                context: context)) {
                              getAllNotifications();
                            }
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
                              onTap: () async {
                                await controller.deleteNotification(
                                  id: controller
                                      .listNotificationEntity[index].id,
                                );

                                getAllNotifications();
                              },
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
