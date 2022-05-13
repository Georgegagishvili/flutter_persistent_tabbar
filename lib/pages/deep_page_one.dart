import 'package:flutter/material.dart';
import 'package:persistent_botbar/pages/deep_page_two.dart';

class DeepPageOne extends StatelessWidget {
  const DeepPageOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Click me"),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.indigo,
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.of(context, rootNavigator: true)
              .push(MaterialPageRoute(builder: (ctx) => DeepPageTwo())),
          child: Text("CLICK"),
        ),
      ),
    );
  }
}
