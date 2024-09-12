import 'package:apparelapp/axondatamodal/axonfitrationmodal/budgerapprovalmainlist.dart';
import 'package:apparelapp/axonlibrary/axonbudgetlibrary.dart';
import 'package:apparelapp/axonlibrary/axonfunctions.dart';
import 'package:apparelapp/main/app_config.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:apparelapp/axondatamodal/budgetapprovalmainlistmodal.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marquee/marquee.dart';
import '../axondatamodal/axonfitrationmodal/axonbudgetdetailmodal.dart';
import '../axondatamodal/budgetapprovaldetailmodal.dart';
import '../axonlibrary/axongeneral.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:collection/collection.dart';

import '../costingreport.dart/costingreport.dart';

class BudgetApproval extends StatefulWidget {
  const BudgetApproval({super.key, required orderno, required styleid});

  @override
  State<BudgetApproval> createState() => _BudgetApprovalState();
}

class _BudgetApprovalState extends State<BudgetApproval> {
  int _selectedIndex = 0;
  int budgetlistlength = 0;
  String? selectedProcess; // Define as nullable
  AxonBudgetLibrary budgetlib = AxonBudgetLibrary();
  late IconData iconname = Icons.verified_user_sharp;
  late IconData statusIcon;
  final List<dynamic> _allbudgetitems = [];
  final List<dynamic> _budgetitems = [];
  final List<dynamic> _comitems = [];
  final List<Budgetdetmodal> _postitemdet = [];
  final List<Budgetdetmodal> _commdet = [];
  final List<dynamic> _costlist = [];
  final List<BudgetMainItem> _mainitemlist = [];
  final List<dynamic> _itemlist = [];
  final List<BudgetDetailModal> _itemlistforprocess = [];

  Map<String, List<BudgetDetailModal>> groupedItems = {};

// Method to group items
  void groupItems() {
    // Ensure _itemlist is of type List<BudgetDetailModal>
    void groupItems() {
      groupedItems = groupBy(
        _itemlistforprocess.where((item) => item.process != null),
        (BudgetDetailModal item) => item.process!,
      );
    }
  }

  //final List<dynamic> _comlist = [];
  TextEditingController apprate = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController txtsearchcontroller = TextEditingController();
  late Budgetorderdetails orderdetails;
  late String quantitydetails = "";
  bool _isLoading = false; // Variable to track data fetching state

