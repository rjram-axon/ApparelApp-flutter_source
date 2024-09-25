class PurchaseOrder {
  String? orderNo;
  int purOrdId;
  String poNumber;
  String item;
  String? style;
  String? colour;
  String reference;
  String orderDate;
  double quantity;
  double rate;
  double totalAmount;
  String supplier;

  PurchaseOrder({
    this.orderNo,
    required this.purOrdId,
    required this.poNumber,
    required this.item,
    this.style,
    this.colour,
    required this.reference,
    required this.orderDate,
    required this.quantity,
    required this.rate,
    required this.totalAmount,
    required this.supplier,
  });

  factory PurchaseOrder.fromJson(Map<String, dynamic> json) {
    return PurchaseOrder(
      orderNo: json['OrderNo'],
      // Check if purOrdId is null and provide a default value if needed
      purOrdId: json['PurOrdId'] != null
          ? json['PurOrdId'] as int
          : 0, // default to 0 or another value
      poNumber: json['PO_Number'] ?? '',
      item: json['Item'] ?? '',
      style: json['Style'],
      colour: json['Colour'],
      reference: json['Reference'] ?? '',
      orderDate: json['OrderDate'] ?? '',
      quantity: (json['Quantity'] ?? 0).toDouble(),
      rate: (json['Rate'] ?? 0).toDouble(),
      totalAmount: (json['TotalAmount'] ?? 0).toDouble(),
      supplier: json['Supplier'] ?? '',
    );
  }
}
