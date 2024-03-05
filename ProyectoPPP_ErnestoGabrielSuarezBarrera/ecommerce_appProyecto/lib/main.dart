import 'package:ecommerce_app/widgets/LoginRegisterMainPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 75, 164, 205)),
        useMaterial3: true,
      ),
      home: const LoginRegisterMainPage(),
    );
  }
}
