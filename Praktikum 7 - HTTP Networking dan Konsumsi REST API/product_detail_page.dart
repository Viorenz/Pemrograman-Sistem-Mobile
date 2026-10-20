import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductDetailPage extends StatefulWidget {
  final Product? product;
  final String? productId;

  const ProductDetailPage({Key? key, this.product, this.productId}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final CartController cartController = Get.find<CartController>();
  final ProductService productService = ProductService(); 

  int jumlah = 1;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final Product? initialProduct = widget.product ?? (args is Product ? args : null);

    if (initialProduct != null) {
      return _buildProductDetailView(context, initialProduct);
    }

    final String? idToFetch = widget.productId ?? (args is String ? args : null);

    if (idToFetch == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Produk'),
          backgroundColor: Colors.purpleAccent,
        ),
        body: const Center(child: Text('Data produk tidak ditemukan.')),
      );
    }

    int idInt = int.tryParse(idToFetch) ?? 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: FutureBuilder<Product>(
        future: productService.fetchProductDetail(idInt),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Gagal memuat detail produk:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Data produk tidak ditemukan.'));
          }

          return _buildProductDetailView(context, snapshot.data!);
        },
      ),
    );
  }

  Widget _buildProductDetailView(BuildContext context, Product selectedProduct) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedProduct.nama),
        backgroundColor: Colors.purpleAccent,
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed('/cart');
            },
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_cart),
                Positioned(
                  right: -4,
                  top: -4,
                  child: Obx(
                    () => cartController.totalItem > 0
                        ? Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${cartController.totalItem}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  selectedProduct.gambar,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.broken_image,
                      size: 80,
                      color: Colors.purpleAccent,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              selectedProduct.nama,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text(
                selectedProduct.kategori.toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.purpleAccent,
            ),
            const SizedBox(height: 8),
            Text(
              'Rp ${selectedProduct.harga.toInt()}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Status Stok: ${selectedProduct.getStatusStok()} (${selectedProduct.stok} unit)',
              style: TextStyle(
                fontSize: 14,
                color: selectedProduct.stok > 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Divider(height: 32),
            const Text(
              'Deskripsi Produk:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              selectedProduct.description ??
                  'Tidak ada deskripsi untuk produk ini.',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Jumlah:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: jumlah > 1
                            ? () => setState(() => jumlah--)
                            : null,
                        icon: const Icon(Icons.remove),
                        color: jumlah > 1 ? Colors.purpleAccent : Colors.grey,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          '$jumlah',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: jumlah < selectedProduct.stok
                            ? () => setState(() => jumlah++)
                            : null,
                        icon: const Icon(Icons.add),
                        color: jumlah < selectedProduct.stok
                            ? Colors.purpleAccent
                            : Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: selectedProduct.stok > 0
                    ? () {
                        for (int i = 0; i < jumlah; i++) {
                          cartController.addToCart(selectedProduct);
                        }
                      }
                    : null,
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                label: const Text(
                  'Tambah ke Keranjang',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}