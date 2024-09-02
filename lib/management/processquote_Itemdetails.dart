class ProcessQuotation {
  final int quoteid;
  final String quoteNo;
  final String quoteDate;
  final String supplier;
  final String buyOrdGeneral;
  final String approvedStatus;

  ProcessQuotation({
    required this.quoteid,
    required this.quoteNo,
    required this.quoteDate,
    required this.supplier,
    required this.buyOrdGeneral,
    required this.approvedStatus,
  });

  factory ProcessQuotation.fromJson(Map<String, dynamic> json) {
    return ProcessQuotation(
      quoteid: json['Quoteid'] ?? '',
      quoteNo: json['QuoteNo'] ?? '',
      quoteDate: json['Quotedate'] ?? '',
      supplier: json['Supplier'] ?? '',
      buyOrdGeneral: json['BuyOrdgeneral'] ?? '',
      approvedStatus: json['ApprovedStatus'] ?? '',
    );
  }
}

class ProcessQuotationEdit {
  final int quoteid;
  final int quoteDetid;
  //final String? buyordNo;
  final String item;
  final String color;
  final String size;
  final String uom;
  final double rate;
  double apprate;
  final double minQty;
  final String approvedStatus;

  final String imgpath;

  ProcessQuotationEdit(
      {required this.quoteid,
      required this.quoteDetid,
      //this.buyordNo,
      required this.item,
      required this.color,
      required this.size,
      required this.uom,
      required this.rate,
      required this.apprate,
      required this.minQty,
      required this.approvedStatus,
      required this.imgpath});

  factory ProcessQuotationEdit.fromJson(Map<String, dynamic> json) {
    return ProcessQuotationEdit(
      quoteid: json['Quoteid'],
      quoteDetid: json['Process_Quote_detid'],
      //buyordNo: json['BuyordNo'],
      item: json['Item'],
      color: json['Color'],
      size: json['size'],
      uom: json['Uom'],
      rate: json['rate'].toDouble(),
      apprate: json['AppRate'].toDouble(),
      minQty: json['MinQty'].toDouble(),
      approvedStatus: json['ApprovedStatus'] ?? '',
      imgpath: json['Image'] ?? '',
    );
  }
}
