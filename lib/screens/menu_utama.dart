//

import 'dart:convert';
//import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tokokueku/screens/live_chat.dart';
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
        .get(Uri.parse("http://103.187.147.121/api/get-profile/$id"), headers: {
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
          Uri.parse("http://103.187.147.121/user_foto/" + dataDecode["foto"]));

      if (imageResponse.statusCode == 200) {
        setState(() {
          _avatar = "http://103.187.147.121/user_foto/" + dataDecode["foto"];
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
          backgroundColor: Colors.red,
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
        //drawer navbar pada app bar
        drawer: Drawer(
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
                  backgroundImage: NetworkImage(_avatar),
                ),
                decoration: const BoxDecoration(
                  color: Colors.red,
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.person,
                  color: Colors.red,
                ),
                title: const Text("Profile"),
                onTap: () {
                  //_launchWhatsapp();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Profile()));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.info,
                  color: Colors.red,
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
                          btnOkColor: Colors.red)
                      .show();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                title: const Text("Keluar"),
                onTap: () {
                  // Navigator.pushReplacementNamed(context, '/');
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const LoginScreen()),
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
                color: Colors.red,
                child: InkWell(
                  // onTap: () {},
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Profile()));
                  },

                  splashColor: Colors.red,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        Icon(Icons.person, color: Colors.white, size: 70.0),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Profile",
                          style: TextStyle(fontSize: 17.0, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.all(8.0),
                color: Colors.red,
                child: InkWell(
                  // onTap: () {},
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                  },

                  splashColor: Colors.red,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        Icon(Icons.cake, color: Colors.white, size: 70.0),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Order",
                          style: TextStyle(fontSize: 17.0, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.all(8.0),
                color: Colors.red,
                child: InkWell(
                  // onTap: () {},
                  onTap: () {
                    _launchWhatsapp();
                  },
                  splashColor: Colors.red,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        Icon(Icons.whatsapp, color: Colors.white, size: 70.0),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Chat via Whatsapp",
                          style: TextStyle(fontSize: 17.0, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.all(8.0),
                color: Colors.red,
                child: InkWell(
                  // onTap: () {},
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LiveChat()));
                  },
                  splashColor: Colors.red,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        Icon(Icons.chat_bubble,
                            color: Colors.white, size: 70.0),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Live Chat",
                          style: TextStyle(fontSize: 17.0, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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




  
