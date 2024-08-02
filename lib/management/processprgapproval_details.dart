import 'dart:ffi';

class ApiProcessPrgAppdetails {
  final int id;
  final String orderno;
  final String refno;
  final String style;
  final double quantity;
  final String approved;

  ApiProcessPrgAppdetails(
      {required this.id,
      required this.orderno,
      required this.refno,
      required this.style,
      required this.quantity,
      required this.approved});

  factory ApiProcessPrgAppdetails.fromJson(Map<String, dynamic> json) {
    return ApiProcessPrgAppdetails(
      id: json['ID'],
      orderno: json['Orderno'],
      refno: json['Refno'],
      style: json['Style'],
      quantity: json['Quantity'],
      approved: json['Approved'],
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
  final Double programquantity;
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
