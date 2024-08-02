class ProfitLossOrdermodal {
  String? orderno;
  String? refno;
  String? style;
  double? quantity;
  String? guom;
  String? description;
  String? imagepath;
  double? despatchqty;
  double? productionqty;
  int? allowancePer;
  String? currency;
  double? price;
  double? exchange;
  double? orderPrice;
  double? orderValue;
  double? salesprice;
  double? salesrate;
  double? despamount;
  double? salesvalue;

  ProfitLossOrdermodal(
      this.allowancePer,
      this.currency,
      this.description,
      this.despamount,
      this.despatchqty,
      this.exchange,
      this.guom,
      this.imagepath,
      this.orderPrice,
      this.orderValue,
      this.orderno,
      this.price,
      this.productionqty,
      this.quantity,
      this.refno,
      this.salesprice,
      this.salesrate,
      this.style,
      this.salesvalue);

  ProfitLossOrdermodal.fromJson(Map<String, dynamic> json) {
    allowancePer = json['AllowancePer'];
    currency = json['Currency'];
    description = json['Description'];
    despamount = json['despamount'];
    despatchqty = json['Despatchqty'];
    exchange = json['Exchange'];
    guom = json['Guom'];
    imagepath = json['Imagepath'];
    orderPrice = json['OrderPrice'];
    orderValue = json['OrderValue'];
    orderno = json['order_no'];
    price = json['Price'];
    productionqty = json['Productionqty'];
    quantity = json['Quantity'];
    refno = json['Ref_no'];
    salesprice = json['Salesprice'];
    salesrate = json['Salesrate'];
    style = json['style'];
    salesvalue = json['salesvalue'];
  }
}
