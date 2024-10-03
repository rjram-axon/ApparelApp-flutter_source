import 'package:apparelapp/axondatamodal/axonfitrationmodal/orderwisestockfilter.dart';
import 'package:apparelapp/housekeeping/about.dart';
import 'package:apparelapp/main.dart';
import 'package:apparelapp/main/loginscreen.dart';
import 'package:apparelapp/main/pie_chart.dart';
import 'package:apparelapp/management/approvals.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../axonlibrary/axongeneral.dart';
import '../costingreport.dart/costingreport.dart';
import '../housekeeping/mispath.dart';
import '../management/main_purchase_approval.dart';
import '../management/mainbudgetapproval.dart';
import '../orderstatus/mainorderstatus.dart';
import '../profitlossreport/profitlossreport.dart';
import '../stock/groupwisestock.dart';
import '../stock/mainstock.dart';
import '../stylegallery/mainstylegallery.dart';
import '../supplieroutstanding/mainoutstanding.dart';
import 'package:fl_chart/fl_chart.dart';

class MyDrawerPage extends StatefulWidget {
  const MyDrawerPage({super.key});

  @override
  State<MyDrawerPage> createState() => _MyDrawerPageState();
}

class _MyDrawerPageState extends State<MyDrawerPage> {
  final CarouselController _carouselController = CarouselController();
  final PageController _pageController = PageController();
  int _current = 0;

