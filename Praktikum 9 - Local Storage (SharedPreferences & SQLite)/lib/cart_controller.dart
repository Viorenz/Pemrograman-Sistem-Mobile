import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/product.dart';
import '../services/order_database.dart';
import '../services/order_database.dart';
import '../screens/order_history_page.dart';

class CartItemModel {
  Product product;
  int quantity;
  CartItemModel({required this.product, this.quantity = 1});

  double get subtotal {
    double hargaSatuan = product is DiscountedProduct
        ? (product as DiscountedProduct).hitungHargaFinal()
        : product.harga;
    return hargaSatuan * quantity;
  }
}

class CartController extends GetxController {
  var cartItems = <CartItemModel>[].obs;

  void addToCart(Product product, {int quantity = 1}) {
    int index = cartItems.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      cartItems[index].quantity += quantity;
      cartItems.refresh();
    } else {
      cartItems.add(CartItemModel(product: product, quantity: quantity));
    }
    Get.snackbar(
      'Produk Berhasil Ditambahkan',
      '${product.nama} Ditambahkan ke Keranjang',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void removeFromCart(Product product) {
    cartItems.removeWhere((item) => item.product.id == product.id);
  }

  void updateQuantity(Product product, int delta) {
    int index = cartItems.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      int newQty = cartItems[index].quantity + delta;
      if (newQty > 0) {
        cartItems[index].quantity = newQty;
        cartItems.refresh();
      } else {
        removeFromCart(product);
      }
    }
  }

  void clearCartWithConfirmation() {
    Get.defaultDialog(
      title: "Kosongkan Keranjang",
      middleText:
          "Apakah Anda Yakin Ingin Menghapus Semua Item dari Keranjang?",
      textConfirm: "Ya, Kosongkan Keranjang",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () {
        cartItems.clear();
        Get.back();
        Get.snackbar('Keranjang Kosong', 'Semua Item Telah Dihapus.');
      },
    );
  }

  int get totalItem {
    return cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalHarga {
    return cartItems.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  Future<void> checkout() async {
    if (cartItems.isEmpty) {
      Get.snackbar(
        'Keranjang Kosong',
        'Tambahkan Produk Terlebih Dahulu Sebelum Checkout!',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    String daftarItemStr = cartItems
        .map((item) => '${item.product.nama} (${item.quantity}x)')
        .join(', ');

    Map<String, dynamic> orderData = {
      'tanggal': DateTime.now().toString().split('.').first,
      'daftarItem': daftarItemStr,
      'totalHarga': totalHarga,
      'status': 'Diproses',
    };

    try {
      await OrderDatabase.instance.insertOrder(orderData);

      cartItems.clear();

      Get.snackbar(
        'Checkout Berhasil',
        'Pesanan Anda Sudah Disimpan ke Riwayat Pesanan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
        duration: const Duration(seconds: 2),
      );

      Get.off(() => const OrderHistoryPage());
      
    } catch (e) {
      Get.snackbar(
        'Checkout Gagal',
        'Terjadi Kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    }
  }
}
