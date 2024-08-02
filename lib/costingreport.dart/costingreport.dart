import 'package:apparelapp/axondatamodal/conscostingmodal.dart';
import 'package:apparelapp/axondatamodal/filtrationmodal.dart';
import 'package:apparelapp/axonlibrary/axonfunctions.dart';
import 'package:apparelapp/axonlibrary/axongeneral.dart';
import 'package:apparelapp/main.dart';
import 'package:apparelapp/main/drawerpage.dart';
import 'package:apparelapp/profitlossreport/profitlossreport.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import '../axonlibrary/axonnorecordmessage.dart';

List<String> orderno = ["-- Select Orderno--"];
List<String> refno = ["-- Select Refno--"];
List<String> style = ["-- Select Style--"];

String ordernoValue = "";
String refnoValue = "";
String styleValue = "";
AxonFunction af = AxonFunction();

class CostingReport extends StatefulWidget {
  const CostingReport({super.key});

  @override
  State<CostingReport> createState() => _CostingReportState();
}

class _CostingReportState extends State<CostingReport> {
  List<ConsCostModal>? conscost = [];
  final dynamic _costorders = [];
  int? listlenth = 0;

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

  Future<void> getcostingdetails() async {
    /* Local variable declaration for getting details & passing parameters*/
    dynamic responsedata;
    String? ordno = "";
    String? refno = "";
    String? sty = "";

    /* Checking with the filtration is empty or not & passing parameter values*/
    if (ordernoValue.toString() == "" ||
        ordernoValue.toString() == "-- Select Orderno--") {
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
    var url = '$hostname:$port/api/apiconscosting'; // This is API Url

    /* This is body content to send the API */
    var body = '''{\r\n        
        companyid:null,\r\n        
        "Order_no":'$ordno',\r\n        
        "Ref_no":'$refno',\r\n        
        "Style":'$sty',\r\n        
        "Styleid":null,\r\n       \r\n}''';
    String length =
        body.length.toString(); // Getting body length from body variable
    var headers = {
      'Content-Type': 'application/json',
      'Content-Length': length,
      'Host': 'apparelmvc',
      'User-Agent': 'PostmanRuntime/7.30.0'
    }; // This is header content to send the API Link

    try {
      final response = await http.post(Uri.parse(url),
          headers: headers,
          body:
              body); // Api (POST) method syntax for sending contents & getting concern details
      if (response.statusCode == 200) {
        responsedata = jsonDecode(response.body);
        responsedata = json.decode(responsedata[0]);
        int rlength = responsedata.length;
        _costorders.add(responsedata);
        for (int i = 0; i < rlength; i++) {
          var data = ConsCostModal.fromJson(responsedata[i]);
          conscost!.add(ConsCostModal(
              data.orderno,
              data.refno,
              data.style,
              data.quantity,
              data.guom,
              data.description,
              data.imagepath,
              data.productionqty,
              data.allowenceper,
              data.currency,
              data.price,
              data.exchange,
              data.orderprice,
              data.ordersvalue,
              data.salesprice,
              data.salesrate,
              data.despamount,
              data.planamount,
              data.actualamount,
              data.actualvalue,
              data.planamount! - data.actualvalue!,
              data.ordersvalue! - data.actualvalue!,
              ((data.ordersvalue! - data.actualamount!) / data.ordersvalue!) *
                  100,
              data.despamount! - data.actualvalue!,
              ((data.despamount! - data.actualvalue!) / data.despamount!) *
                  100));
        }
        setState(() {
          if (conscost!.isNotEmpty) {
            listlenth = conscost!.length;
          } else {
            listlenth = 1;
          }
          //listlenth = _costorders.length;
        });
      } else {}
    } catch (ex) {
      throw ex.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    getcostingdetails();
  }

  @override
  void dispose() {
    super.dispose();
    ordernoValue = "";
    refnoValue = "";
    styleValue = "";
    listlenth = 1;
    _costorders.clear();
    conscost!.clear();
  }

  void resetdata() {
    ordernoValue = "";
    refnoValue = "";
    styleValue = "";
    listlenth = 1;
    _costorders.clear();
    conscost!.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('Cons Costing report'), actions: <Widget>[
        Center(
          child: Row(
            children: [
              IconButton(
                  onPressed: () {},
                  tooltip: "Info",
                  icon: const Icon(Icons.info_outlined)),
              // IconButton(
              //     onPressed: () {
              //       dispose();
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) => const MyDrawerPage()));
              //     },
              //     icon: const Icon(Icons.dashboard)),
              IconButton(
                  onPressed: () {
                    resetdata();
                    //Navigator.pop(context, true);
                    _showModalBottomSheet(context);
                  },
                  icon: const Icon(Icons.tune_outlined))
            ],
          ),
        ),
      ]),
      body: ListView.builder(
        itemCount: listlenth,
        itemBuilder: (BuildContext context, int index) {
          if (conscost!.isEmpty) {
            return const SizedBox(
              child: ShowNorecordMessage(),
            );
          } else {
            return Card(
              margin: const EdgeInsets.all(10.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.white,
              elevation: 20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                                height: 22, child: Text('Order No :')),
                            const SizedBox(height: 22, child: Text('Ref No :')),
                            const SizedBox(
                                height: 22, child: Text('Style    :')),
                            const SizedBox(
                                height: 22, child: Text('Quantity :')),
                            const SizedBox(
                                height: 22, child: Text('Description :')),
                            const SizedBox(
                                height: 22, child: Text('Desp Qty :')),
                            const SizedBox(
                                height: 22, child: Text('Ex Rate :')),
                            const SizedBox(
                              height: 20,
                            ),
                            const SizedBox(
                                height: 22, child: Text('Rate (INR) :')),
                            const SizedBox(
                                height: 22, child: Text('Value (INR) :')),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                                height: 22,
                                child: Text(
                                    'Rate (${conscost![index].currency}) :')),
                            SizedBox(
                                height: 22,
                                child: Text(
                                    'Value (${conscost![index].currency}) :')),
                            const SizedBox(
                                height: 22, child: Text('Despath val (INR) :')),
                            const SizedBox(
                              height: 20,
                            ),
                            const SizedBox(
                                height: 22, child: Text('Planed Cost :')),
                            const SizedBox(
                                height: 22, child: Text('Actul Cost :')),
                            const SizedBox(height: 22, child: Text('Diff :')),
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
                                child: Text(
                                  conscost![index].orderno.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                                height: 22,
                                child: Text(
                                  conscost![index].refno.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                                height: 22,
                                child: Text(
                                  conscost![index].style.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                                height: 22,
                                child: Text(
                                  '${af.formatenumber(conscost![index].quantity!.round())}   ${conscost![index].guom}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                                height: 22,
                                child: Text(
                                  conscost![index].description.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                                height: 22,
                                child: Text(
                                  af.formatenumber(
                                      conscost![index].productionqty!.round()),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                                height: 22,
                                child: Text(
                                  conscost![index].exchange.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                                height: 22,
                                child: Text(
                                  af
                                      .currecyformat(
                                          conscost![index].orderprice)
                                      .toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                                height: 22,
                                child: Text(
                                  af
                                      .currecyformat(
                                          conscost![index].ordersvalue?.round())
                                      .toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                                height: 22,
                                child: Text(
                                  conscost![index].price.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                                height: 22,
                                child: Text(
                                  af
                                      .formatenumber(
                                          conscost![index].ordersvalue!.round())
                                      .toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                                height: 22,
                                child: Text(
                                  af
                                      .formatenumber(
                                          conscost![index].despamount!.round())
                                      .toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                                height: 22,
                                child: Text(
                                  af
                                      .formatenumber(
                                          conscost![index].planamount!.round())
                                      .toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                                height: 22,
                                child: Text(
                                  af
                                      .formatenumber(
                                          conscost![index].actualvalue!.round())
                                      .toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                                height: 22,
                                child: Text(
                                  af.formatenumber(
                                      conscost![index].costdiff!.round()),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        /*child: Image.network(
                        '$hostname:$port${conscost![index].imagepath}',
                        height: 25,
                        width: 25,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return const Icon(
                            Icons.image_not_supported_outlined,
                            size: 25,
                          );
                        },
                      ),*/
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    //mainAxisSize: MainAxisSize.min,
                    children: const [
                      SizedBox(
                          height: 22, child: Text('Profit for Order Quantity')),
                      SizedBox(
                          height: 22,
                          child: Text('Profit % for order quantity')),
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
                            af.formatenumber(
                                conscost![index].profitordqty!.round()),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )),
                      SizedBox(
                          height: 22,
                          child: Text(
                            '${conscost![index].profitordper!.round()}' '%',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    //mainAxisSize: MainAxisSize.min,
                    children: const [
                      SizedBox(
                          height: 22, child: Text('Profit for desp Quantity')),
                      SizedBox(
                          height: 22,
                          child: Text('Profit % for desp quantity')),
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
                            af.formatenumber(
                                conscost![index].profitdespqty!.round()),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )),
                      SizedBox(
                          height: 22,
                          child: Text(
                            '${conscost![index].profitdespper!.round()}' '%',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 30,
                        // child: ElevatedButton(
                        //     style: const ButtonStyle(
                        //         backgroundColor:
                        //             MaterialStatePropertyAll(Colors.indigo)),
                        //     onPressed: () {
                        //       conscost![index];
                        //       AlertDialog(
                        //         title: const Text('test'),
                        //         content: Text(conscost![index].toString()),
                        //       );
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) =>
                        //                   const ProfitLossReport()));
                        //     },
                        //     child: const Text('Profit & Loss')),
                      ),
                      const SizedBox(
                        height: 40,
                        width: 20,
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class BottomSheetModal extends StatefulWidget {
  const BottomSheetModal({super.key});

  @override
  State<BottomSheetModal> createState() => _BottomSheetModalState();
}

class _BottomSheetModalState extends State<BottomSheetModal> {
  final orderCtrl = TextEditingController();
  final styleCtrl = TextEditingController();
  final refnoCtrl = TextEditingController();

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

  @override
  void dispose() {
    super.dispose();
    orderno.removeWhere((item) => item != "-- Select Order no--");
    style.removeWhere((item) => item != "-- Select Style--");
    refno.removeWhere((item) => item != "-- Select Refno--");
    listlenth = 0;
    //_costorders.clear();
  }

  Future<String> getfilrationdata() async {
    dynamic responsedata;
    var url = '$hostname:$port/api/apiconscosting';
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
        dynamic refnoList = json.decode(responsedata[2]);
        dynamic styleList = json.decode(responsedata[3]);
        for (int i = 0; i < orderList.length; i++) {
          dynamic responsedata1 = FilterationDataModal.fromJson(orderList[i]);
          orderno.add(responsedata1.value);
        }
        for (int i = 0; i < refnoList.length; i++) {
          dynamic responsedata1 = FilterationDataModal.fromJson(refnoList[i]);
          refno.add(responsedata1.value);
        }
        for (int i = 0; i < styleList.length; i++) {
          dynamic responsedata1 = FilterationDataModal.fromJson(styleList[i]);
          style.add(responsedata1.value);
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
                ordernoValue = value!;
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
                styleValue = value!;
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
                refnoValue = value!;
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
                              builder: (context) => const CostingReport()));
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
