class StockTransdetails {
  String? documentname;
  String? prefix;
  int? count;
  double? qty;
  double? amount;

  StockTransdetails(
      this.documentname, this.prefix, this.count, this.qty, this.amount);

  StockTransdetails.fromJson(Map<dynamic, dynamic> json) {
    documentname = json["Document_Name"];
    prefix = json["prefix"];
    count = json["count"];
    qty = json["qty"];
    amount = json["Amount"];
  }
}