  double yarncost = 0.0;
  double fabriccost = 0.0;
  double processcost = 0.0;
  double productioncost = 0.0;
  double trimscost = 0.0;
  double comcost = 0.0;
  double totcost = 0.0;
  double salesprice = 0.0;
  double profitper = 0.0;
  double profitval = 0.0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    getbudgetdetails();
  }

  @override
  void dispose() {
    super.dispose();
    txtsearchcontroller.text = "";
    budgetlistlength = 0;
    _budgetitems.clear();
    _allbudgetitems.clear();
    forderno = "";
    fstyleid = 0;
  }

  void _onItemTapped(int index) {
    budgetlistlength = 0;
    _selectedIndex = index;
    _budgetitems.clear();

    switch (_selectedIndex) {
      case 0:
        for (int i = 0; i < _allbudgetitems.length; i++) {
          if (_allbudgetitems[i].process == "") {
            _budgetitems.add(_allbudgetitems[i]);
          }
        }
        _budgetitems
            .sort(((a, b) => a.seqno.toInt().compareTo(b.seqno.toInt())));
        budgetlistlength = _budgetitems.length;
        iconname = Icons.add_shopping_cart_rounded;
        break;

      case 1:
        bool allProcessesEmpty = true;

        // First pass: Check if all processes are empty
        for (var item in _allbudgetitems) {
          if (item.process != null && item.process.trim().isNotEmpty) {
            allProcessesEmpty = false; // Found a non-empty process
            break;
          }
        }

        if (allProcessesEmpty) {
          // Show a message using another_flushbar if all processes are empty
          showMessage("This order do not have any process.");
          return; // Exit the function since there is no need to process further
        }

        // Second pass: Add items with non-empty processes
        for (var item in _allbudgetitems) {
          if (item.process != null && item.process.trim().isNotEmpty) {
            _budgetitems.add(item);
          }
        }
        _budgetitems.sort(
            ((a, b) => a.process.toString().compareTo(b.process.toString())));
        budgetlistlength = _budgetitems.length;
        iconname = Icons.local_shipping_outlined;
        break;

      case 2:
        budgetlistlength = _comitems.length;
        iconname = Icons.assessment_outlined;
        break;

      case 3:
        budgetlistlength = 1;
        iconname = Icons.summarize_outlined;
        calculatecost();
        break;
    }

    if (_selectedIndex < 2) {
      itemlistsplit();
      budgetlistlength = _mainitemlist.length;
    }

    setState(() {
      _selectedIndex;
      _budgetitems;
      _mainitemlist;
      _itemlist;
      budgetlistlength;
    });
  }

  void showMessage(String message) {
    Flushbar(
      message: message,
      icon: Icon(
        Icons.error_outline,
        size: 30.0,
        color: Colors.red,
      ),
      duration: Duration(seconds: 4),
      leftBarIndicatorColor: Colors.red,
      flushbarPosition: FlushbarPosition.TOP, // Set position to TOP
      flushbarStyle: FlushbarStyle.FLOATING,
      backgroundColor: Colors.black, // Background color
      borderRadius: BorderRadius.circular(12.0), // Rounded corners
      margin: EdgeInsets.all(4.0), // Optional: Margin around the Flushbar
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    )..show(context);
  }

  void penfingstatusfilter() {
    _itemlist.clear();
    _mainitemlist.clear();
    itemlistsplit();
    // _itemlist.clear();
    //_onItemTapped(_selectedIndex);
    _itemlist.retainWhere((element) => element.status == 0);
    if (_itemlist.isEmpty) {
      budgetlistlength = 0;
      _mainitemlist.clear();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Information"),
            content: ListTile(
              leading: Icon(Icons.info_outline_rounded, color: Colors.blue),
              title: Text("All items are approved, no items are pending."),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      budgetlistlength = _mainitemlist.length;
    }

    setState(() {
      _itemlist;
      _mainitemlist;
      budgetlistlength;
    });
  }

  void approvedstatusfilter() {
    _itemlist.clear();
    _mainitemlist.clear();
    itemlistsplit();
    // _itemlist.clear();
    //_onItemTapped(_selectedIndex);
    _itemlist.retainWhere((element) => element.status == 1);
    if (_itemlist.length.toString() == "0") {
      budgetlistlength = 0;
      _mainitemlist.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.white,
          content: ListTile(
            leading: Icon(Icons.info_outline_rounded, color: Colors.blue),
            title: Text("All items are approved no items having pending..!"),
          )));
    } else {
      budgetlistlength = _mainitemlist.length;
    }
    setState(() {
      _itemlist;
      _mainitemlist;
      budgetlistlength;
    });
  }

  void calculatecost() {
    for (int i = 0; i < _allbudgetitems.length; i++) {
      switch (_allbudgetitems[i].accesstype) {
        case "BOM-YARN":
          yarncost =
              yarncost + double.parse(_allbudgetitems[i].amount.toString());
          break;
        case "BOM-ACCEORIES":
          trimscost =
              trimscost + double.parse(_allbudgetitems[i].amount.toString());
          break;
        case "PROCESS":
          processcost =
              processcost + double.parse(_allbudgetitems[i].amount.toString());
          break;
        case "PRODUCTION":
          productioncost = productioncost +
              double.parse(_allbudgetitems[i].amount.toString());
          break;
      }
    }

    for (int i = 0; i < _comitems.length; i++) {
      comcost = comcost + double.parse(_comitems[i].amount.toString());
    }

    yarncost = (yarncost / orderdetails.quantity!.toDouble());
    trimscost = (trimscost / orderdetails.quantity!.toDouble());
    processcost = (processcost / orderdetails.quantity!.toDouble());
    productioncost = (productioncost / orderdetails.quantity!.toDouble());
    comcost = (comcost / orderdetails.quantity!.toDouble());

    totcost = yarncost + trimscost + processcost + productioncost + comcost;
  }

  void updateAppRate(int costDefnBomId, String newRate) {
    if (newRate.isNotEmpty) {
      try {
        double apprateValue = double.parse(newRate);
        setState(() {
          for (var item in _itemlist) {
            if (item.cost_defn_bomid == costDefnBomId) {
              item.apprate = apprateValue;
              item.amount = item.quantity * apprateValue;
              // item.status = apprateValue > 0 ? 1 : 0;
            }
          }
        });
      } catch (e) {
        print("Invalid rate: $newRate");
      }
    }
  }

  void updateAppRateByProcess(String processName, String newRate) {
    if (newRate.isNotEmpty) {
      try {
        double apprateValue = double.parse(newRate);
        setState(() {
          for (var item in _itemlist) {
            if (item.process.toString() == processName) {
              item.apprate = apprateValue;
              item.amount = item.quantity * apprateValue;
              // item.status = apprateValue > 0 ? 1 : 0;
            }
          }
        });
      } catch (e) {
        print("Invalid rate: $newRate");
      }
    }
  }

  Flushbar? flushbarMessage;

  void _showFlushbar(String message, Color backgroundColor, IconData iconData) {
    flushbarMessage?.dismiss();
    flushbarMessage = Flushbar(
      message: message,
      duration: Duration(seconds: 1),
      backgroundColor: backgroundColor,
      borderRadius: BorderRadius.circular(10.0),
      margin: EdgeInsets.only(top: 60.0, left: 8.0, right: 8.0),
      padding: EdgeInsets.all(16.0),
      boxShadows: [
        BoxShadow(
          color: Colors.black45,
          blurRadius: 10.0,
          spreadRadius: 1.0,
          offset: Offset(0.0, 3.0),
        ),
      ],
      icon: Icon(
        iconData,
        color: Colors.white,
      ),
      shouldIconPulse: false,
      leftBarIndicatorColor: backgroundColor,
      flushbarPosition: FlushbarPosition.TOP,
    )..show(context);
  }

  void _handleApproveButtonPress() async {
    // Prepare the list of items to be updated
    List<Map<String, dynamic>> itemsToUpdate = _itemlist
        .where((item) => item.status.toString() == "0")
        .map((item) => {
              'cost_defn_bomid': item.cost_defn_bomid,
              'AppRate': item.apprate,
              'AppQty': item.quantity,
              // Add any additional data as needed
            })
        .toList();

    try {
      var response = await http.put(
        Uri.parse(
            'http://${AppConfig().host}:${AppConfig().port}/api/updatebudgetapproval'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(itemsToUpdate),
      );

      if (response.statusCode == 200) {
        _showFlushbar(
          'Budget Approval updated successfully!',
          Colors.green,
          Icons.check,
        );

        // Navigate back after a short delay
        // Future.delayed(Duration(seconds: 1), () {
        //   Navigator.pop(context);
        // });
      } else {
        // Handle the error response
        var errorBody = jsonDecode(response.body);
        String errorMessage =
            errorBody['message'] ?? 'Failed to update approval status';
        throw Exception('Failed to update approval status: $errorMessage');
      }
    } catch (e) {
      // Handle the exception
      setState(() {
        // Optionally show error message or update UI
      });
      // Show error message using Flushbar
      _showFlushbar(
        'Budget Approval Failed!',
        Colors.red,
        Icons.close,
      );
    }
  }

  void _handleApproveButton() async {
    // Prepare the list of items to be updated
    List<Map<String, dynamic>> itemsToUpdate = _itemlist
        .where((item) => item.status.toString() == "0")
        .map((item) => {
              'cost_defn_bomid': item.cost_defn_bomid,
              'AppRate': item.apprate,
              'AppQty': item.quantity,
              // Add any additional data as needed
            })
        .toList();

    try {
      var response = await http.put(
        Uri.parse(
            'http://${AppConfig().host}:${AppConfig().port}/api/updatebudgetapproval'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(itemsToUpdate),
      );

      if (response.statusCode == 200) {
        _showFlushbar(
          'Budget Approval updated successfully!',
          Colors.green,
          Icons.check,
        );

        // Navigate back after a short delay
        Future.delayed(Duration(seconds: 3), () {
          Navigator.pop(context);
        });
      } else {
        // Handle the error response
        var errorBody = jsonDecode(response.body);
        String errorMessage =
            errorBody['message'] ?? 'Failed to update approval status';
        throw Exception('Failed to update approval status: $errorMessage');
      }
    } catch (e) {
      // Handle the exception
      setState(() {
        // Optionally show error message or update UI
      });
      // Show error message using Flushbar
      _showFlushbar(
        'Budget Approval Failed!',
        Colors.red,
        Icons.close,
      );
    }
  }

  void _handleRevertButtonPress() async {
    // Ensure a process is selected
    if (selectedProcess == null) {
      _showFlushbar(
        'No process selected!',
        Colors.red,
        Icons.close,
      );
      return;
    }

    // Filter items to include only those related to the selected process
    var filteredItems =
        _itemlist.where((item) => item.process == selectedProcess).toList();

    // Group filtered items by process
    var groupedItems = groupBy(filteredItems, (item) => item.process);

    // Prepare the list of items to be reverted for each process
    List<Map<String, dynamic>> itemsToRevert = [];

    groupedItems.forEach((process, items) {
      var processItems = items
          .where((item) =>
              item.status.toString() == "1") // Assuming "1" means approved
          .map((item) => {
                'cost_defn_bomid': item.cost_defn_bomid,
                'AppQty': item.quantity,
              })
          .toList();

      // Add each process's items to the final list
      itemsToRevert.add({
        'process': process,
        'items': processItems,
      });
    });

    try {
      var response = await http.put(
        Uri.parse(
            'http://${AppConfig().host}:${AppConfig().port}/api/revertbudgetapproval'), // Revert API endpoint
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(itemsToRevert),
      );

      if (response.statusCode == 200) {
        _showFlushbar(
          'Budget Revert successful!',
          Colors.green,
          Icons.check,
        );

        // Navigate back after a short delay
        // Future.delayed(Duration(seconds: 1), () {
        //   Navigator.pop(context);
        // });
      } else {
        // Handle the error response
        var errorBody = jsonDecode(response.body);
        String errorMessage =
            errorBody['message'] ?? 'Failed to revert approval status';
        throw Exception('Failed to revert approval status: $errorMessage');
      }
    } catch (e) {
      // Handle the exception
      setState(() {
        // Optionally show error message or update UI
      });
      // Show error message using Flushbar
      _showFlushbar(
        'Budget Revert Failed!',
        Colors.red,
        Icons.close,
      );
    }
  }

  void handleSelectedProcess() {
    // Step 1: Group all items by their process
    var groupedItems = groupBy(_itemlist, (item) => item.process);

    // Step 2: Access the items for the selected process
    var itemsForSelectedProcess = groupedItems[selectedProcess] ?? [];

    // Debug print to check items for the selected process
    print('Items for selected process: $itemsForSelectedProcess');

    // Example: Check if a specific item is in the grouped items
    // (Assuming you want to check if an item at a specific index is in the selected process group)
    if (_itemlist.isNotEmpty) {
      final itemAtIndex = _itemlist[0]; // Or any index you want to check
      bool itemInGroupedItems = itemsForSelectedProcess.contains(itemAtIndex);

      print('Is the item in grouped items? $itemInGroupedItems');
    }
  }

  void onappratechanged(int index) {
    if (apprate.text != "") {
      for (int i = 0; i < _allbudgetitems.length; i++) {
        /* if (_allbudgetitems[i].cost_defn_bomid ==
            _budgetitems[index].cost_defn_bomid) {
          _allbudgetitems[i].apprate = double.parse(apprate.text);
          _allbudgetitems[i].amount =
              _allbudgetitems[i].quantity * _allbudgetitems[i].apprate;
          if (_allbudgetitems[i].apprate > 0) {
            _allbudgetitems[i].status = 1;
          } else {
            _allbudgetitems[i].status = 0;
          }
        } */
        if (_allbudgetitems[i].cost_defn_bomid ==
            _itemlist[index].cost_defn_bomid) {
          _allbudgetitems[i].apprate = double.parse(apprate.text);
          _allbudgetitems[i].amount =
              _allbudgetitems[i].quantity * _allbudgetitems[i].apprate;
          // if (_allbudgetitems[i].apprate > 0) {
          //   _allbudgetitems[i].status = 1;
          // } else {
          //   _allbudgetitems[i].status = 0;
          // }
        }
      }
      apprate.text = "";
      setState(() {
        _itemlist;
        _onItemTapped;
      });
    }
  }

  void itemlistsplit() {
    _mainitemlist.clear();
    _itemlist.clear();
    String itemname = "";
    String process = "";
    if (_selectedIndex == 0) {
      _budgetitems.sort((a, b) => a.item.compareTo(b.item));
    } else {
      _budgetitems.where((element) => element > 0);
      _budgetitems.sort((a, b) => a.seqno.compareTo(b.seqno));
    }

    for (int i = 0; i < _budgetitems.length; i++) {
      if (_budgetitems[i].seqno.toString() == "0") {
        if (itemname.toString() != _budgetitems[i].item.toString()) {
          _mainitemlist
              .add(BudgetMainItem(_budgetitems[i].seqno, _budgetitems[i].item));
        }
        _itemlist.add(_budgetitems[i]);

        itemname = _budgetitems[i].item.toString();
      } else {
        if (process.toString() != _budgetitems[i].process.toString()) {
          _mainitemlist.add(
              BudgetMainItem(_budgetitems[i].seqno, _budgetitems[i].process));
        }
        _itemlist.add(_budgetitems[i]);

        process = _budgetitems[i].process.toString();
      }
    }

    if (_selectedIndex == 0) {
      _itemlist.where((element) => element.seqno < 0);
    } else {
      _itemlist.where((element) => element.seqno > 0);
      _itemlist.sort((a, b) => a.seqno.compareTo(b.seqno));
    }
  }

  void getbudgetdetails() async {
    setState(() {
      _isLoading = true; // Set loading state to true
    });
    dynamic responsedata;
    // var url =
    //     '$hostname:$port/api/apibudgetapproval?orderno=$forderno&styleid=$fstyleid';
    var url =
        'http://${AppConfig().host}:${AppConfig().port}/api/apibudgetapproval?orderno=$forderno&styleid=$fstyleid';

    var body = '''''';
    String length = body.length.toString();
    var headers = {
      'Content-Type': 'application/json',
      'Content-Length': length,
      'Host': 'localhost',
      'User-Agent': 'PostmanRuntime/7.30.0'
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        responsedata = json.decode(response.body.toString());

        for (int j = 0; j < responsedata['orderdetails'].length; j++) {
          dynamic data =
              Budgetorderdetails.fromJson(responsedata['orderdetails'][j]);
          orderdetails = data;
          quantitydetails =
              "(${orderdetails.quantity.toString()} ${orderdetails.guom.toString()})";
        }

        for (int j = 0; j < responsedata['budget'].length; j++) {
          dynamic data = BudgetDetailModal.fromJson(responsedata['budget'][j]);
          //budetitems.add(data);
          _budgetitems.add(data);
          _allbudgetitems.add(data);
        }
        for (int j = 0; j < responsedata['commerical'].length; j++) {
          dynamic data =
              Commercialdetails.fromJson(responsedata['commerical'][j]);
          _comitems.add(data);
        }

        _budgetitems.sort((a, b) =>
            a.itemtype!.toUpperCase().compareTo(b.itemtype!.toUpperCase()));

        setState(() {
          // budgetlistlength = _budgetitems.length;
          budgetlistlength = _mainitemlist.length;
          _onItemTapped(0);
        });
      } else {}
    } catch (ex) {
      throw ex.toString();
    } finally {
      setState(() {
        _isLoading = false; // Set loading state to false
      });
    }
  }

  Future<bool> approveall() async {
    bool result = false;
    if (_allbudgetitems.isNotEmpty) {
      for (int i = 0; i < _allbudgetitems.length; i++) {
        _postitemdet.add(Budgetdetmodal(_allbudgetitems[i].cost_defn_bomid,
            _allbudgetitems[i].apprate, _allbudgetitems[i].quantity));
        _costlist.add(_postitemdet[i].toJson());
      }
    }

    var costdetails = {
      "orderno": forderno,
      "styleid": fstyleid,
      "cost_defn_id": orderdetails.cost_defn_id,
      "ProfitPercent": orderdetails.salesratemargin,
      "Approved": "Y",
      "SalePrice": orderdetails.salesprice,
      "Drawback_Percent": orderdetails.draback_percent,
      "sale_Profit": orderdetails.sale_profit,
      "sale_Profit_percent": orderdetails.sale_profit_percent,
      "ApprovedBy": loginuserid,
      "budgetdet": _postitemdet,
      "commdet": _commdet,
    };

    //dynamic responsedata;
    var url = '${AppConfig().host}:${AppConfig().port}/api/apibudgetapproval';
    var body = json.encode(costdetails);
    String length = body.length.toString();
    var headers = {
      'Content-Type': 'application/json',
      'Content-Length': length,
      'Host': 'localhost',
      'User-Agent': 'PostmanRuntime/7.30.0'
    };
    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            elevation: 20,
            backgroundColor: Colors.white,
            content: ListTile(
              leading: Icon(Icons.done, color: Colors.green),
              title: Text("Data saved successfully..!"),
            )));
        // ignore: use_build_context_synchronously
        result = true;
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.white,
            content: ListTile(
              leading: Icon(Icons.dangerous_rounded, color: Colors.red),
              title: Text("Not saved or updated properly..!"),
            )));
        result = false;
      }
    } catch (ex) {
      result = false;
      throw ex.toString();
    }
    return result;
  }

  Future<void> revertall() async {
    if (_allbudgetitems.isNotEmpty) {
      for (int i = 0; i < _allbudgetitems.length; i++) {
        _postitemdet.add(Budgetdetmodal(_allbudgetitems[i].cost_defn_bomid, 0.0,
            _allbudgetitems[i].quantity));
        _costlist.add(_postitemdet[i].toJson());
      }
    }
    if (_commdet.isNotEmpty) {
      for (int i = 0; i < _commdet.length; i++) {
        _commdet[i].apprate = 0;
        _commdet[i].appqty = 0;
      }
    }

    var costdetails = {
      "orderno": forderno,
      "styleid": fstyleid,
      "cost_defn_id": orderdetails.cost_defn_id,
      "ProfitPercent": 0.00,
      "Approved": "Y",
      "SalePrice": 0.00,
      "Drawback_Percent": 0.00,
      "sale_Profit": 0.00,
      "sale_Profit_percent": 0.00,
      "ApprovedBy": loginuserid,
      "budgetdet": _postitemdet,
      "commdet": _commdet,
    };

    //dynamic responsedata;
    var url =
        'http://${AppConfig().host}:${AppConfig().port}/api/apibudgetapproval';
    var body = json.encode(costdetails);
    String length = body.length.toString();
    var headers = {
      'Content-Type': 'application/json',
      'Content-Length': length,
      'Host': 'localhost',
      'User-Agent': 'PostmanRuntime/7.30.0'
    };
    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            elevation: 20,
            backgroundColor: Colors.white,
            content: ListTile(
              leading: Icon(Icons.done, color: Colors.green),
              title: Text("Data reverted successfully..!"),
            )));
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.white,
            content: ListTile(
              leading: Icon(Icons.dangerous_rounded, color: Colors.red),
              title: Text("Not Reverted properly..!"),
            )));
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    int countItemsWithStatusZero =
        _itemlist.where((item) => item.status == 0).length;
    int countProcessItemsWithStatusZero =
        _itemlist.where((process) => process.status == 0).length;

    // Determine visibility of the button
    bool showApproveButton =
        (countItemsWithStatusZero + countProcessItemsWithStatusZero) > 1;

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: SizedBox(
            height: 40,
            child: Marquee(
              text: '${forderno.toString()} ${quantitydetails.toString()}',
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
              style: TextStyle(
                color: Colors.teal, // Set the text color to teal
              ),
            ),
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
            ? const Center(
                // Display loading indicator while fetching data
                child: SpinKitFadingCircle(
                  color: Colors.teal, // Choose your desired color
                  size: 50.0, // Set the size of the loading animation
                ), // Loading indicator
              )
            : NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      backgroundColor: Colors.white,
                      pinned: false,
                      expandedHeight: -100,
                    )
                  ];
                },
                body: ListView.builder(
                  itemCount: budgetlistlength,
                  itemBuilder: ((context, index) {
                    final item = _itemlist[index];

                    List relevantItems = _itemlist
                        .where((item) =>
                            item.item.toString() ==
                                _mainitemlist[index].item.toString() &&
                            item.seqno.toString() ==
                                _mainitemlist[index].seqno.toString())
                        .toList();
                    List relevantprocessItems = _itemlist
                        .where((process) =>
                            process.process.toString() != "" &&
                            process.seqno.toString() ==
                                _mainitemlist[index].seqno.toString())
                        .toList();
                    // Example code to handle empty process page

                    // Check if relevantItems is not empty and process is not empty
                    String titleText;

                    if (relevantItems.isNotEmpty &&
                        relevantItems[0].process != null &&
                        relevantItems[0].process.toString().isNotEmpty) {
                      titleText = relevantItems[0].process.toString();
                    } else {
                      // If relevantItems is empty or process is empty, use a default value
                      titleText = _mainitemlist.isNotEmpty &&
                              index < _mainitemlist.length
                          ? _mainitemlist[index].item.toString()
                          : "No data available"; // Fallback text if _mainitemlist is also empty or index is out of bounds
                    }

                    // Example of displaying a message if lists are empty
                    // if (relevantItems.isEmpty && _mainitemlist.isEmpty) {
                    //   showMessage(
                    //       "The process page is empty and no data is available.");
                    // }
                    // Use item as fallback if no process is found

                    // Check if any relevant item has status == 1
                    bool showCheckIcon =
                        relevantItems.any((item) => item.status == 1);

                    // Check if any relevant item has status == 0
                    bool showInfoIcon =
                        relevantItems.any((item) => item.status == 0);
                    bool showProcessCheckIcon =
                        relevantprocessItems.any((item) => item.status == 1);

                    // Check if any relevant item has status == 0
                    bool showProcessInfoIcon =
                        relevantprocessItems.any((item) => item.status == 0);

                    // Calculate the count of items with status 0
                    int countItemsWithStatusZero =
                        relevantItems.where((item) => item.status == 0).length;
                    int countProcessItemsWithStatusZero = relevantprocessItems
                        .where((item) => item.status == 0)
                        .length;

                    // Combine the counts
                    int totalCountWithStatusZero = countItemsWithStatusZero +
                        countProcessItemsWithStatusZero;

                    // Condition to show the OutlineButton
                    bool showApproveButton = totalCountWithStatusZero > 1;

                    if (_selectedIndex < 2) {
                      return Column(children: [
                        if (index == 0) ...[
                          // const SizedBox(
                          //   height: 0,
                          // ),
                          // SizedBox(
                          //     height: 20,
                          //     width: 380,
                          //     child: Text(
                          //       '${budgetlistlength.toString()} Results found',
                          //       textAlign: TextAlign.center,
                          //       style: const TextStyle(
                          //         color: Color.fromARGB(255, 55, 110, 138),
                          //         fontSize: 18.0,
                          //       ),
                          //     )),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                        ],
                        Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 6,
                            child: ExpansionTile(
                              onExpansionChanged: (expanded) {
                                if (expanded) {
                                  setState(() {
                                    selectedProcess = item.process;
                                    groupItems(); // Ensure grouping is done before accessing
                                  });
                                  // Call the function after updating the selected process
                                  handleSelectedProcess();
                                  print('Selected process: $selectedProcess');
                                }
                              },
                              leading: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    color: Colors.blue,
                                    Icons.library_books,
                                  )),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Wrap the title Text inside an Expanded widget for proper space allocation
                                  Expanded(
                                    child: Text(
                                      titleText,
                                      overflow: TextOverflow
                                          .ellipsis, // Add ellipsis if text overflows
                                    ),
                                  ),

                                  // Conditionally show info icon
                                  if (showCheckIcon)
                                    Icon(Icons.check_circle,
                                        color: Colors.green)
                                  else if (showInfoIcon)
                                    Icon(Icons.info, color: Colors.red)
                                  else if (showProcessCheckIcon)
                                    Icon(Icons.check_circle,
                                        color: Colors.green)
                                  else if (showProcessInfoIcon)
                                    Icon(Icons.info, color: Colors.red)
                                ],
                              ),
                              children: [
                                for (int i = 0; i < _itemlist.length; i++) ...[
                                  if (_selectedIndex == 0) ...[
                                    if (_itemlist[i].item.toString() ==
                                            _mainitemlist[index]
                                                .item
                                                .toString() &&
                                        _itemlist[i].seqno.toString() ==
                                            _mainitemlist[index]
                                                .seqno
                                                .toString()) ...[
                                      if (_itemlist[i].status.toString() ==
                                          "1") ...[
                                        Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          elevation:
                                              6, // Adjust elevation as needed
                                          margin: EdgeInsets.symmetric(
                                              vertical: 8,
                                              horizontal:
                                                  16), // Adjust margins as needed
                                          child: ExpansionTile(
                                            title: Text(
                                              '${_itemlist[i].color.toString()} - ${_itemlist[i].size.toString()}',
                                            ),
                                            subtitle: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      ' Quantity : ${_itemlist[i].quantity.toString()}',
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    Text(
                                                        ' Rate : ${_itemlist[i].apprate.toString()}'),
                                                    Text(
                                                        ' AppRate : ${_itemlist[i].apprate.toString()} '),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [],
                                                ),
                                              ],
                                            ),
                                            children: [
                                              ListTile(
                                                title: TextFormField(
                                                  controller: apprate,
                                                  decoration: InputDecoration(
                                                    labelText: 'App Rate',
                                                    suffixIcon: IconButton(
                                                      onPressed: () {
                                                        onappratechanged(i);
                                                      },
                                                      icon: const Icon(
                                                        Icons.done,
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                            onExpansionChanged: (value) {
                                              if (value == true) {
                                                apprate.text = _itemlist[i]
                                                    .apprate
                                                    .toString();
                                              } else {
                                                apprate.text = "";
                                              }
                                            },
                                          ),
                                        )
                                      ] else ...[
                                        Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          elevation:
                                              6, // Adjust elevation as needed
                                          margin: EdgeInsets.symmetric(
                                              vertical: 8,
                                              horizontal:
                                                  16), // Adjust margins as needed
                                          child: ExpansionTile(
                                            title: Text(
                                              '${_itemlist[i].color.toString()} - ${_itemlist[i].size.toString()}',
                                            ),
                                            subtitle: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      ' Quantity : ${_itemlist[i].quantity.toString()}',
                                                    ),
                                                    Text(
                                                        ' Rate : ${_itemlist[i].apprate.toString()}'),
                                                    Text(
                                                        ' AppRate : ${_itemlist[i].apprate.toString()} '),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [],
                                                ),
                                              ],
                                            ),
                                            children: [
                                              ListTile(
                                                title: TextFormField(
                                                  controller: apprate,
                                                  decoration: InputDecoration(
                                                    labelText: 'App Rate',
                                                    suffixIcon: IconButton(
                                                      onPressed: () {
                                                        onappratechanged(i);
                                                      },
                                                      icon: const Icon(
                                                        Icons.done,
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                            onExpansionChanged: (value) {
                                              if (value == true) {
                                                apprate.text = _itemlist[i]
                                                    .apprate
                                                    .toString();
                                              } else {
                                                apprate.text = "";
                                              }
                                            },
                                          ),
                                        )
                                      ],
                                    ]
                                  ] else if (_selectedIndex == 1) ...[
                                    if (_itemlist[i].process.toString() ==
                                            _itemlist[i].process.toString() &&
                                        _itemlist[i].seqno.toString() ==
                                            _mainitemlist[index]
                                                .seqno
                                                .toString()) ...[
                                      if (_itemlist[i].status.toString() ==
                                              "1" ||
                                          _itemlist[i].status.toString() ==
                                              "0") ...[
                                        Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          margin: EdgeInsets.symmetric(
                                              vertical: 8,
                                              horizontal:
                                                  16), // Adjust margins as needed
                                          child: ExpansionTile(
                                            title: Text(
                                              '${_itemlist[i].item.toString()} - ${_itemlist[i].color.toString()} - ${_itemlist[i].size.toString()}',
                                            ),
                                            subtitle: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      ' Quantity : ${_itemlist[i].quantity.toString()}',
                                                    ),
                                                    Text(
                                                        ' App rate : ${_itemlist[i].apprate.toString()}'),
                                                    Text(
                                                        ' Amount : ${_itemlist[i].amount.toString()}'),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [],
                                                ),
                                              ],
                                            ),
                                            children: [
                                              ListTile(
                                                title: TextFormField(
                                                  controller: apprate,
                                                  decoration: InputDecoration(
                                                    labelText: 'App Rate',
                                                    suffixIcon: IconButton(
                                                      onPressed: () {
                                                        updateAppRate(
                                                            _itemlist[i]
                                                                .cost_defn_bomid,
                                                            apprate.text);
                                                      },
                                                      icon: const Icon(
                                                        Icons.done,
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                            onExpansionChanged: (value) {
                                              if (value == true) {
                                                apprate.text = _itemlist[i]
                                                    .apprate
                                                    .toString();
                                              } else {
                                                apprate.text = "";
                                              }
                                            },
                                          ),
                                        )
                                      ] else ...[
                                        ExpansionTile(
                                          title: Text(
                                              '${_itemlist[i].item.toString()} - ${_itemlist[i].color.toString()} - ${_itemlist[i].size.toString()}'),
                                          subtitle: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                      'Quantity : ${_itemlist[i].quantity.toString()}'),
                                                  Text(
                                                      'AppRate : ${_itemlist[i].apprate.toString()}'),
                                                  Text(
                                                      'Amount : ${_itemlist[i].amount.toString()}'),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [],
                                              ),
                                            ],
                                          ),
                                          children: [
                                            ListTile(
                                              title: TextFormField(
                                                  controller: apprate,
                                                  decoration: InputDecoration(
                                                      labelText: 'App Rate',
                                                      suffixIcon: IconButton(
                                                          onPressed: () {
                                                            onappratechanged(
                                                                index);
                                                          },
                                                          icon: const Icon(
                                                              Icons.done,
                                                              color: Colors
                                                                  .green)))),
                                            )
                                          ],
                                          onExpansionChanged: (value) {
                                            if (value == true) {
                                              apprate.text = _itemlist[i]
                                                  .apprate
                                                  .toString();
                                            } else {
                                              apprate.text = "";
                                            }
                                          },
                                        )
                                      ],
                                    ],
                                  ]
                                ],
                                ListTile(
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextFormField(
                                        controller: apprate,
                                        decoration: InputDecoration(
                                          labelText: 'App Rate',
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              updateAppRateByProcess(
                                                  titleText, apprate.text);
                                            },
                                            icon: const Icon(Icons.done,
                                                color: Colors.green),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              10), // Adjust the height as needed
                                      Center(
                                        child: Visibility(
                                          visible: showProcessInfoIcon ||
                                              showInfoIcon, // Combined condition // Condition for showing the button
                                          child: OutlinedButton(
                                            onPressed: () {
                                              _handleApproveButtonPress(); // Handle button press action
                                            },
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                  side: const BorderSide(),
                                                ),
                                              ),
                                              backgroundColor:
                                                  MaterialStateProperty.all(Colors
                                                      .green), // Example color
                                              foregroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.white),
                                              fixedSize: MaterialStateProperty
                                                  .all(Size(150,
                                                      38)), // Adjust size as needed
                                            ),
                                            child: Text('Approve'),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )),
                      ]);
                    } else if (_selectedIndex < 3) {
                      return Column(children: [
                        if (index == 0) ...[
                          const SizedBox(
                            height: 10,
                          ),
                          // SizedBox(
                          //     height: 15,
                          //     width: 380,
                          //     child: Text(
                          //       '${budgetlistlength.toString()} Results found.',
                          //       textAlign: TextAlign.center,
                          //       style: const TextStyle(
                          //         color: Colors.indigo,
                          //         fontSize: 16.0,
                          //       ),
                          //     )),
                          // const SizedBox(
                          //   height: 5,
                          // ),
                        ],
                        Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ExpansionTile(
                            leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  color: Colors.blue,
                                  Icons.assessment_outlined,
                                )),
                            title: Text(
                              _comitems[index].commercial,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                                "Value : ${_comitems[index].amount.toString()}"),
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: const [
                                        Text('Cost :'),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text('Cost type :'),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text('Amount :'),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(_comitems[index].cost.toString()),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        if (_comitems[index]
                                                .costtype
                                                .toString() ==
                                            "P") ...[
                                          const Text("Per Piece"),
                                        ] else if (_comitems[index]
                                                .costtype
                                                .toString() ==
                                            "O") ...[
                                          const Text("Order value of %"),
                                        ] else ...[
                                          const Text("Value"),
                                        ],
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            _comitems[index].amount.toString()),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ]);
                    } else {
                      return Column(
                        children: [
                          Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: const Text(
                                    "Summary",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      padding: const EdgeInsets.all(5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Text('Fabric and Yarn :'),
                                          SizedBox(height: 10),
                                          Text('Process :'),
                                          SizedBox(height: 10),
                                          Text('Production :'),
                                          SizedBox(height: 10),
                                          Text('Accessories :'),
                                          SizedBox(height: 10),
                                          Text('Commercial :'),
                                          SizedBox(height: 10),
                                          Text('Total :'),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(af
                                              .formatenumber(yarncost)
                                              .toString()),
                                          SizedBox(height: 10),
                                          Text(af
                                              .formatenumber(processcost)
                                              .toString()),
                                          SizedBox(height: 10),
                                          Text(af
                                              .formatenumber(productioncost)
                                              .toString()),
                                          SizedBox(height: 10),
                                          Text(af
                                              .formatenumber(trimscost)
                                              .toString()),
                                          SizedBox(height: 10),
                                          Text(af
                                              .formatenumber(comcost)
                                              .toString()),
                                          SizedBox(height: 10),
                                          Text(af
                                              .formatenumber(totcost)
                                              .toString()),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: const Text(
                                    "Profit & Sales",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Text('Sales price :'),
                                          SizedBox(height: 10),
                                          Text('Profit % :'),
                                          SizedBox(height: 10),
                                          Text('Profit value :'),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(af
                                              .formatenumber(
                                                  orderdetails.salesprice)
                                              .toString()),
                                          SizedBox(height: 10),
                                          Text(af
                                              .formatenumber(orderdetails
                                                  .sale_profit_percent)
                                              .toString()),
                                          SizedBox(height: 10),
                                          Text(af
                                              .formatenumber(
                                                  orderdetails.sale_profit)
                                              .toString()),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                              height:
                                  200), // Space between the cards and button
                          ElevatedButton(
                            onPressed: () {
                              _handleApproveButton(); // Implement your approval logic here
                            },
                            child: Text("Approve"),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 60, vertical: 15),
                              textStyle: TextStyle(fontSize: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  }),
                ),
              ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 20,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.add_shopping_cart_sharp),
              label: 'Purchase',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_shipping_outlined),
              label: 'Process',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assessment_outlined),
              label: 'Commercial',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.summarize_outlined),
              label: 'Summary',
            ),
          ],
          backgroundColor: Colors
              .white, // Set the background color of the BottomNavigationBar
          currentIndex: _selectedIndex,
          selectedItemColor:
              Colors.teal, // Set the color of the selected item icon
          unselectedItemColor: Colors
              .grey, // Set the color of the unselected item icon (optional)
          iconSize: 30,
          onTap: _onItemTapped,
        ));
  }
}

