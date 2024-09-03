import 'package:apparelapp/axondatamodal/axonfitrationmodal/budgerapprovalmainlist.dart';
import 'package:apparelapp/axonlibrary/axonbudgetlibrary.dart';
import 'package:apparelapp/axonlibrary/axonfunctions.dart';
import 'package:apparelapp/management/budgetapproval.dart';
import 'package:flutter/material.dart';
import 'package:apparelapp/axondatamodal/budgetapprovalmainlistmodal.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:apparelapp/main/app_config.dart';
import '../axondatamodal/axonfitrationmodal/axonbudgetdetailmodal.dart';
import '../axondatamodal/budgetapprovaldetailmodal.dart';
import '../axonlibrary/axongeneral.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

AxonFunction af = AxonFunction();

/* All orders are splitted into pending and approved category based on budget (MainBudgetApproval)*/
class MainBudgetApproval extends StatefulWidget {
  const MainBudgetApproval({super.key});

  @override
  State<MainBudgetApproval> createState() => _MainBudgetApprovalState();
}

class _MainBudgetApprovalState extends State<MainBudgetApproval> {
  int _selectedIndex = 0;
  int budgetlistlength = 0;
  var items = ['test', 'test'];
  var order = 2;
  late IconData iconname = Icons.verified_user_sharp;
  final List<BudgetApprovalMainListModal> _budgetitems = [];
  TextEditingController txtsearchcontroller = TextEditingController();
  bool _isLoading = false; // Variable to track data fetching state

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    btype = "BUDGET";
    bordertype = "B";
    getbudgetmainlist();
    iconname = Icons.pending_actions_sharp;
  }

  @override
  void dispose() {
    super.dispose();
    _budgetitems.clear();
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        btype = "BUDGET";
        iconname = Icons.pending_actions_sharp;
        break;
      case 1:
        btype = "APPROVED";
        iconname = Icons.verified_user_sharp;
        break;
    }
    _budgetitems.clear();
    getbudgetmainlist();
    _selectedIndex = index;
  }

  void _reset() {
    _selectedIndex = 0;
    _onItemTapped(_selectedIndex);
  }

  void getbudgetmainlist() async {
    setState(() {
      _isLoading = true; // Set loading state to true
    });
    dynamic responsedata;
    var url =
        // '$hostname:$port/api/apibudgetapproval?cmpid=$bcompanyid&styleid=$bstyleid&orderno=$borderno&refno=$brefno&type=$btype&ordtype=$bordertype&fromdate=01/06/2021&todate=24/12/2022';
        'http://${AppConfig().host}:${AppConfig().port}/api/apibudgetapproval?type=$btype&ordtype=$bordertype&fromdate=01/06/2021&todate=30/05/2025';

    var body = '''''';
    String length = body.length.toString();
    var headers = {
      'Content-Type': 'application/json',
      'Content-Length': length,
      'Host': 'localhost',
      'User-Agent': 'PostmanRuntime/7.30.0'
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        responsedata = json.decode(response.body.toString());

        for (int i = 0; i < responsedata.length; i++) {
          dynamic data = BudgetApprovalMainListModal.fromJson(responsedata[i]);
          _budgetitems.add(BudgetApprovalMainListModal(
              data.cmp,
              data.cmpid,
              data.GUOM,
              data.orderdate,
              data.orderno,
              data.quantity,
              data.refno,
              data.style,
              data.styleamount,
              data.styleid));
        }
        _budgetitems.sort((a, b) =>
            a.orderno!.toUpperCase().compareTo(b.orderno!.toUpperCase()));
        setState(() {
          budgetlistlength = _budgetitems.length;
          _selectedIndex;
        });
      } else {}
    } catch (ex) {
      throw ex.toString();
    } finally {
      setState(() {
        _isLoading = false; // Set loading state to false
      });
    }
  }

  void filter(dynamic value) {
    if (value != "") {
      _budgetitems.retainWhere((data) {
        return data.orderno!.toLowerCase().contains(value.toLowerCase());
      });
    } else {
      _reset();
    }
    setState(() {
      budgetlistlength = _budgetitems.length;
    });
  }

  //List cards = List.generate(20, (i)=> _widgetOptions.elementAt(_selectedIndex));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              // Display loading indicator while fetching data
              child: SpinKitFadingCircle(
                color: Colors.blue, // Choose your desired color
                size: 50.0, // Set the size of the loading animation
              ), // Loading indicator
            )
          : NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxScrolled) {
                return <Widget>[
                  SliverAppBar(
                    elevation: 5,
                    pinned: true,
                    centerTitle: true,
                    title: Text('Main - Budget approval'),
                    actions: [
                      IconButton(
                        onPressed: () {
                          _reset();
                        },
                        icon: Icon(Icons.restart_alt_rounded),
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        height: 40,
                        margin: EdgeInsets.only(top: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: txtsearchcontroller,
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 15),
                            suffixIcon: IconButton(
                              onPressed: () {
                                filter(txtsearchcontroller.text);
                              },
                              icon: const Icon(Icons.search),
                            ),
                          ),
                          onChanged: (value) {
                            filter(txtsearchcontroller.text);
                          },
                          style: const TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: ListView.builder(
                itemCount: budgetlistlength,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation:
                          0, // Set elevation to 0 since we're using the container's shadow
                      child: ListTile(
                        contentPadding: EdgeInsets.all(11),
                        leading: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: btype == "APPROVED"
                                ? Colors.green
                                : Colors.orange,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            btype == "APPROVED"
                                ? Icons.check_circle
                                : Icons.pending_actions_outlined,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          "Order No : ${_budgetitems[index].orderno.toString()}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Ref No : ${_budgetitems[index].refno.toString()}"),
                              SizedBox(height: 5),
                              Text(
                                  "Style : ${_budgetitems[index].style.toString()}"),
                              SizedBox(height: 5),
                              Text(
                                  "Quantity : ${_budgetitems[index].quantity.toString()}"),
                              SizedBox(height: 5),
                              Text(
                                  "Style Value :  ${_budgetitems[index].styleamount.toString()} "),
                              SizedBox(height: 5),
                            ],
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.navigate_next_rounded),
                        ),
                        isThreeLine: true,
                        onTap: () {
                          forderno = _budgetitems[index].orderno.toString();
                          fstyleid = _budgetitems[index].styleid!;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => BudgetApproval(
                                    orderno: forderno,
                                    styleid: fstyleid,
                                  )),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.pending_actions_outlined,
              color: _selectedIndex == 0 ? Colors.orange : Colors.grey,
            ),
            label: 'Pending',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.verified_outlined,
              color: _selectedIndex == 1 ? Colors.green : Colors.grey,
            ),
            label: 'Approved',
            tooltip: 'Approved',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: _selectedIndex == 1
            ? Colors.green
            : _selectedIndex == 0
                ? Colors.orange
                : Colors.grey,
        iconSize: 25,
        onTap: _onItemTapped,
      ),
    );
  }
}
