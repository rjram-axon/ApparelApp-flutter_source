import 'dart:convert';
import 'package:apparelapp/main/app_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StyleDetailsPage extends StatefulWidget {
  final int styleId;

  StyleDetailsPage({required this.styleId});

  @override
  _StyleDetailsPageState createState() => _StyleDetailsPageState();
}

class _StyleDetailsPageState extends State<StyleDetailsPage> {
  bool _isLoading = true;
  bool _isError = false;
  Map<String, dynamic>? _data;

  @override
  void initState() {
    super.initState();
    _fetchStyleDetails();
  }

  Future<void> _fetchStyleDetails() async {
    final url =
        'http://${AppConfig().host}:${AppConfig().port}/api/getstyledetails?styleid=${widget.styleId}';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          _data = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isError = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Style Details',
          style: TextStyle(
            color: Color(0xFF0072FF), // Rich Deep Blue
          ),
        ),
        leading: IconButton(
          color: Color(0xFF0072FF), // Rich Deep Blue

          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _isError
              ? Center(child: Text('Error fetching data'))
              : _data != null && _data!['success'] == true
                  ? ListView.builder(
                      itemCount: _data!['styleDetails'].length,
                      itemBuilder: (context, index) {
                        final styleDetail = _data!['styleDetails'][index];
                        // Constructing the full image URL
                        String imgPath =
                            'http://${AppConfig().host}:${AppConfig().attachment_port}${styleDetail['Imgpath']?.replaceAll('~', '') ?? ''}';

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
                                color: Colors.indigo.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons
                                    .style, // You can change this to any relevant icon
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              "Style: ${styleDetail['Style'] ?? 'N/A'}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Text(
                                  "Buyer: ${styleDetail['Buyer'] ?? 'N/A'}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Order No: ${styleDetail['OrderNo'] ?? 'N/A'}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Ref No: ${styleDetail['RefNo'] ?? 'N/A'}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Description: ${styleDetail['Description'] ?? 'N/A'}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),

                                const SizedBox(height: 4),
                                Text(
                                  "Order Qty: ${styleDetail['OrderQty'] ?? '0'}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),

                                const SizedBox(height: 4),
                                Text(
                                  "Despatch Qty: ${styleDetail['DespQty'] ?? '0'}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 50),
                                // Display the image from the constructed URL
                                Image.network(
                                  imgPath,
                                  height: 100, // Set height as needed
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Text(
                                      "Image not found",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.red,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(child: Text('No style details found')),
    );
  }
}
