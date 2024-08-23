import 'package:apparelapp/main.dart';
import 'package:apparelapp/main/app_config.dart';
import 'package:apparelapp/main/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../axonlibrary/axonfilehandling.dart';
import '../axonlibrary/axongeneral.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.head});
  final String head;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController company = TextEditingController();
  TextEditingController host = TextEditingController();
  TextEditingController port = TextEditingController();
  TextEditingController attachment_port = TextEditingController();
  TextEditingController finyear = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? companyName = prefs.getString('company');

    if (companyName != null && companyName.isNotEmpty) {
      company.text = companyName;

      // Load host and port based on the company name
      String? configJson = prefs.getString('config_${company.text}');
      if (configJson != null) {
        Map<String, dynamic> configData = json.decode(configJson);
        host.text = configData['host'] ?? '';
        port.text = configData['port'] ?? '';

        // Set the host and port in AppConfig when loading the data
        AppConfig().setConfig(
            company: company.text,
            host: host.text,
            port: port.text,
            attachment_port: attachment_port.text);
      }
    }
  }

  Future<void> _savedata() async {
    Configdetail cdet =
        Configdetail(company.text, host.text, port.text, finyear.text);

    if (cdet.company.isNotEmpty) {
      configdetails.add(cdet);

      // Save data to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('company', company.text);
      await prefs.setString('host', host.text);
      await prefs.setString('port', port.text);
      await prefs.setString('finyear', finyear.text);

      // Retrieve existing company names or create a new list
      List<String> companies = prefs.getStringList('companyNames') ?? [];
      if (!companies.contains(company.text)) {
        companies.add(company.text);
      }

      // Save the updated list of company names
      await prefs.setStringList('companyNames', companies);

      // Set the host and port in AppConfig after saving the data
      AppConfig().setConfig(
          company: company.text,
          host: host.text,
          port: port.text,
          attachment_port: attachment_port.text);

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
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyLogin(),
                ),
              ),
              child: const Text('Go To Login'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> delete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Delete the specific company configuration
    await prefs.remove('config_${company.text}');

    // Optionally, clear the company name
    await prefs.remove('company');

    // Clear the TextEditingController values to reflect the reset
    setState(() {
      company.clear();
      host.clear();
      port.clear();
      finyear.clear();
    });

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Apparel Message'),
        content: const Text('All Configurations are deleted successfully...!'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    company.dispose();
    host.dispose();
    port.dispose();
    finyear.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0, 1],
            colors: [Colors.white, Colors.white],
          ),
        ),
        child: Center(
          widthFactor: 100,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/erp.png', width: 300, height: 150),
                SizedBox(
                  width: 380,
                  child: TextField(
                    controller: company,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Company name',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
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
                const SizedBox(height: 10),
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
                const SizedBox(height: 10),
                SizedBox(
                  width: 380,
                  child: TextField(
                    controller: attachment_port,
                    textCapitalization: TextCapitalization.none,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Attachment Port For Quotaions',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: delete,
                        child: const Text('Reset'),
                      ),
                      ElevatedButton(
                        onPressed: _savedata,
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      persistentFooterButtons: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyLogin(),
              ),
            );
          },
          child: const Text('Next'),
        ),
      ],
    );
  }
}
