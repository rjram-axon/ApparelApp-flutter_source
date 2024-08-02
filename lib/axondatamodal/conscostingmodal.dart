class ConsCostModal {
  String? orderno;
  String? refno;
  String? style;
  double? quantity;
  String? guom;
  String? description;
  String? imagepath;
  double? productionqty;
  int? allowenceper;
  String? currency;
  double? price;
  double? exchange;
  double? orderprice;
  double? ordersvalue;
  double? salesprice;
  double? salesrate;
  double? despamount;
  double? planamount;
  double? actualamount;
  double? actualvalue;
  double? costdiff;
  double? profitordqty;
  double? profitordper;
  double? profitdespqty;
  double? profitdespper;

  ConsCostModal(
      this.orderno,
      this.refno,
      this.style,
      this.quantity,
      this.guom,
      this.description,
      this.imagepath,
      this.productionqty,
      this.allowenceper,
      this.currency,
      this.price,
      this.exchange,
      this.orderprice,
      this.ordersvalue,
      this.salesprice,
      this.salesrate,
      this.despamount,
      this.planamount,
      this.actualamount,
      this.actualvalue,
      this.costdiff,
      this.profitordqty,
      this.profitordper,
      this.profitdespqty,
      this.profitdespper);

  ConsCostModal.fromJson(Map<String, dynamic> json) {
    orderno = json['Order_no'];
    refno = json['Ref_no'];
    style = json['Style'];
    quantity = json['Quantity'];
    guom = json['Guom'];
    description = json['Description'];
    imagepath = json['Imagepath'];
    productionqty = json['Productionqty'];
    allowenceper = json['Allowanceper'];
    currency = json['Currency'];
    price = json['Price'];
    exchange = json['Exchange'];
    orderprice = json['OrderPrice'];
    ordersvalue = json['Ordervalue'];
    salesprice = json['Salesprice'];
    salesrate = json['Salesrate'];
    despamount = json['Despamount'];
    planamount = json['Plan_amount'];
    actualamount = json['ActualAmount'];
    actualvalue = json['Actualvalue'];
    costdiff = json['costdiff'];
    profitordqty = json['profitordqty'];
    profitordper = json['profitordper'];
    profitdespqty = json['profitdespqty'];
    profitdespper = json['profitdespper'];
  }
}
