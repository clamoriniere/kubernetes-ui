part of dashboard_app;

class Minion {
  String _ip = "";
  int _cpu = 0;
  int _cpuPercent = 0;
  int _memory = 0;

  int _cpuUsage = 0;
  int _memoryUsage = 0;
  int _maxMemoryUsage = 0;

  List<Container> _containers = [];

  Minion(this._ip);

  String get ip => _ip;
  int get cpu => _cpu;
  int get cpuPercent => _cpuPercent;
  int get memory => _memory;
  int get cpuUsage => _cpuUsage;
  int get memoryUsage => _memoryUsage;
  int get maxMemoryUsage => _maxMemoryUsage;
  List<Container> get containers => _containers;

  set memory(int value) => _memory = value;
  set cpu(int value) => _cpu = value;
  set cpuPercent(int value) => _cpuPercent = value;

  set cpuUsage(int value) => _cpuUsage = value;
  set memoryUsage(int value) => _memoryUsage = value;
  set maxMemoryUsage(int value) => _maxMemoryUsage = value;


  void setMachineInfo(HttpResponse iResponse) {
    if (iResponse.data.containsKey("num_cores")) {
      _cpu = iResponse.data["num_cores"];
    }

    if (iResponse.data.containsKey("memory_capacity")) {
      _memory = iResponse.data["memory_capacity"];
    }
  }

  void setContainersInfo(HttpResponse iResponse) {
    if (iResponse.data.containsKey("stats_summary")) {
      if (iResponse.data["stats_summary"].containsKey("max_memory_usage")) {
        _maxMemoryUsage = iResponse.data["stats_summary"]["max_memory_usage"];
      }
    }

    if (iResponse.data.containsKey("stats")) {
      List stats = iResponse.data["stats"];
      int nbStat = stats.length;

      Map prevStat = stats[nbStat - 2];
      Map lastStat = stats[nbStat - 1];

      int rawUsage = lastStat["cpu"]["usage"]["total"] - prevStat["cpu"]["usage"]["total"];

      // Convert to millicores and take the percentage
      double tmpPercent = (((rawUsage / 1000000) / (_cpu * 1000)) * 100).roundToDouble();
      if (tmpPercent == null) {
        tmpPercent = 0.0;
      }
      _cpuPercent = tmpPercent.round();
      if (_cpuPercent > 100) {
        _cpuPercent = 100;
      }

      _cpuUsage = lastStat["cpu"]["usage"]["total"];
      _cpuPercent;
      _memoryUsage = lastStat["memory"]["usage"];

    }

    if (iResponse.data.containsKey("stats")) {
      List stats = iResponse.data["stats"];
    }

  }

  double getMemoryPercent() {
    if (memory <= 0) {
      return 0.0;
    } else {
      return ((_memoryUsage * 100) / memory).roundToDouble();
    }
  }

  operator ==(Minion a) => _ip == a._ip;
}
