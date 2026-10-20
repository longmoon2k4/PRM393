import 'package:flutter/material.dart';

import '../models/product.dart';
import '../models/store.dart';
import '../services/storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storageService = StorageService();
  Store? _store;
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();
  String _searchKeyword = '';

  @override
  void initState() {
    super.initState();
    _loadStoreData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadStoreData() async {
    try {
      final store = await _storageService.readStore();
      if (mounted) {
        setState(() {
          _store = store;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _autoSave() async {
    if (_store != null) {
      await _storageService.writeStore(_store!);
    }
  }

  void _showProductDialog({Product? productToEdit}) {
    final isEditing = productToEdit != null;
    final nameController = TextEditingController(
      text: isEditing ? productToEdit.name : '',
    );
    final priceController = TextEditingController(
      text: isEditing ? productToEdit.price.toStringAsFixed(0) : '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Chỉnh sửa sản phẩm' : 'Thêm sản phẩm mới'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Tên sản phẩm',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Giá (đ)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              final price = double.tryParse(priceController.text.trim());

              if (name.isEmpty || price == null) return;

              setState(() {
                if (isEditing) {
                  productToEdit.name = name;
                  productToEdit.price = price;
                } else {
                  _store!.products.add(
                    Product(
                      id: DateTime.now().millisecondsSinceEpoch,
                      name: name,
                      price: price,
                      colors: ['mặc định'],
                      inStock: true,
                    ),
                  );
                }
              });

              await _autoSave();

              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isEditing
                          ? 'Đã cập nhật sản phẩm!'
                          : 'Đã thêm và lưu sản phẩm!',
                    ),
                  ),
                );
              }
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa sản phẩm "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              setState(() {
                _store!.products.removeWhere((p) => p.id == product.id);
              });

              await _autoSave();

              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã xóa và cập nhật bộ nhớ!')),
                );
              }
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_store == null) {
      return const Scaffold(
        body: Center(child: Text('Không thể tải dữ liệu!')),
      );
    }

    final filteredProducts = _store!.products.where((p) {
      return p.name.toLowerCase().contains(_searchKeyword.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text('${_store!.storeName} - CRUD JSON')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(
              'Địa chỉ: ${_store!.address.street}, ${_store!.address.district}, ${_store!.address.city}',
              style: const TextStyle(color: Colors.grey),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm sản phẩm theo tên...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchKeyword.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchKeyword = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              onChanged: (val) {
                setState(() => _searchKeyword = val);
              },
            ),
          ),
          const Divider(),

          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(child: Text('Không tìm thấy sản phẩm nào.'))
                : ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final item = filteredProducts[index];
                      return ListTile(
                        leading: CircleAvatar(child: Text('${index + 1}')),
                        title: Text(
                          item.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Giá: ${item.price.toStringAsFixed(0)} đ',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () =>
                                  _showProductDialog(productToEdit: item),
                            ),

                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmDelete(item),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
