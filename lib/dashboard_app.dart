library dashboard_app;


import 'dart:async';
import 'dart:math';

import 'package:logging/logging.dart';

import 'package:angular/angular.dart';
import 'package:angular/animate/module.dart';
import 'package:angular/application_factory.dart';

part 'bom/pod.dart';
part 'bom/minion.dart';
part 'bom/container.dart';
part 'bom/service.dart';
part 'bom/replicationcontroller.dart';

part 'components/minion_component.dart';

part 'controllers/maincontroller.dart';

class MainModule extends Module {
  MainModule() {

    bind(MainController);

    bind(MinionComponent);


    this.install(new AnimationModule());
  }
}

startApp() {
  Injector inj = applicationFactory().addModule(new MainModule()).run();
  // GlobalHttpInterceptors.setUp(inj);
}
