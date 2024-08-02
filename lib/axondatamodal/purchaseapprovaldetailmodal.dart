class PurchaseApprovalMainListModal {
  final int purOrdId;
  final String purOrdNo;
  final DateTime orddate;
  final int supplierId;
  final String supplier;

  PurchaseApprovalMainListModal({
    required this.purOrdId,
    required this.purOrdNo,
    required this.orddate,
    required this.supplierId,
    required this.supplier,
  });

  factory PurchaseApprovalMainListModal.fromJson(Map<String, dynamic> json) {
    return PurchaseApprovalMainListModal(
      purOrdId: json['pur_ord_id'],
      purOrdNo: json['pur_ord_no'],
      orddate: DateTime.parse(json['orddate']),
      supplierId: json['supplierid'],
      supplier: json['Supplier'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pur_ord_id': purOrdId,
      'pur_ord_no': purOrdNo,
      'orddate': orddate.toIso8601String(),
      'supplierid': supplierId,
      'Supplier': supplier,
    };
  }
}
