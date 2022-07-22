import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notificacoes_push_android/layers/bloc/events/notification_events/notification_events.dart';
import 'package:notificacoes_push_android/layers/bloc/events/send_notification_events/notification_events.dart';
import 'package:notificacoes_push_android/layers/bloc/notification_bloc/notification_bloc.dart';
import 'package:notificacoes_push_android/layers/bloc/send_notification_bloc/send_notification_bloc.dart';
import 'package:notificacoes_push_android/layers/bloc/states/notification_state/notification_state.dart';
import 'package:notificacoes_push_android/layers/bloc/states/send_notification_state/send_notification_state.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = GetIt.I.get<NotificationBloc>();
  final sendController = GetIt.I.get<SendNotificationBloc>();

  final GlobalKey<FormState> keyTitulo = GlobalKey<FormState>();
  final GlobalKey<FormState> keyDesc = GlobalKey<FormState>();
  final tituloController = TextEditingController();
  final descricaoController = TextEditingController();
  final FocusNode fTitle = FocusNode();
  final FocusNode fDescription = FocusNode();

  late StreamSubscription sub;

  @override
  void initState() {
    super.initState();

    controller.add(GetAllNotificationEvent());

    sub = sendController.stream.listen((state) {
      switch (state.runtimeType) {
        case SucessSendNotificationState:
          mostraAlerta(
            titulo: 'Sucesso',
            descricao: 'Notificação enviada!',
            context: context,
          );
          controller.add(
            CreateNotificationEvent(
              notificationEntity: sendController.notificationEntity,
            ),
          );
          tituloController.text = '';
          descricaoController.text = '';
          break;
        case ErrorSendNotificationState:
          mostraAlerta(
            titulo: 'Atenção',
            descricao:
                'Não foi possível enviar a notificação. Tente novamente.',
            context: context,
          );
          break;
      }
    });
  }

  @override
  void dispose() {
    sub.cancel();
    controller.close();
    super.dispose();
  }

  void mostraAlerta(
      {required String titulo,
      required String descricao,
      required BuildContext context,
      String textBotao = 'Entendido'}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            titulo,
            style: TextStyle(fontSize: 14),
          ),
          content: Text(descricao),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                elevation: MaterialStateProperty.all(5),
                shadowColor: MaterialStateProperty.all(Colors.blue),
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            Column(
              children: [
                Form(
                  key: keyTitulo,
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: fTitle,
                    controller: tituloController,
                    decoration: InputDecoration(
                      label: Text('Título'),
                      hintText: 'Título da Notificação',
                      isDense: true,
                    ),
                    validator: (text) {
                      if (text == null || text.isEmpty)
                        return 'Digite um título';
                      return null;
                    },
                    onSaved: (title) {
                      sendController.copyWith(title: title);
                    },
                    onFieldSubmitted: (_) {
                      fDescription.requestFocus();
                    },
                  ),
                ),
                SizedBox(height: 10),
                Form(
                  key: keyDesc,
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: fDescription,
                    controller: descricaoController,
                    decoration: InputDecoration(
                      label: Text('Descrição'),
                      hintText: 'Descrição da Notificação',
                      isDense: true,
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 1,
                    onSaved: (description) {
                      sendController.copyWith(description: description);
                    },
                  ),
                ),
                SizedBox(height: 20),
                BlocBuilder<SendNotificationBloc, SendNotificationState>(
                    bloc: sendController,
                    builder: (context, state) {
                      return state is SucessSendNotificationState ||
                              state is ErrorSendNotificationState ||
                              state is EmptySendNotificationState
                          ? ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.blue),
                                elevation: MaterialStateProperty.all(5),
                                shadowColor:
                                    MaterialStateProperty.all(Colors.blue),
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

                                sendController.add(SendNotificationEvent());
                              },
                            )
                          : Center(
                              child: Container(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(),
                              ),
                            );
                    })
              ],
            ),
            Row(
              children: [
                VerticalDivider(),
                BlocBuilder<NotificationBloc, NotificationState>(
                    bloc: controller,
                    builder: (context, state) {
                      return state is SuccessNotificationState
                          ? Expanded(
                              child: Container(
                                child: ListView.separated(
                                  itemBuilder: (_, int index) {
                                    return ListTile(
                                      onTap: () {
                                        tituloController.text =
                                            state.notifications[index].title;
                                        descricaoController.text = state
                                            .notifications[index].description;
                                      },
                                      title: Text(
                                        state.notifications[index].title,
                                      ),
                                      subtitle: Text(
                                        state.notifications[index].description,
                                      ),
                                      trailing: GestureDetector(
                                        child: Icon(Icons.delete),
                                        onTap: () async {
                                          controller.add(
                                            DeleteNotificationEvent(
                                              id: state.notifications[index].id,
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  separatorBuilder: (_, __) =>
                                      SizedBox(height: 10),
                                  itemCount: state.notifications.length,
                                ),
                              ),
                            )
                          : state is LoadingNotifcationState
                              ? Expanded(
                                  child: Center(
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: Center(
                                    child: Container(
                                      child: Text(
                                        'Nenhuma notificação encontrada.',
                                        style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                );
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}
