import 'package:apparelapp/axondatamodal/axonfitrationmodal/orderwisestockfilter.dart';
import 'package:apparelapp/main.dart';
import 'package:apparelapp/management/mainbudgetapproval.dart';
import 'package:apparelapp/management/processorderapp_main.dart';
import 'package:apparelapp/management/processprgapproval_main.dart';
import 'package:apparelapp/management/processquote_Main.dart';
import 'package:apparelapp/management/spl_requition_approvalMain.dart';
import 'package:apparelapp/management/purchasequoteapproval.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'main_purchase_approval.dart';
import 'purchase_order.dart'; // Assuming this is your custom class
import 'dart:convert';
import 'package:apparelapp/management/purchase_approval_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

import '../axonlibrary/axongeneral.dart';
import 'purchase_order.dart'; // Add this import statement

class Approvals extends StatefulWidget {
  @override
  _ApprovalsState createState() => _ApprovalsState();
}

class _ApprovalsState extends State<Approvals> {
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
        body: Column(children: [
          SizedBox(height: 16.0),
          // Smooth page indicator

          Expanded(
            child: GridView.count(
              // shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              crossAxisSpacing: 3, //10
              mainAxisSpacing: 20, //5
              crossAxisCount: 2,
              padding: const EdgeInsets.all(10.0),
              children: <Widget>[
                Card(
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
                              icon: const Icon(Icons.local_mall_rounded),
                              iconSize: 70,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MainPurchaseApproval(),
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
                                builder: (context) => MainPurchaseApproval(),
                              ),
                            );
                          },
                          child: Text(
                            'Purchase Approval',
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
                ),
                Card(
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
                              icon: const Icon(Icons.receipt_long_rounded),
                              iconSize: 70,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainBudgetApproval(),
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
                                builder: (context) => MainBudgetApproval(),
                              ),
                            );
                          },
                          child: Text(
                            'Budget Approval',
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
                ),
                Card(
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
                              icon: const Icon(Icons.assignment),
                              iconSize: 70,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProcessApprovalPage(),
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
                                builder: (context) => MainBudgetApproval(),
                              ),
                            );
                          },
                          child: Text(
                            'Process Order',
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
                ),
                Card(
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
                              icon: const Icon(Icons.hourglass_bottom_rounded),
                              iconSize: 70,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProcessProgramApprovalPage(),
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
                                builder: (context) =>
                                    ProcessProgramApprovalPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Shortage Approval',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'roboto',
                              letterSpacing: 0,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
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
                              icon: const Icon(
                                  Icons.assignment_turned_in_rounded),
                              iconSize: 70,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SpecialRequitionApprovalPage(),
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
                                builder: (context) =>
                                    SpecialRequitionApprovalPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Special Requition Approval',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'roboto',
                              letterSpacing: 0,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
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
                              icon: const Icon(Icons.shopping_cart_outlined),
                              iconSize: 70,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PurchaseQuotationApprovalPage(),
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
                                builder: (context) =>
                                    PurchaseQuotationApprovalPage(),
                              ),
                            );
                          },
                          child: Text(
                            'PurchaseQuotation Approval',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'roboto',
                              letterSpacing: 0,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
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
                              icon: const Icon(Icons.business_center_rounded),
                              iconSize: 70,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProcessQuotationApprovalPage(),
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
                                builder: (context) =>
                                    ProcessQuotationApprovalPage(),
                              ),
                            );
                          },
                          child: Text(
                            'ProcessQuotation Approval',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'roboto',
                              letterSpacing: 0,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ]));
  }
}