  final List<dynamic> _cardContents = [
    'Welcome to Axon Apparel+ ERP',
    'pieChart', // Special identifier for pie chart
  ];
  @override
  void dispose() {
    super.dispose();
    var length = items.length;
    for (int i = 1; i < length; i++) {
      items.removeAt(i);
    }
    loginusername = "";
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Return false to prevent back navigation
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: const Text(
              'Apparel+  Cloud',
              style: TextStyle(color: Color(0xFF0072FF)),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(
              color: Color(0xFF00C6FF),
            ),
            actions: <Widget>[
              Center(
                child: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 0.0,
                          backgroundColor: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Logout',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                Text(
                                  'Are you sure you want to logout?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                const SizedBox(height: 24.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Dismiss the dialog
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors
                                            .grey[200], // background color
                                        onPrimary:
                                            Colors.black, // foreground color
                                      ),
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(
                                            true); // Dismiss the dialog with true value
                                        // Perform logout action here
                                        Navigator.of(context)
                                            .pop(true); // Close current screen
                                        // Or navigate to login screen if needed
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.red, // background color
                                        onPrimary:
                                            Colors.white, // foreground color
                                      ),
                                      child: const Text('Logout'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.power_settings_new_outlined,
                    color: Color(0xFF0072FF),
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Carousel slider with automatic scrolling
                CarouselSlider.builder(
                  carouselController: _carouselController,
                  itemCount: _cardContents.length,
                  itemBuilder: (context, index, realIndex) {
                    // Show pie chart at a specific index, e.g., index 2
                    if (index == 1) {
                      return PieChartWidget();
                    } else if (index == 0) {
                      return buildCardWithImage(_cardContents[index]);
                    }
                    // Otherwise, build the regular card
                    return buildCard(_cardContents[index]);
                  },
                  options: CarouselOptions(
                    height: 220.0, // Height for the carousel
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 4),
                    enlargeCenterPage: true,
                    viewportFraction: 0.8,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    },
                  ),
                ),

                SizedBox(height: 16.0),
                // Smooth page indicator
                AnimatedSmoothIndicator(
                  activeIndex: _current,
                  count: _cardContents.length,
                  effect: ExpandingDotsEffect(
                    expansionFactor: 2,
                    activeDotColor: Color(0xFF0072FF),
                    dotHeight: 8,
                    dotWidth: 8,
                  ),
                  onDotClicked: (index) {
                    _carouselController.animateToPage(index);
                  },
                ),
                SizedBox(height: 16.0),
                // GridView with scrollable behavior
                GridView.count(
                    crossAxisSpacing: 3, //10
                    mainAxisSpacing: 20, //5
                    crossAxisCount: 2,
                    padding: const EdgeInsets.all(10.0),
                    physics:
                        NeverScrollableScrollPhysics(), // Prevents GridView from scrolling independently
                    shrinkWrap:
                        true, // Ensures GridView takes only the required space
                    children: <Widget>[
                      Card(
                        shadowColor: Colors.amber.withOpacity(0.20),
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                            style: BorderStyle.solid,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Center(
                                child: Container(
                                  alignment: Alignment
                                      .center, // Ensures icon is centered
                                  child: Column(
                                    children: [
                                      SizedBox(
                                          height:
                                              30), // Adjust the height as needed
                                      ShaderMask(
                                        shaderCallback: (Rect bounds) {
                                          return LinearGradient(
                                            colors: [
                                              Color(
                                                  0xFF00C6FF), // Electric Blue
                                              Color(
                                                  0xFF0072FF), // Rich Deep Blue
                                              Color(0xFF00FFAA), // Neon Green
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ).createShader(bounds);
                                        },
                                        child: const FaIcon(
                                          FontAwesomeIcons.stamp,
                                          size: 70,
                                          color: Colors
                                              .white, // White icon to ensure gradient visibility
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Approvals(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Approvals',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'roboto',
                                    letterSpacing: 0,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Card(
                      //   shadowColor: Colors.amber.withOpacity(0.4),
                      //   elevation: 10,
                      //   shape: RoundedRectangleBorder(
                      //     side: BorderSide(
                      //       color: Theme.of(context).colorScheme.outline,
                      //       style: BorderStyle.solid,
                      //     ),
                      //     borderRadius:
                      //         const BorderRadius.all(Radius.circular(30)),
                      //   ),
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: <Widget>[
                      //       Expanded(
                      //         child: Center(
                      //           child: SizedBox(
                      //             width: dashboard.maxsizedboxwidth,
                      //             height: dashboard.minimagesizeboxheight,
                      //             child: IconButton(
                      //               color: Colors.teal[500],
                      //               icon: const Icon(Icons.update_rounded),
                      //               iconSize: 70,
                      //               onPressed: () {
                      //                 Navigator.push(
                      //                   context,
                      //                   MaterialPageRoute(
                      //                     builder: (context) =>
                      //                         MainOrderStatus(),
                      //                   ),
                      //                 );
                      //               },
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //       Padding(
                      //         padding: const EdgeInsets.only(bottom: 8.0),
                      //         child: TextButton(
                      //           onPressed: () {
                      //             Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                 builder: (context) => MainOrderStatus(),
                      //               ),
                      //             );
                      //           },
                      //           child: Text(
                      //             'Order Status',
                      //             style: TextStyle(
                      //               color: Colors.black87,
                      //               fontWeight: FontWeight.bold,
                      //               fontFamily: 'roboto',
                      //               letterSpacing: 0,
                      //               fontSize: 13,
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Card(
                        shadowColor: Colors.amber.withOpacity(0.4),
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                            style: BorderStyle.solid,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Center(
                                child: Container(
                                  alignment: Alignment
                                      .center, // Ensures icon is centered
                                  child: Column(
                                    children: [
                                      SizedBox(
                                          height:
                                              30), // Adjust the height as needed
                                      ShaderMask(
                                        shaderCallback: (Rect bounds) {
                                          return LinearGradient(
                                            colors: [
                                              Color(
                                                  0xFF00C6FF), // Electric Blue
                                              Color(
                                                  0xFF0072FF), // Rich Deep Blue
                                              Color(0xFF00FFAA), // Neon Green
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ).createShader(bounds);
                                        },
                                        child: const FaIcon(
                                          FontAwesomeIcons.images,
                                          size: 70,
                                          color: Colors
                                              .white, // White icon to ensure gradient visibility
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MainStyleGallery(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Style Gallery',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'roboto',
                                    letterSpacing: 0,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        shadowColor: Colors.amber.withOpacity(0.4),
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                            style: BorderStyle.solid,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Center(
                                child: Container(
                                  alignment: Alignment
                                      .center, // Ensures icon is centered
                                  child: Column(
                                    children: [
                                      SizedBox(
                                          height:
                                              30), // Adjust the height as needed
                                      ShaderMask(
                                        shaderCallback: (Rect bounds) {
                                          return LinearGradient(
                                            colors: [
                                              Color(
                                                  0xFF00C6FF), // Electric Blue
                                              Color(
                                                  0xFF0072FF), // Rich Deep Blue
                                              Color(0xFF00FFAA), // Neon Green
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ).createShader(bounds);
                                        },
                                        child: const FaIcon(
                                          FontAwesomeIcons.warehouse,
                                          size: 70,
                                          color: Colors
                                              .white, // White icon to ensure gradient visibility
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MainStock(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Stock',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'roboto',
                                    letterSpacing: 0,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Card(
                      //   shadowColor: Colors.amber.withOpacity(0.4),
                      //   elevation: 10,
                      //   shape: RoundedRectangleBorder(
                      //     side: BorderSide(
                      //       color: Theme.of(context).colorScheme.outline,
                      //       style: BorderStyle.solid,
                      //     ),
                      //     borderRadius:
                      //         const BorderRadius.all(Radius.circular(30)),
                      //   ),
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: <Widget>[
                      //       Expanded(
                      //         child: Center(
                      //           child: SizedBox(
                      //             width: dashboard.maxsizedboxwidth,
                      //             height: dashboard.minimagesizeboxheight,
                      //             child: IconButton(
                      //               color: Colors.teal[500],
                      //               icon: const Icon(
                      //                   Icons.assignment_turned_in_outlined),
                      //               iconSize: 70,
                      //               onPressed: () {
                      //                 Navigator.push(
                      //                   context,
                      //                   MaterialPageRoute(
                      //                     builder: (context) => CostingReport(),
                      //                   ),
                      //                 );
                      //               },
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //       Padding(
                      //         padding: const EdgeInsets.only(bottom: 8.0),
                      //         child: TextButton(
                      //           onPressed: () {
                      //             Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                 builder: (context) => CostingReport(),
                      //               ),
                      //             );
                      //           },
                      //           child: Text(
                      //             'Costing Report',
                      //             style: TextStyle(
                      //               color: Colors.black87,
                      //               fontWeight: FontWeight.bold,
                      //               fontFamily: 'roboto',
                      //               letterSpacing: 0,
                      //               fontSize: 13,
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Card(
                      //   shadowColor: Colors.amber.withOpacity(0.4),
                      //   elevation: 10,
                      //   shape: RoundedRectangleBorder(
                      //     side: BorderSide(
                      //       color: Theme.of(context).colorScheme.outline,
                      //       style: BorderStyle.solid,
                      //     ),
                      //     borderRadius:
                      //         const BorderRadius.all(Radius.circular(30)),
                      //   ),
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: <Widget>[
                      //       Expanded(
                      //         child: Center(
                      //           child: SizedBox(
                      //             width: dashboard.maxsizedboxwidth,
                      //             height: dashboard.minimagesizeboxheight,
                      //             child: IconButton(
                      //               color: Colors.teal[500],
                      //               icon: const Icon(Icons.difference_outlined),
                      //               iconSize: 70,
                      //               onPressed: () {
                      //                 Navigator.push(
                      //                   context,
                      //                   MaterialPageRoute(
                      //                     builder: (context) =>
                      //                         ProfitLossReport(),
                      //                   ),
                      //                 );
                      //               },
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //       Padding(
                      //         padding: const EdgeInsets.only(bottom: 8.0),
                      //         child: TextButton(
                      //           onPressed: () {
                      //             Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                 builder: (context) => ProfitLossReport(),
                      //               ),
                      //             );
                      //           },
                      //           child: Text(
                      //             'Profit & Loss Report',
                      //             style: TextStyle(
                      //               color: Colors.black87,
                      //               fontWeight: FontWeight.bold,
                      //               fontFamily: 'roboto',
                      //               letterSpacing: 0,
                      //               fontSize: 13,
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Card(
                        shadowColor: Colors.amber.withOpacity(0.4),
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                            style: BorderStyle.solid,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Center(
                                child: Container(
                                  alignment: Alignment
                                      .center, // Ensures icon is centered

                                  child: Column(
                                    children: [
                                      SizedBox(
                                          height:
                                              30), // Adjust the height as needed
                                      ShaderMask(
                                        shaderCallback: (Rect bounds) {
                                          return LinearGradient(
                                            colors: [
                                              Color(
                                                  0xFF00C6FF), // Electric Blue
                                              Color(
                                                  0xFF0072FF), // Rich Deep Blue
                                              Color(0xFF00FFAA), // Neon Green
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ).createShader(bounds);
                                        },
                                        child: const FaIcon(
                                          FontAwesomeIcons.chartBar,
                                          size: 70,
                                          color: Colors
                                              .white, // White icon to ensure gradient visibility
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GroupWiseStock(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Stock Summary',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'roboto',
                                    letterSpacing: 0,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        shadowColor: Colors.amber.withOpacity(0.4),
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                            style: BorderStyle.solid,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Center(
                                child: Container(
                                  alignment: Alignment
                                      .center, // Ensures icon is centered
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          height:
                                              30), // Adjust the height as needed
                                      ShaderMask(
                                        shaderCallback: (Rect bounds) {
                                          return LinearGradient(
                                            colors: [
                                              Color(
                                                  0xFF00C6FF), // Electric Blue
                                              Color(
                                                  0xFF0072FF), // Rich Deep Blue
                                              Color(0xFF00FFAA), // Neon Green
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ).createShader(bounds);
                                        },
                                        child: const FaIcon(
                                          FontAwesomeIcons.bell,
                                          size: 70,
                                          color: Colors
                                              .white, // White icon to ensure gradient visibility
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MainOutstandingList(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Outstanding',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'roboto',
                                    letterSpacing: 1,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
              ],
            ),
          ),
          drawer: Drawer(
            // Add a ListView to the drawer. This ensures the user can scroll
            // through the options in the drawer if there isn't enough vertical
            // space to fit everything.
            //elevation: 100.0,
            semanticLabel: 'Text',
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color(0xFF00C6FF),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const Icon(
                        Icons.person_outline,
                        size: 60,
                        color: Colors.white,
                      ),
                      Text('Welcome $loginusername...!',
                          style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                              letterSpacing: 2,
                              fontSize: 17)),
                      // TextButton(
                      //   onPressed: () {
                      //     Navigator.of(context).pop();
                      //     Navigator.pushReplacement(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => const MyLogin(),
                      //       ),
                      //     );
                      //   },
                      //   child: const Text('Log out',
                      //       style: TextStyle(color: Colors.white)),
                      // ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.dashboard_outlined,
                    color: Color(0xFF00C6FF),
                  ),
                  title: const Text('Home (Dashboard)'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyDrawerPage()));
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.approval,
                    color: Color(0xFF00C6FF),
                  ),
                  title: const Text('Purchase Approval'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MainPurchaseApproval()));
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.approval,
                    color: Color(0xFF00C6FF),
                  ),
                  title: const Text('Budget Approval'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainBudgetApproval()));
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.image_outlined,
                    color: Color(0xFF00C6FF),
                  ),
                  title: const Text('Style gallery'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainStyleGallery()));
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.my_library_books_outlined,
                    color: Color(0xFF00C6FF),
                  ),
                  title: const Text('Order status'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainOrderStatus()));
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.warehouse_outlined,
                    color: Color(0xFF00C6FF),
                  ),
                  title: const Text('Order wise stock'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainStock()));
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.request_quote_outlined,
                    color: Color(0xFF00C6FF),
                  ),
                  title: const Text('Costing report'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CostingReport()));
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.difference_outlined,
                    color: Color(0xFF00C6FF),
                  ),
                  title: const Text('Profit & Loss'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfitLossReport()));
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.settings,
                    color: Color(0xFF00C6FF),
                  ),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Mispath()));
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.info_outline,
                    color: Color(0xFF00C6FF),
                  ),
                  title: const Text('About'),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const About()));
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.security,
                    color: Color(0xFF00C6FF),
                  ),
                  title: const Text('Privacy Policy'),
                  onTap: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => const About()));
                  },
                ),
              ],
            ),
          ),
        ));
  }

  Widget buildCard(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Card(
        elevation: 6.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0), // Rounded corners
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  // Method to build a card with an image
  Widget buildCardWithImage(String content) {
    return Container(
      height: 600.0,
      width: 600.0, // Manually set the card width
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/axon_logo.png', // Your image path
                height: 100,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 10),
              Expanded(
                child: Center(
                  child: Text(
                    content,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
