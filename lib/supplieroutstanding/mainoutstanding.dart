import 'package:apparelapp/supplieroutstanding/processoutstanding.dart';
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
          title: const Text("Main Outstanding"),
        ),
        body: Column(
          children: [
            Card(
                child: ListTile(
              leading: const Icon(Icons.shopping_basket_outlined),
              title: const Text("Purchase"),
              onTap: () {},
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
              onTap: () {},
            )),
          ],
        ));
  }
}
