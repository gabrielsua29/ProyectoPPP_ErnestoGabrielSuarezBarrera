import 'package:ecommerce_app/widgets/LoginRegisterMainPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey:
          "AIzaSyBC95bqE7uXrTO2tpXzajLgpbxq-oM0dn8", // paste your api key here
      appId:
          "1:653198875001:android:03354c1877d9956a0937a8", //paste your app id here
      messagingSenderId: "653198875001", //paste your messagingSenderId here
      projectId: "proyectoflutter-b088e", //paste your project id here
    ),
  );
  bool firebaseInitialized = Firebase.apps.isNotEmpty;
  print('Firebase initialized: $firebaseInitialized');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'), // English
        Locale('es', 'ES'), // Spanish
      ],
      locale: const Locale('es', 'ES'), // Default to Spanish
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
