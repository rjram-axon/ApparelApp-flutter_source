import 'package:apparelapp/axondatamodal/stocktransmodal.dart';
import 'package:apparelapp/axonlibrary/axonfunctions.dart';
import 'package:apparelapp/axonlibrary/axongeneral.dart';
import 'package:apparelapp/axonlibrary/axonstocklibrary.dart';
import 'package:apparelapp/stock/itemwisestockdetails.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:apparelapp/axonlibrary/axonstockmainfilter.dart';

AxonFunction af = AxonFunction();
AxonStockLibrary stocklibrary = AxonStockLibrary();

class Transactionwisestock extends StatefulWidget {
  const Transactionwisestock({super.key});

  @override
  State<Transactionwisestock> createState() => _TransactionwisestockState();
}

class _TransactionwisestockState extends State<Transactionwisestock> {
  int listlength = 0;
  List<StockTransdetails> transitemlist = [];

  @override
  void initState() {
    super.initState();
    getttransdetails();
    setState(() {
      listlength;
    });
  }

  @override
  void dispose() {
    super.dispose();
    transitemlist.clear();
    listlength = 0;
  }

  Future<void> getttransdetails() async {
    dynamic responsedata;
    var url =
        '$hostname:$port/api/apisstocksummary?id=1&itemtype=$itemtype&transtype=$transtype';
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
        responsedata = jsonDecode(response.body);
        responsedata = json.decode(responsedata[0]);
        for (int i = 0; i < responsedata.length; i++) {
          var data = StockTransdetails.fromJson(responsedata[i]);
          transitemlist.add(StockTransdetails(data.documentname, data.prefix,
              data.count, data.qty, data.amount));
        }
        listlength = transitemlist.length;
        setState(() {
          listlength;
          transitemlist;
        });
      }
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(stocklibrary.transtitlename)),
      body: ListView.builder(
          itemCount: listlength,
          itemBuilder: ((context, index) {
            return Column(
              children: [
                if (index == 0) ...[
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                      height: 15,
                      width: 380,
                      child: Text(
                        '${listlength.toString()} Results found...!',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.indigo,
                          fontSize: 12.0,
                        ),
                      )),
                ],
                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.inventory_2_outlined,
                      color: Colors.blue,
                    ),
                    title: Text(transitemlist[index]
                        .documentname
                        .toString()
                        .toUpperCase()),
                    subtitle: Text(
                      ' ${af.currecyformat(transitemlist[index].amount)}',
                    ),
                    trailing: Text(transitemlist[index].qty.toString(),
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        )),
                    onTap: () {
                      transtype = transitemlist[index].prefix.toString();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) =>
                                  const ItemStockwiseDetail())));
                    },
                  ),
                )
              ],
            );
          })),
    );
  }
}
