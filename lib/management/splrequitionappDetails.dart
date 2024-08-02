class ApiSplReqdetails {
  final int reqId;
  final String splReqNo;
  final String refNo;
  final String? orderNo;
  final String jobOrdNo;
  final String orderDate;

  ApiSplReqdetails({
    required this.reqId,
    required this.splReqNo,
    required this.refNo,
    this.orderNo,
    required this.jobOrdNo,
    required this.orderDate,
  });

  factory ApiSplReqdetails.fromJson(Map<String, dynamic> json) {
    return ApiSplReqdetails(
      reqId: json['Req_id'],
      splReqNo: json['Spl_Req_no'],
      refNo: json['Ref_No'],
      orderNo: json['OrderNo'],
      jobOrdNo: json['Job_ord_no'],
      orderDate: json['OrderDate'],
    );
  }
}

class ApiSplReqeditdetails {
  final int reqid;
  final int reqdetid;
  final String jobOrdNo;
  final String item;
  final String color;
  final String size;
  final String unit;
  final double quantity;
  final String mode;
  final String purUnit;
  double appQuantity;
  double appRate;
  String isapproved;

  ApiSplReqeditdetails({
    required this.reqid,
    required this.reqdetid,
    required this.jobOrdNo,
    required this.item,
    required this.color,
    required this.size,
    required this.unit,
    required this.quantity,
    required this.mode,
    required this.purUnit,
    required this.appQuantity,
    required this.appRate,
    required this.isapproved,
  });

  factory ApiSplReqeditdetails.fromJson(Map<String, dynamic> json) {
    return ApiSplReqeditdetails(
      reqid: json['Reqid'],
      reqdetid: json['Reqdetid'],
      jobOrdNo: json['Job_ord_no'],
      item: json['Item'],
      color: json['Color'],
      size: json['Size'],
      unit: json['Unit'],
      quantity: json['Quantity'],
      mode: json['Mode'],
      purUnit: json['PurUnit'],
      appQuantity: json['AppQuantity'],
      appRate: json['AppRate'],
      isapproved: json['IsApproved'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Item': item,
      'Color': color,
      'Size': size,
      'Unit': unit,
      'Quantity': quantity,
      'Mode': mode,
      'PurUnit': purUnit,
      'AppQuantity': appQuantity,
      'AppRate': appRate,
    };
  }
}
