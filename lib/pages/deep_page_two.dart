import 'package:flutter/material.dart';

class DeepPageTwo extends StatelessWidget {
  const DeepPageTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Click me"),
      ),
      backgroundColor: Colors.pinkAccent,
    );
  }
}
