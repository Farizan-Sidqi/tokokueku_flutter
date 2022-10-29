import 'package:flutter/material.dart';
import 'package:tokokueku/screens/bayar.dart';
import 'package:tokokueku/screens/splashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      //home: HomeScreen()
      // home: Pembayaran(orderId: "32"),
    );
  }
}
