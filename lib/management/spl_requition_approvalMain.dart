import 'dart:convert';
import 'package:apparelapp/main/app_config.dart';
import 'package:apparelapp/management/spl_requition_edit.dart';
import 'package:apparelapp/management/splrequitionappDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class SpecialRequitionApprovalPage extends StatefulWidget {
  @override
  _SpecialRequitionApprovalPageState createState() =>
      _SpecialRequitionApprovalPageState();
}

class _SpecialRequitionApprovalPageState
    extends State<SpecialRequitionApprovalPage> {
  bool _isApproved = false;
  late Future<List<ApiSplReqdetails>> futureSplReqDetails;

  @override
  void initState() {
    super.initState();
    futureSplReqDetails = fetchSplReqDetails(_isApproved ? 'Y' : 'N');
  }

  Future<List<ApiSplReqdetails>> fetchSplReqDetails(String isApproved) async {
    final response = await http.get(
      Uri.parse(
          'http://${AppConfig().host}:${AppConfig().port}/api/apisplreqapproval?isapproved=$isApproved'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['success']) {
        List<dynamic> body = jsonResponse['splreqs'];
        List<ApiSplReqdetails> splReqDetails = body
            .map((dynamic item) => ApiSplReqdetails.fromJson(item))
            .toList();
        return splReqDetails;
      } else {
        throw ('No purchases found.');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  void _setApprovalStatus(bool isApproved, {bool reload = true}) {
    setState(() {
      _isApproved = isApproved;
      if (reload) {
        futureSplReqDetails = fetchSplReqDetails(_isApproved ? 'Y' : 'N');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Special Requisition Approval',
          style: TextStyle(color: Colors.teal),
        ),
        leading: IconButton(
          color: Colors.teal,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _setApprovalStatus(true),
                  style: ElevatedButton.styleFrom(
                    primary: _isApproved ? Colors.green : Colors.grey[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Approved'),
                ),
                ElevatedButton(
                  onPressed: () => _setApprovalStatus(false),
                  style: ElevatedButton.styleFrom(
                    primary:
                        !_isApproved ? Colors.orange[400] : Colors.grey[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Pending'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ApiSplReqdetails>>(
              future: futureSplReqDetails,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitFadingCircle(
                      color: Colors.blue,
                      size: 50.0,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No purchases found.'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final splReq = snapshot.data![index];
                      return GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SpecialRequitionEditPage(
                                reqId: splReq.reqId,
                                jobordno: splReq.jobOrdNo,
                              ),
                            ),
                          );
                          if (result == true) {
                            // If the result is true, reload the data
                            _setApprovalStatus(_isApproved, reload: true);
                          }
                        },
                        child: Card(
                          margin: EdgeInsets.all(10.0),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.description,
                                      color: Colors.blue,
                                      size: 40.0,
                                    ),
                                    SizedBox(width: 15.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Req No: ${splReq.splReqNo}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            'Ref No: ${splReq.refNo}',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            'Order No: ${splReq.orderNo ?? 'N/A'}',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            'Job Order No: ${splReq.jobOrdNo}',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            'Order Date: ${splReq.orderDate}',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
