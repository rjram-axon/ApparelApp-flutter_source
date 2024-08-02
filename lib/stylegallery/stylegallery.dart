//import 'package:apparelapp/profitlossreport/profitlossreport.dart';
//import 'package:apparelapp/stock/orderwisestock.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
//import 'package:apparelapp/orderstatus/orderstatus.dart';
import 'package:apparelapp/axondatamodal/stylegallerydetailsdatamodal.dart';
import 'package:apparelapp/axonlibrary/axongeneral.dart';
import 'package:apparelapp/axondatamodal/axonfitrationmodal/stylegalleryfilter.dart';
import 'package:http/http.dart' as http;

class StyleGallery extends StatefulWidget {
  const StyleGallery({super.key});

  @override
  State<StyleGallery> createState() => _StyleGalleryState();
}

class _StyleGalleryState extends State<StyleGallery> {
  final List<StyleGalleryDetailDataModal> _styleitemsdetail = [];
  final List<StyleGalleryDetailDataModal> _styleorderdetail = [];
  String filterorderno = "";
  int styleitemlength = 0;
  double totalqty = 0;

  @override
  void initState() {
    super.initState();
    getstyledetails();
  }

  @override
  void dispose() {
    super.dispose();
    _styleorderdetail.clear();
    _styleitemsdetail.clear();
  }

  void getstyledetails() async {
    dynamic responsedata;
    var url = '$hostname:$port/api/apistylgallery/$styleid';
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
        dynamic responsedata1 = json.decode(responsedata);
        for (int i = 0; i < responsedata1.length; i++) {
          dynamic data = StyleGalleryDetailDataModal.fromJson(responsedata1[i]);
          _styleitemsdetail.add(StyleGalleryDetailDataModal(
              data.orderno,
              data.refno,
              data.style,
              data.quantity,
              data.description,
              data.color,
              data.size,
              data.despqty,
              data.orderqty,
              data.productionqty,
              data.imgpath));
          if (filterorderno.toString() == "" ||
              filterorderno.toString() != data.orderno.toString()) {
            _styleorderdetail.add(StyleGalleryDetailDataModal(
                data.orderno,
                data.refno,
                data.style,
                data.quantity,
                data.description,
                data.color,
                data.size,
                data.despqty,
                data.orderqty,
                data.productionqty,
                data.imgpath));
          }
          filterorderno = data.orderno;
        }

        setState(() {
          _styleitemsdetail;
          _styleorderdetail;
          //styleitemlength = _styleitemsdetail.length;
          styleitemlength = _styleorderdetail.length;
        });
      } else {}
    } catch (ex) {
      throw ex.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 5,
          centerTitle: true,
          title: const Text('Style Gallery Details'),
        ),
        body: ListView.builder(
          itemCount: styleitemlength,
          itemBuilder: (context, index) {
            return Column(children: [
              Card(
                margin: const EdgeInsets.all(10.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.white,
                elevation: 20,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              SizedBox(height: 22, child: Text('Order No :')),
                              SizedBox(height: 22, child: Text('Refer No :')),
                              SizedBox(height: 22, child: Text('Style    :')),
                              SizedBox(height: 22, child: Text('Quantity :')),
                              SizedBox(
                                  height: 22, child: Text('Description :')),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  height: 22,
                                  child:
                                      Text(_styleorderdetail[index].orderno!)),
                              SizedBox(
                                  height: 22,
                                  child: Text(_styleorderdetail[index].refno!)),
                              SizedBox(
                                  height: 22,
                                  child: Text(_styleorderdetail[index].style!)),
                              SizedBox(
                                  height: 22,
                                  child: Text(_styleorderdetail[index]
                                      .quantity!
                                      .toString())),
                              SizedBox(
                                  height: 22,
                                  child: Text(_styleorderdetail[index]
                                      .description
                                      .toString())),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Image(
                                image: NetworkImage(
                                    '$hostname:$port${_styleorderdetail[index].imgpath!.replaceAll('~', '')}'),
                                height: 50,
                                width: 50,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  return Image(
                                    image: NetworkImage(
                                        '$hostname:$port${_styleorderdetail[index].imgpath!.replaceAll('~', '')}'),
                                    height: 50,
                                    width: 50,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.image_not_supported_outlined,
                                        size: 5,
                                      );
                                    },
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 5,
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //mainAxisSize: MainAxisSize.min,
                      children: const [
                        SizedBox(
                          height: 10,
                          child: Text('       '),
                        ),
                        /* SizedBox(height: 20, child: Text('Live stage :')), */
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //mainAxisSize: MainAxisSize.min,
                      children: const [
                        SizedBox(
                          height: 10,
                          child: Text('       '),
                        ),
                        /* SizedBox(
                            height: 30,
                            child: Text(
                              'Yarn purchse made for partial quantity (100 KGS)  ',
                              maxLines: 3,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            )), */
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //mainAxisSize: MainAxisSize.min,
                      children: const [
                        SizedBox(
                          height: 10,
                          child: Text('       '),
                        ),
                        SizedBox(
                          height: 20,
                          child: Text(
                            'Color & Size wise details:- ',
                            maxLines: 1,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.all(0),
                          margin: const EdgeInsets.all(0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 22, child: Text(' ')),
                              SizedBox(
                                  height: 22,
                                  child: Text(_styleorderdetail[index]
                                      .color
                                      .toString())),
                            ],
                          ),
                        ),
                        for (int i = 0; i < _styleitemsdetail.length; i++) ...[
                          if (_styleitemsdetail[i].orderno.toString() ==
                                  _styleorderdetail[index].orderno.toString() &&
                              _styleitemsdetail[i].style.toString() ==
                                  _styleorderdetail[index]
                                      .style
                                      .toString()) ...[
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(0),
                              margin: const EdgeInsets.all(0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      height: 22,
                                      child: Text(_styleitemsdetail[i]
                                          .size
                                          .toString())),
                                  SizedBox(
                                      height: 22,
                                      child: Text(_styleitemsdetail[i]
                                          .orderqty
                                          .toString())),
                                ],
                              ),
                            ),
                          ],
                        ],
                        /* for total order qty details of concern order                        
                         Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.all(0),
                          margin: const EdgeInsets.all(0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              SizedBox(height: 22, child: Text('Total')),
                              SizedBox(height: 22, child: Text('')),
                            ],
                          ),
                        ), */
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                      width: 10,
                    ),
                    /* For Next page movement code (order status,stock and costing report)                   
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 30,
                          child: ElevatedButton(
                              style: const ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.blue)),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const OrderStatus()));
                              },
                              child: const Text(
                                'Status',
                                style: TextStyle(),
                              )),
                        ),
                        const SizedBox(
                          height: 30,
                          width: 10,
                        ),
                        SizedBox(
                          height: 30,
                          child: ElevatedButton(
                              style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Colors.deepOrange)),
                              onPressed: () {
                                _styleorderdetail[index].orderno.toString();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const OrderWiseStock()));
                              },
                              child: const Text('Stock')),
                        ),
                        const SizedBox(
                          height: 30,
                          width: 10,
                        ),
                        SizedBox(
                          height: 30,
                          child: ElevatedButton(
                              style: const ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.indigo)),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ProfitLossReport()));
                              },
                              child: const Text('Costing')),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ), */
                  ],
                ),
              ),
              //_widgetOptions.elementAt(_selectedIndex),
            ]);
          },
        ));
  }
}