class FilterButtonsWidget extends StatefulWidget {
  final Function onPendingSelected;
  final Function onApprovedSelected;

  const FilterButtonsWidget({
    Key? key,
    required this.onPendingSelected,
    required this.onApprovedSelected,
  }) : super(key: key);

  @override
  _FilterButtonsWidgetState createState() => _FilterButtonsWidgetState();
}

class _FilterButtonsWidgetState extends State<FilterButtonsWidget> {
  bool isPendingSelected = false;
  bool isApprovedSelected = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                isPendingSelected = true;
                isApprovedSelected = false;
              });
              widget.onPendingSelected();
            },
            style: ElevatedButton.styleFrom(
              primary: isPendingSelected
                  ? Colors.blue
                  : Colors.grey, // Change color based on selection
              onPrimary: isPendingSelected
                  ? Colors.white
                  : Colors.white, // Change text color based on selection
            ),
            icon: Icon(Icons.pending_actions_outlined),
            label: Text('Pending'),
          ),
          SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                isPendingSelected = false;
                isApprovedSelected = true;
              });
              widget.onApprovedSelected();
            },
            style: ElevatedButton.styleFrom(
              primary: isApprovedSelected
                  ? Colors.amber
                  : Colors.grey, // Change color based on selection
              onPrimary: isApprovedSelected
                  ? Colors.white
                  : Colors.white, // Change text color based on selection
            ),
            icon: Icon(Icons.verified_user_outlined),
            label: Text('Approved'),
          ),
        ],
      ),
    );
  }
}
