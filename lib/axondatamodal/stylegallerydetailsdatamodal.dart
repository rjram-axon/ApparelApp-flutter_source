class StyleGalleryDetailDataModal {
  String? buyer;
  String? orderno;
  String? refno;
  String? style;
  int? quantity;
  String? description;
  String? color;
  String? size;
  double? orderqty;
  double? productionqty;
  double? despqty;
  String? imgpath;

  StyleGalleryDetailDataModal(
      this.buyer,
      this.orderno,
      this.refno,
      this.style,
      this.quantity,
      this.description,
      this.color,
      this.size,
      this.despqty,
      this.orderqty,
      this.productionqty,
      this.imgpath);

  StyleGalleryDetailDataModal.fromJson(Map<String, dynamic> json) {
    orderno = json['order_no'];
    refno = json['Ref_No'];
    style = json['style'];
    quantity = json['Quantity'];
    description = json['Description'];
    color = json['color'];
    size = json['size'];
    despqty = json['DespQty'];
    orderqty = json['OrderQty'];
    productionqty = json['Productionqty'];
    imgpath = json['Imgpath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['buyer'] = buyer;
    data['order_no'] = orderno;
    data['Ref_No'] = refno;
    data['style'] = style;
    data['Quantity'] = quantity;
    data['Description'] = description;
    data['color'] = color;
    data['size'] = size;
    data['DespQty'] = despqty;
    data['OrderQty'] = orderqty;
    data['Productionqty'] = productionqty;
    data['Imgpath'] = imgpath;
    return data;
  }
}
