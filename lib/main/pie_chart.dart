import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:apparelapp/main/app_config.dart';
import 'package:apparelapp/management/main_purchase_approval.dart';
import 'package:apparelapp/management/mainbudgetapproval.dart';
import 'package:apparelapp/management/processorderapp_main.dart';
import 'package:apparelapp/management/processprgapproval_details.dart';
import 'package:apparelapp/management/processprgapproval_main.dart';
import 'package:apparelapp/management/spl_requition_approvalMain.dart';
import 'package:apparelapp/management/splrequitionappDetails.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../axondatamodal/axonfitrationmodal/budgerapprovalmainlist.dart';

class PieChartWidget extends StatefulWidget {
  @override
  _PieChartWidgetState createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int touchedIndex = -1; // To track which section is tapped
  bool _loading = true;
  bool _showProcessOrderApproval = false;
  bool _showPurchaseApproval = false;
  bool _showPurchaseQuotationApproval = false;
  int approvedCount = 0;
  int pendingCount = 0;
  int processordapppending = 0;
  int totalsplreqpenCount = 0;
  bool _showProcessOrderApp = false;
  bool _showPurchaseApp = false;
  bool _showProcessProgApproval = false;
  bool _showSpecialReqApproval = false;
  bool _showBudgetApproval = false;
  bool _showPurchaseQuotationApp = false;
  bool _showProcessQuotationApproval = false;
  bool _showPieChart = false;
  bool _isLoading = false; // Variable to track data fetching state
  int budgetpendingCount = 0;

  List<int> menuidList = [
    78,
    220,
    2481,
    2482,
    2489
  ]; // Menu IDs for each approval type.

  // Removed _showProcessQuotationApproval as it's no longer used

  @override
  void initState() {
    super.initState();
    // Fetch both approval status and pending counts concurrently
    _fetchApprovalStatus()
        .then((_) => poPendingCounts())
        .then((_) => _processOrdAppPendingCount())
        .then((_) => fetchPendingsplreqCount())
        .then((_) => fetchprocessprgapppending())
        .then((_) => getBudgetCount())
        .then((_) {
      setState(() {
        _loading = false;
      });
    }).catchError((e) {
      // Handle errors appropriately
      setState(() {
        _loading = false;
      });
      print('Initialization error: $e');
    });
  }

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

