import 'dart:convert';
import 'dart:io';
import 'package:apparelapp/management/purchasequotedetails.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:another_flushbar/flushbar.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker package

class PurchaseQuotationEditPage extends StatefulWidget {
  final int quoteId;

  PurchaseQuotationEditPage({required this.quoteId});

  @override
  _PurchaseQuotationEditPageState createState() =>
      _PurchaseQuotationEditPageState();
}

class _PurchaseQuotationEditPageState extends State<PurchaseQuotationEditPage> {
  List<PurchaseQuotationEdit> _purchaseQuotationEditList = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _isApproved = false; // Track approval status
  final TextEditingController _attachmentController = TextEditingController(); // Controller for the attachment text box
  final ImagePicker _picker = ImagePicker(); // ImagePicker instance
  File? _selectedImage; // To hold the selected image file

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
            'http://13.232.84.26:81/api/apipurchasequoteedit?quoteid=${widget.quoteId}'),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['success']) {
          List<PurchaseQuotationEdit> list = [];
          if (jsonData['purchasequotes'] != null) {
            for (var item in jsonData['purchasequotes']) {
              list.add(PurchaseQuotationEdit.fromJson(item));
            }
          }
          setState(() {
            _purchaseQuotationEditList = list;
            // Set _isApproved based on the first item's approval status
            if (list.isNotEmpty) {
              _isApproved =
                  list[0].approvedStatus == 'A'; // Assuming 'A' means approved
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

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _attachmentController.text = _selectedImage!.path.split('/').last;
        });
      }
    } catch (e) {
      _showFlushbar(
        'Failed to pick image: $e',
        Colors.red,
        Icons.error,
      );
    }
  }

  void _handleApproval(String action) async {
    final apiUrl =
        'http://13.232.84.26:81/api/updatepurchasequoteapproval/${widget.quoteId}';

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'isApproved': action, // Set action to 'A' for approve and 'P' for reject
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['success']) {
          setState(() {
            _isApproved = action == 'A';
          });
          _showFlushbar(
            _isApproved
                ? 'Purchase Quotation approved successfully'
                : 'Purchase Quotation Reverted successfully',
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
          'Failed to update Purchase Quotation approval: ${response.statusCode}',
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
          'Purchase Quotation Edit',
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
              child: CircularProgressIndicator(),
            )
          : _errorMessage != null
              ? Center(
                  child: Text(_errorMessage!),
                )
              : _purchaseQuotationEditList.isEmpty
                  ? Center(
                      child: Text('No data available.'),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: _purchaseQuotationEditList.length,
                            itemBuilder: (context, index) {
                              var item = _purchaseQuotationEditList[index];

                              return Card(
                                margin: const EdgeInsets.all(8.0),
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Item: ${item.item}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                          'Buy Ord No: ${item.buyordNo ?? 'N/A'}'),
                                      Text('Color: ${item.color}'),
                                      Text('Size: ${item.size}'),
                                      Text('UOM: ${item.uom}'),
                                      Text(
                                          'Rate: ${item.rate.toStringAsFixed(2)}'),
                                      Text(
                                          'Approved Rate: ${item.apprate.toStringAsFixed(2)}'),
                                      Text(
                                          'Min Qty: ${item.minQty.toStringAsFixed(2)}'),
                                      Text(
                                          'Max Qty: ${item.maxQty.toStringAsFixed(2)}'),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              TextField(
                                controller: _attachmentController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: 'Attachment',
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.attach_file),
                                    onPressed: _pickImage,
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () {
                                  _handleApproval(_isApproved ? 'P' : 'A');
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
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
    );
  }
}
