import 'dart:convert';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:apparelapp/axondatamodal/axonfitrationmodal/axondatafiltration.dart';
import 'package:apparelapp/axondatamodal/axonfitrationmodal/orderwisestockfilter.dart';
import 'package:apparelapp/axondatamodal/stockreportmodal.dart';
import 'package:apparelapp/axonlibrary/axongeneral.dart';
import 'package:apparelapp/main/app_config.dart';
import 'package:apparelapp/stock/orderwisestock.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/* Below Variable for using on filtration */
List<String> companylist = ["-- Select Company --"];
List<String> buyerlist = ["-- Select Buyer --"];
List<String> emplist = ["-- Select Employee --"];
List<String> ordernolist = ["-- Select Orderno--"];
List<String> refnolist = ["-- Select Refno--"];
List<String> stylelist = ["-- Select Style--"];
List<String> itemlist = ["-- Select Item--"];
List<String> colorlist = ["-- Select color--"];
List<String> sizelist = ["-- Select Size--"];
List<String> storenamelist = ["-- Select Store--"];

List<FilterationModal> companylistmodal = [];
List<FilterationModal> buyerlistmodal = [];
List<FilterationModal> emplistmodal = [];
List<FilterationModal> ordernolistmodal = [];
List<FilterationModal> refnolistmodal = [];
List<FilterationModal> stylelistmodal = [];
List<FilterationModal> itemlistmodal = [];
List<FilterationModal> colorlistmodal = [];
List<FilterationModal> sizelistmodal = [];
List<FilterationModal> storenamelistmodal = [];

String companyValue = "";
String buyervalue = "";
String empvalue = "";
String ordernoValue = "";
String refnoValue = "";
String styleValue = "";
String itemValue = "";
String colorValue = "";
String sizeValue = "";
String storeValue = "";
int itemidValue = 0;
int coloridValue = 0;
int sizeidValue = 0;
int storeidValue = 0;

class MainStock extends StatefulWidget {
  const MainStock({super.key});

  @override
  State<MainStock> createState() => _MainStockState();
}

