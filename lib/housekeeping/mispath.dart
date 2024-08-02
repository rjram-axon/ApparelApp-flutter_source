import 'package:flutter/material.dart';

class Mispath extends StatefulWidget {
  const Mispath({super.key});

  @override
  State<Mispath> createState() => _MispathState();
}

class _MispathState extends State<Mispath> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Container(),
    );
  }
}
