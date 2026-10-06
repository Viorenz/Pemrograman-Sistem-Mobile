import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailPage extends StatefulWidget {
  final Product? product;

  const ProductDetailPage({Key? key, this.product}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int jumlah = 1;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final Product? selectedProduct =
        widget.product ?? (args is Product ? args : null);

    if (selectedProduct == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Produk'),
          backgroundColor: Colors.purpleAccent,
        ),
        body: const Center(
          child: Text('Data produk tidak ditemukan.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedProduct.nama),
        backgroundColor: Colors.purpleAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.image,
                  size: 80,
                  color: Colors.purpleAccent,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              selectedProduct.nama,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
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
              selectedProduct.description ?? 'Tidak ada deskripsi untuk produk ini.',
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
                        Navigator.pop(
                          context,
                          '$jumlah item ${selectedProduct.nama} berhasil ditambahkan ke keranjang!',
                        );
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