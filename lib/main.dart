import 'package:flutter/material.dart';

import 'presentation/view/my_string_home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Fix: Added key parameter to avoid
  // a warning about a named 'key' parameter

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Flutter Dummy MVVM Clean',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyStringHomeScreen(),
    );
  }
}