class _MainStockState extends State<MainStock> {
  List<StockMainListDataModal>? stocksummary = [];
  List<StockMainListDataModal>? stocksummaryfilter = [];
  final dynamic _stocksummary = [];
  int? listlenth = 0;
  TextEditingController txtsearchcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getstocksummary();
  }

  @override
  void dispose() {
    super.dispose();
    listlenth = 0;
    _stocksummary.clear();
    stocksummary!.clear();
    itemid = 0;
    colorid = 0;
    sizeid = 0;
  }

  Future<void> getstocksummary() async {
    /* Local variable declaration for getting details & passing parameters*/
    dynamic responsedata;
/*     String? compy = "";
    String? ordno = "";
    String? refno = "";
    String? sty = "";
    String? item = "";
    String? color = "";
    String? size = "";
    String? store = "";
    int? itemid = 0;
    int? colorid = 0;
    int? sizeid = 0; */

    /* Checking with the filtration is empty or not & passing parameter values*/

    if (companyValue.toString() == "" ||
        companyValue.toString() == "-- Select Company--") {
      compy = null;
    } else {
      compy = ordernoValue;
    }

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
    var url =
        'http://${AppConfig().host}:${AppConfig().port}/api/apistockstatus'; // This is API Url

    /* This is body content to send the API */
    var body = json.encode({
      "companyid": compy,
      "Order_no": ordno,
      "Ref_no": refno,
      "Style": sty,
      "Styleid": sty,
      "Item": item,
      "Itemid": itemid,
      "Color": color,
      "Colorid": colorid,
      "Size": size,
      "Sizeid": sizeid,
      "Storename": store,
      "Storeid": store
    });
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
        _stocksummary.add(responsedata);
        for (int i = 0; i < rlength; i++) {
          var data = StockMainListDataModal.fromJson(responsedata[i]);
          stocksummary!.add(StockMainListDataModal(
              data.item,
              data.color,
              data.size,
              data.balqty,
              data.uom,
              data.storename,
              data.companyid,
              data.itemid,
              data.colorid,
              data.sizeid,
              data.storeunitid,
              data.orderno,
              data.refno,
              data.style,
              data.transno));
        }
        setState(() {
          listlenth = stocksummary!.length;
          stocksummaryfilter!.addAll(stocksummary!);
        });
      } else {}
    } catch (ex) {
      throw ex.toString();
    }
  }

  void refreshdata() {
    txtsearchcontroller.text = "";
    stocksummary!.clear();
    stocksummaryfilter!.clear();
    getstocksummary();
  }

  void summaryfiltration(String value) {
    stocksummary!.clear();
    stocksummary!.addAll(stocksummaryfilter!);
    stocksummary!.retainWhere((data) {
      return data.item!.toLowerCase().contains(value.toLowerCase()) ||
          data.color!.toLowerCase().contains(value.toLowerCase()) ||
          data.size!.toLowerCase().contains(value.toLowerCase());
    });
    setState(() {
      stocksummary;
      listlenth = stocksummary!.length;
    });
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      elevation: 40.0,
      // backgroundColor: Colors.cyanAccent,
      builder: (context) {
        return const SingleChildScrollView(child: BottomSheetModal());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            'Stock Details',
            style: TextStyle(color: Color(0xFF0072FF)),
          ),
          leading: IconButton(
            color: Color(0xFF0072FF),
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Navigate back to the previous screen
            },
          ),
        ),
        body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: Colors.white,
                  pinned: true,
                  automaticallyImplyLeading: false,
                  title: Container(
                    margin: const EdgeInsets.all(10),
                    height: 40,
                    decoration: const BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Color.fromARGB(255, 252, 254, 255),
                          // offset: Offset(1.1, 1.1),
                          //blurRadius: 5.0
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: 380,
                      height: 38,
                      child: TextField(
                        controller: txtsearchcontroller,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                summaryfiltration(txtsearchcontroller.text);
                              },
                              icon: const Icon(Icons.search)),
                          border: const OutlineInputBorder(),
                          labelText: 'Search...',
                        ),
                        onChanged: (value) {
                          summaryfiltration(txtsearchcontroller.text);
                        },
                        style: const TextStyle(
                          backgroundColor: Colors.transparent,
                          //color: Colors.blue,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                )
              ];
            },
            body: ListView.builder(
                itemCount: listlenth,
                itemBuilder: (BuildContext context, int index) {
                  return Column(children: [
                    if (index == 0) ...[
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                          height: 15,
                          width: 380,
                          child: Text(
                            '${listlenth.toString()} Results found.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.indigo,
                              fontSize: 12.0,
                            ),
                          )),
                    ],
                    Card(
                        margin: const EdgeInsets.all(6.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Colors.white,
                        elevation: 2,
                        child:
                            Column(mainAxisSize: MainAxisSize.max, children: [
                          ListTile(
                            //leading: const Icon(Icons.inventory_2_rounded),
                            title: Text(stocksummary![index].item.toString()),
                            subtitle: Text(
                                '${stocksummary![index].size.toString()} - ${stocksummary![index].color.toString()}'),
                            trailing: Text(
                              '${stocksummary![index].balqty.toString()} ${stocksummary![index].uom.toString()}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            isThreeLine: true,
                            onTap: () {
                              itemid = stocksummary![index].itemid;
                              colorid = stocksummary![index].colorid;
                              sizeid = stocksummary![index].sizeid;
                              storeid = stocksummary![index].storeunitid;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const OrderWiseStock()));
                            },
                          ),
                        ])),
                    /*  Card(
                      margin: const EdgeInsets.all(6.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Colors.white,
                      elevation: 2,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 200,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.all(5),
                                  margin: const EdgeInsets.all(5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          height: 35,
                                          child: Text(stocksummary![index]
                                              .item
                                              .toString())),
                                      SizedBox(
                                          height: 35,
                                          child: Text(
                                              '${stocksummary![index].size.toString()} - ${stocksummary![index].color.toString()}')),
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.all(5),
                                  margin: const EdgeInsets.all(5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          height: 35,
                                          child: Text(
                                            '${stocksummary![index].balqty.toString()} ${stocksummary![index].uom.toString()}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        height: 30,
                                        child: TextButton(
                                            style: const ButtonStyle(
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                        Colors.white)),
                                            onPressed: () {
                                              itemid =
                                                  stocksummary![index].itemid;
                                              colorid =
                                                  stocksummary![index].colorid;
                                              sizeid =
                                                  stocksummary![index].sizeid;
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const OrderWiseStock()));
                                            },
                                            child: const Text('Detail')),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                        ],
                      ),
                    ), */
                    //],
                    //_widgetOptions.elementAt(_selectedIndex),
                  ]);
                })));
  }
}