  Future<void> _rolepermission(int roleid) async {
    try {
      // Call to mispath API
      final mispathResponse = await http.get(Uri.parse(
          'http://${AppConfig().host}:${AppConfig().port}/api/apimispath'));

      if (mispathResponse.statusCode == 200) {
        final mispathData = json.decode(mispathResponse.body);
        if (mispathData['success']) {
          setState(() {
            // Update UI based on mispath response
            _showProcessOrderApp = mispathData['mispaths'][0]
                    ['ValidateProcessOrderApproval'] ??
                false;
            _showPurchaseApp =
                mispathData['mispaths'][0]['ValidatePOApproval'] == 'Y' ||
                    mispathData['mispaths'][0]['ValidatePOGerApproval'] == 'Y';
            _showPurchaseQuotationApp = mispathData['mispaths'][0]
                    ['chkValidateQuoteDetailsForPO'] ??
                false;
            _showProcessQuotationApproval = mispathData['mispaths'][0]
                    ['chkValidateQuoteDetailsForProcessOrder'] ??
                false;
          });

          // Call the role API to fetch the user's permissions
          for (var menuid in menuidList) {
            final roleResponse = await http.get(Uri.parse(
                'http://${AppConfig().host}:${AppConfig().port}/api/apirole?roleid=$roleid'));

            if (roleResponse.statusCode == 200) {
              final roleData = json.decode(roleResponse.body);
              if (roleData['success']) {
                // Update based on Menuid and Addflag
                for (var role in roleData['roles']) {
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

                      default:
                        break;
                    }
                    print(
                        "Menuid: ${role['Menuid']}, Addflag: ${role['Addflag']}");
                  });
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

  Future<void> poPendingCounts() async {
    final approvedUrl =
        'http://${AppConfig().host}:${AppConfig().port}/api/apipurchaseapproval?isapproved=Y';
    final pendingUrl =
        'http://${AppConfig().host}:${AppConfig().port}/api/apipurchaseapproval?isapproved=N';

    try {
      final approvedResponse = await http.get(Uri.parse(approvedUrl));
      final pendingResponse = await http.get(Uri.parse(pendingUrl));

      if (approvedResponse.statusCode == 200 &&
          pendingResponse.statusCode == 200) {
        final List<dynamic> approvedPurchases =
            jsonDecode(approvedResponse.body)['purchases'];
        final List<dynamic> pendingPurchases =
            jsonDecode(pendingResponse.body)['purchases'];

        final Set<String> approvedPOs = approvedPurchases
            .map((purchase) => purchase['PO_Number'] as String)
            .toSet();

        final Set<String> pendingPOs = pendingPurchases
            .map((purchase) => purchase['PO_Number'] as String)
            .toSet();

        setState(() {
          approvedCount = approvedPOs.length;
          pendingCount = pendingPOs.length;
          print('Fetching counts: $pendingCount');
        });
      } else {
        throw Exception('Failed to load counts');
      }
    } catch (e) {
      print('Error fetching counts: $e');
    }
  }

// Function to fetch pending approvals
  Future<List<ApiProcess>> fetchProcesses(String approvedStatus) async {
    final String apiUrl =
        'http://${AppConfig().host}:${AppConfig().port}/api/apiprocessordapproval?approved=$approvedStatus';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['success']) {
        List<dynamic> processesJson = jsonData['processes'];
        return processesJson.map((json) => ApiProcess.fromJson(json)).toList();
      } else {
        throw Exception(jsonData['message']);
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

// Function to calculate pending count
  Future<void> _processOrdAppPendingCount() async {
    try {
      List<ApiProcess> pendingProcesses =
          await fetchProcesses('P'); // 'P' for pending
      setState(() {
        processordapppending =
            pendingProcesses.length; // Number of pending approvals
        print('Fetching ProcessPending counts: $processordapppending');
      });
    } catch (error) {
      print('Error calculating pending count: $error');
      setState(() {
        processordapppending = 0; // Reset count in case of error
      });
    }
  }

  Future<void> _fetchApprovalStatus() async {
    try {
      final response = await http.get(Uri.parse(
          'http://${AppConfig().host}:${AppConfig().port}/api/apimispath')); // Replace with your API URL

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          setState(() {
            _showProcessOrderApproval =
                data['mispaths'][0]['ValidateProcessOrderApproval'] ?? false;
            _showPurchaseApproval =
                (data['mispaths'][0]['ValidatePOApproval'] == 'Y' ||
                    data['mispaths'][0]['ValidatePOGerApproval'] == 'Y');
            // Removed _showProcessQuotationApproval as it's no longer used
          });
        }
      }
    } catch (e) {
      print('Error fetching approval status: $e');
    }
  }

  Future<int> fetchPendingsplreqCount() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://${AppConfig().host}:${AppConfig().port}/api/apisplreqapproval?isapproved=N'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print(jsonResponse); // Log the JSON response

        if (jsonResponse['success']) {
          List<dynamic> body =
              jsonResponse['splreqs'] ?? []; // Handle null case

          // Get the count of total requisitions
          totalsplreqpenCount = body.length; // Count of items received

          // Count the number of pending orders (assuming 'N' is the pending status)
          int pendingCount =
              body.where((item) => item['isapproved'] == 'N').length;

          print('Total Requisitions: $totalsplreqpenCount'); // Log total count
          print('Pending Requisitions: $pendingCount'); // Log pending count

          return pendingCount; // Return the count of pending requisitions
        } else {
          return 0; // Return 0 if success is false
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching data: $error');
    }
  }

  Future<dynamic> fetchprocessprgapppending() async {
    final response = await http.get(Uri.parse(
        'http://${AppConfig().host}:${AppConfig().port}/api/apiprocessprgapproval?approved=N'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data); // Log the JSON response
      if (data['success']) {
        final allItems = (data['processprglist'] as List)
            .map((item) => ApiProcessPrgAppdetails.fromJson(item))
            .toList();

        // Remove duplicates based on 'orderno'
        final uniqueItems = <String, ApiProcessPrgAppdetails>{};
        for (var item in allItems) {
          uniqueItems[item.orderno] = item;
        }

        // Count of unique items
        int count = uniqueItems.length; // Get the count of unique items
        print('Total unique items count: $count'); // Log the count

        // Return both the count and the unique items
        return {
          'count': count,
          'items': uniqueItems.values.toList(),
        };
      } else {
        throw Exception(data['message']);
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> getBudgetCount() async {
    setState(() {
      _isLoading = true; // Set loading state to true
    });

    var url =
        'http://${AppConfig().host}:${AppConfig().port}/api/apibudgetapproval?type=BUDGET&ordtype=$bordertype&fromdate=01/06/2021&todate=30/05/2025';

    var headers = {
      'Content-Type': 'application/json',
      'User-Agent': 'PostmanRuntime/7.30.0'
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        var responsedata = json.decode(response.body.toString());

        // Ensure the response is a list and count the items with type 'BUDGET'
        if (responsedata is List) {
          budgetpendingCount =
              responsedata.where((item) => item['type'] == "BUDGET").length;
        } else {
          print("Unexpected data format");
        }

        setState(() {
          // Use budgetpendingCount as needed, for example:
          print("Number of BUDGET items: $budgetpendingCount");
        });
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (ex) {
      print('Error: $ex');
    } finally {
      setState(() {
        _isLoading = false; // Set loading state to false
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Conditionally show the Pie Chart based on role permissions
        // if (_showPieChart)
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0), // Add top padding
              child: SizedBox(
                width:
                    200, // Adjust this to control the overall size of the PieChart
                height: 200, // Adjust height accordingly
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                          _showMessageTile(
                              context, touchedIndex); // Show message tile
                        });
                      },
                    ),
                    sections: _buildSections(),
                    sectionsSpace: 2, // Optional: space between sections
                    centerSpaceRadius: 25, // Reduced to make the chart smaller
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Section Legend (can also be shown conditionally)
        // if (_showPieChart)
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: _getActiveSections().map((section) {
              return Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: section.color,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    section.title,
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildSections() {
    List<_PieSection> activeSections = _getActiveSections();

    // Calculate the total value for dynamic sizing
    double total =
        activeSections.fold(0, (sum, section) => sum + section.value);

    if (total == 0) {
      return [];
    }

    return activeSections.asMap().entries.map((entry) {
      int idx = entry.key;
      _PieSection section = entry.value;
      final isTouched = section.index == touchedIndex;
      final double fontSize = isTouched ? 10.0 : 10.0;
      final double radius = isTouched ? 70.0 : 60.0;

      // Calculate percentage based on total
      double percentage = (section.value / total) * 100;

      return PieChartSectionData(
        color: section.color,
        value: section.value,
        title: '${section.value.toStringAsFixed(0)}',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  List<_PieSection> _getActiveSections() {
    List<_PieSection> activeSections = [];

    if (_showPurchaseApproval) {
      activeSections.add(_PieSection(
        title: 'Budget App',
        value: 10,
        color: Color(0xFF6A0DAD), // Royal Purple
        index: 0,
      ));
    }

    if (_showPurchaseApproval) {
      activeSections.add(_PieSection(
        title: 'PO App',
        value: pendingCount.toDouble(),
        color: Colors.teal, // Deep Sky Blue
        index: 1,
      ));
    }

    // **Always include Budget Approval**
    activeSections.add(
      _PieSection(
        title: 'Shortage App',
        value: 1,
        color: Color(0xFFFF8C00), // Dark Orange
        index: 2,
      ),
    );

    // **Always include Special Requisition Approval**
    activeSections.add(
      _PieSection(
        title: 'SplReq App',
        value: totalsplreqpenCount.toDouble(),
        color: Color(0xFFFF1493), // Deep Pink
        index: 3,
      ),
    );

    return activeSections;
  }

  void _showMessageTile(BuildContext context, int index) {
    final activeSections = _getActiveSections();
    if (index < 0 || index >= activeSections.length) return;

    final section = activeSections[index];

    Flushbar(
      message: '${section.title} (${section.title == 'Purchase Approval' ? {
          section.value.toStringAsFixed(0)
        } : '${(section.value / activeSections.fold(0, (sum, s) => sum + s.value)) * 100}%'})',
      duration: Duration(seconds: 2),
      onStatusChanged: (status) {
        if (status == FlushbarStatus.DISMISSED) {
          _navigateToPage(context, section.index);
        }
      },
      icon: Icon(
        Icons.info_outline,
        size: 28.0,
        color: section.color,
      ),
      leftBarIndicatorColor: section.color,
    ).show(context);
  }

  void _navigateToPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        // Navigate to ProcessApprovalPage (Blue section)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainBudgetApproval(),
          ),
        );
        break;
      case 1:
        // Navigate to MainPurchaseApproval (Red section)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainPurchaseApproval(),
          ),
        );
        break;
      case 2:
        // Navigate to ProcessProgramApprovalPage (Green section)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProcessProgramApprovalPage(),
          ),
        );
        break;
      // case 3:
      //   // Navigate to MainBudgetApproval (Orange section) **Always Available**
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) =>
      //           MainBudgetApproval(), // Corrected to MainBudgetApproval
      //     ),
      //   );
      //   break;
      case 3:
        // Navigate to SpecialRequisitionApprovalPage (Purple section)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                SpecialRequitionApprovalPage(), // Replace with the actual page
          ),
        );
        break;
      // case 4:
      //   // Navigate to SpecialRequisitionApprovalPage (Purple section)
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) =>
      //           SpecialRequitionApprovalPage(), // Replace with the actual page
      //     ),
      //   );
      //   break;
      default:
        // Handle other cases or show a default page
        break;
    }
  }
}

// Example of a detailed page for other sections
class PieChartDetailPage extends StatelessWidget {
  final int index;

  PieChartDetailPage({required this.index});

  @override
  Widget build(BuildContext context) {
    final sectionData = [
      {
        'color': Colors.teal,
        'value': '40%',
        'description': 'Blue section details...'
      },
      {
        'color': Colors.red,
        'value': '30%',
        'description': 'Red section details...'
      },
      {
        'color': Colors.green,
        'value': '20%',
        'description': 'Green section details...'
      },
      {
        'color': Colors.orange,
        'value': '10%',
        'description': 'Orange section details...'
      },
    ];

    final selectedSection = sectionData[index];

    return Scaffold(
      appBar: AppBar(title: Text('Section Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selected Section: ${selectedSection['value']}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text(
              selectedSection['description'] as String,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class _PieSection {
  final String title;
  final double value;
  final Color color;
  final int index;

  _PieSection({
    required this.title,
    required this.value,
    required this.color,
    required this.index,
  });
}
