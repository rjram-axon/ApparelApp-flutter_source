class PurchaseOrder {
  final String orderNo;
  final int purOrdId;
  final String purOrdNo;
  final String item;
  final String style;
  final String color;
  final String reference;
  final DateTime orderDate;
  final double quantity;
  final double rate;
  final double totalAmount;
  final String supplier;
  String approved;

  PurchaseOrder({
    required this.orderNo,
    required this.purOrdId,
    required this.purOrdNo,
    required this.item,
    required this.style,
    required this.orderDate,
    required this.quantity,
    required this.rate,
    required this.totalAmount,
    required this.supplier,
    required this.approved,
    required this.color,
    required this.reference,
  });

  factory PurchaseOrder.fromJson(Map<String, dynamic> json) {
    return PurchaseOrder(
      orderNo: json['orderNo'],
      purOrdId: json['purOrdId'],
      purOrdNo: json['purOrdNo'],
      item: json['item'],
      style: json['style'],
      color: json['color'],
      reference: json['reference'],
      orderDate: DateTime.parse(json['orderDate']),
      quantity: json['quantity'].toDouble(),
      rate: json['rate'].toDouble(),
      totalAmount: json['totalAmount'].toDouble(),
      supplier: json['supplier'],
      approved: json['approved'],
    );
  }

  static Map<String, double> calculateTotal(List<PurchaseOrder> orders) {
    double totalQuantity = 0;
    double totalRate = 0;
    double totalAmount = 0;

    for (var order in orders) {
      totalQuantity += order.quantity;
      totalRate += order.rate;
      totalAmount += order.totalAmount;
    }

    return {
      'totalQuantity': double.parse(totalQuantity.toStringAsFixed(3)),
      'totalRate': double.parse(totalRate.toStringAsFixed(3)),
      'totalAmount': double.parse(totalAmount.toStringAsFixed(3)),
    };
  }
}

class User {
  final int menuId;
  final int allFlag;
  final int addFlag;
  final int editFlag;
  final int deleteFlag;
  final int printFlag;

  User({
    required this.menuId,
    required this.allFlag,
    required this.addFlag,
    required this.editFlag,
    required this.deleteFlag,
    required this.printFlag,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      menuId: json['MenuId'],
      allFlag: json['AllFlg'],
      addFlag: json['AddFlg'],
      editFlag: json['EditFlg'],
      deleteFlag: json['DeleteFlg'],
      printFlag: json['PrintFlg'],
    );
  }
}
