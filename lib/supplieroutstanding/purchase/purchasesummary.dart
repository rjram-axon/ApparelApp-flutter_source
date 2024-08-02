import 'dart:convert';

import 'package:apparelapp/axonlibrary/axongeneral.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../axondatamodal/axonfitrationmodal/processoutstandingfilter.dart';
import '../../axondatamodal/processoutstandingmodal.dart';

class Purchasesummary extends StatefulWidget {
  const Purchasesummary({super.key});

  @override
  State<Purchasesummary> createState() => _PurchasesummaryState();
}

class _PurchasesummaryState extends State<Purchasesummary> {
  int listlength = 0;
  String status = "Wait fetching data...";
  final List<ProcessOutstandingModal> _itemlist = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _itemlist.clear();
  }

  Future<void> getsummarydetails() async {
    dynamic responsedata;
    var url =
        '$hostname:$port/api/apipurchaseoutstanding?supplierid=0&orderno=&styleid=0&fromdate=&todate=';
    var body = '''''';
    String length = body.length.toString();
    var header = {
      'Content-type': 'application/json',
      'Host': 'localhost',
      'User-Agent': 'PostmanRuntime/7.30.0',
      'Content-Length': length
    };
    try {
      var response = await http.get(Uri.parse(url), headers: header);
      if (response.statusCode == 200) {
        responsedata = jsonDecode(response.body);
        responsedata = json.decode(responsedata);
        for (int i = 0; i < responsedata.length; i++) {
          var data = ProcessOutstandingModal.fromJson(responsedata[i]);
          _itemlist.add(data);
        }

        listlength = _itemlist.length;
        setState(() {
          listlength;
          _itemlist;
        });
      } else {}
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(status),
      ),
      body: ListView.builder(
          itemCount: listlength,
          itemBuilder: ((context, index) {
            return Column(
              children: [
                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.shopping_basket_outlined,
                      color: Colors.purple,
                    ),
                    title: Text(
                        _itemlist[index].supplier.toString().toUpperCase()),
                    trailing: Text(
                      '${_itemlist[index].balanceqty.toString()} ${_itemlist[index].outuom.toString()}',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Icon(
                          Icons.arrow_upward_rounded,
                          color: Colors.blueAccent,
                          size: 15,
                        ),
                        Text(_itemlist[index].issueqty.toString()),
                        const Icon(
                          Icons.arrow_downward_rounded,
                          color: Colors.green,
                          size: 15,
                        ),
                        Text(_itemlist[index].receivedqty.toString()),
                      ],
                    ),
                    onTap: () {
                      outsupplierid = _itemlist[index].supplierid;
                      outsupplier = _itemlist[index].supplier;
                      /* Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SupplierBasedOutstanding())); */
                    },
                  ),
                ),
              ],
            );
          })),
    );
  }
}
