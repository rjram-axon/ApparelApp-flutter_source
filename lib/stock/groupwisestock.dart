import 'package:apparelapp/axondatamodal/stockgroupwisemodal.dart';
import 'package:apparelapp/axonlibrary/axongeneral.dart';
import 'package:apparelapp/axonlibrary/axonstocklibrary.dart';
import 'package:apparelapp/main/app_config.dart';
import 'package:apparelapp/stock/transactionwisestock.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:apparelapp/axonlibrary/axonstockmainfilter.dart';

AxonStockLibrary stocklibrary = AxonStockLibrary();

class GroupWiseStock extends StatefulWidget {
  const GroupWiseStock({super.key});

  @override
  State<GroupWiseStock> createState() => _GroupWiseStockState();
}

class _GroupWiseStockState extends State<GroupWiseStock> {
  int listlength = 0;
  List<StockGroupWise> itemlist = [];

  @override
  void initState() {
    super.initState();
    ordtype = "B";
    getstockgroupdetails();
    setState(() {
      listlength;
    });
  }

  @override
  void dispose() {
    super.dispose();
    listlength = 0;
    ordtype = "";
    itemlist.clear();
  }

  void _onTapped(value) {
    itemlist.clear();
    ordtype = value;
    getstockgroupdetails();
  }

  Future<void> getstockgroupdetails() async {
    dynamic responsedata;
    var url =
        'http://${AppConfig().host}:${AppConfig().port}/api/apisstocksummary?otype=$ordtype';
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
        // responsedata = json.decode(response.body.toString());
        //  responsedata = json.decode(responsedata[0]);
        responsedata = jsonDecode(response.body);
        responsedata = json.decode(responsedata[0]);
        for (int i = 0; i < responsedata.length; i++) {
          var data = StockGroupWise.fromJson(responsedata[i]);
          itemlist.add(StockGroupWise(data.itemtype, data.count));
        }

        listlength = itemlist.length;

        setState(() {
          listlength;
        });
      }
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Stock - Group Wise Summary',
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
      body: ListView.builder(
          itemCount: listlength,
          itemBuilder: ((context, index) {
            return Column(
              children: [
                if (index == 0) ...[
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FilterChip(
                        //avatar: const Icon(Icons.book_outlined),
                        label: const Text("Bulk Order"),
                        onSelected: ((value) {
                          _onTapped("B");
                        }),
                        // backgroundColor: Colors.cyan,
                        selectedColor: Colors.cyan,
                        // backgroundColor: Colors.white,
                        //shape: const StadiumBorder(side: BorderSide()),
                      ),
                      FilterChip(
                        label: const Text("Sample Order"),
                        onSelected: ((value) {
                          _onTapped("S");
                        }),
                        selectedColor: Colors.cyan,
                      ),
                      FilterChip(
                        label: const Text("General"),
                        onSelected: ((value) {
                          _onTapped("G");
                        }),
                        selectedColor: Colors.cyan,
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                ],
                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.inventory_2_outlined,
                      color: Colors.purple,
                    ),
                    title:
                        Text(itemlist[index].itemtype.toString().toUpperCase()),
                    /* trailing: Text(
                      itemlist[index].count.toString(),
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        //backgroundColor: Colors.blue,
                      ), 
                    ),*/
                    onTap: () {
                      itemtype = itemlist[index].itemtype.toString();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) =>
                                  const Transactionwisestock())));
                    },
                  ),
                )
              ],
            );
          })),
    );
  }
}
