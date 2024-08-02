class ProcessOutstandingModal {
  int? supplierid;
  String? supplier;
  double? issueqty;
  double? receivedqty;
  double? cancelqty;
  double? balanceqty;
  String? outuom;
  String? inpuom;

  ProcessOutstandingModal(
      this.supplierid,
      this.supplier,
      this.issueqty,
      this.receivedqty,
      this.cancelqty,
      this.balanceqty,
      this.outuom,
      this.inpuom);

  ProcessOutstandingModal.fromJson(Map<dynamic, dynamic> json) {
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
