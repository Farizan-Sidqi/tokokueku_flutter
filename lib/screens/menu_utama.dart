//

import 'dart:convert';
//import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:tokokueku/screens/login_screen.dart';
import 'package:tokokueku/screens/home_screen.dart';
import 'package:tokokueku/screens/profile.dart';
import 'package:tokokueku/screens/dana.dart';
//import 'package:tokokue/screens/order_screen.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:url_launcher/link.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:http/http.dart' as http;

// import 'home_screen.dart';

class MenuUtama extends StatefulWidget {
  const MenuUtama({Key? key}) : super(key: key);

  @override
  MenuUtamaState createState() => MenuUtamaState();
}

class MenuUtamaState extends State<MenuUtama> {
  @override
  var token;
  var _authToken = '';
  String? _nama;
  String? _no_wa;
  String? _email;
  String _avatar =
      "https://play-lh.googleusercontent.com/-u-oG-Ni_pco9h7zc3CQl-lFkKJjztO3RGZMjnbaDiznnbXoMQZYUjITHN0BVxYHBg=w240-h480-rw";

  void getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var id = pref.getString("id_user");
    var accessToken = pref.getString("token");
    final result = await http
        .get(Uri.parse("https://farizan.my.id/api/get-profile/$id"), headers: {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    });

    if (result.statusCode == 200) {
      final dataDecode = jsonDecode(result.body);
      setState(() {
        _nama = dataDecode['nama'];
        _email = dataDecode['email'];
        _no_wa = dataDecode['no_wa'];
        //_avatar = "https://farizan.my.id/user_foto/" + dataDecode["foto"];

      });

      final imageResponse = await http.get(
          Uri.parse("https://farizan.my.id/user_foto/" + dataDecode["foto"]));

      if (imageResponse.statusCode == 200) {
        setState(() {
          _avatar = "https://farizan.my.id/user_foto/" + dataDecode["foto"];
        });
      }
    }
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  Widget build(BuildContext context) {
    _launchWhatsapp() async {
      var whatsapp = "+6285296007605";
      var whatsappAndroid =
          Uri.parse("whatsapp://send?phone=$whatsapp&text=Hello Toko kueku");

      if (await canLaunchUrl(whatsappAndroid)) {
        await launchUrl(whatsappAndroid);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("WhatsApp is not installed on the device"),
          ),
        );
      }
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 223, 53, 53),
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'Menu Utama',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.red[100],
        //drawer navbar pada app bar
        drawer: Drawer(
          backgroundColor: Colors.red[200],
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                  _nama.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17.0),
                ),
                accountEmail: Text(_email.toString()),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                      _avatar),
                ),
                decoration: BoxDecoration(color: Colors.red[400]),
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: Colors.blue.shade400,
                ),
                title: const Text("Profile"),
                onTap: () {
                  //_launchWhatsapp();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Profile()));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.money,
                  color: Colors.blue.shade400,
                ),
                title: const Text("Dana"),
                onTap: () {
                  //_launchWhatsapp();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const dana()));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.info,
                  color: Colors.blue[900],
                ),
                title: const Text("Tentang"),
                onTap: () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.INFO,
                    animType: AnimType.BOTTOMSLIDE,
                    title: 'Toko Kueku',
                    desc: 'Toko Kueku adalah sebuat aplikasi android  ' +
                        'pemesanan kue basah rumahan',
                    // btnCancelOnPress: () {},
                    btnOkOnPress: () {},
                  )..show();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.exit_to_app,
                  color: Colors.red,
                ),
                title: const Text("Keluar"),
                onTap: () {
                  // Navigator.pushReplacementNamed(context, '/');
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => const LoginScreen()),
                      ModalRoute.withName('/'));
                },
              )
            ],
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(30.0),
          child: GridView.count(
            crossAxisCount: 2,
            children: <Widget>[
              Card(
                margin: const EdgeInsets.all(8.0),
                child: InkWell(
                  // onTap: () {},
                  onTap: () {
                    //Navigator.push(context,
                    //    MaterialPageRoute(builder: (context) => HomeScreen()));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Profile()));
                  },

                  splashColor: Colors.green,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        Icon(Icons.person, color:  Colors.blue, size: 70.0),
                        Text(
                          "Profile",
                          style: TextStyle(fontSize: 17.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.all(8.0),
                child: InkWell(
                  // onTap: () {},
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()));
                  },

                  splashColor: Colors.green,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        Icon(Icons.payment, color: Colors.blue, size: 70.0),
                        Text(
                          "Order",
                          style: TextStyle(fontSize: 17.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Card(
              //   margin: const EdgeInsets.all(8.0),
              //   child: InkWell(
              //     // onTap: () {},
              //     onTap: () {
              //       _launchWhatsapp();
              //     },
              //
              //     splashColor: Colors.green,
              //     child: Center(
              //       child: Column(
              //         mainAxisSize: MainAxisSize.min,
              //         children: const <Widget>[
              //           Icon(Icons.payment, color: Colors.blue, size: 70.0),
              //           Text(
              //             "WhatApps",
              //             style: TextStyle(fontSize: 17.0),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ));

    // throw UnimplementedError();
  }
}














//whatapp

// openwhatapp() async {
//   var whatapp = "+6285296007605";
//   var whatappURL_android =
//       "whatsapp://send?phone=" + whatapp + "&text=Hello Toko kueku";
//   var whatappURL_ios =
//       "https://wa.me/$whatapp?text=${Uri.parse("Hello Toko kueku")}";

//   if (Platform.isIOS) {
    
//     return whatappURL_ios;
//   } else {
    
//     return whatappURL_android;
//   }
// }  




  
