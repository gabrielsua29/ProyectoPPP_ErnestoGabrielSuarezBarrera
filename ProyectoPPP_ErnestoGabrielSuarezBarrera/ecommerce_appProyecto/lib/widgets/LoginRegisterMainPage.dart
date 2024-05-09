import 'package:flutter/material.dart';
import 'package:ecommerce_app/widgets/LoginPage.dart';
import 'package:ecommerce_app/widgets/RegisterPage.dart';
import 'package:ecommerce_app/assets/i18n/utils/localeConfig.dart';

class LoginRegisterMainPage extends StatelessWidget {
  const LoginRegisterMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Future.wait([
          getTranslatedString(context, 'login'),
          getTranslatedString(context, 'register'),
        ]),
        builder: (context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          "lib/assets/images/LoginRegisterMainPageBackground.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 55,
                  left: 0,
                  right: 0,
                  child: CustomButton(
                    buttonText: snapshot.data![0],
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: -20,
                  left: 0,
                  right: 0,
                  child: CustomButton(
                    buttonText: snapshot.data![1],
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;

  const CustomButton({
    required this.onPressed,
    required this.buttonText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 55,
      margin: const EdgeInsets.only(bottom: 120, left: 30, right: 30),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(200, 50),
          backgroundColor: const Color.fromARGB(255, 161, 212, 228),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 18.0,
            fontFamily: 'RobotoSlab',
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            letterSpacing: 0.7,
            color: Color.fromARGB(255, 5, 93, 119),
          ),
        ),
      ),
    );
  }
}
