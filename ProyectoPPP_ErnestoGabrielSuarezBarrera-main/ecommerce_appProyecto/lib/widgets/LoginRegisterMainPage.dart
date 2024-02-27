import 'package:ecommerce_app/widgets/LoginPage.dart';
import 'package:ecommerce_app/widgets/RegisterPage.dart';
import 'package:flutter/material.dart';

class LoginRegisterMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
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
            buttonText: 'Login',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        LoginPage()), // Navigator.push para cambiar de widget
              );
            },
          ),
        ),
        Positioned(
          bottom: -20,
          left: 0,
          right: 0,
          child: CustomButton(
            buttonText: 'Register',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        RegisterPage()), // Navigator.push para cambiar de widget
              );
            },
          ),
        ),
      ]),
    );
  }
}

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  /*
  VoidCallback is a type definition in Flutter for a function that takes no arguments and 
  returns no value (i.e., a function with a signature void Function()). It is commonly used for handling callback functions,
  especially in scenarios where you want to perform an action in response to an event, such as pressing a button.
  */

  const CustomButton(
      {super.key, required this.onPressed, required this.buttonText});

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
        child: 
          Text(buttonText,
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
