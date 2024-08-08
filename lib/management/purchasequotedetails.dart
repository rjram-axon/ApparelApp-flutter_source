class PurchaseQuotation {
  final int quoteid;
  final String quoteNo;
  final String entryNo;
  final String entryDate;
  final String quoteDate;
  final String supplier;
  final String buyOrdGeneral;
  final String approvedStatus;

  PurchaseQuotation({
    required this.quoteid,
    required this.quoteNo,
    required this.entryNo,
    required this.entryDate,
    required this.quoteDate,
    required this.supplier,
    required this.buyOrdGeneral,
    required this.approvedStatus,
  });

  factory PurchaseQuotation.fromJson(Map<String, dynamic> json) {
    return PurchaseQuotation(
      quoteid: json['Quoteid'],
      quoteNo: json['QuoteNo'] ?? '',
      entryNo: json['EntryNo'] ?? '',
      entryDate: json['EntryDate'] ?? '',
      quoteDate: json['Quotedate'] ?? '',
      supplier: json['Supplier'] ?? '',
      buyOrdGeneral: json['BuyOrdgeneral'] ?? '',
      approvedStatus: json['ApprovedStatus'] ?? '',
    );
  }
}

// lib/models/purchase_quotation_edit.dart

class PurchaseQuotationEdit {
  final int quoteid;
  final int quoteDetid;
  final String? buyordNo;
  final String item;
  final String color;
  final String size;
  final String uom;
  final double rate;
  double apprate;
  final double minQty;
  final double maxQty;
  final String approvedStatus;
  final String imgpath;

  PurchaseQuotationEdit(
      {required this.quoteid,
      required this.quoteDetid,
      this.buyordNo,
      required this.item,
      required this.color,
      required this.size,
      required this.uom,
      required this.rate,
      required this.apprate,
      required this.minQty,
      required this.maxQty,
      required this.approvedStatus,
      required this.imgpath});

  factory PurchaseQuotationEdit.fromJson(Map<String, dynamic> json) {
    return PurchaseQuotationEdit(
      quoteid: json['Quoteid'],
      quoteDetid: json['Process_Quote_detid'],
      buyordNo: json['BuyordNo'],
      item: json['Item'],
      color: json['Color'],
      size: json['Size'],
      uom: json['UOM'],
      rate: json['Rate'].toDouble(),
      apprate: json['Apprate'].toDouble(),
      minQty: json['MinQty'].toDouble(),
      maxQty: json['MaxQty'].toDouble(),
      approvedStatus: json['ApprovedStatus'] ?? '',
      imgpath: json['Image'] ?? '',
    );
  }
}
