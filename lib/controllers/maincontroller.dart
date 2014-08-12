part of dashboard_app;

@Controller(selector: '[indexctrl]', publishAs: 'mainCtrl')
class MainController {
  Http _http;
  Scope _scope;

  String placeholder = "127.0.0.1";
  String ipmaster = "";

  Set<Minion> minions = new Set<Minion>();
  Set<Pod> pods = new Set<Pod>();
  Set<Service> services = new Set<Service>();
  Set<ReplicationController> replicationcontrollers = new Set<ReplicationController>();

  bool _listenCluster = false;

  MainController(this._http, this._scope) {

  }
  
  bool get isStarted => _listenCluster;

  void connectToMaster() {
    _listenCluster = true;
    getMinionList();

    _watchMinions();
    _watchPods();
    _watchServices();
    _watchReplicationControllers();
  }
  
  void stopListen() {
    _listenCluster = false;
  }

  void getMinionList() {
    String url = "http://" + ipmaster + ":8080/api/v1beta1/minions";


    _http.get(url).then((HttpResponse response) => _setMinions(response)).catchError((e) {
      Logger.root.severe('There was a ${e.runtimeType} error');
      Logger.root.severe('Error Details ${e.toString()}');
    });
  }

  void _setMinions(HttpResponse iResponse) {
    Logger.root.info("setMinions update");

    if ((iResponse.data.containsKey("kind")) && (iResponse.data["kind"] == "MinionList") && iResponse.data.containsKey("minions")) {
      Set<Minion> newMinions = new Set<Minion>();
      for (Map iMinion in iResponse.data["minions"]) {
        if (iMinion.containsKey("id")) {
          Logger.root.info("minion id:" + iMinion["id"]);
          Minion newMinion = new Minion(iMinion["id"]);

          if (minions.contains(newMinion)) {
            newMinion = minions.lookup(newMinion);
          }

          newMinions.add(newMinion);

        }
      }

      minions = newMinions;

    } else {
      Logger.root.severe("Error during get REST Minion parsing");
    }
  }

  void getPodList() {
    String url = "http://" + ipmaster + ":8080/api/v1beta1/pods";


    _http.get(url).then((HttpResponse response) => _setPods(response)).catchError((e) {
      Logger.root.severe('There was a ${e.runtimeType} error');
      Logger.root.severe('Error Details ${e.toString()}');

    });
  }

  void getServiceList() {
    String url = "http://" + ipmaster + ":8080/api/v1beta1/services";


    _http.get(url).then((HttpResponse response) => _setServices(response)).catchError((e) {
      Logger.root.severe('There was a ${e.runtimeType} error');
      Logger.root.severe('Error Details ${e.toString()}');

    });
  }

  void getReplicationControllersList() {
    String url = "http://" + ipmaster + ":8080/api/v1beta1/replicationControllers";


    _http.get(url).then((HttpResponse response) => _setReplicationControllers(response)).catchError((e) {
      Logger.root.severe('There was a ${e.runtimeType} error');
      Logger.root.severe('Error Details ${e.toString()}');

    });
  }

  void _setPods(HttpResponse iResponse) {
    Logger.root.info("setPods update");

    if ((iResponse.data.containsKey("kind")) && (iResponse.data["kind"] == "PodList") && iResponse.data.containsKey("items")) {
      Set<Pod> newPods = new Set<Pod>();
      for (Map iPod in iResponse.data["items"]) {
        if (iPod.containsKey("id")) {
          Logger.root.info("pod id:" + iPod["id"]);

          Pod newPod = new Pod(iPod["id"]);

          if (pods.contains(newPod)) {
            newPod = pods.lookup(newPod);
          }

          newPod.labelName = iPod["labels"]["name"];
          newPod.labelReplicationController = iPod["labels"]["replicationController"];

          if (iPod.containsKey("currentState")) {

            if (iPod["currentState"].containsKey("info")) {

              if (iPod["currentState"]["info"].containsKey("net")) {

                if (iPod["currentState"]["info"]["net"].containsKey("State")) {

                  bool status = iPod["currentState"]["info"]["net"]["State"]["Running"];
                  if (status) {
                    newPod.status = "up";
                  } else {
                    newPod.status = "down";
                  }
                }
              }
            }
          }

          newPods.add(newPod);
        }
      }

      pods = newPods;
    } else {
      Logger.root.severe("Error during get REST Pods parsing");
    }
  }

