class ApiProcessPrgAppdetails {
  final int id;
  final String orderno;
  final String prodprgno;
  final String refno;
  final String style;
  final double quantity;
  final String approved;

  ApiProcessPrgAppdetails(
      {required this.id,
      required this.orderno,
      required this.prodprgno,
      required this.refno,
      required this.style,
      required this.quantity,
      required this.approved});

  factory ApiProcessPrgAppdetails.fromJson(Map<String, dynamic> json) {
    return ApiProcessPrgAppdetails(
      id: json['ID'] ?? 0, // Default to 0 if null
      orderno: json['Orderno'] ?? '', // Default to empty string if null
      prodprgno: json['ProdPrgNo'] ?? '', // Default to empty string if null
      refno: json['Refno'] ?? '', // Default to empty string if null
      style: json['Style'] ?? '', // Default to empty string if null
      quantity: (json['Quantity'] as num?)?.toDouble() ??
          0.0, // Convert to double or default to 0.0 if null
      approved: json['Approved'] ?? '', // Default to empty string if null
    );
  }
}

class ApiProcessPrgAppOverlaydetails {
  final String prodprgid;
  final String prodprgno;
  final String process;
  final DateTime programdate;
  final String approved;

  ApiProcessPrgAppOverlaydetails(
      {required this.prodprgid,
      required this.prodprgno,
      required this.process,
      required this.programdate,
      required this.approved});

  factory ApiProcessPrgAppOverlaydetails.fromJson(Map<String, dynamic> json) {
    return ApiProcessPrgAppOverlaydetails(
      prodprgid: json['ProdPrgid'],
      prodprgno: json['ProdPrgNo'],
      process: json['Process'],
      programdate: json['ProgramDate'],
      approved: json['Approved'],
    );
  }
}

class ProcessPrgApprovedetails {
  final String item;
  final String color;
  final String size;
  final String unit;
  final String inorout;
  final double programquantity;
  final String approved;

  ProcessPrgApprovedetails(
      {required this.item,
      required this.color,
      required this.size,
      required this.unit,
      required this.inorout,
      required this.programquantity,
      required this.approved});

  factory ProcessPrgApprovedetails.fromJson(Map<String, dynamic> json) {
    return ProcessPrgApprovedetails(
        item: json['Item'],
        color: json['Color'],
        size: json['Size'],
        unit: json['Unit'],
        inorout: json['InOrOut'],
        programquantity: json['ProgramQuantity'],
        approved: json['Approved']);
  }
}
