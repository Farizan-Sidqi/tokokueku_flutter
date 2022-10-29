import 'package:flutter/material.dart';

class dana extends StatelessWidget {
  const dana({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dana',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dana'),
        ),
        body: Container(
          color: Colors.grey[200],
          child: new Image.asset('images/dana.PNG'),
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
