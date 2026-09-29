import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = [...daftarProduk, ...daftarProduk];

    return Scaffold(
      backgroundColor: Colors.grey[70],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'TokoKita',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.purpleAccent,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Belanja jadi lebih mudah',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.shopping_cart, color: Colors.purpleAccent),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: daftarProduk.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: daftarProduk[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}