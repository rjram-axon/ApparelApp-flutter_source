import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:apparelapp/main/app_config.dart';
import 'package:apparelapp/management/processquote_Itemdetails.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart'; // For file paths
import 'package:open_file/open_file.dart'; // For opening files
import 'package:path/path.dart' as p;

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

  void _setAttachment(String? imagePath) {
    _currentImagePath = imagePath;

    if (_currentImagePath != null) {
      String filename = p.basename(_currentImagePath!);
      _attachmentController.text = filename;
    } else {
      _attachmentController.text = 'No attachment';
    }
  }

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final String apiUrl =
        'http://${AppConfig().host}:${AppConfig().port}/api/apiprocessquoteapprovaledit?quoteid=${widget.quoteId}';

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
              _setAttachment(list[0].imgpath);
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

  Future<void> _updateRate() async {
    if (_selectedItemIndex == null) {
      _showFlushbar('No item selected', Colors.red, Icons.error);
      return;
    }

    final apiUrl =
        'http://${AppConfig().host}:${AppConfig().port}/api/updateprocessquoteapproval/${widget.quoteId}';

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'QuoteDetid': _selectedItemIndex != null
              ? _ProcessQuotationEditList[_selectedItemIndex!].quoteDetid
              : null,
          'NewApprate': _selectedItemIndex != null
              ? double.tryParse(
                  _rateController.text,
                )
              : null,
          'isApproved': 'N', // No change in approval status
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['success']) {
          _showFlushbar(
            'Rate updated successfully',
            Colors.green,
            Icons.check_circle,
          );
          setState(() {
            _ProcessQuotationEditList[_selectedItemIndex!].apprate =
                double.parse(_rateController.text);
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
          'Failed to update rate: ${response.statusCode}',
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

  Future<void> _handleApproval(String action) async {
    final apiUrl =
        'http://${AppConfig().host}:${AppConfig().port}/api/updateprocessquoteapproval/${widget.quoteId}';

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'QuoteDetid': _selectedItemIndex != null
              ? _ProcessQuotationEditList[_selectedItemIndex!].quoteDetid
              : null,
          'NewApprate': _selectedItemIndex != null
              ? double.tryParse(
                  _rateController.text,
                )
              : null,
          'isApproved':
              action, // Set action to 'A' for approve and 'P' for reject
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

  Future<void> _viewAttachment() async {
    if (_currentImagePath == null) {
      _showFlushbar('No attachment available', Colors.red, Icons.error);
      return;
    }

    // Full URL using the base path and file name
    final String fileUrl =
        'http://${AppConfig().host}:${AppConfig().port}/$_currentImagePath';

    try {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/${p.basename(_currentImagePath!)}');

      // Download the file from the URL
      final response = await http.get(Uri.parse(fileUrl));

      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        OpenFile.open(file.path);
      } else {
        _showFlushbar(
          'Failed to load attachment: ${response.statusCode}',
          Colors.red,
          Icons.error,
        );
      }
    } catch (e) {
      _showFlushbar(
        'Exception while opening the file: $e',
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
                                                  onPressed: _updateRate,
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
                                  suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // IconButton(
                                      //   icon: Icon(Icons.attach_file),
                                      //   onPressed: _pickImage,
                                      // ),
                                      IconButton(
                                        icon: Icon(Icons.remove_red_eye),
                                        onPressed: _viewAttachment,
                                      ),
                                    ],
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
