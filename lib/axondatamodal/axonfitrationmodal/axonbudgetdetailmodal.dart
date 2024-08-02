/* Order details fields declaration and initialization*/
class Budgetorderdetails {
  String? company;
  String? style;
  String? buyer;
  String? orderno;
  String? refno;
  String? style1;
  String? shipdate;
  double? quantity;
  double? price;
  double? value;
  String? abbreviation;
  double? exchangerate;
  int? decimalplace;
  String? guom;
  // ignore: non_constant_identifier_names
  int? cost_defn_id;
  int? styleid;
  // ignore: non_constant_identifier_names
  int? cost_defn_id1;
  double? salesprice;
  // ignore: non_constant_identifier_names
  double? draback_percent;
  // ignore: non_constant_identifier_names
  double? sale_profit;
  // ignore: non_constant_identifier_names
  double? sale_profit_percent;
  double? salesratemargin;
  int? status;

  Budgetorderdetails(
      this.company,
      this.style,
      this.buyer,
      this.orderno,
      this.refno,
      this.style1,
      this.shipdate,
      this.quantity,
      this.price,
      this.value,
      this.abbreviation,
      this.exchangerate,
      this.decimalplace,
      this.guom,
      this.cost_defn_id,
      this.styleid,
      this.cost_defn_id1,
      this.salesprice,
      this.draback_percent,
      this.sale_profit,
      this.sale_profit_percent,
      this.salesratemargin,
      this.status);

  Budgetorderdetails.fromJson(Map<String, dynamic> json) {
    company = json['company'];
    style = json['style'];
    buyer = json['buyer'];
    orderno = json['order_no'];
    refno = json['ref_no'];
    style1 = json['style1'];
    shipdate = json['shipdate'];
    quantity = json['quantity'];
    price = json['price'];
    value = json['value'];
    abbreviation = json['Abbreviation'];
    exchangerate = json['Exchangerate'];
    decimalplace = json['decimalplace'];
    guom = json['guom'];
    cost_defn_id = json['cost_defn_id'];
    salesprice = json['saleprice'];
    draback_percent = json['Drawback_Percent'];
    sale_profit = json['sale_profit'];
    sale_profit_percent = json['sale_Profit_percent'];
    salesratemargin = json['Salesratemargin'];
    status = json['status'];
  }
}

/* Budget details fields declaration and initialization*/
class BudgetDetailModal {
  int? seqno;
  String? accesstype;
  String? orderno;
  String? style;
  String? process;
  String? component;
  String? item;
  String? color;
  String? size;
  String? uom;
  double? apprate;
  double? actualrate;
  double? quantity;
  double? amount;
  int? itemid;
  int? colorid;
  int? sizeid;
  int? styleid;
  int? processid;
  int? uomid;
  int? currencyid;
  double? exrate;
  double? currencyrate;
  double? appcurrencyrate;
  String? issecqty;
  int? status;
  // ignore: non_constant_identifier_names
  int? cost_defn_bomid;
  String? itemtype;
  double? porate;

  BudgetDetailModal(
      this.accesstype,
      this.amount,
      this.appcurrencyrate,
      this.apprate,
      this.actualrate,
      this.color,
      this.colorid,
      this.component,
      this.cost_defn_bomid,
      this.currencyid,
      this.currencyrate,
      this.exrate,
      this.issecqty,
      this.item,
      this.itemid,
      this.itemtype,
      this.orderno,
      this.porate,
      this.process,
      this.processid,
      this.quantity,
      this.seqno,
      this.size,
      this.sizeid,
      this.status,
      this.style,
      this.styleid,
      this.uom,
      this.uomid);

  BudgetDetailModal.fromJson(Map<String, dynamic> json) {
    seqno = json['Seqno'];
    accesstype = json['Access_Type'];
    orderno = json['Order_no'];
    style = json['style'];
    process = json['Process'];
    component = json['Component'];
    item = json['item'];
    color = json['color'];
    size = json['size'];
    itemid = json['itemid'];
    colorid = json['colorid'];
    sizeid = json['sizeid'];
    apprate = json['AppRate'];
    actualrate = json['Actual_Rate'];
    quantity = json['Quantity'];
    amount = json['Amount'];
    styleid = json['styleid'];
    processid = json['Processid'];
    uomid = json['uomid'];
    uom = json['uom'];
    currencyid = json['Currencyid'];
    exrate = json['Exrate'];
    currencyrate = json['CurrencyRate'];
    appcurrencyrate = json['AppCurrencyRate'];
    issecqty = json['IsSecQty'];
    status = json['status'];
    cost_defn_bomid = json['cost_defn_bomid'];
    itemtype = json['ItemType'];
    porate = json['porate'];
  }
}

/* Commercial details fields declaration and initialization*/
class Commercialdetails {
  String? costdefnno;
  // ignore: non_constant_identifier_names
  int? cost_defn_id;
  int? commercialid;
  String? commercial;
  double? cost;
  String? costtype;
  // ignore: non_constant_identifier_names
  int? cost_defn_comid;
  double? amount;

  Commercialdetails(
      this.costdefnno,
      this.cost_defn_id,
      this.commercialid,
      this.commercial,
      this.cost,
      this.costtype,
      this.cost_defn_comid,
      this.amount);

  Commercialdetails.fromJson(Map<String, dynamic> json) {
    costdefnno = json['Cost_Defn_No'];
    cost_defn_id = json['Cost_Defn_id'];
    commercialid = json['CommercialID'];
    commercial = json['Commercial'];
    cost = json['Cost'];
    costtype = json['CostType'];
    cost_defn_comid = json['Cost_Defn_COMid'];
    amount = json['Amount'];
  }
}
