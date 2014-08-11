part of dashboard_app;

class Container{
  String _name;
  
  Container(this._name);
  
  operator == (Container a) => _name == a._name;
  
}