part of dashboard_app;

class ReplicationController {
  String _id = "";
  String _replicatSelectorName = "";
  int _replicas = 0;

  ReplicationController(this._id);

  String get id => _id;
  String get replicaSelectorName => _replicatSelectorName;
  int get replicas => _replicas;

  set replicaSelectorName(String value) => _replicatSelectorName = value;
  set replicas(int value) => _replicas = value;

  operator ==(ReplicationController a) => _id == a._id;
}
