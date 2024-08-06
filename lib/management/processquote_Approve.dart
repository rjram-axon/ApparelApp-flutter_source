import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:apparelapp/management/processquote_Itemdetails.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ProcessQuotationEditPage extends StatefulWidget {
  final int quoteId;

  ProcessQuotationEditPage({required this.quoteId});

  @override
  _ProcessQuotationEditPageState createState() =>
      _ProcessQuotationEditPageState();
}

class _ProcessQuotationEditPageState extends State<ProcessQuotationEditPage> {
  List<ProcessQuotationEdit> _ProcessQuotationEditList = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _isApproved = false; // Track approval status
  final TextEditingController _attachmentController =
      TextEditingController(); // Controller for the attachment text box
  final TextEditingController _rateController =
      TextEditingController(); // Controller for approved rate
  final ImagePicker _picker = ImagePicker(); // ImagePicker instance
  File? _selectedImage; // To hold the selected image file
  int? _selectedItemIndex; // To keep track of which card is selected
  String? _currentImagePath; // To hold the current image path

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
    final String apiUrl =
        'http://13.232.84.26:81/api/apiprocessquoteapprovaledit?quoteid=${widget.quoteId}';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['success']) {
          List<ProcessQuotationEdit> list = [];
          if (jsonData['processquoteedit'] != null) {
            for (var item in jsonData['processquoteedit']) {
              list.add(ProcessQuotationEdit.fromJson(item));
            }
          }
          setState(() {
            _ProcessQuotationEditList = list;
            // Set _isApproved based on the first item's approval status
            if (list.isNotEmpty) {
              _isApproved =
                  list[0].approvedStatus == 'A'; // Assuming 'A' means approved
              // Set the image path if available
              _currentImagePath = list[0].imgpath;
              _attachmentController.text = _currentImagePath ?? 'No attachment';
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
          _attachmentController.text = pickedFile.path.split('/').last;
          _currentImagePath = pickedFile.path;
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
          'isApproved':
              action, // Set action to 'A' for approve and 'P' for reject
          'imgpath': _currentImagePath, // Include the image path
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

  void _onCardTap(int index) {
    setState(() {
      _selectedItemIndex = _selectedItemIndex == index ? null : index;
      if (_selectedItemIndex != null) {
        // Set the rateController text to the current approved rate if available
        _rateController.text =
            _ProcessQuotationEditList[_selectedItemIndex!].apprate.toString();
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
          'Process Quotation Edit',
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
              : _ProcessQuotationEditList.isEmpty
                  ? Center(
                      child: Text('No data available.'),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: _ProcessQuotationEditList.length,
                            itemBuilder: (context, index) {
                              var item = _ProcessQuotationEditList[index];

                              return Card(
                                margin: const EdgeInsets.all(8.0),
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: InkWell(
                                  onTap: () => _onCardTap(index),
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
                                        if (_selectedItemIndex == index)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TextField(
                                                  controller: _rateController,
                                                  keyboardType: TextInputType
                                                      .numberWithOptions(
                                                          decimal: true),
                                                  decoration: InputDecoration(
                                                    labelText:
                                                        'Update Approved Rate',
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                ),
                                                SizedBox(height: 8.0),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    // _updateApprovedRate(index);
                                                  },
                                                  child: Text('Update Rate'),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors.teal,
                                                    onPrimary: Colors.white,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 12.0,
                                                            horizontal: 24.0),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
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
                                  _isApproved
                                      ? 'Revert Items'
                                      : 'Approve Items',
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary:
                                      _isApproved ? Colors.red : Colors.green,
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
