part of dashboard_app;

@Component(
    selector: 'minion',
    templateUrl: 'packages/dashboard/components/minion.html',
    publishAs: 'ctrl',
    useShadowDom: false
)
class MinionComponent {
  @NgOneWay("item")
  Minion minion;


  MinionComponent() {    
  }
  
  
}