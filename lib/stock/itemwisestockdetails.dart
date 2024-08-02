import 'package:apparelapp/axondatamodal/itemwisestockdetailsmodal.dart';
import 'package:apparelapp/axonlibrary/axongeneral.dart';
import 'package:apparelapp/axonlibrary/axonstocklibrary.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../axonlibrary/axonstockmainfilter.dart';
import 'dart:convert';

AxonStockLibrary astock = AxonStockLibrary();

class ItemStockwiseDetail extends StatefulWidget {
  const ItemStockwiseDetail({super.key});

  @override
  State<ItemStockwiseDetail> createState() => _ItemStockwiseDetailState();
}

class _ItemStockwiseDetailState extends State<ItemStockwiseDetail> {
  int listlength = 0;
  List<ItemWiseStockdetails> itemdetaillist = [];

  @override
  void initState() {
    super.initState();
    getitemdetails();
    setState(() {
      listlength;
    });
  }

  @override
  void dispose() {
    super.dispose();
    itemdetaillist.clear();
    listlength = 0;
  }

  Future<void> getitemdetails() async {
    dynamic responsedata;
    var url =
        '$hostname:$port/api/apisstocksummary?id=2&itemtype=$itemtype&transtype=$transtype';
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
          var data = ItemWiseStockdetails.fromJson(responsedata[i]);
          itemdetaillist.add(
              ItemWiseStockdetails(data.item, data.abbreviation, data.qty));
        }
        listlength = itemdetaillist.length;
        setState(() {
          listlength;
          itemdetaillist;
        });
      }
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(astock.itemwisetitlename)),
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
                    title: Text(itemdetaillist[index].item.toString()),
                    trailing: Text(
                        '${itemdetaillist[index].qty.toString()} ${itemdetaillist[index].abbreviation.toString()}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        )),
                    onTap: () {},
                  ),
                )
              ],
            );
          })),
    );
  }
}
