import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:lap_09/models/store.dart';
import 'package:path_provider/path_provider.dart';

class StorageService {
  static const String _fileName = 'item.json';

  Future<File?> _getFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      return File('${directory.path}/$_fileName');
    } catch (e) {
      return null;
    }
  }

  Future<Store> readStore() async {
    try {
      final filePath = await _getFile();
      if (filePath != null && await filePath.exists()) {
        final String content = await filePath.readAsString();
        final Map<String, dynamic> data = json.decode(content);
        return Store.fromJson(data);
      }
    } catch (_) {
    }

    final String assetContent = await rootBundle.loadString(
      'assets/data/$_fileName',
    );
    final Map<String, dynamic> data = json.decode(assetContent);
    return Store.fromJson(data);
  }

  Future<void> writeStore(Store store) async {
    final filePath = await _getFile();
    if (filePath == null) {
      throw Exception(
        'Không thể tìm thấy thư mục lưu trữ dữ liệu.',
      );
    }
    final Map<String, dynamic> data = store.toJson();
    final String content = json.encode(data);
    await filePath.writeAsString(content);
  }
}
