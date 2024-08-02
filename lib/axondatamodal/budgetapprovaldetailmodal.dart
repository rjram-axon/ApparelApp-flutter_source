class BudgetApprovalDetailModal {
  int? costdefnid;
  int? costdefnbomid;
  int? processid;
  int? itemid;
  int? colorid;
  int? sizeid;
  int? uomid;
  int? secuomid;
  String? itemtype;
  String? process;
  String? item;
  String? color;
  String? size;
  //String? uom;
  //String? secuom;
  String? issecqty;
  double? qty;
  double? rate;
  double? amount;
  double? secqty;
  double? appqty;
  double? apprate;
  double? appamount;
  double? appsecqty;
  double? porate;

  BudgetApprovalDetailModal(
      this.costdefnid,
      this.costdefnbomid,
      this.processid,
      this.itemid,
      this.colorid,
      this.sizeid,
      this.uomid,
      this.secuomid,
      this.itemtype,
      this.process,
      this.item,
      this.color,
      this.size,
      //this.uom,
      //this.secuom,
      this.issecqty,
      this.qty,
      this.rate,
      this.amount,
      this.apprate,
      this.appqty,
      this.appamount,
      this.appsecqty,
      this.porate);

  BudgetApprovalDetailModal.fromJson(Map<String, dynamic> json) {
    costdefnid = json['Cost_Defn_id'];
    costdefnbomid = json['Cost_Defn_BOMid'];
    processid = json['Processid'];
    itemid = json['Itemid'];
    colorid = json['Colorid'];
    sizeid = json['Sizeid'];
    uomid = json['UOMid'];
    secuomid = json['UOMid'];
    itemtype = json['Itmtype'];
    process = json['process'];
    item = json['Item'];
    color = json['color'];
    size = json['size'];
    //uom = json['Cost_Defn_id'];
    //secuom = json['Cost_Defn_id'];
    issecqty = json['IsSecQty'];
    qty = json['Quantity'];
    rate = json['Rate'];
    amount = qty! * rate!;
    apprate = json['AppRate'];
    appqty = json['AppQty'];
    appamount = appqty! * apprate!;
    appsecqty = json['AppSecQty'];
    porate = json['PoRate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Cost_Defn_id'] = costdefnid;
    data['Cost_Defn_BOMid'] = costdefnbomid;
    data['Processid'] = processid;
    data['Itemid'] = itemid;
    data['Colorid'] = colorid;
    data['Sizeid'] = sizeid;
    data['UOMid'] = uomid;
    data['UOMid'] = secuomid;
    data['Itmtype'] = itemtype;
    data['process'] = process;
    data['Item'] = item;
    data['color'] = color;
    data['size'] = size;
    data['IsSecQty'] = issecqty;
    data['Quantity'] = qty;
    data['Rate'] = rate;
    data['amount'] = qty! * rate!;
    data['AppRate'] = apprate;
    data['AppQty'] = appqty;
    data['appamount'] = appqty! * apprate!;
    data['AppSecQty'] = appsecqty;
    data['PoRate'] = porate;
    return data;
  }
}

class Budgetpostdata {
  String? orderno;
  int? styleid;
  int? costdefnid;
  double? profitper;
  String? approved;
  double? salesprice;
  double? drowbackper;
  double? salesprofit;
  int? approvredby;
  List<Budgetdetmodal>? budgetdet;
  List<Budgetdetmodal>? commdet;

  Budgetpostdata(
      this.orderno,
      this.styleid,
      this.costdefnid,
      this.profitper,
      this.approved,
      this.salesprice,
      this.drowbackper,
      this.salesprofit,
      this.approvredby,
      this.budgetdet,
      this.commdet);
}

class Budgetdetmodal {
// ignore: non_constant_identifier_names
  int? cost_defn_bomid;
  double? apprate;
  double? appqty;

  Budgetdetmodal(this.cost_defn_bomid, this.apprate, this.appqty);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cost_defn_bomid'] = cost_defn_bomid;
    data['apprate'] = apprate;
    data['appqty'] = appqty;
    return data;
  }
}
