import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:apparelapp/management/processprgapproval_main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:marquee/marquee.dart';

class ProcessPrgApprovedetails {
  final String prodprgno;
  final String item;
  final String color;
  final String size;
  final String unit;
  final String inorout;
  final double programquantity;
  String approved;

  ProcessPrgApprovedetails(
      {required this.prodprgno,
      required this.item,
      required this.color,
      required this.size,
      required this.unit,
      required this.inorout,
      required this.programquantity,
      required this.approved});

  factory ProcessPrgApprovedetails.fromJson(Map<String, dynamic> json) {
    return ProcessPrgApprovedetails(
      prodprgno: json['ProdPrgNo'] ?? '',
      item: json['Item'] ?? '',
      color: json['Color'] ?? '',
      size: json['Size'] ?? '',
      unit: json['Unit'] ?? '',
      inorout: json['InOrOut'] ?? '',
      programquantity: json['ProgramQuantity'] != null
          ? json['ProgramQuantity'].toDouble()
          : 0.0,
      approved: json['Approved'],
    );
  }
}

class ProcessPrgAppEditPage extends StatefulWidget {
  final int prodprgid;

  ProcessPrgAppEditPage({required this.prodprgid});

  @override
  _ProcessPrgAppEditPageState createState() => _ProcessPrgAppEditPageState();
}

class _ProcessPrgAppEditPageState extends State<ProcessPrgAppEditPage> {
  List<ProcessPrgApprovedetails> _processPrgEditList = [];
  bool _isLoading = true;
  String? _errorMessage;
  Flushbar? flushbarMessage; // For showing flushbar messages

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
            'http://13.232.84.26:81/api/apiprocessprgappItemedit?id=${widget.prodprgid}'),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['success']) {
          List<ProcessPrgApprovedetails> list = [];
          if (jsonData['processprgedit'] != null) {
            for (var item in jsonData['processprgedit']) {
              list.add(ProcessPrgApprovedetails.fromJson(item));
            }
          }
          setState(() {
            // Sort the list so that input items come first
            list.sort((a, b) => a.inorout.compareTo(b.inorout));
            _processPrgEditList = list;
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

  void _handleApprove(String action) async {
    String prodPrgNo = _processPrgEditList.first.prodprgno;
    String apiUrl =
        'http://13.232.84.26:81/api/updateprocessprgapproval/$prodPrgNo';

    String requestBody = jsonEncode({
      "Approved": action, // Set action to "Y" for approve and "N" for revert
    });

    try {
      var response = await http.put(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['success']) {
          setState(() {
            for (var item in _processPrgEditList) {
              item.approved = action;
            }
          });
          _showFlushbar(
            'Process Program approval updated successfully',
            Colors.green,
            Icons.check_circle,
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProcessProgramApprovalPage(),
            ),
          );
        } else {
          _showFlushbar(
            jsonData['message'] ?? 'Unknown error',
            Colors.red,
            Icons.error,
          );
        }
      } else {
        _showFlushbar(
          'Failed to update Process Program approval: ${response.statusCode}',
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
      duration: Duration(seconds: 2),
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
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.teal,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: SizedBox(
          height: 40,
          child: Marquee(
            text: '${_processPrgEditList.first.prodprgno.toString()}',
            style: TextStyle(color: Colors.teal),
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.center,
            blankSpace: 20.0,
            velocity: 40.0,
            pauseAfterRound: Duration(seconds: 2),
            startPadding: 10.0,
            accelerationDuration: Duration(seconds: 1),
            accelerationCurve: Curves.linear,
            decelerationDuration: Duration(milliseconds: 500),
            decelerationCurve: Curves.easeOut,
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _errorMessage != null
              ? Center(
                  child: Text(_errorMessage!),
                )
              : _processPrgEditList.isEmpty
                  ? Center(
                      child: Text('No data available.'),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: _processPrgEditList.length,
                            itemBuilder: (context, index) {
                              var item = _processPrgEditList[index];

                              String heading =
                                  item.inorout == 'I' ? 'Input' : 'Output';

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (index == 0 ||
                                      _processPrgEditList[index - 1].inorout !=
                                          item.inorout)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 16.0),
                                      child: Text(
                                        heading,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    child: Card(
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: Colors.blue
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Icon(
                                                Icons.assignment,
                                                size: 32,
                                                color: Colors.blue,
                                              ),
                                            ),
                                            SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${item.item}',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    'Color: ${item.color}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    'Size: ${item.size}',
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    'Unit: ${item.unit}',
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    'Quantity: ${item.programquantity}',
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        if (_processPrgEditList.isNotEmpty)
                          ElevatedButton.icon(
                            onPressed: () => _handleApprove(
                                _processPrgEditList.first.approved == 'N'
                                    ? 'Y'
                                    : 'N'),
                            icon: Icon(
                              _processPrgEditList.first.approved == 'N'
                                  ? Icons.check
                                  : Icons.undo,
                            ),
                            label: Text(
                              _processPrgEditList.first.approved == 'N'
                                  ? 'Approve Items'
                                  : 'Revert Items',
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: _processPrgEditList.first.approved == 'N'
                                  ? Colors.green
                                  : Colors.red,
                              onPrimary: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 24.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                        SizedBox(height: 16),
                      ],
                    ),
    );
  }
}
