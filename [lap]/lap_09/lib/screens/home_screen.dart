import 'package:flutter/material.dart';
import '../models/store.dart';
import '../services/storage_service.dart';
import 'add_product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storageService = StorageService();
  late Future<Store> _storeFuture;

  @override
  void initState() {
    super.initState();
    _reloadStore();
  }

  void _reloadStore() {
    setState(() {
      _storeFuture = _storageService.readStore();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reloadStore,
          )
        ],
      ),
      body: FutureBuilder<Store>(
        future: _storeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Không có dữ liệu!'));
          }

          final store = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text('Cửa hàng: ${store.storeName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text('Địa chỉ: ${store.address.city}, ${store.address.district}, ${store.address.street}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddProduct()),
                  );
                  if (mounted) {
                    _reloadStore();
                  }
                },
                child: const Text('Thêm / Quản lý sản phẩm'),
              ),
              const Divider(),
              const Text('Danh sách sản phẩm:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              if (store.products.isEmpty)
                const Text('Chưa có sản phẩm nào.')
              else
                for (final product in store.products)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(product.name),
                    subtitle: Text('Giá: ${product.price} đ\nMàu sắc: ${product.colors.join(", ")}'),
                    trailing: Text(product.inStock ? 'Còn hàng' : 'Hết hàng'),
                  ),
            ],
          );
        },
      ),
    );
  }
}
