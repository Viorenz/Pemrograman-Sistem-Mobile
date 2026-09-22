import 'package:flutter/material.dart';

class StockBadge extends StatelessWidget {
  final int stock;

  const StockBadge({Key? key, required this.stock}) : super(key: key);

  // Menentukan warna badge
  Color _getBadgeColor() {
    if (stock > 5) {
      return Colors.green;
    } else if (stock > 0) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  // Menentukan teks status
  String _getBadgeText() {
    if (stock > 5) {
      return "Tersedia ($stock)";
    } else if (stock > 0) {
      return "Stok Terbatas ($stock)";
    } else {
      return "Habis";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getBadgeColor().withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: _getBadgeColor()),
      ),
      child: Text(
        _getBadgeText(),
        style: TextStyle(
          color: _getBadgeColor(),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}