import 'package:flutter/material.dart';

class PriceLabel extends StatelessWidget {
  final double price;

  const PriceLabel({Key? key, required this.price}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "Rp ${price.toStringAsFixed(0)}",
      style: TextStyle(
        fontSize: 16,
        color: Colors.green[700],
        fontWeight: FontWeight.bold,
      ),
    );
  }
}