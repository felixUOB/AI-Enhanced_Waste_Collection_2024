import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  home: Scaffold(
    appBar: AppBar(
      title: const Text(
        "Enhanced Waste Collection",
        style: TextStyle(
          fontFamily: 'Questrial',
          fontWeight: FontWeight.bold,
        )
      ),
      centerTitle: true,
      backgroundColor: Colors.cyan[600],

    ),
    body: const Center(
      child: Text(
        'TEMP',
        style: TextStyle(
          fontSize: 20,
          // fontWeight: FontWeight.bold,
          letterSpacing: 2.5,
          color: Colors.green,
          fontFamily: 'Questrial'
        )
      )
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: null,
      child: Text(""),
      backgroundColor: Colors.cyan[600],
    ),
  ),
));
