class BudgetApprovalMainListModal {
  int? cmpid;
  int? styleid;
  String? cmp;
  String? orderno;
  String? refno;
  String? style;
  String? orderdate;
  double? quantity;
  double? styleamount;
  // ignore: non_constant_identifier_names
  String? GUOM;

  BudgetApprovalMainListModal(
      this.cmp,
      this.cmpid,
      this.GUOM,
      this.orderdate,
      this.orderno,
      this.quantity,
      this.refno,
      this.style,
      this.styleamount,
      this.styleid);

  BudgetApprovalMainListModal.fromJson(Map<String, dynamic> json) {
    cmp = json['cmp'];
    cmpid = json['cmpid'];
    GUOM = json['GUOM'];
    orderdate = json['date'];
    orderno = json['orderno'];
    quantity = json['qty'];
    refno = json['refno'];
    style = json['style'];
    styleamount = json['StyleAmnt'];
    styleid = json['styleid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cmp'] = cmp;
    data['cmpid'] = cmpid;
    data['GUOM'] = GUOM;
    data['date'] = orderdate;
    data['orderno'] = orderno;
    data['qty'] = quantity;
    data['refno'] = refno;
    data['style'] = style;
    data['StyleAmnt'] = styleamount;
    data['styleid'] = styleid;
    return data;
  }
}

class BudgetMainItem {
  int? seqno;
  String? item;
  double? porate;
  double? apprate;
  int? status;
  String? process;

  BudgetMainItem(this.seqno, this.item);
}
