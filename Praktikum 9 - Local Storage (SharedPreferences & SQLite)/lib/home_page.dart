import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';
import '../services/product_service.dart';
import '../screens/wishlist_page.dart';
import '../services/order_database.dart';
import '../screens/cart_page.dart';
import '../widgets/product_card.dart';
import '../screens/order_history_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductService productService = ProductService();
  List<String> favoriteProductIds = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _verifyDatabase();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteProductIds = prefs.getStringList('favorite_product_ids') ?? [];
    });
  }

  Future<void> _verifyDatabase() async {
    try {
      final db = await OrderDatabase.instance.database;
      print(
        "LOG: Database SQLite dan tabel 'orders' berhasil diinisialisasi di path: ${db.path}",
      );
    } catch (e) {
      print("LOG: Gagal membuat database: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda TokoKita'),
        backgroundColor: Colors.purpleAccent,

        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            tooltip: 'Riwayat Pesanan',
            onPressed: () {
              Get.to(() => const OrderHistoryPage());
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            tooltip: 'Wishlist',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WishlistPage()),
              );
              _loadFavorites();
              setState(() {});
            },
          ),

          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            tooltip: 'Keranjang',
            onPressed: () {
              Get.to(() => const CartPage());
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadFavorites();
          setState(() {});
        },
        child: FutureBuilder<List<Product>>(
          future: productService.fetchProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Center(
                      child: Text(
                        'Gagal memuat produk:\n${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Tidak ada produk tersedia!'));
            }

            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                return ProductCard(product: product);
              },
            );
          },
        ),
      ),
    );
  }
}
