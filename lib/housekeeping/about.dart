import 'package:flutter/material.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: SingleChildScrollView(
            child: Column(
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
                          children: [
                            Image.asset('assets/images/erp.png',
                                width: 75, height: 100),
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
                            SizedBox(
                                height: 22,
                                child: Text('Apparel+ ERP Cloud v10.0',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            SizedBox(
                                height: 22,
                                child: Text('Design & developed by Axon')),
                            SizedBox(
                                height: 22, child: Text('Copyrights@2022')),
                            SizedBox(height: 22, child: Text('App Ver: 1.0.0')),
                          ],
                        ),
                      ),
                    ]),
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
                            SizedBox(
                                height: 22,
                                child: Text('Our Successful Products...',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                          ],
                        ),
                      ),
                    ]),
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
                          children: [
                            Image.asset('assets/images/erp.png',
                                width: 75, height: 75)
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
                            SizedBox(
                                height: 22,
                                child: Text('Apparel+ v8',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            SizedBox(
                                height: 22,
                                child: Text(
                                  'ERP for Garments and Exporters',
                                )),
                            SizedBox(
                                height: 22,
                                child: Text(
                                  'Copyrights@2022',
                                )),
                          ],
                        ),
                      ),
                    ]),
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
                          children: [
                            Image.asset('assets/images/fabrica.png',
                                width: 75, height: 75)
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
                            SizedBox(
                                height: 22,
                                child: Text('Fabrica v8',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            SizedBox(
                                height: 22,
                                child: Text(
                                  'ERP for Garments and Exporters',
                                )),
                            SizedBox(
                                height: 22,
                                child: Text(
                                  'Copyrights@2022',
                                )),
                          ],
                        ),
                      ),
                    ]),
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
                          children: [
                            Image.asset('assets/images/scm.png',
                                width: 75, height: 75)
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
                            SizedBox(
                                height: 22,
                                child: Text('Apparel+ SCM',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            SizedBox(
                                height: 22,
                                child: Text(
                                  'ERP for Garments and Exporters',
                                )),
                            SizedBox(
                                height: 22,
                                child: Text(
                                  'Copyrights@2022',
                                )),
                          ],
                        ),
                      ),
                    ]),
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
                          children: [
                            Image.asset('assets/images/crm.png',
                                width: 75, height: 75)
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
                            SizedBox(
                                height: 22,
                                child: Text('Apparel+ CRM',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            SizedBox(
                                height: 22,
                                child: Text(
                                  'ERP for Garments and Exporters',
                                )),
                            SizedBox(
                                height: 22,
                                child: Text(
                                  'Copyrights@2022',
                                )),
                          ],
                        ),
                      ),
                    ]),
              ],
            ),
          )),
    );
  }
}
