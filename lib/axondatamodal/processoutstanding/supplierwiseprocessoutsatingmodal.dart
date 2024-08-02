class SupplierWiseProcessOutstandingModal {
  int? supplierid;
  int? processid;
  String? process;
  String? supplier;
  double? issueqty;
  double? receivedqty;
  double? cancelqty;
  double? balanceqty;
  String? outuom;
  String? inpuom;

  SupplierWiseProcessOutstandingModal(
      this.supplierid,
      this.processid,
      this.process,
      this.supplier,
      this.issueqty,
      this.receivedqty,
      this.cancelqty,
      this.balanceqty,
      this.outuom,
      this.inpuom);

  SupplierWiseProcessOutstandingModal.fromJson(Map<dynamic, dynamic> json) {
    supplierid = json['supplierid'];
    processid = json['processid'];
    process = json['Process'];
    supplier = json['supplier'];
    issueqty = json['issuedqty'];
    receivedqty = json['receivedqty'];
    cancelqty = json['cancelqty'];
    balanceqty = json['balanceqty'];
    outuom = json['outuom'];
    inpuom = json['inpuom'];
  }
}
