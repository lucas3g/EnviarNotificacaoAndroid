import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl_standalone.dart';
import 'package:notificacoes_push_android/app_widget.dart';
import 'package:notificacoes_push_android/core/inject/inject.dart';

void main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await initializeDateFormatting(await findSystemLocale(), '');

      Inject.init();

      runApp(AppWidget());
    },
    (error, st) => print(error),
  );
}
