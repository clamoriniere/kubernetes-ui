part of dashboard_app;

class Service {
  String _id = "";
  String _selectorName = "";
  int _port = 0;

  Service(this._id);

  String get id => _id;
  String get selectorName => _selectorName;
  int get port => _port;

  set selectorName(String value) => _selectorName = value;
  set port(int value) => _port = value;

  operator ==(Service a) => _id == a._id;
}
