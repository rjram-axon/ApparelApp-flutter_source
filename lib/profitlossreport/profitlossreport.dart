import 'package:apparelapp/axonhelp/profitlosshelp.dart';
import 'package:apparelapp/axonlibrary/axonfunctions.dart';
import 'package:apparelapp/main/drawerpage.dart';
import 'package:flutter/material.dart';
import 'package:apparelapp/main.dart';
import 'package:apparelapp/orderstatus/orderstatus.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:apparelapp/axonlibrary/axongeneral.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:apparelapp/axondatamodal/filtrationmodal.dart';
import 'package:apparelapp/axondatamodal/profitlossmodal.dart';
import 'package:apparelapp/axondatamodal/profitlossordermodal.dart';
import 'package:apparelapp/axonlibrary/axonnorecordmessage.dart';

List<String> orderno = ["-- Select Orderno--"];
List<String> refno = ["-- Select Refno--"];
List<String> style = ["-- Select Style--"];

List<FilterationDataModal> ordermodal = [];
List<FilterationDataModal> refnomodal = [];
List<FilterationDataModal> stylemodal = [];

String ordernoValue = "";
String refnoValue = "";
String styleValue = "";

int? listlenth = 0;

class ProfitLossReport extends StatefulWidget {
  const ProfitLossReport({super.key});

  @override
  State<ProfitLossReport> createState() => _ProfitLossReportState();
}

class _ProfitLossReportState extends State<ProfitLossReport> {
  List<ProfitLossOrdermodal> plorder = [];
  List<ProfitLossModal> plcost = [];
  late double plantotalamount = 0;
  late double apptotalamount = 0;
  late double acttotalamount = 0;
  late double invtotalamount = 0;
  AxonFunction af = AxonFunction();

  Color colors = Colors.red;

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      elevation: 40.0,
      // backgroundColor: Colors.cyanAccent,
      builder: (context) {
        return const BottomSheetModal();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    loaddetails();
  }

  @override
  void dispose() {
    super.dispose();
    listlenth = 0;
    plcost.clear();
  }

  void resetdata() {
    listlenth = 0;
    plcost.clear();
  }

