import 'package:apparelapp/main.dart';
import 'package:apparelapp/main/app_config.dart';
import 'package:apparelapp/management/mainbudgetapproval.dart';
import 'package:apparelapp/management/processorderapp_main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main_purchase_approval.dart';
import 'purchase_approval_list.dart';
import 'processprgapproval_main.dart';
import 'purchasequoteapproval.dart';
import 'spl_requition_approvalMain.dart';
import 'processquote_Main.dart';

class Approvals extends StatefulWidget {
  @override
  _ApprovalsState createState() => _ApprovalsState();
}

class _ApprovalsState extends State<Approvals> {
  bool _loading = true;
  bool _showProcessOrderApproval = false;
  bool _showPurchaseApproval = false;
  bool _showPurchaseQuotationApproval = false;
  bool _showProcessQuotationApproval = false;

  @override
  void initState() {
    super.initState();
    _fetchApprovalStatus();
  }

  Future<void> _fetchApprovalStatus() async {
    try {
      final response = await http.get(Uri.parse(
          'http://${AppConfig().host}:${AppConfig().port}/api/apimispath')); // Replace with your API URL

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          setState(() {
            _showProcessOrderApproval =
                data['mispaths'][0]['ValidateProcessOrderApproval'] ?? false;
            _showPurchaseApproval =
                (data['mispaths'][0]['ValidatePOApproval'] == 'Y' ||
                    data['mispaths'][0]['ValidatePOGerApproval'] == 'Y');
            _showPurchaseQuotationApproval =
                data['mispaths'][0]['chkValidateQuoteDetailsForPO'] ?? false;
            _showProcessQuotationApproval = data['mispaths'][0]
                    ['chkValidateQuoteDetailsForProcessOrder'] ??
                false;
            _loading = false;
          });
        } else {
          setState(() {
            _loading = false;
          });
        }
      } else {
        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print('Error fetching approval status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            'Approvals',
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
        body: _loading
            ? Center(child: CircularProgressIndicator())
            : Column(children: [
                SizedBox(height: 16.0),
                Expanded(
                  child: GridView.count(
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 20,
                    crossAxisCount: 2,
                    padding: const EdgeInsets.all(10.0),
                    children: <Widget>[
                      if (_showPurchaseApproval)
                        _buildApprovalCard(
                          context,
                          icon: Icons.local_mall_rounded,
                          label: 'Purchase Approval',
                          page: MainPurchaseApproval(),
                        ),
                      _buildApprovalCard(
                        context,
                        icon: Icons.receipt_long_rounded,
                        label: 'Budget Approval',
                        page: MainBudgetApproval(),
                      ),
                      if (_showProcessOrderApproval)
                        _buildApprovalCard(
                          context,
                          icon: Icons.assignment,
                          label: 'Process Order',
                          page: ProcessApprovalPage(),
                        ),
                      _buildApprovalCard(
                        context,
                        icon: Icons.hourglass_bottom_rounded,
                        label: 'Shortage Approval',
                        page: ProcessProgramApprovalPage(),
                      ),
                      _buildApprovalCard(
                        context,
                        icon: Icons.assignment_turned_in_rounded,
                        label: 'Special Requisition Approval',
                        page: SpecialRequitionApprovalPage(),
                      ),
                      if (_showPurchaseQuotationApproval)
                        _buildApprovalCard(
                          context,
                          icon: Icons.shopping_cart_outlined,
                          label: 'Purchase Quotation Approval',
                          page: PurchaseQuotationApprovalPage(),
                        ),
                      if (_showProcessQuotationApproval)
                        _buildApprovalCard(
                          context,
                          icon: Icons.business_center_rounded,
                          label: 'Process Quotation Approval',
                          page: ProcessQuotationApprovalPage(),
                        ),
                    ],
                  ),
                )
              ]));
  }

  Widget _buildApprovalCard(BuildContext context,
      {required IconData icon, required String label, required Widget page}) {
    return Card(
      shadowColor: Colors.amber.withOpacity(0.4),
      elevation: 10,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
          style: BorderStyle.solid,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Center(
              child: SizedBox(
                width: dashboard.maxsizedboxwidth,
                height: dashboard.minimagesizeboxheight,
                child: IconButton(
                  color: Colors.teal[500],
                  icon: Icon(icon),
                  iconSize: 70,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => page,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => page,
                  ),
                );
              },
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'roboto',
                  letterSpacing: 0,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
