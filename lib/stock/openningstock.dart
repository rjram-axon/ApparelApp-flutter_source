import 'package:flutter/material.dart';

class Openningstock extends StatefulWidget {
  const Openningstock({super.key});

  @override
  State<Openningstock> createState() => _OpenningstockState();
}

class _OpenningstockState extends State<Openningstock> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('mydata'),
      ),
    );
  }
}
