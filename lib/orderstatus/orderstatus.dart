import 'package:flutter/material.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';

class OrderStatus extends StatefulWidget {
  const OrderStatus({super.key});

  @override
  State<OrderStatus> createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
  @override
  Widget build(BuildContext context) {
    List<TimelineModel> items = [
      TimelineModel(
          const Text(
            'Order Confirmed on 28-11-2022 ',
            maxLines: 5,
          ),
          position: TimelineItemPosition.right,
          iconBackground: const Color.fromARGB(255, 106, 128, 8),
          icon: const Icon(
            Icons.blur_circular,
            size: 10,
          )),
      TimelineModel(
          const Text(
            'Planning maded on 28-11-2022 by employee  ',
            maxLines: 5,
          ),
          position: TimelineItemPosition.right,
          iconBackground: const Color.fromARGB(255, 164, 130, 245),
          icon: const Icon(
            Icons.blur_circular,
            size: 10,
          )),
      TimelineModel(
          const Text(
            'Yarn purchase partial quanttiy (100 KGS) done in xyz supplier by employee 28-11-2022  ',
            maxLines: 5,
          ),
          position: TimelineItemPosition.right,
          iconBackground: const Color.fromARGB(255, 164, 130, 245),
          icon: const Icon(
            Icons.blur_circular,
            size: 10,
          )),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Status'),
      ),
      body: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        margin: const EdgeInsets.all(10.0),
        color: Colors.white,
        child: Timeline(
          children: items,
          position: TimelinePosition.Left,
          iconSize: 0.0,
          lineWidth: 2,
          lineColor: Colors.green,
          primary: true,
        ),
      ),
    );
  }
}
