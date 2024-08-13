import 'package:apparelapp/main/app_config.dart';
import 'package:apparelapp/management/purchasequote_approve.dart';
import 'package:apparelapp/management/purchasequotedetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PurchaseQuotationApprovalPage extends StatefulWidget {
  @override
  _PurchaseQuotationApprovalPageState createState() =>
      _PurchaseQuotationApprovalPageState();
}

class _PurchaseQuotationApprovalPageState
    extends State<PurchaseQuotationApprovalPage> {
  bool _isApproved = false;
  List<PurchaseQuotation> _purchaseQuotations = [];
  bool _loading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchPurchaseQuotations();
  }

  Future<void> _fetchPurchaseQuotations() async {
    setState(() {
      _loading = true;
      _error = '';
    });

    final String status = _isApproved ? 'A' : 'P';
    final String apiUrl =
        'http://${AppConfig().host}:${AppConfig().port}/api/apipurchasequoteapproval?isapproved=$status';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success']) {
          final List<dynamic> quotationsJson = jsonResponse['purchasequotes'];
          setState(() {
            _purchaseQuotations = quotationsJson
                .map((json) => PurchaseQuotation.fromJson(json))
                .toList();
          });
        } else {
          setState(() {
            _error = jsonResponse['message'] ?? 'Failed to load quotations';
          });
        }
      } else {
        setState(() {
          _error = 'Failed to load quotations';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _setApprovalStatus(bool isApproved) {
    setState(() {
      _isApproved = isApproved;
    });
    _fetchPurchaseQuotations();
  }

  Future<void> _navigateToEditPage(int quoteId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PurchaseQuotationEditPage(quoteId: quoteId),
      ),
    );

    if (result == true) {
      // Reload the list if the result is true
      _fetchPurchaseQuotations();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Purchase Quotation Approval',
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
                    primary: _isApproved ? Colors.green : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Approved'),
                ),
                ElevatedButton(
                  onPressed: () => _setApprovalStatus(false),
                  style: ElevatedButton.styleFrom(
                    primary: !_isApproved ? Colors.orange[400] : Colors.grey,
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
            child: _loading
                ? Center(
                    child: SpinKitFadingCircle(
                      color: Colors.blue,
                      size: 50.0,
                    ),
                  )
                : _error.isNotEmpty
                    ? Center(child: Text(_error))
                    : ListView.builder(
                        itemCount: _purchaseQuotations.length,
                        itemBuilder: (context, index) {
                          final quotation = _purchaseQuotations[index];
                          return Card(
                            margin: const EdgeInsets.all(8.0),
                            elevation: 6.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: InkWell(
                              onTap: () async {
                                await _navigateToEditPage(quotation.quoteid);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.receipt_rounded,
                                            color: Colors.blue),
                                        SizedBox(width: 8.0),
                                        Expanded(
                                          child: Text(
                                            'Entry No: ${quotation.entryNo}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      'Quote NO: ${quotation.quoteNo}',
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                    Text(
                                      'Supplier: ${quotation.supplier}',
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                    Text(
                                      'Entry Date: ${quotation.entryDate}',
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                    Text(
                                      'Quote Date: ${quotation.quoteDate.isEmpty ? 'N/A' : quotation.quoteDate}',
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                    Text(
                                      'Buy Ord General: ${quotation.buyOrdGeneral.isEmpty ? 'N/A' : quotation.buyOrdGeneral}',
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
