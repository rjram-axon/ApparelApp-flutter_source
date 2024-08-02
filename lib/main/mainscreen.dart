import 'dart:convert';

import 'package:apparelapp/main.dart';
import 'package:apparelapp/main/loginscreen.dart';
import 'package:flutter/material.dart';

import '../axonlibrary/axonfilehandling.dart';
import '../axonlibrary/axongeneral.dart';
/* Main Screen from the app startup configurations*/

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.head});
  final String head;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  /* Initialize the texfield values usinig the texteditingcontroller*/
  TextEditingController company = TextEditingController();
  TextEditingController host = TextEditingController();
  TextEditingController port = TextEditingController();
  TextEditingController finyear = TextEditingController();

  /* Configuration saved function*/
  Future<void> _savedata() async {
    /* Data fetched from the concern textfields 'company,host,port,finyear'*/
    Configdetail cdet =
        Configdetail(company.text, host.text, port.text, finyear.text);

    /* check and write the configuration details in axonconfiguration file (write on json)'*/
    if (cdet.company.toString() != "") {
      configdetails.add(cdet);
      final cd = ConfigurationStorage();
      cd.writeCounter(json.encode(configdetails));

      /* After saved the configuration alert with the message & go to next page option*/
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Apparel Message'),
          content: Text('${company.text} added successfully...!'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MyLogin())),
              child: const Text('Go To Login'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> delete() async {
    String result = "";
    final cd = ConfigurationStorage();

    result = await cd.deletefile();

    if (result.toString() != "") {
      /* After saved the configuration alert with the message & go to next page option*/
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Apparel Message'),
          content:
              const Text('All Configurations are deleted successfully...!'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    //checkconfig();
    setState(() {});
  }

  Future<void> checkconfig() async {
    var file = ConfigurationStorage();
    var data = await file.readCounter();
    if (data.isNotEmpty) {
      var datas = json.decode(data);
      configdetails.add(datas);
      if (configdetails.isNotEmpty) {
        var cf = AxonConfiguration();
        cf.setconfiguration(configdetails);
        // ignore: use_build_context_synchronously
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const MyLogin()));
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    company.dispose();
    host.dispose();
    port.dispose();
    finyear.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      backgroundColor: Colors.white,
      body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0, 1],
                  colors: [Colors.white, Colors.white])),
          child: Center(
            widthFactor: 100,
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  //Image.asset('assets/images/axon_logo.png',
                  //    width: 150, height: 150),
                  Image.asset('assets/images/erp.png', width: 300, height: 150),
                  SizedBox(
                    width: 380,
                    child: TextField(
                      controller: company,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Company name',
                        //hintText: 'Company name',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 380,
                    child: TextField(
                      controller: host,
                      textCapitalization: TextCapitalization.none,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Hosted URL',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 380,
                    child: TextField(
                      controller: port,
                      textCapitalization: TextCapitalization.none,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Hosted Port',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // SizedBox(
                  //   width: 380,
                  //   child: TextField(
                  //     controller: finyear,
                  //     textCapitalization: TextCapitalization.characters,
                  //     decoration: const InputDecoration(
                  //       border: OutlineInputBorder(),
                  //       labelText: 'Description',
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 30,
                    //width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                            onPressed: () {
                              delete();
                            },
                            child: const Text('Reset')),
                        ElevatedButton(
                            onPressed: _savedata, child: const Text('Add'))
                      ],
                    ),
                  )
                ])),
          )),
      persistentFooterButtons: <Widget>[
        ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MyLogin()));
            },
            child: const Text('Next')),
      ],
    );
  }
}
