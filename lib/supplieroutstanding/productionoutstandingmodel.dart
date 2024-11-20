class ProductionOutstandingModal {
  final String? cuttingOrderNo;
  final int? styleid;
  final String? process;
  final String? orderNo;
  final String? style;
  final String? supplier;
  final String? colorname;
  final String? deliveryDate;
  double issuedqty;
  double orderQty;
  final String? size;
  final String? recptitem;
  final String? recptcolor;
  final String? recptsize;
  final String? cuttingRecptNo;
  final String dcNo;
  final String recptUom;
  final String issueUom;
  final double recptQty;
  final double recptwgt;
  final double grammage;
  final double orderIssueqty;
  final double orderReturnqty;
  final double orderRecptqty;
  final double ordrecptwgt;
  final double orderwiseOrdQty;

  ProductionOutstandingModal({
    required this.cuttingOrderNo,
    required this.styleid,
    required this.process,
    required this.orderNo,
    required this.style,
    required this.supplier,
    required this.colorname,
    required this.deliveryDate,
    required this.issuedqty,
    required this.orderQty,
    required this.size,
    required this.recptitem,
    required this.recptcolor,
    required this.recptsize,
    required this.cuttingRecptNo,
    required this.dcNo,
    required this.recptUom,
    required this.issueUom,
    required this.recptQty,
    required this.recptwgt,
    required this.grammage,
    required this.orderIssueqty,
    required this.orderReturnqty,
    required this.orderRecptqty,
    required this.ordrecptwgt,
    required this.orderwiseOrdQty,
  });

  factory ProductionOutstandingModal.fromJson(Map<String, dynamic> json) {
    return ProductionOutstandingModal(
      cuttingOrderNo: json['CuttingOrderNo'],
      styleid: json['Styleid'],
      process: json['Process'],
      orderNo: json['Order_No'],
      style: json['Style'],
      supplier: json['Supplier'],
      colorname: json['Colorname'],
      deliveryDate: json['DeliveryDate'],
      issuedqty: json['Issuedqty'],
      orderQty: json['OrderQty'],
      size: json['size'],
      recptitem: json['Recptitem'],
      recptcolor: json['Recptcolor'],
      recptsize: json['Recptsize'],
      cuttingRecptNo: json['CuttingRecptNo'],
      dcNo: json['DCNo'],
      recptUom: json['RecptUom'],
      issueUom: json['IssueUom'],
      recptQty: json['RecptQty'],
      recptwgt: json['Recptwgt'],
      grammage: json['Grammage'],
      orderIssueqty: json['OrderIssueqty'],
      orderReturnqty: json['orderReturnqty'],
      orderRecptqty: json['orderRecptqty'],
      ordrecptwgt: json['ordrecptwgt'],
      orderwiseOrdQty: json['OrderwiseOrdQty'],
    );
  }
}
