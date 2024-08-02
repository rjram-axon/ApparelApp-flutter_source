import 'package:apparelapp/axondatamodal/processoutstanding/supplierwiseprocessoutsatingmodal.dart';
import 'package:apparelapp/supplieroutstanding/processorderwisedetails.dart';
import 'package:flutter/material.dart';
import 'package:apparelapp/axondatamodal/axonfitrationmodal/processoutstandingfilter.dart';
import 'package:http/http.dart' as http;
import '../axonlibrary/axongeneral.dart';
import 'dart:convert';

class SupplierBasedOutstanding extends StatefulWidget {
  const SupplierBasedOutstanding({super.key});

  @override
  State<SupplierBasedOutstanding> createState() =>
      _SupplierBasedOutstandingState();
}

class _SupplierBasedOutstandingState extends State<SupplierBasedOutstanding> {
  int listlength = 0;
  String status = "Wait fetching data...";
  final List<SupplierWiseProcessOutstandingModal> _itemlist = [];

  @override
  void initState() {
    super.initState();
    getstockdetails();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getstockdetails() async {
    dynamic responsedata;
    var url = '$hostname:$port/api/apiprocessoutstanding/$outsupplierid';
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
          var data =
              SupplierWiseProcessOutstandingModal.fromJson(responsedata[i]);
          _itemlist.add(data);
        }

        listlength = _itemlist.length;

        setState(() {
          status = outsupplier!;
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
                      Icons.local_shipping_outlined,
                      color: Colors.purple,
                    ),
                    title:
                        Text(_itemlist[index].process.toString().toUpperCase()),
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
                      outprocessid = _itemlist[index].processid;
                      outprocess = _itemlist[index].process;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const Processorderwisedetails()));
                    },
                  ),
                ),
              ],
            );
          })),
    );
  }
}
