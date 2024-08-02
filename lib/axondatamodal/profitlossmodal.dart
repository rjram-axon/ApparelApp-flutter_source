class ProfitLossModal {
  String? accesstype;
  String? itemgroup;
  double? estamount;
  double? appamount;
  double? actualamount;
  double? invoiceamount;
  double? diff;

  ProfitLossModal(this.accesstype, this.itemgroup, this.estamount,
      this.appamount, this.actualamount, this.invoiceamount, this.diff);

  ProfitLossModal.fromJson(Map<String, dynamic> json) {
    accesstype = json['Access_type'];
    itemgroup = json['itemgroup'];
    estamount = json['EstAmount'];
    appamount = json['AppAmount'];
    actualamount = json['Actualamount'];
    invoiceamount = json['InvoiceAmount'];
    diff = json['Diff'];
  }
}
