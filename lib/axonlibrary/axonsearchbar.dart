import 'package:flutter/material.dart';

TextEditingController txtsearchcontroller = TextEditingController();

void summaryfiltration(String value) {}
SliverAppBar axonSerachAppBar() {
  return SliverAppBar(
    backgroundColor: Colors.white,
    pinned: true,
    automaticallyImplyLeading: false,
    title: Container(
      margin: const EdgeInsets.all(10),
      height: 40,
      decoration: const BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color.fromARGB(255, 252, 254, 255),
            // offset: Offset(1.1, 1.1),
            //blurRadius: 5.0
          ),
        ],
      ),
      child: SizedBox(
        width: 380,
        height: 38,
        child: TextField(
          //controller: txtsearchcontroller,
          decoration: InputDecoration(
            suffixIcon: IconButton(
                onPressed: () {
                  summaryfiltration(txtsearchcontroller.text);
                },
                icon: const Icon(Icons.search)),
            border: const OutlineInputBorder(),
            labelText: 'Search...',
          ),
          style: const TextStyle(
            backgroundColor: Colors.transparent,
            //color: Colors.blue,
            fontSize: 18.0,
          ),
        ),
      ),
    ),
  );
}
