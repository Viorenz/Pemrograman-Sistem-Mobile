import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/product.dart';

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
}
