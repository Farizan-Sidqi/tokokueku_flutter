import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_tawk/flutter_tawk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:tokokueku/screens/menu_utama.dart';

class LiveChat extends StatefulWidget {
  const LiveChat({Key? key}) : super(key: key);

  @override
  State<LiveChat> createState() => _LiveChatState();
}

class _LiveChatState extends State<LiveChat> {
  String _nama = '';
  String _email = '';

  getUser() async {
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
      });
    }
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Live Chat'),
          backgroundColor: Color.fromARGB(255, 223, 53, 53),
          elevation: 0,
          leading: BackButton(onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const MenuUtama()));
          }),
        ),
        body: Tawk(
          directChatLink:
              'https://tawk.to/chat/630a25b037898912e9658519/1gbfq6eso',
          visitor: TawkVisitor(
            name: _nama,
            email: _email,
          ),
          onLoad: () {
            print('Hello Tawk!');
          },
          onLinkTap: (String url) {
            print(url);
          },
          placeholder: const Center(
            child: Text('Loading...'),
          ),
        ),
      ),
    );
  }
}
