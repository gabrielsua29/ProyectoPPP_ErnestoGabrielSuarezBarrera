import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ecommerce_app/widgets/MainShop.dart';
import 'package:ecommerce_app/assets/i18n/utils/localeConfig.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("lib/assets/images/Login_BG.jpg"),
                  fit: BoxFit.cover),
            ),
            child: LoginForm()),
      ],
    ));
  }
}

class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: Future.wait([
        getTranslatedString(context, 'welcome'),
        getTranslatedString(context, 'usernameLabel'),
        getTranslatedString(context, 'passwordLabel'),
        getTranslatedString(context, 'login'),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for translation, return a loading indicator or placeholder
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // If an error occurred during translation, handle it appropriately
          return Text('Error: ${snapshot.error}');
        } else {
          // If translation is successful, use the translated strings
          var userBoxLabel = snapshot.data![0];
          var usernameLabel = snapshot.data![1];
          var passwordLabel = snapshot.data![2];
          var buttonText = snapshot.data![3];

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(bottom: 30.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.account_circle_rounded,
                              size: 90.0,
                            ),
                            Text(
                              userBoxLabel,
                              style: TextStyle(
                                fontFamily: "RobotoSlab",
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomLoginInput(labelText: usernameLabel),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomLoginInput(labelText: passwordLabel),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Login...')),
                              );
                              // Add database login
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MainShop(),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            minimumSize: const Size(250, 50),
                            shadowColor: const Color.fromARGB(255, 56, 56, 56),
                          ),
                          child: Text(
                            snapshot.data![3],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

// ignore: must_be_immutable
class CustomLoginInput extends StatefulWidget {
  final String labelText;
  final String? Function(String?)? validator;

  const CustomLoginInput({
    super.key,
    required this.labelText,
    this.validator,
  });

  @override
  _CustomLoginInputState createState() => _CustomLoginInputState();
}

class _CustomLoginInputState extends State<CustomLoginInput> {
  bool isObscured = true;

  @override
  Widget build(BuildContext context) {
    //Obtaining values from the CustomLoginInput
    final String labelText = widget.labelText;
    final String? Function(String?)? validator = widget.validator;

    if (labelText == 'Username:') {
      return SizedBox(
        width: 300,
        child: TextFormField(
          validator: (value) {
            if (validator != null) {
              return validator(value);
            } else {
              if (value == null || value.isEmpty) {
                return 'This field cannot be empty.';
              }
              return null;
            }
          },
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'RobotoSlab',
            fontStyle: FontStyle.italic,
          ),
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(
                fontSize: 16.0,
                fontFamily: "RobotoSlab",
                fontWeight: FontWeight.w200),
            hintText: "Introduzca su usuario...",
            hintStyle: const TextStyle(height: 3.0),
          ),
        ),
      );
    } else {
      return SizedBox(
        width: 300,
        child: TextFormField(
          obscureText: isObscured,
          validator: (value) {
            if (validator != null) {
              return validator(value);
            } else {
              if (value == null || value.isEmpty) {
                return 'This field cannot be empty.';
              }
              return null;
            }
          },
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'RobotoSlab',
            fontStyle: FontStyle.italic,
          ),
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(
                fontSize: 16.0,
                fontFamily: "RobotoSlab",
                fontWeight: FontWeight.w200),
            hintText: "Introduzca su contraseña...",
            hintStyle: const TextStyle(height: 3.0),
            suffixIcon: IconButton(
              icon: Container(
                margin: const EdgeInsets.only(top: 22.0),
                child: Icon(
                  isObscured ? Icons.visibility : Icons.visibility_off,
                ),
              ),
              onPressed: () {
                setState(() {
                  isObscured = !isObscured;
                });
              },
            ),
          ),
        ),
      );
    }
  }
}
