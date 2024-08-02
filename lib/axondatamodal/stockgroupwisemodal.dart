class StockGroupWise {
  String? itemtype;
  int? count;

  StockGroupWise(this.itemtype, this.count);

  StockGroupWise.fromJson(Map<dynamic, dynamic> json) {
    itemtype = json["itemtype"];
    count = json["count"];
  }
}
