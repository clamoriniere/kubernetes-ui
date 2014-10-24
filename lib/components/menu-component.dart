part of dashboard_app;

@Component(
    selector: 'menu',
    templateUrl: 'packages/dashboard/components/menu.html',
    useShadowDom: false
)
class MenuComponent {
  KubernetesService kubernetesservice;
  
  MenuComponent(this.kubernetesservice){
    
  }
  
  @NgTwoWay("isStarted")
  bool listenCluster;
  
  @NgTwoWay("ipmaster")
  String ipmaster;
  
  @NgTwoWay("placeholder")
  String placeholder;
  
  void connectToMaster(){
    print("connectToMaster");
    kubernetesservice.getMinionList(ipmaster);
  }
  
  void stopListen() {
    print("stopListen");
  }
  
  

}