import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mt;
import 'package:notificacoes_push_android/layers/data/datasourcers/get_all_notification_datasource.dart';
import 'package:notificacoes_push_android/layers/data/datasourcers/local/get_all_notification_local_datasource_imp.dart';
import 'package:notificacoes_push_android/layers/data/repositories/create_notification_repository_imp.dart';
import 'package:notificacoes_push_android/layers/data/repositories/get_all_notification_repository_imp.dart';
import 'package:notificacoes_push_android/layers/domain/repositories/get_all_notification_repository.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/create_notification/create_notification_usecase_imp.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/get_all_notification/get_all_notificatin_usecase.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/get_all_notification/get_all_notificatin_usecase_imp.dart';
import 'package:notificacoes_push_android/layers/presentation/controllers/notification_controller.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = NotificationController(
    GetAllNotificationUseCaseImp(
      GetAllNotificationRepositoryImp(
        GetAllNotificationLocalDataSourceImp(),
      ),
    ),
    CreateNotificationUseCaseImp(
      CreateNotificationRepositoryImp(),
    ),
  );

  final GlobalKey<FormState> keyTitulo = GlobalKey<FormState>();
  final GlobalKey<FormState> keyDesc = GlobalKey<FormState>();
  final tituloController = TextEditingController();
  final descricaoController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // controller.addListener(() async {
    //   setState(() {});
    //   if (controller.status == NotificationStatus.camposVazios) {
    //     mostraAlerta(
    //         titulo: 'Por favor preencher todos os campos',
    //         descricao: 'Titulo e Descrição');
    //   } else if (controller.status == NotificationStatus.error) {
    //     mostraAlerta(
    //         titulo: 'Opsss...',
    //         descricao: 'Não consegui enviar a notificação. Tente novamente.');
    //   } else if (controller.status == NotificationStatus.success) {
    //     mostraAlerta(
    //         titulo: 'Sucesso',
    //         descricao: 'Notificação enviada!',
    //         textBotao: 'Obrigado :)');
    //   }
    // });
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
                      onSaved: (value) {
                        //controller.title = value!;
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
                      onSaved: (value) {
                        //controller.description = value!;
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

                      //await controller.enviarNotificacao();
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
                              tituloController.text =
                                  controller.notificationEntity[index].title;
                              descricaoController.text = controller
                                  .notificationEntity[index].description;
                            },
                            title: Text(
                                controller.notificationEntity[index].title),
                            subtitle: Text(controller
                                .notificationEntity[index].description),
                            trailing: GestureDetector(
                              child: Icon(FluentIcons.delete),
                              onTap: () async {},
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => SizedBox(height: 10),
                        itemCount: controller.notificationEntity.length,
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