  Future<void> loaddetails() async {
    /* Local variable declaration for getting details & passing parameters*/
    dynamic responsedata;
    String? ordno = "";
    String? refno = "";
    String? sty = "";

    /* Checking with the filtration is empty or not & passing parameter values*/
    if (ordernoValue.toString() == "" ||
        ordernoValue.toString() == "-- Select Order no--") {
      ordno = null;
    } else {
      ordno = ordernoValue;
    }
    if (refnoValue.toString() == "" ||
        refnoValue.toString() == "-- Select Refno--") {
      refno = null;
    } else {
      refno = refnoValue;
    }
    if (styleValue.toString() == "" ||
        styleValue.toString() == "-- Select Style--") {
      sty = null;
    } else {
      sty = styleValue;
    }

    /* Getting the data from the concern project using API (Application programming Interface) */
    var url = '$hostname:$port/api/apiprofitloss'; // This is API Url

    /* This is body content to send the API */
    var body = json.encode({
      "Buy_ord_masid": ordno,
      "Styleid": sty,
      "Refno": refno,
      "Fromdate": null,
      "Todate": null
    });

    String length =
        body.length.toString(); // Getting body length from body variable
    var headers = {
      'Content-Type': 'application/json',
      'Content-Length': length,
      'Host': 'apparelmvc',
      //'User-Agent': 'PostmanRuntime/7.30.0'
    }; // This is header content to send the API Link

    if (ordno != null || sty != null) {
      try {
        final response = await http.post(Uri.parse(url),
            headers: headers,
            body:
                body); // Api (POST) method syntax for sending contents & getting concern details
        if (response.statusCode == 200) {
          plcost.clear();

          responsedata = jsonDecode(response.body);
          dynamic masdata = json.decode(responsedata[0]);
          dynamic detdata = json.decode(responsedata[1]);

          int rlength = detdata.length;

          for (int i = 0; i < rlength; i++) {
            var data = ProfitLossModal.fromJson(detdata[i]);
            plcost.add(ProfitLossModal(
                data.accesstype,
                data.itemgroup,
                data.estamount,
                data.appamount,
                data.actualamount,
                data.invoiceamount,
                data.diff));

            if (data.estamount != null) {
              plantotalamount = plantotalamount + data.estamount!.toDouble();
            }
            if (data.appamount != null) {
              apptotalamount = apptotalamount + data.appamount!.toDouble();
            }
            if (data.actualamount != null) {
              acttotalamount = acttotalamount + data.actualamount!.toDouble();
            }
            if (data.invoiceamount != null) {
              invtotalamount = invtotalamount + data.invoiceamount!.toDouble();
            }
          }

          for (int j = 0; j < masdata.length; j++) {
            var data = ProfitLossOrdermodal.fromJson(masdata[j]);
            plorder.add(ProfitLossOrdermodal(
                data.allowancePer,
                data.currency,
                data.description,
                data.despamount,
                data.despatchqty,
                data.exchange,
                data.guom,
                data.imagepath,
                data.orderPrice,
                data.orderValue,
                data.orderno,
                data.price,
                data.productionqty,
                data.quantity,
                data.refno,
                data.salesprice! * data.exchange!,
                data.salesrate,
                data.style,
                data.salesprice! * data.exchange! * data.despatchqty!));
          }
          setState(() {
            listlenth = masdata.length;
          });
        } else {}
      } catch (ex) {
        throw ex.toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profit & Loss report'),
        actions: [
          IconButton(
              tooltip: "Info",
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  elevation: 40.0,
                  // backgroundColor: Colors.cyanAccent,
                  builder: (context) {
                    return const ProfitLossHelp();
                  },
                );
              },
              icon: const Icon(Icons.info_outlined)),
          // IconButton(
          //     onPressed: () {
          //     //   Navigator.push(
          //     //       context,
          //     //       MaterialPageRoute(
          //     //           builder: (context) => const MyDrawerPage()));
          //     // },
          //     icon: const Icon(Icons.dashboard)),
          IconButton(
              onPressed: () {
                _showModalBottomSheet(context);
              },
              icon: const Icon(Icons.tune_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          if (plorder.isNotEmpty) ...[
            for (int x = 0; x < plorder.length; x++) ...[
              if (plorder[x].salesrate!.toString() != "") ...[
                Card(
                  margin: const EdgeInsets.all(10.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.white,
                  elevation: 20,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                SizedBox(height: 22, child: Text('Order No :')),
                                SizedBox(height: 22, child: Text('Ref No :')),
                                SizedBox(height: 22, child: Text('Style    :')),
                                SizedBox(height: 22, child: Text('Quantity :')),
                                SizedBox(
                                    height: 22, child: Text('Description :')),
                                SizedBox(height: 22, child: Text('Desp Qty :')),
                                SizedBox(height: 20, child: Text('Ex Rate :')),
                                SizedBox(
                                    height: 20, child: Text('Style Value :')),
                                SizedBox(
                                    height: 20, child: Text('Sales value:')),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    height: 22,
                                    child: Text(plorder[x].orderno.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ))),
                                SizedBox(
                                    height: 22,
                                    child: Text(plorder[x].refno.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ))),
                                SizedBox(
                                    height: 22,
                                    child: Text(plorder[x].style.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ))),
                                SizedBox(
                                    height: 22,
                                    child: Text(
                                        '${af.formatenumber(plorder[x].quantity).toString()} ${plorder[x].guom.toString()}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ))),
                                SizedBox(
                                    height: 22,
                                    child:
                                        Text(plorder[x].description.toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ))),
                                SizedBox(
                                    height: 22,
                                    child: Text(
                                        '${af.formatenumber(plorder[x].despatchqty).toString()} ${plorder[x].guom.toString()}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ))),
                                SizedBox(
                                    height: 20,
                                    child: Text(plorder[x].exchange.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ))),
                                SizedBox(
                                    height: 20,
                                    child: Text(
                                        af
                                            .formatenumber(
                                                plorder[x].orderValue)
                                            .toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ))),
                                SizedBox(
                                    height: 20,
                                    child: Text(
                                        af
                                            .formatenumber(
                                                plorder[x].salesvalue)
                                            .toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ))),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(10),
                            child: Image.network(
                              '$hostname:$port${plorder[x].imagepath}',
                              height: 50,
                              width: 50,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return const Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 25,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        //mainAxisSize: MainAxisSize.min,
                        children: const [
                          SizedBox(height: 22, child: Text('Price (INR)')),
                          SizedBox(
                              height: 22, child: Text('Sales price (INR)')),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                              height: 22,
                              child: Text(
                                  af
                                      .currecyformat(plorder[x].orderPrice)
                                      .toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ))),
                          SizedBox(
                              height: 22,
                              child: Text(
                                  af
                                      .currecyformat(plorder[x].salesprice)
                                      .toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ))),
                        ],
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.all(8),
                              width: 250,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                      height: 22,
                                      width: 180,
                                      child: Text('Particulars',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  for (int i = 0; i < plcost.length; i++) ...[
                                    SizedBox(
                                        height: 30,
                                        width: 250,
                                        child: Text(
                                          '${(i + 1).toString()}. ${plcost[i].itemgroup.toString()}',
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                          ),
                                        )),
                                  ],
                                  const SizedBox(
                                      height: 22,
                                      child: Text('Total Amount',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  const SizedBox(
                                      height: 22,
                                      child: Text('Cost / Pcs',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  const SizedBox(
                                      height: 22,
                                      child: Text('Profit val :',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  const SizedBox(
                                      height: 22,
                                      child: Text('Profit % :',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                      height: 22,
                                      child: Text('Plan',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  for (int i = 0; i < plcost.length; i++) ...[
                                    SizedBox(
                                        height: 30,
                                        child: Text(
                                          af
                                              .formatenumber(
                                                  plcost[i].estamount)
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                          ),
                                        )),
                                  ],
                                  SizedBox(
                                      height: 22,
                                      child: Text(
                                          af
                                              .formatenumber(plantotalamount
                                                  .roundToDouble())
                                              .toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  SizedBox(
                                      height: 22,
                                      child: Text(
                                        af
                                            .formatenumber(((plorder[x]
                                                            .orderValue!
                                                            .round() -
                                                        plantotalamount
                                                            .round()) /
                                                    plorder[x]
                                                        .quantity!
                                                        .round())
                                                .round())
                                            .toString(),
                                      )),
                                  SizedBox(
                                      height: 22,
                                      child: Text(af
                                          .formatenumber((plorder[x]
                                                      .salesvalue!
                                                      .toDouble() -
                                                  plantotalamount.toDouble())
                                              .round())
                                          .toString())),
                                  if (plorder[x].salesprice != 0.00) ...[
                                    SizedBox(
                                        height: 22,
                                        child: Text(
                                          (((plorder[x].salesvalue!.toDouble() -
                                                          plantotalamount
                                                              .toDouble()) /
                                                      plorder[x]
                                                          .salesvalue!
                                                          .toDouble()) *
                                                  100)
                                              .round()
                                              .toString(),
                                        )),
                                  ] else ...[
                                    const SizedBox(
                                        height: 22,
                                        child: Text('0.00 %',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              //backgroundColor: Colors.redAccent,
                                            ))),
                                  ]
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                      height: 22,
                                      child: Text('Actual',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  for (int i = 0; i < plcost.length; i++) ...[
                                    SizedBox(
                                        height: 30,
                                        child: Text(
                                          af
                                              .formatenumber(
                                                  plcost[i].actualamount)
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                          ),
                                        )),
                                  ],
                                  SizedBox(
                                      height: 22,
                                      child: Text(
                                          af
                                              .formatenumber(acttotalamount
                                                  .roundToDouble())
                                              .toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  SizedBox(
                                      height: 22,
                                      child: Text(af
                                          .formatenumber(((plorder[x]
                                                          .orderValue!
                                                          .toDouble() -
                                                      acttotalamount
                                                          .toDouble()) /
                                                  plorder[x].quantity!.round())
                                              .round())
                                          .toString())),
                                  SizedBox(
                                      height: 22,
                                      child: Text(af
                                          .formatenumber((plorder[x]
                                                      .salesvalue!
                                                      .toDouble() -
                                                  acttotalamount.toDouble())
                                              .round())
                                          .toString())),
                                  if (plorder[x].salesprice != 0.00) ...[
                                    SizedBox(
                                        height: 22,
                                        child: Text(
                                            (((plorder[x]
                                                                .salesvalue!
                                                                .toDouble() -
                                                            acttotalamount
                                                                .toDouble()) /
                                                        plorder[x]
                                                            .salesvalue!
                                                            .toDouble()) *
                                                    100)
                                                .round()
                                                .toString(),
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ))),
                                  ] else ...[
                                    const SizedBox(
                                        height: 22,
                                        child: Text('0.00 %',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              //backgroundColor: Colors.redAccent,
                                            ))),
                                  ]
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                      height: 22,
                                      child: Text('Invoiced',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  for (int i = 0; i < plcost.length; i++) ...[
                                    SizedBox(
                                        height: 30,
                                        child: Text(
                                          af
                                              .formatenumber(
                                                  plcost[i].invoiceamount)
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                          ),
                                        )),
                                  ],
                                  SizedBox(
                                      height: 22,
                                      child: Text(
                                          af
                                              .formatenumber(invtotalamount
                                                  .roundToDouble())
                                              .toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  SizedBox(
                                      height: 22,
                                      child: Text(af
                                          .formatenumber(((plorder[x]
                                                          .orderValue!
                                                          .toDouble() -
                                                      invtotalamount
                                                          .toDouble()) /
                                                  plorder[x].quantity!.round())
                                              .round())
                                          .toString())),
                                  SizedBox(
                                      height: 22,
                                      child: Text(af
                                          .formatenumber((plorder[x]
                                                      .salesvalue!
                                                      .toDouble() -
                                                  invtotalamount.toDouble())
                                              .round())
                                          .toString())),
                                  if (plorder[x].salesprice != 0.00) ...[
                                    SizedBox(
                                        height: 22,
                                        child: Text(
                                            '${(((plorder[x].salesvalue!.toDouble() - invtotalamount.toDouble()) / plorder[x].salesvalue!.toDouble()) * 100).round().toString()} %',
                                            style: const TextStyle(
                                                color: Colors.green,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold))),
                                  ] else ...[
                                    const SizedBox(
                                        height: 22,
                                        child: Text('0.00 %',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              //backgroundColor: Colors.redAccent,
                                            ))),
                                  ]
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 30,
                            child: ElevatedButton(
                                style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Colors.indigo)),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const OrderStatus()));
                                },
                                child: const Text('Order status')),
                          ),
                          const SizedBox(
                            height: 40,
                            width: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ]
            ]
          ] else ...[
            const SizedBox(
              child: ShowNorecordMessage(),
            )
          ]
        ]
            //_widgetOptions.elementAt(_selectedIndex),
            //]
            ),
      ),
    );
  }
}

