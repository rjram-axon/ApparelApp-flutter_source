import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:apparelapp/main/app_config.dart';
import 'package:apparelapp/management/purchasequotedetails.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

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
  bool _isApproved = false;
  final TextEditingController _attachmentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  int? _selectedItemIndex;
  String? _currentImagePath;
  List<TextEditingController> _rateControllers = [];

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
        'http://${AppConfig().host}:${AppConfig().port}/api/apipurchasequoteedit?quoteid=${widget.quoteId}';

    try {
      final response = await http.get(Uri.parse(apiUrl));

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
            _rateControllers = list
                .map((item) =>
                    TextEditingController(text: item.apprate.toString()))
                .toList();
            if (list.isNotEmpty) {
              _isApproved = list[0].approvedStatus == 'A';
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

  Future<void> _viewAttachment() async {
    if (_currentImagePath == null) {
      _showFlushbar('No attachment available', Colors.red, Icons.error);
      return;
    }

    final String fileUrl = 'http://13.232.84.26:81/$_currentImagePath';

    try {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/${p.basename(_currentImagePath!)}');

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

  void _updateRate() async {
    if (_selectedItemIndex == null) return;

    final selectedItem = _purchaseQuotationEditList[_selectedItemIndex!];
    final apiUrl =
        'http://${AppConfig().host}:${AppConfig().port}/api/updatepurchasequoteapproval/${widget.quoteId}';

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'QuoteDetid': selectedItem.quoteDetid,
          'NewApprate': selectedItem.apprate,
          'isApproved': _isApproved ? 'A' : 'P',
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

  void _handleApproval(String action) async {
    final apiUrl =
        'http://${AppConfig().host}:${AppConfig().port}/api/updatepurchasequoteapproval/${widget.quoteId}';

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'QuoteDetid': _selectedItemIndex != null
              ? _purchaseQuotationEditList[_selectedItemIndex!].quoteDetid
              : null,
          'NewApprate': _selectedItemIndex != null
              ? double.tryParse(_purchaseQuotationEditList[_selectedItemIndex!]
                  .apprate
                  .toString())
              : null,
          'isApproved': action,
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
          Future.delayed(Duration(seconds: 2), () {
            Navigator.pop(context, true);
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
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _attachmentController.text = p.basename(pickedFile.path);
        _currentImagePath = p.basename(pickedFile.path);
      });
    }
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
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _purchaseQuotationEditList.isEmpty
                  ? Center(child: Text('No data available.'))
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
                                                  controller:
                                                      _rateControllers[index],
                                                  keyboardType: TextInputType
                                                      .numberWithOptions(
                                                          decimal: true),
                                                  decoration: InputDecoration(
                                                    labelText:
                                                        'Update Approved Rate',
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      item.apprate =
                                                          double.tryParse(
                                                                  value) ??
                                                              item.apprate;
                                                    });
                                                  },
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
                                  _isApproved
                                      ? Icons.close
                                      : Icons.check_circle,
                                ),
                                label: Text(
                                  _isApproved
                                      ? 'Revert Purchase Quotation'
                                      : 'Approve Purchase Quotation',
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary:
                                      _isApproved ? Colors.red : Colors.green,
                                  onPrimary: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 32.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
    );
  }
}
