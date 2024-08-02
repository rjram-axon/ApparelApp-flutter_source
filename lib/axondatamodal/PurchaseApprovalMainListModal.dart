// ignore: file_names
class PurchaseOrder {
  final int purOrdId;
  final String purOrdNo;
  final DateTime orddate;
  final int supplierId;
  final String supplier;

  PurchaseOrder({
    required this.purOrdId,
    required this.purOrdNo,
    required this.orddate,
    required this.supplierId,
    required this.supplier,
  });

  factory PurchaseOrder.fromJson(Map<String, dynamic> json) {
    return PurchaseOrder(
      purOrdId: json['pur_ord_id'],
      purOrdNo: json['pur_ord_no'],
      orddate: DateTime.parse(json['orddate']),
      supplierId: json['supplierid'],
      supplier: json['Supplier'],
    );
  }
}
