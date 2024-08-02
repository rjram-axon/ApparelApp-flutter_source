List configdata = [];
var loginusername = "";
int loginuserid = 0;
var company = "";
var hostname = "";
var port = "";
var finyear = "";

class Apparelcolor {
  String? headingcolor = 'green';
  String? iconcolor = 'bluegrey';
}

class AxonConfiguration {
  List getconfiguration() {
    return configdata;
  }

  void setconfiguration(List data) {
    configdata = data;
  }
}

class FilterItems {
  int? id;
  String? value;
  FilterItems(this.id, this.value);
}

class CostingReportFilter {
  String? orderno;
  String? style;
  int? styleid;
  int? orderid;
  CostingReportFilter(this.orderno, this.style, this.styleid, this.orderid);
}
