import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/store.dart';
import '../services/storage_service.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final StorageService _storageService = StorageService();

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _colorsController = TextEditingController();
  bool _inStock = true;

  Store? _store;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
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

  void _addProduct() {
    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim());
    final colors = _colorsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (name.isEmpty || price == null || colors.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đủ thông tin!')),
      );
      return;
    }

    if (_store == null) return;

    setState(() {
      _store!.products.add(Product(
        id: DateTime.now().millisecondsSinceEpoch,
        name: name,
        price: price,
        colors: colors,
        inStock: _inStock,
      ));
    });

    _nameController.clear();
    _priceController.clear();
    _colorsController.clear();
    setState(() => _inStock = true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã thêm vào danh sách (chưa lưu vào máy).')),
    );
  }

  Future<void> _saveData() async {
    if (_store == null) return;
    try {
      await _storageService.writeStore(_store!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã lưu thành công vào thiết bị!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _colorsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _store == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Thêm sản phẩm')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm sản phẩm'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text('Cửa hàng: ${_store!.storeName}'),
          Text('Địa chỉ: ${_store!.address.street}, ${_store!.address.district}, ${_store!.address.city}'),
          const Divider(),
          const Text('Thông tin sản phẩm mới:', style: TextStyle(fontWeight: FontWeight.bold)),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
          ),
          TextField(
            controller: _priceController,
            decoration: const InputDecoration(labelText: 'Giá (đ)'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _colorsController,
            decoration: const InputDecoration(
              labelText: 'Màu sắc',
              hintText: 'Nhập các màu, cách nhau dấu phẩy (vd: đỏ, xanh)',
            ),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Tình trạng: Còn hàng'),
            value: _inStock,
            onChanged: (val) => setState(() => _inStock = val),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _addProduct,
            child: const Text('Thêm vào danh sách'),
          ),
          ElevatedButton(
            onPressed: _saveData,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            child: const Text('Lưu tất cả vào bộ nhớ máy (Persist Data)'),
          ),
          const Divider(),
          const Text('Danh sách sản phẩm hiện có:', style: TextStyle(fontWeight: FontWeight.bold)),
          if (_store!.products.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text('Chưa có sản phẩm nào.'),
            )
          else
            for (int i = 0; i < _store!.products.length; i++)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('${i + 1}. ${_store!.products[i].name}'),
                subtitle: Text(
                  'Giá: ${_store!.products[i].price} đ\nMàu sắc: ${_store!.products[i].colors.join(", ")}\nTình trạng: ${_store!.products[i].inStock ? "Còn hàng" : "Hết hàng"}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _store!.products.removeAt(i);
                    });
                  },
                ),
              ),
        ],
      ),
    );
  }
}