/* Filtration modal part for profit & loss report */
class BottomSheetModal extends StatefulWidget {
  const BottomSheetModal({super.key});

  @override
  State<BottomSheetModal> createState() => _BottomSheetModalState();
}

class _BottomSheetModalState extends State<BottomSheetModal> {
  var listlenth = 0;

  /* Initilization of local controller for assigning and getting the filtration values*/
  final companyCtrl = TextEditingController();
  final buyerCtrl = TextEditingController();
  final empCtrl = TextEditingController();
  final orderCtrl = TextEditingController();
  final styleCtrl = TextEditingController();
  final refnoCtrl = TextEditingController();
  final itemCtrl = TextEditingController();
  final colorCtrl = TextEditingController();
  final sizeCtrl = TextEditingController();
  final storeCtrl = TextEditingController();

  /*Page intialization part function*/
  @override
  void initState() {
    getfilrationdata();
    super.initState();
    if (companylist.isEmpty) {
      companylist.add("-- Select Company--");
    }
    if (buyerlist.isEmpty) {
      buyerlist.add("-- Select Buyer--");
    }
    if (emplist.isEmpty) {
      emplist.add("-- Select Employee--");
    }
    if (ordernolist.isEmpty) {
      ordernolist.add("-- Select Order no--");
    }
    if (stylelist.isEmpty) {
      stylelist.add("-- Select Style--");
    }
    if (refnolist.isEmpty) {
      refnolist.add("-- Select Refno--");
    }
    if (itemlist.isEmpty) {
      itemlist.add("-- Select Item--");
    }
    if (colorlist.isEmpty) {
      colorlist.add("-- Select Color--");
    }
    if (sizelist.isEmpty) {
      sizelist.add("-- Select Size--");
    }
    if (storenamelist.isEmpty) {
      storenamelist.add("-- Select Store--");
    }

    companyValue = companylist.first;
    buyervalue = buyerlist.first;
    empvalue = emplist.first;
    ordernoValue = ordernolist.first;
    styleValue = stylelist.first;
    refnoValue = refnolist.first;
    itemValue = itemlist.first;
    colorValue = colorlist.first;
    sizeValue = sizelist.first;
    storeValue = storenamelist.first;
  }

  /*Page close or dispose part function*/
  @override
  void dispose() {
    super.dispose();
    companylist.removeWhere((item) => item != "-- Select Company--");
    buyerlist.removeWhere((item) => item != "-- Select Buyer--");
    emplist.removeWhere((item) => item != "-- Select Employee--");
    ordernolist.removeWhere((item) => item != "-- Select Order no--");
    stylelist.removeWhere((item) => item != "-- Select Style--");
    refnolist.removeWhere((item) => item != "-- Select Refno--");
    itemlist.removeWhere((item) => item != "-- Select Item--");
    colorlist.removeWhere((item) => item != "-- Select Color--");
    sizelist.removeWhere((item) => item != "-- Select Size--");
    storenamelist.removeWhere((item) => item != "-- Select Store--");
    listlenth = 0;
    companylistmodal.clear();
    buyerlistmodal.clear();
    emplistmodal.clear();
    ordernolistmodal.clear();
    refnolistmodal.clear();
    stylelistmodal.clear();
    itemlistmodal.clear();
    colorlistmodal.clear();
    sizelistmodal.clear();
    storenamelistmodal.clear();
  }

