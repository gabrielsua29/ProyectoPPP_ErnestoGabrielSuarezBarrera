import 'package:ecommerce_app/widgets/ProfilePage.dart';
import 'package:ecommerce_app/widgets/ShopPage.dart';

import 'package:flutter/material.dart';

class MainShop extends StatefulWidget {
  const MainShop({Key? key}) : super(key: key);

  @override
  State<MainShop> createState() => _MainShopState();
}

class _MainShopState extends State<MainShop> {
  int currentIndex = 0;
  List screens = [
    const ShopPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("E-Commerce Shop"),
        centerTitle: true,
      ),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() => currentIndex = value);
        },
        items: const [
          BottomNavigationBarItem(
            label: "Shop",
            icon: Icon(Icons.shop),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(Icons.person),
          )
        ],
      ),
    );
  }
}
