import 'package:apparelapp/main/app_config.dart';
import 'package:apparelapp/supplieroutstanding/supplierbasedoutstanding.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:apparelapp/axondatamodal/processoutstandingmodal.dart';
import 'package:apparelapp/axonlibrary/axongeneral.dart';
import 'package:apparelapp/axondatamodal/axonfitrationmodal/processoutstandingfilter.dart';

class ProcessOutstanding extends StatefulWidget {
  const ProcessOutstanding({super.key});

  @override
  State<ProcessOutstanding> createState() => _ProcessOutstandingState();
}

class _ProcessOutstandingState extends State<ProcessOutstanding> {
  int listlength = 0;
  final List<String> itemlist = [];
  final List<ProcessOutstandingModal> _itemlist = [];
  String status = "Wait fetching data...";

  @override
  void initState() {
    super.initState();
    getoutstandingdetails();
  }

  @override
  void dispose() {
    super.dispose();
    itemlist.clear();
    _itemlist.clear();
  }

  Future<void> getoutstandingdetails() async {
    dynamic responsedata;
    var url =
        'http://${AppConfig().host}:${AppConfig().port}/api/apiprocessoutstanding';
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
          var data = ProcessOutstandingModal.fromJson(responsedata[i]);
          _itemlist.add(data);
        }

        listlength = _itemlist.length;

        setState(() {
          status = "Supplier wise outstanding";
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
          'Supplier Wise Outstanding',
          style: TextStyle(color: Color(0xFF0072FF)),
        ),
        leading: IconButton(
          color: Color(0xFF0072FF),
          icon: const Icon(Icons.arrow_back),
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
                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.local_shipping_outlined,
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SupplierBasedOutstanding()));
                    },
                  ),
                ),
              ],
            );
          })),
    );
  }
}
