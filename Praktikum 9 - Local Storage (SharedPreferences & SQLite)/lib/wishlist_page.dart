import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/product_card.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final ProductService _productService = ProductService();
  List<String> _wishlistIds = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _wishlistIds = prefs.getStringList('favorite_product_ids') ?? [];
      _isLoading = false;
    });
  }

  Future<void> _removeFromWishlist(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _wishlistIds.remove(productId);
    });
    await prefs.setStringList('favorite_product_ids', _wishlistIds);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Produk Dihapus dari Wishlist'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist Kita'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _wishlistIds.isEmpty
              ? const Center(
                  child: Text(
                    'Belum Ada Produk di Wishlist',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : FutureBuilder<List<Product>>(
                  future: _productService.fetchProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Gagal Memuat Data: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Tidak Ada Produk yang Tersedia'));
                    }

                    final allProducts = snapshot.data!;
                    final wishlistProducts = allProducts
                        .where((product) => _wishlistIds.contains(product.id.toString()))
                        .toList();

                    if (wishlistProducts.isEmpty) {
                      return const Center(
                        child: Text('Belum Ada Produk Favorit di Wishlist'),
                      );
                    }

                    return ListView.builder(
                      itemCount: wishlistProducts.length,
                      itemBuilder: (context, index) {
                        final product = wishlistProducts[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: ListTile(
                            leading: Image.network(
                              product.gambar,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image),
                            ),
                            title: Text(
                              product.nama,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text('Rp ${product.harga}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _removeFromWishlist(product.id.toString());
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}