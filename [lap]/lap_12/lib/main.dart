import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lap_12/screens/task_list_screen.dart';
import 'package:lap_12/providers/task_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Taskly',
        home: TaskListScreen(),
      ),
    ),
  );
}

