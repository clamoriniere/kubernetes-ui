part of dashboard_app;

@Controller(selector: '[indexctrl]', publishAs: 'mainCtrl')
class MainController {
  Http _http;
  Scope _scope;

  String name = "Caroline";
  
  String placeholder = "127.0.0.1";
  String ipmaster = "";
  
  List<Minion> minions = [];


  MainController(this._http, this._scope) {
   
  }
  
  void connectToMaster(){
    String url = "http://" + ipmaster + ":8080/api/v1beta1/minions";
     
    
     _http.get(url).then((HttpResponse response) => _setMinions(response)).catchError((e) {
      print('There was a ${e.runtimeType} error');
      print('Error Details ${e.toString()}');
    });
  }
  
  void _setMinions(HttpResponse iResponse) {
    Logger.root.info("setMinions update");
    
    if ((iResponse.data.containsKey("kind"))
        && (iResponse.data["kind"] == "MinionList")
        && iResponse.data.containsKey("minions"))
    {
      List<Minion> newMinions = [];
      for (Map iMinion in iResponse.data["minions"]) {
        print ("for start");
        if (iMinion.containsKey("id")){
          print(iMinion["id"]);
          newMinions.add(new Minion(iMinion["id"]));
        
        }
      }
      
      if (!(minions == newMinions)){
        minions = newMinions;
        
        _watchMinions();
      }
      
    }else {
      Logger.root.severe("Error during get REST Minion parsing");
    }
  }
  
  void _watchMinions(){
    for (Minion item in minions){
      getMinionCadvisorInfo(item);
    }
    
    sleep2().then((_) => _watchMinions());
  }
  
  Future sleep2() {
    return new Future.delayed(const Duration(seconds: 2), () => "2");
  }
  
  void getMinionCadvisorInfo(Minion iMinion){
    String urlMachine = "http://" + iMinion.ip + ":4194/api/v1.0/machine";
         
        
    _http.get(urlMachine).then((HttpResponse response) => iMinion.setMachineInfo(response)).catchError((e) {
          print('There was a ${e.runtimeType} error');
          print('Error Details ${e.toString()}');
        });
    
    
    String urlContainers = "http://" + iMinion.ip + ":4194/api/v1.0/containers/";
    _http.get(urlContainers).then((HttpResponse response) => iMinion.setContainersInfo(response)).catchError((e) {
              print('There was a ${e.runtimeType} error');
              print('Error Details ${e.toString()}');
    });
    
    
  }

}
