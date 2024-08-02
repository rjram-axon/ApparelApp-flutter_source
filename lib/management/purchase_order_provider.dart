import 'package:flutter/material.dart';
import 'package:apparelapp/management/purchase_order.dart'; // Import the PurchaseOrder class

class PurchaseOrderProvider extends ChangeNotifier {
  List<PurchaseOrder> _orders = []; // List to store purchase orders

  // Getter for the list of orders
  List<PurchaseOrder> get orders => _orders;

  // Method to add a new order
  void addOrder(PurchaseOrder order) {
    _orders.add(order);
    notifyListeners(); // Notify listeners of changes
  }

  // Method to update the approval status of an order
  void updateOrderApprovalStatus(String poNumber, String status) {
    // Find orders with the given purchase order number and update their approval status
    notifyListeners(); // Notify listeners of changes
  }

  // Method to get orders for a specific purchase order number
}
