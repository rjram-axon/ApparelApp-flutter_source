import 'package:apparelapp/supplieroutstanding/processoutstanding.dart';
import 'package:apparelapp/supplieroutstanding/productionoutstanding.dart';
import 'package:apparelapp/supplieroutstanding/purchase/purchasesummary.dart';
import 'package:flutter/material.dart';

class MainOutstandingList extends StatefulWidget {
  const MainOutstandingList({super.key});

  @override
  State<MainOutstandingList> createState() => _MainOutstandingListState();
}

class _MainOutstandingListState extends State<MainOutstandingList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            'Main Outstanding',
            style: TextStyle(color: Color(0xFF0072FF)),
          ),
          leading: IconButton(
            color: Color(0xFF0072FF),
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Navigate back to the previous screen
            },
          ),
        ),
        body: Column(
          children: [
            Card(
                child: ListTile(
              leading: const Icon(Icons.shopping_basket_outlined),
              title: const Text("Purchase"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const Purchasesummary())));
              },
            )),
            Card(
                child: ListTile(
              leading: const Icon(Icons.local_shipping_outlined),
              title: const Text("Process"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const ProcessOutstanding())));
              },
            )),
            Card(
                child: ListTile(
              leading: const Icon(Icons.local_shipping_outlined),
              title: const Text("Production"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const ProductionOutstanding())));
              },
            )),
          ],
        ));
  }
}
