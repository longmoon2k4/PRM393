import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lap_09/models/store.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Store> _store;
  Future<Store> _loadLocalStore() async {
    final String localStore = await rootBundle.loadString(
      'assets/data/item.json',
    );
    Map<String, dynamic> jsonMap = jsonDecode(localStore);
    return Store.fromJson(jsonMap);
  }

  @override
  void initState() {
    super.initState();
    _store = _loadLocalStore();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Local Data')),
      body: FutureBuilder<Store>(
        future: _store,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final store = snapshot.data!;
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Địa chỉ ${store.address.city} |  ${store.address.district} | ${store.address.street}',
                  ),
                  const SizedBox(height: 8.0),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: store.products.length,
                    itemBuilder: (context, index) {
                      final product = store.products[index];
                      return ListTile(
                        title: Text(product.name),
                        subtitle: Text('Giá: ${product.price}'),
                      );
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
