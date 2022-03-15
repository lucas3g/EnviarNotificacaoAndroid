import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mt;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notificacoes_push_android/layers/bloc/events/notification_events.dart';
import 'package:notificacoes_push_android/layers/bloc/notification_bloc/notification_bloc.dart';
import 'package:notificacoes_push_android/layers/bloc/states/notification_state.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = GetIt.I.get<NotificationBloc>();

  final GlobalKey<FormState> keyTitulo = GlobalKey<FormState>();
  final GlobalKey<FormState> keyDesc = GlobalKey<FormState>();
  final tituloController = TextEditingController();
  final descricaoController = TextEditingController();
  final FocusNode fTitle = FocusNode();
  final FocusNode fDescription = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      return controller.add(GetAllNotificationEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Acrylic(
      child: BlocBuilder<NotificationBloc, NotificationState>(
          bloc: controller,
          builder: (context, state) {
            return Padding(
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
                            controller.copyWith(title: title);
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
                            controller.copyWith(description: description);
                          },
                          prefix: const Padding(
                            padding: EdgeInsetsDirectional.only(start: 8.0),
                            child: Icon(FluentIcons.list),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      state is SucessNotifcationState ||
                              state is ErrorNotifcationState ||
                              state is EmptyNotifcationState
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

                                controller.add(SendNotificationEvent());
                                if (state is SucessNotifcationState) {
                                  tituloController.text = '';
                                  descricaoController.text = '';
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
                      ((state is SucessNotifcationState) &&
                              state.notifications.isNotEmpty)
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
                                          state.notifications[index].title),
                                      subtitle: Text(state
                                          .notifications[index].description),
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
                            )
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }
}
