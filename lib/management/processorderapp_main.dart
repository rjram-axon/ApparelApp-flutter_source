import 'dart:convert';
import 'package:apparelapp/main/app_config.dart';
import 'package:apparelapp/management/processorderapp_approve.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class ApiProcess {
  final String processOrder;
  final DateTime processOrderDate;
  final String companyName;
  final String companyUnit;
  final String process;
  final String processor;
  final String approved;
  final int procid;

  ApiProcess({
    required this.processOrder,
    required this.processOrderDate,
    required this.companyName,
    required this.companyUnit,
    required this.process,
    required this.processor,
    required this.approved,
    required this.procid,
  });

  factory ApiProcess.fromJson(Map<String, dynamic> json) {
    return ApiProcess(
      processOrder: json['processorder'] ?? 'N/A',
      processOrderDate: DateTime.parse(json['ProcessOrdate']),
      companyName: json['CompanyName'] ?? 'N/A',
      companyUnit: json['CompanyUnit'] ?? 'N/A',
      process: json['Process'] ?? 'N/A',
      processor: json['Processor'] ?? 'N/A',
      approved: json['Approved'] ?? 'N/A',
      procid: json['processordid'] ?? '',
    );
  }
}

class ApiService {
  static String apiUrl =
      'http://${AppConfig().host}:${AppConfig().port}/api/apiprocessordapproval';

  Future<List<ApiProcess>> fetchProcesses(String approved) async {
    final response = await http.get(Uri.parse('$apiUrl?approved=$approved'));

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
}

class ProcessApprovalPage extends StatefulWidget {
  @override
  _ProcessApprovalPageState createState() => _ProcessApprovalPageState();
}

class _ProcessApprovalPageState extends State<ProcessApprovalPage> {
  late Future<List<ApiProcess>> futureProcesses;
  String selectedFilter = 'P';

  @override
  void initState() {
    super.initState();
    futureProcesses = ApiService().fetchProcesses(selectedFilter);
  }

  void _fetchData(String filter) {
    setState(() {
      selectedFilter = filter;
      futureProcesses = ApiService().fetchProcesses(filter);
    });
  }

  void _refreshData() {
    _fetchData(selectedFilter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'ProcessOrder Main List',
          style: TextStyle(color: Colors.teal),
        ),
        leading: IconButton(
          color: Colors.teal,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _fetchData('A'),
                style: ElevatedButton.styleFrom(
                    primary: selectedFilter == 'A' ? Colors.green : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                child: Text('Approved'),
              ),
              ElevatedButton(
                onPressed: () => _fetchData('P'),
                style: ElevatedButton.styleFrom(
                    primary:
                        selectedFilter == 'P' ? Colors.orange : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                child: Text('Pending'),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<ApiProcess>>(
              future: futureProcesses,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitFadingCircle(
                      color: Colors.blue,
                      size: 50.0,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No processes found'));
                } else {
                  final processes = snapshot.data!;
                  return ListView.builder(
                    itemCount: processes.length,
                    itemBuilder: (context, index) {
                      final process = processes[index];
                      return Card(
                        elevation: 5,
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          leading: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.shopping_cart_rounded,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            'Process Order: ${process.processOrder}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Order Date: ${process.processOrderDate.toString().substring(0, 10)}'),
                              Text('Company: ${process.companyName}'),
                              Text('Unit: ${process.companyUnit}'),
                              Text('Process: ${process.process}'),
                              Text('Processor: ${process.processor}'),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProcOrderListScreen(
                                  procid: process.procid,
                                  processorder: process.processOrder,
                                  onApprovalUpdate: _refreshData,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
