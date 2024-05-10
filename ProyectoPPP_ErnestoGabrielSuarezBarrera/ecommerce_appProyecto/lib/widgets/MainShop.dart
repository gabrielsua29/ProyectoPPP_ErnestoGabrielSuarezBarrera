import 'package:ecommerce_app/model/userData.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/widgets/ProfilePage.dart';
import 'package:ecommerce_app/widgets/ShopPage.dart';
import 'package:ecommerce_app/assets/i18n/utils/localeConfig.dart';

class MainShop extends StatefulWidget {
  const MainShop({Key? key}) : super(key: key);

  @override
  State<MainShop> createState() => _MainShopState();
}

class _MainShopState extends State<MainShop> {
  int currentIndex = 0;
  late String shopLabel = '';
  late String profileLabel = '';
  List screens = [
    const ShopPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _loadTranslations();
  }

  Future<void> _loadTranslations() async {
    // Delay for a very short duration to allow initState to complete
    await Future.delayed(Duration.zero);

    final List<String> labels = await Future.wait([
      getTranslatedString(context, 'shopMenuLabel'),
      getTranslatedString(context, 'profileMenuLabel'),
    ]);
    setState(() {
      shopLabel = labels[0];
      profileLabel = labels[1];
    });
  }

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
        items: [
          BottomNavigationBarItem(
            label: shopLabel,
            icon: const Icon(Icons.shop),
          ),
          BottomNavigationBarItem(
            label: profileLabel,
            icon: const Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
