import 'dart:convert';
import 'package:apparelapp/axonlibrary/axongeneral.dart';
import 'package:apparelapp/axonlibrary/axonjson.dart';
import 'package:apparelapp/axonlibrary/axonmessage.dart';
import 'package:apparelapp/main/app_config.dart';
import 'package:apparelapp/main/drawerpage.dart';
import 'package:apparelapp/main/mainscreen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late FocusNode userFocusNode;
  late FocusNode passwordFocusNode;
  late FocusNode accountFocusNode;
  String defItem = '--Select Account--';
  List<String> items = ["-- Select Account--"];
  String dropdownValue = "-- Select Account--";

  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    loadSavedCredentials();
    userFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    accountFocusNode = FocusNode();
    loadConfig();
  }

  Future<void> loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      usernameController.text = prefs.getString('username') ?? '';
      passwordController.text = prefs.getString('password') ?? '';
      rememberMe = prefs.getBool('rememberMe') ?? false;
    });
  }

  Future<void> saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', usernameController.text);
    await prefs.setString('password', passwordController.text);
    await prefs.setBool('rememberMe', rememberMe);
  }

  Future<void> loadConfig() async {
    AppConfig config = AppConfig();
    List<Map<String, String>> allConfigs = await config.loadAllConfigs();

    setState(() {
      items.clear();
      items.add("-- Select Account--");
      for (var conf in allConfigs) {
        items.add(conf['company']!);
      }
      if (items.length > 1) {
        dropdownValue = items[1];
        config.loadConfig(dropdownValue);
      }
    });
  }

  Future<void> loginclick() async {
    if (usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        dropdownValue != "-- Select Account--") {
      AppConfig config = AppConfig();
      await config.loadConfig(dropdownValue);

      var data = await checkLogin();
      if (data.isNotEmpty) {
        if (rememberMe) {
          await saveCredentials();
        }
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyDrawerPage()),
        );
      }
    } else {
      if (usernameController.text.isEmpty) {
        userFocusNode.requestFocus();
      } else if (passwordController.text.isEmpty) {
        passwordFocusNode.requestFocus();
      } else if (dropdownValue == "-- Select Account--") {
        accountFocusNode.requestFocus();
      }
    }
  }

  Future<String> checkLogin() async {
    String username = usernameController.text;
    String password = passwordController.text;

    var url =
        'http://${AppConfig().host}:${AppConfig().port}/api/apilogin?username=$username&password=$password';
    var headers = {
      'Content-Type': 'application/json',
      'Host': 'apparelmvc',
      'User-Agent': 'PostmanRuntime/7.30.0'
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        var userDetails = responseData['users'];
        // Store permissions globally
        await saveUserPermissions(userDetails);

        loginusername = username;
        _showBottomSheet(context);
      } else {
        loginusername = "";
        _showErrorDialog('Username or password Incorrect..!');
      }
    } catch (ex) {
      loginusername = "";
      _showErrorDialog('Username or password Incorrect..!');
    }
    return loginusername;
  }

  Future<void> saveUserPermissions(Map<String, dynamic> userDetails) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt('Addflag', userDetails['Addflag']);
    await prefs.setInt('Editflag', userDetails['Editflag']);
    await prefs.setInt('Deleteflag', userDetails['Deleteflag']);
    await prefs.setInt('Printflag', userDetails['Printflag']);
  }

  void _showErrorDialog(String message) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Apparel Message'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      elevation: 40.0,
      builder: (context) {
        return const ShowLoginProgressMessage();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
    userFocusNode.dispose();
    passwordFocusNode.dispose();
    accountFocusNode.dispose();
    items.clear();
    items.add("--Select Account--");
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: double.infinity,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0, 1],
              colors: [Colors.white, Colors.white])),
      child: SingleChildScrollView(
        child: Center(
          child: Column(children: <Widget>[
            const SizedBox(height: 150),
            Image.asset('assets/images/axon_logo.png', width: 150, height: 150),
            const SizedBox(
                height: 50,
                child: Text('Welcome to axon ..!',
                    style: TextStyle(
                        color: Color.fromARGB(255, 26, 72, 94),
                        fontSize: 25.0,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold))),
            SizedBox(
              width: 380,
              child: TextField(
                controller: usernameController,
                focusNode: userFocusNode,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 380,
              child: TextField(
                controller: passwordController,
                focusNode: passwordFocusNode,
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.remove_red_eye_outlined),
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 360,
              height: 50,
              child: DropdownButton<String>(
                alignment: Alignment.centerRight,
                isExpanded: true,
                value: dropdownValue,
                focusNode: accountFocusNode,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(color: Colors.black),
                underline: Container(
                  height: 2,
                  color: const Color.fromARGB(255, 198, 199, 204),
                ),
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                items: items.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.only(left: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: rememberMe,
                    onChanged: (bool? value) {
                      setState(() {
                        rememberMe = value ?? false;
                        saveCredentials();
                      });
                    },
                  ),
                  const Text('Remember Me'),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 380,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.arrow_forward_sharp),
                onPressed: loginclick,
                label: const Text('Log in'),
              ),
            ),
            SizedBox(
              width: 380,
              child: TextButton(
                onPressed: () {
                  items.clear();
                  items.add("--Select Account--");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainScreen(
                                head: 'Welcome to Apparel',
                              )));
                },
                child: const Text("Activate App"),
              ),
            ),
          ]),
        ),
      ),
    ));
  }
}
