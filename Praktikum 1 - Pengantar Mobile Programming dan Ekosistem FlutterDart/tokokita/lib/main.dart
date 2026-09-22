import 'package:flutter/material.dart';
import 'models/product.dart';
import 'widgets/product_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Membuat data dummy Product untuk ditampilkan di ProductCard
    final List<Product> daftarProduk = [
      Product(
        id: "L313",
        nama: "Laptop Gaming",
        harga: 7500000.0,
        kategori: "Elektronik",
        stok: 13,
        description: "Laptop performa tinggi",
      ),
      Product(
        id: "JK56",
        nama: "Jaket Kulit",
        harga: 250000.0,
        kategori: "Fashion",
        stok: 0,
      ),
      Product(
        id: "CT9",
        nama: "Cokelat Almond",
        harga: 45000.0,
        kategori: "Makanan",
        stok: 1,
      ),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TokoKita',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('TokoKita - Praktikum 3'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        // Menampilkan ProductCard menggunakan ListView
        body: ListView.builder(
          padding: const EdgeInsets.only(top: 16),
          itemCount: daftarProduk.length,
          itemBuilder: (context, index) {
            return ProductCard(product: daftarProduk[index]);
          },
        ),
      ),
    );
  }
}
