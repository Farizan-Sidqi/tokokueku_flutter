//

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:tokokue/screens/login_screen.dart';
//import 'package:tokokue/screens/home_screen.dart';
//import 'package:tokokue/screens/order_screen.dart';
//import 'package:url_launcher/url_launcher.dart';
//import 'package:url_launcher/link.dart';
//import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';

// import 'home_screen.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  String? token;
  //var _authToken = '';
  String? idUser;
  String _alamat = '';
  String _no_wa = '';
  String _email = '';
  String _password = '';
  String _nama = '';
  String _avatar =
      // "https://play-lh.googleusercontent.com/-u-oG-Ni_pco9h7zc3CQl-lFkKJjztO3RGZMjnbaDiznnbXoMQZYUjITHN0BVxYHBg=w240-h480-rw";
      "https://img.icons8.com/pastel-glyph/344/person-male--v1.png";

  var textNama = TextEditingController();
  var textEmail = TextEditingController();
  var textAlamat = TextEditingController();
  var textWa = TextEditingController();

  bool isPreview = false;
  String? photoPath;
  File? photoProfile;

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
        idUser = id;
        _nama = dataDecode['nama'];
        _email = dataDecode['email'];
        _alamat = dataDecode['alamat'];
        _no_wa = dataDecode['no_wa'];
        //_avatar = "http://103.187.147.121/user_foto/" + dataDecode["foto"];

        textNama.text = dataDecode['nama'].toString();
        textEmail.text = dataDecode['email'].toString();
        textAlamat.text = dataDecode['alamat'].toString();
        textWa.text = dataDecode['no_wa'].toString();
        token = accessToken;
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

  updateProfile() async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      };
      var request = http.MultipartRequest('POST',
          Uri.parse("http://103.187.147.121/api/update-profile/$idUser"));
      request.headers.addAll(headers);
      request.fields['email'] = _email;
      request.fields['nama'] = _nama;
      request.fields['alamat'] = _alamat;
      request.fields['no_wa'] = _no_wa;

      if (photoPath != null) {
        request.files.add(http.MultipartFile('foto',
            photoProfile!.readAsBytes().asStream(), photoProfile!.lengthSync(),
            filename: photoProfile!.path.split("/").last));
      }

      var res = await request.send();
      var responseBytes = await res.stream.toBytes();
      var responseString = utf8.decode(responseBytes);

      debugPrint("response code: ${res.statusCode}");
      debugPrint("response: $responseString");

      final dataDecode = jsonDecode(responseString);
      if (res.statusCode == 200) {
        setState(() {
          isPreview = false;
          if (photoPath != null) {
            _avatar = "http://103.187.147.121/user_foto/" +
                dataDecode['data']['foto'];
          }
          photoPath = null;
        });

        var snackBar = SnackBar(
          content: Text(dataDecode['messages']),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      debugPrint('$e');
      var snackBar = SnackBar(
        content: Text('$e'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  getPhoto(String avatar) {
    if (avatar.contains('https://') || avatar.contains('http://')) {
      return CachedNetworkImageProvider(avatar);
    } else {
      return AssetImage(avatar);
    }
  }

  void pickPhoto() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png']);
    if (result == null) return;

    PlatformFile file = result.files.single;
    setState(() {
      isPreview = true;
      photoPath = file.path.toString();
      photoProfile = File(file.path.toString());
    });
    debugPrint(file.toString());
  }

  Widget buildProfileImage() {
    return Container(
      width: double.infinity,
      height: 180,
      color: Colors.red,
      child: Stack(children: [
        Center(
          child: isPreview
              ? Container(
                  width: double.infinity,
                  height: 120.0,
                  color: Colors.red,
                  child: Image.file(
                    File(photoPath.toString()),
                    fit: BoxFit.contain,
                  ),
                )
              : Container(
                  width: 120.0,
                  height: 120.0,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                      image: getPhoto(_avatar),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(80.0),
                    border: Border.all(
                      color: Colors.white,
                      width: 2.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 4,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                ),
        ),
        Positioned(
          bottom: 5,
          right: 40,
          child: Container(
            width: 50,
            height: 50,
            decoration: const ShapeDecoration(
              shape: CircleBorder(),
              color: Colors.red,
            ),
            child: IconButton(
              onPressed: () {
                pickPhoto();
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          buildProfileImage(),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 388,
            child: ListView(
              shrinkWrap: true,
              children: [
                Text(
                  "Email",
                  style: TextStyle(color: Colors.grey.shade500),
                ),
                TextField(
                  readOnly: true,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                  controller: textEmail,
                  onChanged: (value) {
                    _email = value;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Nama",
                  style: TextStyle(color: Colors.grey.shade500),
                ),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Nama',
                  ),
                  controller: textNama,
                  onChanged: (value) {
                    _nama = value;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Alamat",
                  style: TextStyle(color: Colors.grey.shade500),
                ),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Alamat',
                  ),
                  controller: textAlamat,
                  onChanged: (value) {
                    _alamat = value;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "No. Whatsapp",
                  style: TextStyle(color: Colors.grey.shade500),
                ),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'No WA',
                  ),
                  controller: textWa,
                  onChanged: (value) {
                    _no_wa = value;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    onPressed: () {
                      updateProfile();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      minimumSize: const Size.fromHeight(50),
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Text(
                        'Update Profile',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
                const SizedBox(
                  height: 40,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
