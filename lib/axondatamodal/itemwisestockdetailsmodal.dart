class ItemWiseStockdetails {
  String? item;
  String? abbreviation;
  double? qty;

  ItemWiseStockdetails(this.item, this.abbreviation, this.qty);

  ItemWiseStockdetails.fromJson(Map<dynamic, dynamic> json) {
    item = json["item"];
    abbreviation = json["Abbreviation"];
    qty = json["qty"];
  }
}
