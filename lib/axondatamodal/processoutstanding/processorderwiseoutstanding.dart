class ProcessorderWiseOutstandingModal {
  String? process;
  String? processorder;
  int? supplierid;
  String? supplier;
  double? issueqty;
  double? receivedqty;
  double? cancelqty;
  double? balanceqty;
  String? outuom;
  String? inpuom;

  ProcessorderWiseOutstandingModal(
      this.process,
      this.processorder,
      this.supplierid,
      this.supplier,
      this.issueqty,
      this.receivedqty,
      this.cancelqty,
      this.balanceqty,
      this.outuom,
      this.inpuom);

  ProcessorderWiseOutstandingModal.fromJson(Map<dynamic, dynamic> json) {
    process = json['Process'];
    processorder = json['processorder'];
    supplierid = json['supplierid'];
    supplier = json['supplier'];
    issueqty = json['issuedqty'];
    receivedqty = json['receivedqty'];
    cancelqty = json['cancelqty'];
    balanceqty = json['balanceqty'];
    outuom = json['outuom'];
    inpuom = json['inpuom'];
  }
}
