library dashboard_main;

@MirrorsUsed(targets: const ['dashboard_app'], override: '*')
import 'dart:mirrors';
import 'package:logging/logging.dart';
import 'package:dashboard/dashboard_app.dart';


void main() {
  Logger.root.level = Level.FINEST;
  Logger.root.onRecord.listen((LogRecord r) {
    print(r.message);
  });
  startApp();
}


