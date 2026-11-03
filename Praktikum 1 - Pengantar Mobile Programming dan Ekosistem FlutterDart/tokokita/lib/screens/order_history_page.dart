import 'package:flutter/material.dart';

import '../services/order_database.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  List _orders = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders({String keyword = ''}) async {
    setState(() {
      _isLoading = true;
    });

    List data;
    if (keyword.isEmpty) {
      data = await OrderDatabase.instance.getAllOrders();
    } else {
      data = await OrderDatabase.instance.searchOrders(keyword);
    }

    setState(() {
      _orders = data;
      _isLoading = false;
    });
  }

  Future<void> _updateStatus(int id, String currentStatus) async {
    String nextStatus = currentStatus == 'Diproses' ? 'Selesai' : 'Diproses';
    await OrderDatabase.instance.updateOrderStatus(id, nextStatus);
    _loadOrders(keyword: _searchController.text);
  }

  Future<void> _delete(int id) async {
    await OrderDatabase.instance.deleteOrder(id);
    _loadOrders(keyword: _searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText:
                    'Cari berdasarkan status (cth: Diproses) atau item...',
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.purpleAccent,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _loadOrders();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.purpleAccent,
                    width: 2,
                  ),
                ),
              ),
              onChanged: (value) {
                _loadOrders(keyword: value);
              },
            ),
          ),

          // Daftar Riwayat Pesanan
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _orders.isEmpty
                ? const Center(
                    child: Text(
                      'Tidak ada riwayat pesanan yang ditemukan.',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  )
                : ListView.builder(
                    itemCount: _orders.length,
                    itemBuilder: (context, index) {
                      final order = _orders[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        elevation: 2,
                        child: ListTile(
                          title: Text('Item: ${order['daftarItem']}'),
                          subtitle: Text(
                            'Total: Rp ${order['totalHarga']}\nTanggal: ${order['tanggal']}\nStatus: ${order['status']}',
                          ),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                tooltip: 'Ubah Status',
                                onPressed: () =>
                                    _updateStatus(order['id'], order['status']),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                tooltip: 'Hapus Pesanan',
                                onPressed: () => _delete(order['id']),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
