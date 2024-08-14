import 'dart:convert';
import 'dart:io';
import 'package:apparelapp/main/app_config.dart';
import 'package:apparelapp/main/drawerpage.dart';
import 'package:apparelapp/main/mainscreen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../axonlibrary/axonfilehandling.dart';
import '../axonlibrary/axongeneral.dart';
import '../axonlibrary/axonjson.dart';
import '../axonlibrary/axonmessage.dart';
import '../main.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  late FocusNode userFocusNode;
  late FocusNode passwordFocusNode;
  late FocusNode finyearFocusNode;
  String defitem = '--Select Financial Year--';
  List<String> item = ["-- Select Account Type--", "LAN", "WAN"];

  String dropdownValue = items.first;
  final _storage = const FlutterSecureStorage();
  Future<void> loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      usernamecontroller.text = prefs.getString('username') ?? '';
      passwordcontroller.text = prefs.getString('password') ?? '';
      rememberMe = prefs.getBool('rememberMe') ?? false;
    });
  }

// Function to save login credentials
  Future<void> saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', usernamecontroller.text);
    await prefs.setString('password', passwordcontroller.text);
    await prefs.setBool('rememberMe', rememberMe);
  }

  @override
  void initState() {
    super.initState();
    loadSavedCredentials();
    userFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    finyearFocusNode = FocusNode();
    loadconfig();
  }

  Future<void> loadconfig() async {
    var file = ConfigurationStorage();
    var data = await file.readCounter();
    if (data.isNotEmpty) {
      //var datas = json.decode(data);
      var datas = jsonDecode(data);
      var config = Configdetail.fromJson(datas[0]);
      configdetails.clear();
      configdetails.add(config);
      setState(() {
        for (int i = 0; i < configdetails.length; i++) {
          items.add(configdetails[i].finyear);
        }
      });
    }
  }

  Future<void> loginclick() async {
    if (usernamecontroller.text.toString() != "" &&
        passwordcontroller.text.toString() != "") {
      for (int i = 0; i < configdetails.length; i++) {
        if (dropdownValue == configdetails[i].finyear) {
          company = configdetails[i].company;
          hostname = configdetails[i].host;
          port = configdetails[i].port;
          finyear = configdetails[i].finyear;
        }
      }
      var data = await checklogin();
      if (data.toString() != "") {
        // If "Remember Me" is checked, save the credentials
        if (rememberMe) {
          saveCredentials();
        }
        // Navigate to the next screen
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyDrawerPage()),
        );
      }
    } else {
      if (usernamecontroller.text.toString() == "") {
        userFocusNode.requestFocus();
      } else if (passwordcontroller.text.toString() == "") {
        passwordFocusNode.requestFocus();
      }
    }
  }

  Future<String> checklogin() async {
    dynamic responsedata;
    // var url =
    // '$hostname:$port/api/apilogin?username=${usernamecontroller.text}&password=${passwordcontroller.text}';
    var url =
        'http://${AppConfig().host}:${AppConfig().port}/api/apilogin?username=${usernamecontroller.text}&password=${passwordcontroller.text}';
    var body =
        '''{username:"${usernamecontroller.text}",password:"${passwordcontroller.text}"''';
    String length = body.length.toString();
    var headers = {
      'Content-Type': 'application/json',
      'Host': 'apparelmvc',
      'User-Agent': 'PostmanRuntime/7.30.0'
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        //Encrypted data;
        //AxonFunction af = AxonFunction();
        responsedata = json.decode(response.body);
        responsedata = Userdetails.fromJson(responsedata);
        //data = (responsedata.username) as Encrypted;
        //responsedata = af.decrypt(data);
        //loginusername = af.decrypt(data);
        loginuserid = responsedata.userid;
        loginusername = usernamecontroller.text;
        _showBottomSheet(context);
      } else {
        loginusername = "";
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Apparel Message'),
            content: const Text('Username or password Incorrect..!'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (ex) {
      // if (responsedata == 'null') {
      loginusername = "";
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Apparel Message'),
          content: const Text('Username or password Incorrect..!'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      // }
      throw ex.toString();
    }
    return loginusername;
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      elevation: 40.0,
      // backgroundColor: Colors.cyanAccent,
      builder: (context) {
        return const ShowLoginProgressMessage();
      },
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
    usernamecontroller.dispose();
    passwordcontroller.dispose();
    userFocusNode.dispose();
    passwordFocusNode.dispose();
    finyearFocusNode.dispose();
    item.clear();
    item.add("--Select Account Type--");
    //items.removeRange(1, items.length - 1);
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: AppBar(),
        //backgroundColor: Colors.white,
        body: Container(
      height: 1500,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0, 1],
              colors: [Colors.white, Colors.white]
              //colors: [Colors.white, Color.fromARGB(255, 18, 87, 143)]
              )),
      child: SingleChildScrollView(
        child: Center(
          widthFactor: 100,
          child: Column(children: <Widget>[
            const SizedBox(
              height: 150,
            ),
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
                controller: usernamecontroller,
                textCapitalization: TextCapitalization.none,
                focusNode: userFocusNode,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 380,
              child: TextField(
                textCapitalization: TextCapitalization.none,
                controller: passwordcontroller,
                focusNode: passwordFocusNode,
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.remove_red_eye_outlined),
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 360,
              height: 50,
              child: DropdownButton<String>(
                alignment: Alignment.centerRight,
                //dropdownColor: Colors.amber,
                isExpanded: true,
                value: dropdownValue,
                focusNode: finyearFocusNode,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(color: Colors.black),
                underline: Container(
                  height: 2,
                  color: const Color.fromARGB(255, 198, 199, 204),
                ),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
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
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.only(left: 20.0), // Adjust margin as needed
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: rememberMe,
                    onChanged: (bool? value) {
                      setState(() {
                        rememberMe = value ?? false;
                        // Call function to save credentials when checkbox state changes
                        saveCredentials();
                      });
                    },
                  ),
                  Text('Remember Me'),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 380,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.arrow_forward_sharp),
                onLongPress: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Apparel Message'),
                    content: Text(
                        'username :${usernamecontroller.text}  Password :${passwordcontroller.text}'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, 'OK');
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  loginclick();
                },
                // onPressed: () {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) => MyDrawerPage()),
                //   );
                // },
                label: const Text('Log in'),
                //child: const Text('Log in'),
              ),
            ),
            SizedBox(
              width: 380,
              child: TextButton(
                  onPressed: () {
                    item.clear();
                    item.add("--Select Account Type--");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainScreen(
                                  head: 'Welconme to Apparl',
                                )));
                  },
                  child: const Text("Activate App")),
            ),
          ]),
        ),
      ),
    ));
  }
}
