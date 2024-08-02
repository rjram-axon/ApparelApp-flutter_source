import 'package:apparelapp/orderstatus/orderstatus.dart';
import 'package:flutter/material.dart';

class MainOrderStatus extends StatefulWidget {
  const MainOrderStatus({super.key});

  @override
  State<MainOrderStatus> createState() => _MainOrderStatusState();
}

class _MainOrderStatusState extends State<MainOrderStatus> {
  final _orderitems = [
    {'orderno': 'AXN#ION0001'}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        centerTitle: true,
        /* leading:
            IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)), */
        title: const Text('Main - Order Status'),
        //actions: <Widget>[DropdownButton(items: items, onChanged: () {})],
      ),
      body: Column(children: [
        for (int x = 1; x <= _orderitems.length; x++) ...[
          //_widgetOptions.elementAt(_selectedIndex),
          // you can add widget here as well
          Card(
            margin: const EdgeInsets.all(10.0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.white,
            elevation: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          SizedBox(height: 22, child: Text('Order No :')),
                          SizedBox(height: 22, child: Text('Refer No :')),
                          SizedBox(height: 22, child: Text('Style    :')),
                          SizedBox(height: 22, child: Text('Quantity :')),
                          SizedBox(height: 22, child: Text('Description :')),
                          SizedBox(height: 20, child: Text('Live stage :')),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          SizedBox(height: 22, child: Text('AXN£ION00002')),
                          SizedBox(height: 22, child: Text('TESTING 002')),
                          SizedBox(height: 22, child: Text('MANS T SHIRT')),
                          SizedBox(height: 22, child: Text('1000 PCS')),
                          SizedBox(height: 22, child: Text('MENS POLO TSHIRT')),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          const Icon(Icons.settings_accessibility_sharp,
                              size: 50),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const OrderStatus()));
                            },
                            child: const Text('View'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    SizedBox(
                        height: 60,
                        child: Text(
                          'Yarn purchse made for partial quantity (100 KGS) \n ',
                          maxLines: 3,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        )),
                  ],
                ),
              ],
            ),
          ),
        ],
        //_widgetOptions.elementAt(_selectedIndex),
      ]),
    );
  }
}
