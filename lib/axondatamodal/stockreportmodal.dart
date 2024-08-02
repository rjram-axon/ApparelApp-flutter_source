class StockMainListDataModal {
  String? item;
  String? color;
  String? size;
  double? balqty;
  String? uom;
  String? storename;
  int? companyid;
  int? itemid;
  int? colorid;
  int? sizeid;
  int? storeunitid;
  String? orderno;
  String? refno;
  String? style;
  String? transno;

  StockMainListDataModal(
      this.item,
      this.color,
      this.size,
      this.balqty,
      this.uom,
      this.storename,
      this.companyid,
      this.itemid,
      this.colorid,
      this.sizeid,
      this.storeunitid,
      this.orderno,
      this.refno,
      this.style,
      this.transno);

  StockMainListDataModal.fromJson(Map<String, dynamic> json) {
    item = json['item'];
    color = json['color'];
    size = json['size'];
    balqty = json['Balqty'];
    uom = json['uom'];
    storename = json['StoreName'];
    companyid = json['companyid'];
    itemid = json['itemid'];
    colorid = json['colorid'];
    sizeid = json['sizeid'];
    storeunitid = json['storeunitid'];
    orderno = json['Order_no'];
    refno = json['Ref_no'];
    style = json['style'];
    transno = json['transno'];
  }
}
