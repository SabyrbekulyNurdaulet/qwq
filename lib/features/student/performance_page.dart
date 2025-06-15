// Пример заглушки для PerformancePage (создай performance_page.dart)
import 'package:flutter/material.dart';

class PerformancePage extends StatelessWidget {
  const PerformancePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Посещаемость')),
      body: const Center(child: Text('Страница Посещаемости')),
    );
  }
}
