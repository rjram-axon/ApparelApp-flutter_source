import 'package:apparelapp/main.dart';
import 'package:apparelapp/main/app_config.dart';
import 'package:apparelapp/management/mainbudgetapproval.dart';
import 'package:apparelapp/management/processorderapp_main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'main_purchase_approval.dart';
import 'purchase_approval_list.dart';
import 'processprgapproval_main.dart';
import 'purchasequoteapproval.dart';
import 'spl_requition_approvalMain.dart';
import 'processquote_Main.dart';

class Approvals extends StatefulWidget {
  @override
  _ApprovalsState createState() => _ApprovalsState();
}

class _ApprovalsState extends State<Approvals> {
  bool _loading = true;
  bool _showProcessOrderApproval = false;
  bool _showPurchaseApproval = false;
  bool _showProcessProgApproval = false;
  bool _showSpecialReqApproval = false;
  bool _showBudgetApproval = false;
  bool _showPurchaseQuotationApproval = false;
  bool _showProcessQuotationApproval = false;
  List<int> menuidList = [
    78,
    220,
    2481,
    2482,
    2489
  ]; // Menu IDs for each approval type.

  @override
  void initState() {
    super.initState();
    _initializeApprovals();
  }

  Future<void> _initializeApprovals() async {
    try {
      final roleId = await loginUserFromPrefs();
      if (roleId != null) {
        await _fetchApprovalStatus(roleId);
      } else {
        setState(() {
          _loading = false; // Set loading false if no roleId
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No valid credentials found.')),
        );
      }
    } catch (e) {
      setState(() {
        _loading = false; // Set loading false on error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error initializing approvals: $e')),
      );
    }
  }

// Function to login using credentials stored in SharedPreferences
  Future<int?> loginUserFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('username');
    String? savedPassword = prefs.getString('password');

    if (savedUsername == null || savedPassword == null) {
      print('No saved credentials found');
      return null;
    }

    // Use the saved credentials to attempt login
    return await loginUser(savedUsername, savedPassword);
  }

// Function to login using either saved credentials from AppConfig or provided credentials
  Future<int?> loginUser([String? savedUsername, String? savedPassword]) async {
    String? username, password;

    if (savedUsername != null && savedPassword != null) {
      // If credentials are provided, use them
      username = savedUsername;
      password = savedPassword;
    }

    // Ensure username and password are not null
    if (username == null || password == null) {
      print('Username or password is null');
      return null;
    }

    // API login URL
    final url = Uri.parse(
        'http://${AppConfig().host}:${AppConfig().port}/api/apilogin?username=$username&password=$password');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success']) {
          // Extract Roleid from the first user in the 'users' array
          if (data['users'] != null && data['users'].isNotEmpty) {
            final roleId = data['users'][0]['Roleid'];

            if (roleId != null) {
              print('Login successful! Role ID: $roleId');
              return roleId;
            } else {
              print('Roleid not found in response');
            }
          } else {
            print('No users found in response');
          }
        } else {
          print('Login failed: ${data['message']}');
        }
      } else {
        print('Failed to login: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }

    return null; // Return null if login fails
  }

  Future<void> _fetchApprovalStatus(int roleid) async {
    try {
      // First call to the existing API
      final mispathResponse = await http.get(Uri.parse(
          'http://${AppConfig().host}:${AppConfig().port}/api/apimispath'));

      if (mispathResponse.statusCode == 200) {
        final mispathData = json.decode(mispathResponse.body);
        if (mispathData['success']) {
          setState(() {
            _showProcessOrderApproval = mispathData['mispaths'][0]
                    ['ValidateProcessOrderApproval'] ??
                false;
            _showPurchaseApproval =
                (mispathData['mispaths'][0]['ValidatePOApproval'] == 'Y' ||
                    mispathData['mispaths'][0]['ValidatePOGerApproval'] == 'Y');
            _showPurchaseQuotationApproval = mispathData['mispaths'][0]
                    ['chkValidateQuoteDetailsForPO'] ??
                false;
            _showProcessQuotationApproval = mispathData['mispaths'][0]
                    ['chkValidateQuoteDetailsForProcessOrder'] ??
                false;
          });

          // Then, call the role API to check the addflag for the menu
          for (var menuid in menuidList) {
            final roleResponse = await http.get(Uri.parse(
                'http://${AppConfig().host}:${AppConfig().port}/api/apirole?roleid=$roleid'));

            if (roleResponse.statusCode == 200) {
              final roleData = json.decode(roleResponse.body);
              if (roleData['success']) {
                // Check the role data to update approval flags
                for (var role in roleData['roles']) {
                  if (menuidList.contains(role['Menuid'])) {
                    setState(() {
                      switch (role['Menuid']) {
                        case 78:
                          _showBudgetApproval = role['Addflag'] == 1;
                          break;
                        case 220:
                          _showPurchaseApproval = role['Addflag'] == 1;
                          break;
                        case 2481:
                          _showProcessProgApproval = role['Addflag'] == 1;
                          break;
                        case 2482:
                          _showSpecialReqApproval = role['Addflag'] == 1;
                          break;
                        case 2489:
                          _showProcessOrderApproval = role['Addflag'] == 1;
                          break;
                      }
                    });
                  }
                }
              }
            }
          }
        }
      }

      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print('Error fetching approval status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            'Approvals',
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
        body: _loading
            ? Center(child: CircularProgressIndicator())
            : Column(children: [
                SizedBox(height: 16.0),
                Expanded(
                  child: GridView.count(
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 20,
                    crossAxisCount: 2,
                    padding: const EdgeInsets.all(10.0),
                    children: <Widget>[
                      if (_showPurchaseApproval)
                        _buildApprovalCard(
                          context,
                          icon: Icons.local_mall_rounded,
                          label: 'Purchase Approval',
                          page: MainPurchaseApproval(),
                        ),
                      if (_showBudgetApproval)
                        _buildApprovalCard(
                          context,
                          icon: Icons.receipt_long_rounded,
                          label: 'Budget Approval',
                          page: MainBudgetApproval(),
                        ),
                      if (_showProcessOrderApproval)
                        _buildApprovalCard(
                          context,
                          icon: Icons.assignment,
                          label: 'Process Order',
                          page: ProcessApprovalPage(),
                        ),
                      if (_showProcessProgApproval)
                        _buildApprovalCard(
                          context,
                          icon: Icons.hourglass_bottom_rounded,
                          label: 'Shortage Approval',
                          page: ProcessProgramApprovalPage(),
                        ),
                      if (_showSpecialReqApproval)
                        _buildApprovalCard(
                          context,
                          icon: Icons.assignment_turned_in_rounded,
                          label: 'Special Requisition Approval',
                          page: SpecialRequitionApprovalPage(),
                        ),
                      if (_showPurchaseQuotationApproval)
                        _buildApprovalCard(
                          context,
                          icon: Icons.shopping_cart_outlined,
                          label: 'Purchase Quotation Approval',
                          page: PurchaseQuotationApprovalPage(),
                        ),
                      if (_showProcessQuotationApproval)
                        _buildApprovalCard(
                          context,
                          icon: Icons.business_center_rounded,
                          label: 'Process Quotation Approval',
                          page: ProcessQuotationApprovalPage(),
                        ),
                    ],
                  ),
                )
              ]));
  }

  Widget _buildApprovalCard(BuildContext context,
      {required IconData icon, required String label, required Widget page}) {
    return Card(
      shadowColor: Colors.amber.withOpacity(0.4),
      elevation: 10,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
          style: BorderStyle.solid,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center the children vertically
              children: [
                SizedBox(height: 20), // Adjust this if needed
                IconButton(
                  iconSize: 80, // Increase icon size if necessary
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => page,
                      ),
                    );
                  },
                  icon: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        colors: [
                          Color(0xFF00C6FF), // Electric Blue
                          Color(0xFF0072FF), // Rich Deep Blue
                          Color(0xFF00FFAA), // Neon Green
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: FaIcon(
                      icon, // Use the same icon passed to the IconButton
                      size: 70, // Set size of the FaIcon
                      color: Colors
                          .white, // Set color to ensure gradient visibility
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => page,
                  ),
                );
              },
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Set font color to black
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class User {
  int userId;
  int roleId;
  String username;
  String password;
  String roleName;
  String loginStatus;
  String? loginPC;
  int unitId;
  int menuId;
  int allFlag;
  int addFlag;
  int editFlag;
  int deleteFlag;
  int printFlag;

  User({
    required this.userId,
    required this.roleId,
    required this.username,
    required this.password,
    required this.roleName,
    required this.loginStatus,
    this.loginPC,
    required this.unitId,
    required this.menuId,
    required this.allFlag,
    required this.addFlag,
    required this.editFlag,
    required this.deleteFlag,
    required this.printFlag,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['UserId'],
      roleId: json['Roleid'],
      username: json['Username'],
      password: json['Password'],
      roleName: json['RoleName'],
      loginStatus: json['LoginStatus'],
      loginPC: json['LoginPC'],
      unitId: json['UnitId'],
      menuId: json['MenuId'],
      allFlag: json['AllFlg'],
      addFlag: json['AddFlg'],
      editFlag: json['EditFlg'],
      deleteFlag: json['DeleteFlg'],
      printFlag: json['PrintFlg'],
    );
  }
}
