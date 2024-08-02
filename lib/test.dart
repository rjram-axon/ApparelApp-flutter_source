import 'package:flutter/material.dart';

void main() {
  return runApp(const Mytest());
}

/* Testing widget*/
class Mytest extends StatelessWidget {
  const Mytest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test'),
      ),
      body: Card(
        margin: const EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                      SizedBox(height: 25, child: Text('Order No :')),
                      SizedBox(height: 25, child: Text('Refer No :')),
                      SizedBox(height: 25, child: Text('Style    :')),
                      SizedBox(height: 25, child: Text('Quantity :')),
                      SizedBox(height: 25, child: Text('Description :')),
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
                      SizedBox(height: 25, child: Text('AXN#ION0001')),
                      SizedBox(height: 25, child: Text('TESTING 001')),
                      SizedBox(height: 25, child: Text('MANS T SHIRT')),
                      SizedBox(height: 25, child: Text('1000 PCS')),
                      SizedBox(height: 25, child: Text('MENS POLO TSHIRT')),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      const Icon(Icons.settings_accessibility_sharp, size: 60),
                      const SizedBox(height: 20),
                      ElevatedButton(
                          onPressed: () {}, child: const Text('View1')),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
