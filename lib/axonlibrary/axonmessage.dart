import 'dart:math';

import 'package:apparelapp/main.dart';
import 'package:flutter/material.dart';

class ShowMessage extends StatefulWidget {
  const ShowMessage({super.key});

  @override
  State<ShowMessage> createState() => _ShowMessageState();
}

class _ShowMessageState extends State<ShowMessage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            SizedBox(
              height: 50,
              width: max(100, 380),
              child: const Text(
                "Please check your internet connection, you have't connected internet..! ",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    overflow: TextOverflow.visible,
                    letterSpacing: 0.4,
                    wordSpacing: 5.0),
              ),
            ),
            SizedBox(
                height: 30,
                width: max(100, 380),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AppPage()));
                    },
                    child: const Text(" Try to Reluanch"))),
            const SizedBox(height: 20),
          ],
        ));
  }
}

class ShowLoginProgressMessage extends StatelessWidget {
  const ShowLoginProgressMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            SizedBox(
              height: 50,
              width: max(100, 380),
              child: Row(children: [
                Column(
                  children: [
                    Transform.scale(
                      scale: 0.7,
                      child: const CircularProgressIndicator(
                        color: Colors.blue,
                        strokeWidth: 2.0,
                        semanticsLabel: "Please wia",
                        semanticsValue: "Please wia",
                      ),
                    )
                  ],
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: const [
                      SizedBox(
                        height: 7,
                      ),
                      Text(
                        " Please wait fetching the data... ",
                        style: TextStyle(
                          //fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          overflow: TextOverflow.visible,
                          letterSpacing: 0.4,
                          wordSpacing: 5.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ]),
              ]),
            ),
          ],
        ));
  }
}

class PreLoderMessage extends StatelessWidget {
  const PreLoderMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            SizedBox(
              height: 50,
              width: max(100, 380),
              child: Row(children: [
                Column(
                  children: [
                    Transform.scale(
                      scale: 0.7,
                      child: const CircularProgressIndicator(
                        color: Colors.blue,
                        strokeWidth: 2.0,
                        semanticsLabel: "Please wia",
                        semanticsValue: "Please wia",
                      ),
                    )
                  ],
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: const [
                      SizedBox(
                        height: 7,
                      ),
                      Text(
                        " Wait fetching the data... ",
                        style: TextStyle(
                          //fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          overflow: TextOverflow.visible,
                          letterSpacing: 0.4,
                          wordSpacing: 5.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ]),
              ]),
            ),
          ],
        ));
  }
}
