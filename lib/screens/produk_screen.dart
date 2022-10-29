import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tokokueku/screens/home_screen.dart';

class DetailProduk extends StatefulWidget {
  const DetailProduk({Key? key, required this.produk}) : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  final produk;
  @override
  State<DetailProduk> createState() => _DetailProdukState();
}

class _DetailProdukState extends State<DetailProduk> {
  @override
  Widget build(BuildContext context) {
    final String namaProduk = widget.produk['nama'];
    final double hargaProduk = double.parse(widget.produk['harga'].toString());
    final String deskripsiProduk = widget.produk['deskripsi'];
    final String photoProduk =
        'http://103.187.147.121/foto/${widget.produk['foto']}';

    final formatter = NumberFormat.simpleCurrency(locale: 'id_ID');
    final String hargaProdukRupiah = formatter.format(hargaProduk);

    return Scaffold(
      appBar: AppBar(
        title: Text(namaProduk),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 223, 53, 53),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(photoProduk),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            height: MediaQuery.of(context).size.height / 3,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hargaProdukRupiah,
                  style: const TextStyle(
                      color: Colors.cyan,
                      fontSize: 35,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Text(namaProduk,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                const Text(
                  "Deskripsi Produk",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Text(
                  deskripsiProduk,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ) /* add child content here */,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        },
        label: const Text('Kembali'),
        icon: const Icon(Icons.arrow_back),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }
}