  /*User-defined function for gathering the filtration dropdown values*/
  Future<String> getfilrationdata() async {
    dynamic responsedata;
    var url = '$hostname:$port/api/apistockstatus';
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

        for (int i = 0; i < responsedata.length; i++) {
          dynamic resultdata = json.decode(responsedata[i]);
          switch (i) {
            case 0:
              for (int j = 0; j < resultdata.length; j++) {
                dynamic data = FilterationModal.fromJson(resultdata[j]);
                companylist.add(data.value);
                companylistmodal.add(FilterationModal(data.id, data.value));
              }
              break;
            case 1:
              for (int j = 0; j < resultdata.length; j++) {
                dynamic data = FilterationModal.fromJson(resultdata[j]);
                buyerlist.add(data.value);
                buyerlistmodal.add(FilterationModal(data.id, data.value));
              }
              break;
            case 2:
              for (int j = 0; j < resultdata.length; j++) {
                dynamic data = FilterationModal.fromJson(resultdata[j]);
                emplist.add(data.value);
                emplistmodal.add(FilterationModal(data.id, data.value));
              }
              break;
            case 3:
              for (int j = 0; j < resultdata.length; j++) {
                dynamic data = FilterationModal.fromJson(resultdata[j]);
                ordernolist.add(data.value);
                ordernolistmodal.add(FilterationModal(data.id, data.value));
              }
              break;
            case 4:
              for (int j = 0; j < resultdata.length; j++) {
                dynamic data = FilterationModal.fromJson(resultdata[j]);
                refnolist.add(data.value);
                refnolistmodal.add(FilterationModal(data.id, data.value));
              }
              break;
            case 5:
              for (int j = 0; j < resultdata.length; j++) {
                dynamic data = FilterationModal.fromJson(resultdata[j]);
                stylelist.add(data.value);
                stylelistmodal.add(FilterationModal(data.id, data.value));
              }
              break;
            case 6:
              for (int j = 0; j < resultdata.length; j++) {
                dynamic data = FilterationModal.fromJson(resultdata[j]);
                itemlist.add(data.value);
                itemlistmodal.add(FilterationModal(data.id, data.value));
              }
              break;
            case 7:
              for (int j = 0; j < resultdata.length; j++) {
                dynamic data = FilterationModal.fromJson(resultdata[j]);
                colorlist.add(data.value);
                colorlistmodal.add(FilterationModal(data.id, data.value));
              }
              break;
            case 8:
              for (int j = 0; j < resultdata.length; j++) {
                dynamic data = FilterationModal.fromJson(resultdata[j]);
                sizelist.add(data.value);
                sizelistmodal.add(FilterationModal(data.id, data.value));
              }
              break;
            case 9:
              for (int j = 0; j < resultdata.length; j++) {
                dynamic data = FilterationModal.fromJson(resultdata[j]);
                storenamelist.add(data.value);
                storenamelistmodal.add(FilterationModal(data.id, data.value));
              }
              break;
          }
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
        const SizedBox(width: 360, height: 30, child: Text('Comapny:')),
        SizedBox(
            width: 360,
            height: 40,
            child: CustomDropdown.search(
              hintText: 'Select Company',
              items: companylist,
              controller: companyCtrl,
              onChanged: (String? value) {
                //ordernoValue = value!;
                for (int i = 0; i < companylistmodal.length; i++) {
                  if (value! == companylistmodal[i].value!) {
                    compyid = companylistmodal[i].id!.toInt();
                  }
                }
              },
            )),
        const SizedBox(width: 360, height: 20),
        const SizedBox(width: 360, height: 30, child: Text('Order No:')),
        SizedBox(
            width: 360,
            height: 40,
            child: CustomDropdown.search(
              hintText: 'Select Order no',
              items: ordernolist,
              controller: orderCtrl,
              onChanged: (String? value) {
                //ordernoValue = value!;
                for (int i = 0; i < ordernolistmodal.length; i++) {
                  if (value! == ordernolistmodal[i].value!) {
                    ordno = ordernolistmodal[i].id.toString();
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
              items: stylelist,
              controller: styleCtrl,
              onChanged: (String? value) {
                // styleValue = value!;
                for (int i = 0; i < stylelistmodal.length; i++) {
                  if (value! == stylelistmodal[i].value!) {
                    styleid = stylelistmodal[i].id!.toInt();
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
              items: refnolist,
              controller: refnoCtrl,
              onChanged: (String? value) {
                //refnoValue = value!;
                for (int i = 0; i < refnolistmodal.length; i++) {
                  if (value! == refnolistmodal[i].value!) {
                    refno = refnolistmodal[i].value!;
                  }
                }
              },
            )),
        const SizedBox(width: 360, height: 10),
        const SizedBox(width: 360, height: 30, child: Text('Item :')),
        SizedBox(
            width: 360,
            height: 40,
            child: CustomDropdown.search(
              hintText: 'Select Item',
              items: itemlist,
              controller: itemCtrl,
              onChanged: (String? value) {
                //refnoValue = value!;
                for (int i = 0; i < itemlistmodal.length; i++) {
                  if (value! == itemlistmodal[i].value!) {
                    itemid = itemlistmodal[i].id!;
                  }
                }
              },
            )),
        const SizedBox(width: 360, height: 10),
        const SizedBox(width: 360, height: 30, child: Text('Color :')),
        SizedBox(
            width: 360,
            height: 40,
            child: CustomDropdown.search(
              hintText: 'Select Color',
              items: colorlist,
              controller: colorCtrl,
              onChanged: (String? value) {
                //refnoValue = value!;
                for (int i = 0; i < colorlistmodal.length; i++) {
                  if (value! == colorlistmodal[i].value!) {
                    colorid = colorlistmodal[i].id!;
                  }
                }
              },
            )),
        const SizedBox(width: 360, height: 10),
        const SizedBox(width: 360, height: 30, child: Text('Size :')),
        SizedBox(
            width: 360,
            height: 40,
            child: CustomDropdown.search(
              hintText: 'Select Size',
              items: sizelist,
              controller: sizeCtrl,
              onChanged: (String? value) {
                //refnoValue = value!;
                for (int i = 0; i < sizelistmodal.length; i++) {
                  if (value! == sizelistmodal[i].value!) {
                    sizeid = sizelistmodal[i].id!;
                  }
                }
              },
            )),
        const SizedBox(width: 360, height: 10),
        const SizedBox(width: 360, height: 30, child: Text('Store :')),
        SizedBox(
            width: 360,
            height: 40,
            child: CustomDropdown.search(
              hintText: 'Select Size',
              items: storenamelist,
              controller: storeCtrl,
              onChanged: (String? value) {
                //refnoValue = value!;
                for (int i = 0; i < storenamelistmodal.length; i++) {
                  if (value! == storenamelistmodal[i].value!) {
                    storeid = storenamelistmodal[i].id!;
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
                        /* companyValue = companylist.first;
                        buyervalue = buyerlist.first;
                        empvalue = emplist.first;
                        ordernoValue = ordernolist.first;
                        styleValue = stylelist.first;
                        refnoValue = refnolist.first;
                        itemValue = itemlist.first;
                        colorValue = colorlist.first;
                        sizeValue = sizelist.first;
                        storeValue = storenamelist.first; */
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue),
                    child: const Text('Reset'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainStock()));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 43, 141, 46)),
                    child: const Text('Submit'),
                  )
                ])),
        const SizedBox(width: 360, height: 30),
      ],
    );
  }
}

class MainStockSummary extends StatefulWidget {
  const MainStockSummary({super.key});

  @override
  State<MainStockSummary> createState() => _MainStockSummaryState();
}

class _MainStockSummaryState extends State<MainStockSummary> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
