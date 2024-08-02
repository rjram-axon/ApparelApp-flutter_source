import 'dart:math';
import 'package:flutter/material.dart';

class ShowNorecordMessage extends StatelessWidget {
  const ShowNorecordMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          backgroundBlendMode: BlendMode.colorBurn,
          color: Colors.lightBlue,
          border: Border.all(
              color: Colors.transparent, width: 10.0, style: BorderStyle.solid),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0),
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
        ),
        //color: Colors.cyan,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            SizedBox(
              height: 22,
              width: max(100, 380),
              child: const Text(
                "No Records Found..! (Or) No Details found in the concern filtration ...!",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    overflow: TextOverflow.visible,
                    letterSpacing: 0.4,
                    wordSpacing: 5.0),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ));
  }
}
