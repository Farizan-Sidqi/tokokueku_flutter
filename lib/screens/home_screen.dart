import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tokokueku/screens/order_screen.dart';
import 'package:tokokueku/screens/menu_utama.dart';
import 'package:tokokueku/screens/produk_screen.dart';
import 'dart:convert';

import '../models/listorder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String apiUrl = "https://farizan.my.id/api/produk";
  List<ListOrder> orderList = [];
  int totalItem = 0;

  void klikBeli(item) {
    bool containsItem = orderList.any((element) => element.id == item['id']);
    debugPrint("bool : $containsItem");
    setState(() {
      totalItem++;
      //ceck exist
      if (containsItem) {
        //update qty
        final index =
            orderList.indexWhere((element) => element.id == item['id']);

        if (index != -1) {
          int newQty = orderList[index].qty! + 1;
          int hargaBrg = orderList[index].harga!;
          orderList[index].qty = newQty;
          final int totalHarga = newQty * hargaBrg;
          orderList[index].total_harga = totalHarga;
        }
      } else {
        orderList.add(ListOrder(
            id: item['id'].toString(),
            nama: item['nama'],
            foto: item['foto'],
            qty: 1,
            harga: int.parse(item['harga'].toString()),
            total_harga: int.parse(item['harga'].toString())));
      }

      addToChart(orderList, totalItem);
    });
  }

  Future<void> getListOrder() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var listOrder = pref.getString("orderList");
    var totQty = pref.getInt("qty");

    if (listOrder != null) {
      var orderListMap = ListOrder.decode(listOrder.toString());
      for (var order in orderListMap) {
        setState(() {
          totalItem = totQty!;
          orderList.add(ListOrder(
              id: order.id,
              nama: order.nama,
              foto: order.foto,
              qty: order.qty,
              harga: int.parse(order.harga.toString()),
              total_harga: int.parse(order.total_harga.toString())));
        });
      }
    }
  }

  void addToChart(item, qty) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("orderList", ListOrder.encode(item));
    await preferences.setInt("qty", qty);
  }

  Widget shoppingCartBadge() {
    return Badge(
      position: BadgePosition.topEnd(top: 0, end: 3),
      animationDuration: const Duration(milliseconds: 300),
      animationType: BadgeAnimationType.slide,
      badgeContent: Text(
        totalItem.toString(),
        style: const TextStyle(color: Colors.white),
      ),
      child: IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const OrderScreen(),
                ));
          }),
    );
  }

  Future<List<dynamic>> _fecthDataUsers() async {
    var result = await http.get(Uri.parse(apiUrl), headers: {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    });
    return json.decode(result.body);
  }

  String formatNumber(String number) {
    var numb = int.parse(number);
    var formatter = NumberFormat("#,##0.00", "en_US");
    return formatter.format(numb);
  }

  @override
  void initState() {
    getListOrder();
    super.initState();
  }

  Widget buildListProduk(item) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage:
              // ignore: prefer_interpolation_to_compose_strings
              NetworkImage('https://farizan.my.id/foto/' + item['foto']),
        ),
        title: InkWell(
          child: Text(item['nama'].toString(),
              style: const TextStyle(fontSize: 22.0)),
          onTap: () {
            //
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailProduk(
                          produk: item,
                        )));
          },
        ),
        subtitle: Text(item['deskripsi'].toString(),
            style: const TextStyle(fontSize: 22.0)),
        trailing: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(formatNumber(item['harga'].toString()),
                  style: const TextStyle(fontSize: 18.0)),
              const SizedBox(width: 8),
              CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.red,
                  child: IconButton(
                      onPressed: () {
                        //
                        klikBeli(item);
                      },
                      icon: const Icon(Icons.add))),
            ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Daftar Produk'),
          centerTitle: true,
          leading: BackButton(onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const MenuUtama()));
          }),
          backgroundColor: Color.fromARGB(255, 223, 53, 53),
          actions: <Widget>[shoppingCartBadge()]),
      body: Container(
        margin: const EdgeInsets.all(0),
        child: FutureBuilder<List<dynamic>>(
          future: _fecthDataUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var item = snapshot.data[index];
                    return buildListProduk(item);
                  });
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
