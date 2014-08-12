part of dashboard_app;

class Pod {
  String _id = "";
  String _labelName = "";
  String _labelReplicationController = "";

  String _status = "down";

  Pod(this._id);

  String get id => _id;
  String get labelName => _labelName;
  String get labelReplicationController => _labelReplicationController;
  String get status => _status;
  

  set id(String value) => _id = value;
  set labelName(String value) => _labelName = value;
  set labelReplicationController(String value) => _labelReplicationController = value;
  set status(String value) => _status = value;

  String getStatusCssClass() {
    if (_status == "up") {
      return "badge-success";
    } else {
      return "";
    }
  }
  
  operator ==(Pod a) => _id == a._id;
}
