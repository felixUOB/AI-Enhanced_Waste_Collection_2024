import 'package:flutter/material.dart';

class MySquare extends StatelessWidget{
  final Widget child;
  final String title;

  // ignore: prefer_const_constructors_in_immutables
  MySquare({
    super.key, 
    required this.title,
    required this.child
    });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(title),
          Container(
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            child: Padding(
               padding: const EdgeInsets.symmetric(horizontal: 16.0), 
              child: Center(
              // the graph
              child: child,
              ),
          ),
          ),
        ],
      ),
      
    );
  }
}