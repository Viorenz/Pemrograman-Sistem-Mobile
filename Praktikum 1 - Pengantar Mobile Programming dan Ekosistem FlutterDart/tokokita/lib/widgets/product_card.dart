import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';
import '../screens/product_detail_page.dart';
import '../controllers/cart_controller.dart';
import '../services/product_service.dart';
import 'price_label.dart';
import 'stock_badge.dart';
import 'category_tag.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favoriteIds =
        prefs.getStringList('favorite_product_ids') ?? [];

    if (mounted) {
      setState(() {
        isFavorite = favoriteIds.contains(widget.product.id.toString());
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteIds =
        prefs.getStringList('favorite_product_ids') ?? [];

    final productIdStr = widget.product.id.toString();

    setState(() {
      isFavorite = !isFavorite;
      if (isFavorite) {
        if (!favoriteIds.contains(productIdStr)) {
          favoriteIds.add(productIdStr);
        }
      } else {
        favoriteIds.remove(productIdStr);
      }
    });

    await prefs.setStringList('favorite_product_ids', favoriteIds);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.tealAccent.withOpacity(0.3),
            blurRadius: 13,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: InkWell(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
              onTap: () async {
                final result = await Get.to(
                  () => ProductDetailPage(product: widget.product),
                );

                if (result != null) {
                  Get.snackbar(
                    'Produk Berhasil Ditambahkan',
                    '${widget.product.nama} ($result) berhasil ditambahkan ke keranjang!',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green.shade100,
                    colorText: Colors.green.shade900,
                    duration: const Duration(seconds: 2),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            width: 70,
                            height: 70,
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.image,
                              size: 35,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        if (widget.product is DiscountedProduct)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${(widget.product as DiscountedProduct).discountPercent.toInt()}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CategoryTag(category: widget.product.kategori),
                          const SizedBox(height: 4),
                          Text(
                            widget.product.nama,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          PriceLabel(price: widget.product.harga),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.add_shopping_cart,
                    color: Colors.purpleAccent,
                  ),
                  tooltip: 'Tambah ke Keranjang',
                  onPressed: () {
                    final CartController cartController = Get.find<CartController>();
                    cartController.addToCart(widget.product);
                  },
                ),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                  tooltip: 'Wishlist',
                  onPressed: () {
                    _toggleFavorite();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}