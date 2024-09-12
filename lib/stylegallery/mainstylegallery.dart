import 'package:apparelapp/axondatamodal/axonfitrationmodal/stylegalleryfilter.dart';
import 'package:apparelapp/main/app_config.dart';
import 'package:flutter/material.dart';
import 'package:apparelapp/stylegallery/stylegallery.dart';
import 'package:apparelapp/axondatamodal/stylegallerymodal.dart';
import '../axonlibrary/axongeneral.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MainStyleGallery extends StatefulWidget {
  const MainStyleGallery({super.key});

  @override
  State<MainStyleGallery> createState() => _MainStyleGalleryState();
}

class _MainStyleGalleryState extends State<MainStyleGallery> {
  final List<StyleGalleryDataModal> _styleitems = [];
  int stylelistlength = 0;

  @override
  void initState() {
    super.initState();
    getstylegallerydetails();
  }

  @override
  void dispose() {
    super.dispose();
    _styleitems.clear();
    styleid = 0;
    imagepath = "";
    imagetite = "";
    stylelistlength = 0;
  }

  void getstylegallerydetails() async {
    dynamic responsedata;
    var url =
        'http://${AppConfig().host}:${AppConfig().port}/api/apistylgallery';
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
          dynamic data = StyleGalleryDataModal.fromJson(responsedata[i]);
          _styleitems.add(StyleGalleryDataModal(
              data.styleid, data.imagepath, data.imagetite));
        }
        setState(() {
          _styleitems;
          stylelistlength = _styleitems.length;
        });
      } else {}
    } catch (ex) {
      throw ex.toString();
    }
  }

  void setfilterdetails(int index) {
    styleid = _styleitems[index].styleid!;
    imagetite = _styleitems[index].imagetite!;
    imagepath = _styleitems[index].imagepath!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Main - Style Gallery'),
          centerTitle: true,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.restart_alt)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.tune_sharp))
          ],
        ),
        body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            //childAspectRatio: 0.56,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
          ),
          padding: const EdgeInsets.all(8.0),
          itemCount: stylelistlength,
          itemBuilder: (context, index) {
            return Card(
                //margin: const EdgeInsets.all(10.0),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                    style: BorderStyle.solid,
                    // width: 12.0,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: SizedBox(
                        //width: 300,
                        //height: 100,
                        child: Center(
                          child: IconButton(
                            autofocus: true,
                            //hoverColor: Colors.indigoAccent,
                            icon: Image.network(
                              'http://${AppConfig().host}:${AppConfig().attachment_port}${_styleitems[index].imagepath!.replaceAll('~', '')}',
                              //height: 100,
                              width: 100,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return const Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 25,
                                );
                              },
                            ),
                            iconSize: 100,
                            onPressed: () {
                              setfilterdetails(index);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const StyleGallery()));
                            },
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        width: 300,
                        //height: 30,
                        child: Center(
                          child: TextButton(
                              onPressed: () {
                                setfilterdetails(index);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const StyleGallery()));
                              },
                              child: Text(_styleitems[index].imagetite!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'callbri',
                                    letterSpacing: 0,
                                    fontSize: 15,
                                  ))),
                        ),
                      ),
                    )
                  ],
                ));
          },
        ));
  }
}
