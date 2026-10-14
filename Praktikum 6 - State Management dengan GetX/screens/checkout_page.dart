import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ringkasan Pesanan (Checkout)'),
        backgroundColor: Colors.purpleAccent,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detail Pesanan Anda',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartController.cartItems[index];
                  return ListTile(
                    title: Text(item.product.nama),
                    subtitle: Text(
                      '${item.quantity}x @ Rp ${item.product.harga.toInt()}',
                    ),
                    trailing: Text(
                      'Rp ${item.subtotal.toInt()}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Pembayaran:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Rp ${cartController.totalHarga.toInt()}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  cartController.cartItems.clear();
                  Get.offAllNamed('/');
                  Get.snackbar('Sukses!', 'Pesanan Berhasil Diselesaikan');
                },
                child: const Text(
                  'Selesaikan Pembayaran & Kembali ke Beranda',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
