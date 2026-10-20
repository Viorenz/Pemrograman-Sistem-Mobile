import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductService {
  final String endpoint = 'https://fakestoreapi.com/products';

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        List<dynamic> bodyData = jsonDecode(response.body) as List<dynamic>;

        List<Product> productList = bodyData
            .map((dynamic item) => Product.fromJson(item))
            .toList();

        return productList;
      } else {
        throw Exception(
          'Gagal memuat produk dari server (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('Terjadi error: $e');
    }
  }

  Future<Product> fetchProductDetail(int id) async {
    try {
      final response = await http.get(Uri.parse('$endpoint/$id'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> bodyData = jsonDecode(response.body);
        return Product.fromJson(bodyData);
      } else {
        throw Exception(
          'Gagal memuat detail produk (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('Terjadi error: $e');
    }
  }
}
