part of dashboard_app;

class Container {
  String _name;
  String _image;

  Container(this._name);

  String get name => _name;
  String get image => _image;

  set image(String value) => _image = value;

  operator ==(Container a) => _name == a._name;

}
