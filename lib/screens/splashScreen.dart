import 'dart:async';
import 'package:tokokueku/Screens/register_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isVisible = false;
  
  var child;

  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      setState(() {
        isVisible = true;
      });
      toHomePage();
    });

    super.initState();
  }

  toHomePage() {
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const RegisterScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedSwitcher(
              duration: const Duration(seconds: 3),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              // child: isVisible
              //      ? FlutterLogo(size: screenSize.height / 4)
                
                child: isVisible
                ? new Image.asset(
                          'images/kue5.png',
                          height: 100.0,
                          fit: BoxFit.cover,
                        )
                  
                  : const SizedBox()),

          const SizedBox(height: 25),
          const Text("TOKO KUEKU", style: TextStyle(fontSize: 28,
          color: Colors.deepPurpleAccent,
          fontWeight: FontWeight.bold)),
          isVisible ? const Align(
              //alignment: FractionalOffset.bottomCenter,
              heightFactor: 5,
              alignment: Alignment.bottomCenter,
              child: CircularProgressIndicator(
                color: Colors.grey,
              )) :const SizedBox() 
        ],
      )),
    );
  }
}