/* Filtration modal part for profit & loss report */
class BottomSheetModal extends StatefulWidget {
  const BottomSheetModal({super.key});

  @override
  State<BottomSheetModal> createState() => _BottomSheetModalState();
}

class _BottomSheetModalState extends State<BottomSheetModal> {
  /* Initilization of local controller for assigning and getting the filtration values*/
  final orderCtrl = TextEditingController();
  final styleCtrl = TextEditingController();
  final refnoCtrl = TextEditingController();

  /*Page intialization part function*/
  @override
  void initState() {
    getfilrationdata();
    super.initState();
    if (orderno.isEmpty) {
      orderno.add("-- Select Order no--");
    }
    if (style.isEmpty) {
      style.add("-- Select Style--");
    }
    if (refno.isEmpty) {
      refno.add("-- Select Refno--");
    }
    ordernoValue = orderno.first;
    styleValue = style.first;
    refnoValue = refno.first;
  }

  /*Page close or dispose part function*/
  @override
  void dispose() {
    super.dispose();
    orderno.removeWhere((item) => item != "-- Select Order no--");
    style.removeWhere((item) => item != "-- Select Style--");
    refno.removeWhere((item) => item != "-- Select Refno--");
    listlenth = 0;
    ordermodal.clear();
    refnomodal.clear();
    stylemodal.clear();
  }

