import 'package:apparelapp/main/app_config.dart';
import 'package:apparelapp/main/drawerpage.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../axondatamodal/axonfitrationmodal/orderwisestockfilter.dart';
import '../axondatamodal/stockreportmodal.dart';
import '../axonlibrary/axongeneral.dart';
import 'package:http/http.dart' as http;
import '../main.dart';

class StockTracking extends StatefulWidget {
  const StockTracking({super.key});

  @override
  State<StockTracking> createState() => _StockTrackingState();
}

class _StockTrackingState extends State<StockTracking> {
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
    _stocksummary.clear();
    stocksummary!.clear();
    itemid = 0;
    colorid = 0;
    sizeid = 0;
    ordno = "";
    refno = "";
    storeid = 0;
  }

  Future<void> getstocksummary() async {
    /* Local variable declaration for getting details & passing parameters*/
    dynamic responsedata;

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
      "Storeid": storeid,
      "Fromdate": "2022-12-01",
      "Todate": "2025-01-02"
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
          data.size!.toLowerCase().contains(value.toLowerCase()) ||
          data.transno!.toLowerCase().contains(value.toLowerCase()) ||
          data.storename!.toLowerCase().contains(value.toLowerCase());
    });
    setState(() {
      stocksummary;
      listlenth = stocksummary!.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            'Stock Tracking',
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
                          summaryfiltration(value);
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
                            '${listlenth.toString()} Records are displayed..',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.indigo,
                              fontSize: 11.0,
                            ),
                          )),
                    ],
                    Card(
                      margin: const EdgeInsets.all(5.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Colors.white,
                      elevation: 5,
                      child: Column(
                        //mainAxisSize: MainAxisSize.min,
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
                                          height: 25,
                                          child: Text(stocksummary![index]
                                              .transno
                                              .toString())),
                                      SizedBox(
                                          height: 35,
                                          child: Text(stocksummary![index]
                                              .storename
                                              .toString())),
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
                                          height: 25,
                                          child: Text(
                                            '${stocksummary![index].balqty.toString()} ${stocksummary![index].uom.toString()}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ],
                                  ),
                                ),
                              ]),
                        ],
                      ),
                    )
                  ]);
                })));
  }
}
