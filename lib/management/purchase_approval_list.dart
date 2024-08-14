import 'dart:convert';
import 'dart:io';
import 'package:apparelapp/main/app_config.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:marquee/marquee.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;

import 'main_purchase_approval.dart';
import 'purchase_order.dart'; // Importing the PurchaseOrder class

class PurchaseOrderDetail extends StatefulWidget {
  final String poNumber;
  final List<PurchaseOrder> orders;
  final Function(String, String) onApprovalStatusChanged;

  const PurchaseOrderDetail({
    Key? key,
    required this.poNumber,
    required this.orders,
    required this.onApprovalStatusChanged,
  }) : super(key: key);

  @override
  _PurchaseOrderDetailState createState() => _PurchaseOrderDetailState();
}

class _PurchaseOrderDetailState extends State<PurchaseOrderDetail> {
  List<PurchaseOrder> _filteredOrders(String poNumber) {
    return widget.orders.where((order) => order.purOrdNo == poNumber).toList();
  }

  Map<String, List<PurchaseOrder>> groupOrdersByItem() {
    Map<String, List<PurchaseOrder>> groupedOrders = {};

    for (var order in _filteredOrders(widget.poNumber)) {
      if (groupedOrders.containsKey(order.item)) {
        groupedOrders[order.item]!.add(order);
      } else {
        groupedOrders[order.item] = [order];
      }
    }

    return groupedOrders;
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

  bool _areAllItemsApproved() {
    return _filteredOrders(widget.poNumber)
        .every((order) => order.approved == 'Y');
  }

  bool _areAnyItemsApproved() {
    return _filteredOrders(widget.poNumber)
        .any((order) => order.approved == 'Y');
  }

  @override
  Widget build(BuildContext context) {
    List<MapEntry<String, List<PurchaseOrder>>> entries =
        groupOrdersByItem().entries.toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: SizedBox(
          height: 40,
          child: Marquee(
            text: 'Purchase Order Details - ${widget.poNumber}',
            style: const TextStyle(color: Colors.teal),
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: () => viewPdf(context),
            icon: Icon(Icons.picture_as_pdf, color: Colors.teal),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                for (var entry in entries) ...?_buildItemCard(entry),
              ],
            ),
          ),
          if (!_areAllItemsApproved())
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => _handleApprovalStatusChangedForAll('Y'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text('Approve'),
              ),
            ),
          if (_areAnyItemsApproved())
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => _handleApprovalStatusChangedForAll('N'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text('Reject'),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget>? _buildItemCard(MapEntry<String, List<PurchaseOrder>> entry) {
    List<PurchaseOrder> filteredOrders = _filteredOrders(widget.poNumber);

    if (filteredOrders.isNotEmpty) {
      Map<String, dynamic> totalValues =
          PurchaseOrder.calculateTotal(filteredOrders);

      return [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ExpansionTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'Quantity: ${totalValues['totalQuantity']}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Rate: ${totalValues['totalRate']}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Amount: ${totalValues['totalAmount']}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_areAllItemsApproved())
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                  if (!_areAllItemsApproved())
                    Icon(
                      Icons.info,
                      color: Colors.orange,
                    ),
                ],
              ),
              leading: Icon(
                Icons.inventory,
                color: Colors.blue[800],
              ),
              trailing: SizedBox.shrink(),
              children: [
                SizedBox(height: 8),
                Column(
                  children: [
                    for (var order in filteredOrders) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            title: order.orderNo != null &&
                                    order.orderNo.isNotEmpty
                                ? Text(
                                    'Order NO: ${order.orderNo}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : SizedBox
                                    .shrink(), // This hides the Text widget if orderNo is null
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (order.color != null)
                                  Text(
                                    'Colour: ${order.color}',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                if (order.style != null)
                                  Text(
                                    'Style: ${order.style}',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                if (order.quantity != null)
                                  Text(
                                    'Quantity: ${order.quantity}',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                if (order.rate != null)
                                  Text(
                                    'Rate: ${order.rate}',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                if (order.totalAmount != null)
                                  Text(
                                    'Total Amount: ${order.totalAmount}',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ];
    } else {
      return null;
    }
  }

  void _handleApprovalStatusChangedForAll(String status) async {
    setState(() {});

    late String message;
    late Color backgroundColor;
    late IconData iconData;

    String newStatus = status == 'Y' ? 'Y' : 'N';

    try {
      for (var order in _filteredOrders(widget.poNumber)) {
        if (order.approved != newStatus) {
          var response = await http.put(
            Uri.parse(
                'http://${AppConfig().host}:${AppConfig().port}/api/updatepurchaseapproval/${order.purOrdNo}'),
            //'http://192.168.1.50:81/api/apipurchaseapproval/${order.purOrdNo}'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              'isApproved': newStatus,
            }),
          );

          if (response.statusCode == 200) {
            order.approved = newStatus;
          } else {
            // If the request failed, parse the error message from the response body
            String errorMessage = '';
            try {
              Map<String, dynamic> errorBody = jsonDecode(response.body);
              errorMessage = errorBody['message'];
            } catch (e) {
              errorMessage = 'Failed to update approval status';
            }
            // Throw an exception with the detailed error message
            throw Exception('Failed to update approval status: $errorMessage');
          }
        }
      }

      // Set message and color based on the status
      if (newStatus == 'Y') {
        message = 'All pending orders have been approved';
        backgroundColor = Colors.green;
        iconData = Icons.check_circle;
      } else {
        message = 'All approved orders have been rejected';
        backgroundColor = Colors.red;
        iconData = Icons.cancel;
      }

      widget.onApprovalStatusChanged(widget.poNumber, newStatus);

      // Navigate to another screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainPurchaseApproval(),
        ),
      );
    } catch (e) {
      message = 'Failed to update approval status';
      backgroundColor = Colors.red;
      iconData = Icons.error;
    }

    _showFlushbar(message, backgroundColor, iconData);

    setState(() {});
  }

  Future<void> viewPdf(BuildContext context) async {
    final pdf = pw.Document();

    final fontData = await rootBundle.load('assets/font/arial.ttf');
    final titleStyle = pw.TextStyle(
      font: pw.Font.ttf(fontData),
      fontSize: 20,
      fontWeight: pw.FontWeight.bold,
    );
    final headerStyle = pw.TextStyle(
      font: pw.Font.ttf(fontData),
      fontSize: 16,
      fontWeight: pw.FontWeight.bold,
    );
    final contentStyle = pw.TextStyle(
      font: pw.Font.ttf(fontData),
      fontSize: 14,
    );

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text('Purchase Order Details', style: titleStyle),
              ),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                border: pw.TableBorder.all(),
                headerStyle: headerStyle,
                headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
                cellAlignment: pw.Alignment.center,
                headerAlignment: pw.Alignment.center,
                tableWidth: pw.TableWidth.max,
                columnWidths: {
                  0: pw.FixedColumnWidth(60), // Adjust column width as needed
                  1: pw.FlexColumnWidth(
                      3.5), // Use flexible width for remaining columns
                  2: pw.FlexColumnWidth(1.5),
                  3: pw.FlexColumnWidth(1.5),
                  4: pw.FlexColumnWidth(1.5),
                  5: pw.FlexColumnWidth(1.5),
                  6: pw.FlexColumnWidth(2),
                },
                data: <List<String>>[
                  <String>[
                    'Item',
                    'Order Numbers',
                    'Colors',
                    'Styles',
                    'Total Quantity',
                    'Total Rate',
                    'Total Amount'
                  ],
                  for (var entry in groupOrdersByItem().entries)
                    ..._generateTableRow(entry),
                ],
              ),
            ],
          );
        },
      ),
    );

    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;
    final tempFile = File('$tempPath/purchase_order.pdf');
    await tempFile.writeAsBytes(await pdf.save());

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PDFView(
          filePath: tempFile.path,
        ),
      ),
    );
  }

  List<List<String>> _generateTableRow(MapEntry<String, dynamic> entry) {
    final List<String> rowData = [
      entry.key,
      _formatOrderNumbers(entry.value),
      _formatColors(entry.value),
      _formatStyles(entry.value),
      _calculateTotalQuantity(entry.value).toString(),
      _calculateTotalRate(entry.value).toString(),
      _calculateTotalAmount(entry.value).toString(),
    ];
    return [rowData];
  }

  String _formatOrderNumbers(List<PurchaseOrder> orders) {
    return orders.map((order) => order.orderNo).join(', ');
  }

  String _formatColors(List<PurchaseOrder> orders) {
    return orders.map((order) => order.color).toSet().join(', ');
  }

  String _formatStyles(List<PurchaseOrder> orders) {
    return orders.map((order) => order.style).toSet().join(', ');
  }

  double _calculateTotalQuantity(List<PurchaseOrder> orders) {
    return orders.map((order) => order.quantity).reduce((a, b) => a + b);
  }

  double _calculateTotalRate(List<PurchaseOrder> orders) {
    return orders.map((order) => order.rate).reduce((a, b) => a + b);
  }

  double _calculateTotalAmount(List<PurchaseOrder> orders) {
    return orders.map((order) => order.totalAmount).reduce((a, b) => a + b);
  }
}
