import 'dart:convert';
import 'package:apparelapp/axonlibrary/axongeneral.dart';
import 'package:flutter/material.dart';
import '../axondatamodal/axonfitrationmodal/processoutstandingfilter.dart';
import '../axondatamodal/processoutstanding/processorderwiseoutstanding.dart';
import 'package:http/http.dart' as http;

class Processorderwisedetails extends StatefulWidget {
  const Processorderwisedetails({super.key});

  @override
  State<Processorderwisedetails> createState() =>
      _ProcessorderwisedetailsState();
}

class _ProcessorderwisedetailsState extends State<Processorderwisedetails> {
  int listlength = 0;
  String status = "Wait fetching data...";
  final List<ProcessorderWiseOutstandingModal> _itemlist = [];

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
    var url =
        '$hostname:$port/api/apiprocessoutstanding?supplierid=$outsupplierid&processid=$outprocessid';
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
          var data = ProcessorderWiseOutstandingModal.fromJson(responsedata[i]);
          _itemlist.add(data);
        }

        listlength = _itemlist.length;

        setState(() {
          status = outprocess!;
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
                    title: Text(
                        _itemlist[index].processorder.toString().toUpperCase()),
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
                  ),
                ),
              ],
            );
          })),
    );
  }
}
