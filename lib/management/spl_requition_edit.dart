import 'dart:convert';
import 'package:apparelapp/main/app_config.dart';
import 'package:apparelapp/management/splrequitionappDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:another_flushbar/flushbar.dart';

class SpecialRequitionEditPage extends StatefulWidget {
  final int reqId;
  final String jobordno;

  const SpecialRequitionEditPage({required this.reqId, required this.jobordno});

  @override
  _SpecialRequitionEditPageState createState() =>
      _SpecialRequitionEditPageState();
}

class _SpecialRequitionEditPageState extends State<SpecialRequitionEditPage> {
  List<ApiSplReqeditdetails> splReqEditDetails = [];
  bool _isApproved = false; // Track overall approval status
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse(
            'http://${AppConfig().host}:${AppConfig().port}/api/apisplreqappItemedit?reqid=${widget.reqId}'),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['success']) {
          List<ApiSplReqeditdetails> list = [];
          if (jsonData['splreqedit'] != null) {
            for (var item in jsonData['splreqedit']) {
              list.add(ApiSplReqeditdetails.fromJson(item));
            }
          }
          setState(() {
            splReqEditDetails = list;
            // Set _isApproved based on the first item's approval status
            if (list.isNotEmpty) {
              _isApproved = list[0].isapproved == 'Y';
            }
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = jsonData['message'] ?? 'Unknown error';
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Failed to connect to the server. Please check your internet connection.';
      });
    }
  }

  void _handleApproval(String action) async {
    final apiUrl =
        'http://${AppConfig().host}:${AppConfig().port}/api/updatesplreqapproval/${widget.jobordno}';

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'IsApproved':
              action, // Set action to 'Y' for approve and 'N' for reject
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['success']) {
          setState(() {
            _isApproved = action == 'Y';
          });
          _showFlushbar(
            _isApproved
                ? 'Special Requisition approved successfully'
                : 'Special Requisition reverted successfully',
            _isApproved ? Colors.green : Colors.red,
            _isApproved ? Icons.check_circle : Icons.close,
          );
          Future.delayed(Duration(seconds: 1), () {
            Navigator.pop(context, true); // Return true to indicate success
          });
        } else {
          _showFlushbar(
            jsonData['message'] ?? 'Unknown error',
            Colors.red,
            Icons.error,
          );
        }
      } else {
        _showFlushbar(
          'Failed to update Special Requisition approval: ${response.statusCode}',
          Colors.red,
          Icons.error,
        );
      }
    } catch (e) {
      _showFlushbar(
        'Exception during API call: $e',
        Colors.red,
        Icons.error,
      );
    }
  }

  void _showFlushbar(String message, Color backgroundColor, IconData iconData) {
    Flushbar(
      message: message,
      duration: Duration(seconds: 1),
      backgroundColor: backgroundColor,
      borderRadius: BorderRadius.circular(10.0),
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(16.0),
      icon: Icon(
        iconData,
        color: Colors.white,
      ),
      leftBarIndicatorColor: backgroundColor,
      flushbarPosition: FlushbarPosition.TOP,
    )..show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Special Requisition Edit',
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
      body: _isLoading
          ? Center(
              child: SpinKitFadingCircle(
                color: Colors.blue,
                size: 50.0,
              ),
            )
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : splReqEditDetails.isEmpty
                  ? Center(child: Text('No data available.'))
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: splReqEditDetails.length,
                            itemBuilder: (context, index) {
                              final splReqEdit = splReqEditDetails[index];
                              return Card(
                                margin: EdgeInsets.all(10.0),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Item: ${splReqEdit.item}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text('Color: ${splReqEdit.color}'),
                                      Text('Size: ${splReqEdit.size}'),
                                      Text('Unit: ${splReqEdit.unit}'),
                                      Text('Quantity: ${splReqEdit.quantity}'),
                                      Text('Mode: ${splReqEdit.mode}'),
                                      Text('Pur Unit: ${splReqEdit.purUnit}'),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _handleApproval(_isApproved ? 'N' : 'Y');
                            },
                            icon: Icon(
                              _isApproved ? Icons.undo : Icons.check,
                            ),
                            label: Text(
                              _isApproved ? 'Revert Items' : 'Approve Items',
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: _isApproved ? Colors.red : Colors.green,
                              onPrimary: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 24.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
    );
  }
}