  /*User-defined function for gathering the filtration dropdown values*/
  Future<String> getfilrationdata() async {
    dynamic responsedata;
    var url = '$hostname:$port/api/apiprofitloss';
    var body = '''''';
    String length = body.length.toString();
    var headers = {
      'Content-Type': 'application/json',
      'Content-Length': length,
      'Host': 'localhost',
      'User-Agent': 'PostmanRuntime/7.30.0'
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        responsedata = json.decode(response.body.toString());
        dynamic orderList = json.decode(responsedata[1]);
        dynamic styleList = json.decode(responsedata[2]);
        dynamic refnoList = json.decode(responsedata[3]);

        for (int i = 0; i < orderList.length; i++) {
          dynamic responsedata1 = FilterationDataModal.fromJson(orderList[i]);
          orderno.add(responsedata1.value);
          ordermodal
              .add(FilterationDataModal(responsedata1.id, responsedata1.value));
        }
        for (int i = 0; i < refnoList.length; i++) {
          dynamic responsedata1 = FilterationDataModal.fromJson(refnoList[i]);
          refno.add(responsedata1.value);
          refnomodal
              .add(FilterationDataModal(responsedata1.id, responsedata1.value));
        }
        for (int i = 0; i < styleList.length; i++) {
          dynamic responsedata1 = FilterationDataModal.fromJson(styleList[i]);
          style.add(responsedata1.value);
          stylemodal
              .add(FilterationDataModal(responsedata1.id, responsedata1.value));
        }
      } else {}
    } catch (ex) {
      throw ex.toString();
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(width: 360, height: 20),
        const SizedBox(width: 360, height: 30, child: Text('Order No:')),
        SizedBox(
            width: 360,
            height: 40,
            child: CustomDropdown.search(
              hintText: 'Select Order no',
              items: orderno,
              controller: orderCtrl,
              onChanged: (String? value) {
                //ordernoValue = value!;
                for (int i = 0; i < ordermodal.length; i++) {
                  if (value! == ordermodal[i].value!) {
                    ordernoValue = ordermodal[i].id.toString();
                  }
                }
              },
            )),
        const SizedBox(width: 360, height: 10),
        const SizedBox(width: 360, height: 30, child: Text('Style:')),
        SizedBox(
            width: 360,
            height: 40,
            child: CustomDropdown.search(
              hintText: 'Select Style',
              items: style,
              controller: styleCtrl,
              onChanged: (String? value) {
                // styleValue = value!;
                for (int i = 0; i < stylemodal.length; i++) {
                  if (value! == stylemodal[i].value!) {
                    styleValue = stylemodal[i].id.toString();
                  }
                }
              },
            )),
        const SizedBox(width: 360, height: 10),
        const SizedBox(width: 360, height: 30, child: Text('Reference No:')),
        SizedBox(
            width: 360,
            height: 40,
            child: CustomDropdown.search(
              hintText: 'Select Ref no',
              items: refno,
              controller: refnoCtrl,
              onChanged: (String? value) {
                //refnoValue = value!;
                for (int i = 0; i < refnomodal.length; i++) {
                  if (value! == refnomodal[i].value!) {
                    refnoValue = refnomodal[i].value!;
                  }
                }
              },
            )),
        const SizedBox(width: 360, height: 30),
        SizedBox(
            width: 360,
            height: 30,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        dispose();
                        ordernoValue = orderno.first;
                        styleValue = style.first;
                        refnoValue = refno.first;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue),
                    child: const Text('Reset'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfitLossReport()));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 43, 141, 46)),
                    child: const Text('Submit'),
                  )
                ])),
      ],
    );
  }
}
