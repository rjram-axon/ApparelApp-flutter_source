import 'package:flutter/material.dart';
import 'dart:math';

class ProfitLossHelp extends StatelessWidget {
  const ProfitLossHelp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          backgroundBlendMode: BlendMode.colorBurn,
          color: Colors.white,
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
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 22,
              width: max(100, 380),
              child: const Text(
                "STYLE VALUE ",
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 137, 123),
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    overflow: TextOverflow.visible,
                    letterSpacing: 0.4,
                    wordSpacing: 5.0),
              ),
            ),
            SizedBox(
              height: 22,
              width: max(100, 380),
              child: const Text(
                "Style Price * Order quantity",
                style: TextStyle(
                    //fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    overflow: TextOverflow.visible,
                    letterSpacing: 0.4,
                    wordSpacing: 5.0),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 22,
              width: max(100, 380),
              child: const Text(
                "SALES VALUE ",
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 137, 123),
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    overflow: TextOverflow.visible,
                    letterSpacing: 0.4,
                    wordSpacing: 5.0),
              ),
            ),
            SizedBox(
              height: 22,
              width: max(100, 380),
              child: const Text(
                "Despatch quantity * sales price * Exchange rate",
                style: TextStyle(
                    //fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    overflow: TextOverflow.visible,
                    letterSpacing: 0.4,
                    wordSpacing: 5.0),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 22,
              width: max(100, 380),
              child: const Text(
                "COST / PCS ",
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 137, 123),
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    overflow: TextOverflow.visible,
                    letterSpacing: 0.4,
                    wordSpacing: 5.0),
              ),
            ),
            SizedBox(
              height: 22,
              width: max(100, 380),
              child: const Text(
                "(Style value - Sum of amount) / Order quantity",
                style: TextStyle(
                    //fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    overflow: TextOverflow.visible,
                    letterSpacing: 0.4,
                    wordSpacing: 5.0),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 22,
              width: max(100, 380),
              child: const Text(
                "PROFIT VALUE ",
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 137, 123),
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    overflow: TextOverflow.visible,
                    letterSpacing: 0.4,
                    wordSpacing: 5.0),
              ),
            ),
            SizedBox(
              height: 22,
              width: max(100, 380),
              child: const Text(
                "Sales value - sum of amount",
                style: TextStyle(
                    //fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    overflow: TextOverflow.visible,
                    letterSpacing: 0.4,
                    wordSpacing: 5.0),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 22,
              width: max(100, 380),
              child: const Text(
                "PROFIT % ",
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 137, 123),
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    overflow: TextOverflow.visible,
                    letterSpacing: 0.4,
                    wordSpacing: 5.0),
              ),
            ),
            SizedBox(
              height: 22,
              width: max(100, 380),
              child: const Text(
                "(Sales value - sum of amount)/Sales value * 100",
                style: TextStyle(
                    //fontWeight: FontWeight.bold,
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
