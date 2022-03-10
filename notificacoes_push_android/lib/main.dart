import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl_standalone.dart';
import 'package:notificacoes_push_android/app_widget.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:notificacoes_push_android/core/inject/inject.dart';

void main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await initializeDateFormatting(await findSystemLocale(), '');

      Inject.init();

      runApp(AppWidget());

      doWhenWindowReady(() {
        final win = appWindow;
        // win.minSize = const Size(410, 540);
        // win.size = const Size(410, 540);
        // win.maxSize = const Size(410, 540);
        win.alignment = Alignment.center;
        win.title = 'Envio de Notificações';
        win.show();
      });
    },
    (error, st) => print(error),
  );
}
