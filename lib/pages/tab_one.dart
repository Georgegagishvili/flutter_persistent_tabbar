import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_botbar/pages/deep_page_one.dart';

class TabOnePage extends StatelessWidget {
  const TabOnePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("cLick"),
          automaticallyImplyLeading: true,
        ),
        backgroundColor: Color(0xffeeee),
        body: Center(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 25),
            children: [
              TextField(controller: TextEditingController(),),
              ElevatedButton(
                onPressed: () => Navigator.of(context)
                    .push(CupertinoPageRoute(builder: (ctx) => DeepPageOne())),
                child: Text("CLICK"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