  void _setServices(HttpResponse iResponse) {
    Logger.root.info("setService update");

    if ((iResponse.data.containsKey("kind")) && (iResponse.data["kind"] == "ServiceList") && iResponse.data.containsKey("items")) {
      Set<Service> newServices = new Set<Service>();
      for (Map iService in iResponse.data["items"]) {
        if (iService.containsKey("id")) {
          Logger.root.info("service id:" + iService["id"]);

          Service newService = new Service(iService["id"]);

          if (services.contains(newService)) {
            newService = services.lookup(newService);
          }

          newService.selectorName = iService["selector"]["name"];
          newService.port = iService["port"];
          newServices.add(newService);
        }
      }

      services = newServices;
    } else {
      Logger.root.severe("Error during get REST Services parsing");
    }
  }

  void _setReplicationControllers(HttpResponse iResponse) {
    Logger.root.info("setReplicationControllers update");

    if ((iResponse.data.containsKey("kind")) && (iResponse.data["kind"] == "ReplicationControllerList")) {
      Set<ReplicationController> newReplicationControllers = new Set<ReplicationController>();
      if (iResponse.data.containsKey("items")) {
        for (Map iReplicationController in iResponse.data["items"]) {
          if (iReplicationController.containsKey("id")) {
            Logger.root.info("Replicate id:" + iReplicationController["id"]);

            ReplicationController newReplicationController = new ReplicationController(iReplicationController["id"]);

            if (replicationcontrollers.contains(newReplicationController)) {
              newReplicationController = replicationcontrollers.lookup(newReplicationController);
            }

            newReplicationController.replicas = iReplicationController["desiredState"]["replicas"];
            newReplicationController.replicaSelectorName = iReplicationController["desiredState"]["replicaSelector"]["name"];

            newReplicationControllers.add(newReplicationController);
          }
        }
      }
      replicationcontrollers = newReplicationControllers;
    } else {
      Logger.root.severe("Error during get REST replicationControllers parsing");
    }
  }


  void _watchMinions() {
    for (Minion item in minions) {
      getMinionCadvisorInfo(item);
    }

    if (_listenCluster) {
      sleep2().then((_) => _watchMinions());
    }
  }

  void _watchPods() {
    getPodList();

    for (Pod item in pods) {
      // TODO call api for Pod info
    }

    if (_listenCluster) {
      sleep2().then((_) => _watchPods());
    }
  }

  void _watchServices() {
    getServiceList();

    for (Service item in services) {
      // TODO call api for Service info
    }

    if (_listenCluster) {
      sleep2().then((_) => _watchServices());
    }
  }

  void _watchReplicationControllers() {
    getReplicationControllersList();

    for (Service item in services) {
      // TODO call api for Service info
    }

    if (_listenCluster) {
      sleep2().then((_) => _watchReplicationControllers());
    }
  }

  Future sleep2() {
    return new Future.delayed(const Duration(seconds: 2), () => "2");
  }

  void getMinionCadvisorInfo(Minion iMinion) {
    String urlMachine = "http://" + iMinion.ip + ":4194/api/v1.0/machine";


    _http.get(urlMachine).then((HttpResponse response) => iMinion.setMachineInfo(response)).catchError((e) {
      Logger.root.severe('There was a ${e.runtimeType} error');
      Logger.root.severe('Error Details ${e.toString()}');
    });


    String urlContainers = "http://" + iMinion.ip + ":4194/api/v1.0/containers/";
    _http.get(urlContainers).then((HttpResponse response) => iMinion.setContainersInfo(response)).catchError((e) {
      Logger.root.severe('There was a ${e.runtimeType} error');
      Logger.root.severe('Error Details ${e.toString()}');
    });


  }

}
