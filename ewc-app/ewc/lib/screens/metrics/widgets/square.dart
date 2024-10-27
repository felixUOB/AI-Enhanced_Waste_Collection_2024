import 'package:flutter/material.dart';

class MySquare extends StatelessWidget{
  final Widget child;
  final String title;

  MySquare({
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
              color: Colors.deepPurple[200],
            ),
            child: Center(
              // the graph
              child: child,
              ),
          ),
        ],
      ),
      
    );
  }
}