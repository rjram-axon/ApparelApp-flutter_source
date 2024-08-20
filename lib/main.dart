import 'package:apparelapp/axondatamodal/axonfitrationmodal/orderwisestockfilter.dart';
import 'package:apparelapp/main/mainscreen.dart';
import 'package:apparelapp/stock/groupwisestock.dart';
import 'package:apparelapp/supplieroutstanding/mainoutstanding.dart';
import 'package:flutter/material.dart';
import 'package:apparelapp/management/mainbudgetapproval.dart';
import 'package:apparelapp/orderstatus/mainorderstatus.dart';
import 'package:apparelapp/stylegallery/mainstylegallery.dart';
import 'package:apparelapp/stock/mainstock.dart';
import 'package:apparelapp/costingreport.dart/costingreport.dart';
import 'package:apparelapp/profitlossreport/profitlossreport.dart';
import 'package:apparelapp/housekeeping/mispath.dart';
import 'package:apparelapp/housekeeping/about.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'axonlibrary/axonfilehandling.dart';
import 'package:apparelapp/axonlibrary/axondashboardgridsize.dart';
import 'package:apparelapp/axonlibrary/axongeneral.dart';
import 'package:apparelapp/axonlibrary/axonjson.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'axonlibrary/axonmessage.dart';

import 'main/loginscreen.dart';
import 'management/main_purchase_approval.dart';

AxonDashboard dashboard = AxonDashboard();
List configdetails = [];
//List<String> items = [];
List<String> items = [
  "-- Select Account Type--",
  "LAN", "WAN"
  // Add more values as needed
];
bool rememberMe = false; // State for the "Remember Me" checkbox
// ignore: prefer_typing_uninitialized_variables
var internetconnection;

void main() {
  runApp(MyApp(
    storage: ConfigurationStorage(),
  ));
  //runApp(const AppPage());
}

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  double value = 0;

  @override
  void initState() {
    super.initState();
    // internetconnection = checkinternet();
    pageloader();
  }

  @override
  void dispose() {
    super.dispose();
    //exit(0);
  }

  void pageloader() async {
    await _navigateBasedOnCache();
  }

  Future<void> _navigateBasedOnCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final companyConfigured = prefs.getString('company') != null;

      if (companyConfigured) {
        // Navigate to LoginScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyLogin()),
        );
      } else {
        // Navigate to MainScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainScreen(head: 'Welcome to Apparel'),
          ),
        );
      }
    } catch (e) {
      // Handle the error
      print("Error fetching shared preferences: $e");
    }
  }

  // void _showBottomSheet(BuildContext context) {
  //   showModalBottomSheet<void>(
  //     context: context,
  //     elevation: 40.0,
  //     // backgroundColor: Colors.cyanAccent,
  //     // builder: (context) {
  //     //   // return const ShowMessage();
  //     // },
  //   );
  // }

  Future<bool> checkinternet() async {
    try {
      final response = await InternetAddress.lookup('www.google.com');
      internetconnection = response.isNotEmpty;
    } on SocketException {
      internetconnection = false;
    }
    return internetconnection;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
        //backgroundColor: Colors.greenAccent,
      ),
      debugShowCheckedModeBanner: false,
      home: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
                //colors: [Colors.cyan, Color.fromARGB(255, 24, 70, 107)]
                //colors: [Colors.white]
                colors: [Colors.cyan, Color.fromARGB(255, 133, 179, 216)])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
              width: 300,
              child: Image.asset('assets/images/erp.png'),
            ),
            const SizedBox(
              height: 13,
              child: Text(
                'Loading....',
                style: TextStyle(
                    // height: 10,
                    letterSpacing: 0.5,
                    color: Color.fromARGB(255, 27, 16, 92),
                    fontSize: 8.0,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
                width: 350,
                child: LinearProgressIndicator(
                  value: value,
                  color: Colors.purple,
                  backgroundColor: Colors.black,
                )),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.storage});
  final ConfigurationStorage storage;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apparel+ Cloud Erp',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        // backgroundColor: Colors.black,
        // iconTheme: const IconThemeData(color: Colors.black),
      ),
      //home: const MyHomePage(title: 'Apparel+ Cloud Erp'),
      //home: const MainScreen(head: 'Welcome to Apparel'),
      home: const AppPage(),
      //home: Text(names),
      //home: const MyDrawerPage(),
      //home: const MainBudgetApproval(),
      //home :const MyLogin(title:)
      //home: FlutterDemo(storage: CounterStorage()),

      debugShowCheckedModeBanner: false,
    );
  }
}

class License {
  late List<Licensedetails> license;
}

class Licensedetails {
  int? slno;
  String? company;
  int? userlicense;
  DateTime? startdate;
  DateTime? enddate;
}

class Configdetail {
  late String company;
  late String host;
  late String port;
  late String finyear;

  Configdetail(this.company, this.host, this.port, this.finyear);

  Configdetail.fromJson(Map<String, dynamic> json) {
    company = json['company'];
    host = json['host'];
    port = json['port'];
    finyear = json['finyear'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['company'] = company;
    data['host'] = host;
    data['port'] = port;
    data['finyear'] = finyear;
    return data;
  }
}

Future<void> readPlayerData(File file) async {
  String contents = await file.readAsString();
  var jsonResponse = jsonDecode(contents);
  for (var p in jsonResponse) {
    Configdetail details =
        Configdetail(p['company'], p['host'], p['port'], p['finyesr']);
    configdetails.add(details);
  }
}
