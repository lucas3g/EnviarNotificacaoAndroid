import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mt;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notificacoes_push_android/layers/bloc/events/notification_events/notification_events.dart';
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

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      return controller.add(GetAllNotificationEvent());
    });

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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: fTitle,
                    controller: tituloController,
                    header: 'Título',
                    validator: (text) {
                      if (text == null || text.isEmpty)
                        return 'Digite um título';
                      return null;
                    },
                    placeholder: 'Título da Notificação',
                    onSaved: (title) {
                      sendController.copyWith(title: title);
                    },
                    onFieldSubmitted: (_) {
                      fDescription.requestFocus();
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: fDescription,
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
                      sendController.copyWith(description: description);
                    },
                    prefix: const Padding(
                      padding: EdgeInsetsDirectional.only(start: 8.0),
                      child: Icon(FluentIcons.list),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                BlocBuilder<SendNotificationBloc, SendNotificationState>(
                    bloc: sendController,
                    builder: (context, state) {
                      return state is SucessSendNotificationState ||
                              state is ErrorSendNotificationState ||
                              state is EmptySendNotificationState
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

                                sendController.add(SendNotificationEvent());
                              },
                            )
                          : Center(
                              child: Container(
                                height: 30,
                                width: 30,
                                child: mt.CircularProgressIndicator(),
                              ),
                            );
                    })
              ],
            ),
            Row(
              children: [
                mt.VerticalDivider(),
                BlocBuilder<NotificationBloc, NotificationState>(
                    bloc: controller,
                    builder: (context, state) {
                      return state is SuccessNotificationState
                          ? Expanded(
                              child: Container(
                                child: ListView.separated(
                                  itemBuilder: (_, int index) {
                                    return mt.ListTile(
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
                                        child: Icon(FluentIcons.delete),
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
                                      child: mt.CircularProgressIndicator(),
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
