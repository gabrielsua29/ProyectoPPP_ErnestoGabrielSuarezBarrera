import 'package:ecommerce_app/widgets/RegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/widgets/MainShop.dart';
import 'package:ecommerce_app/assets/i18n/utils/localeConfig.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                fit: BoxFit.cover,
              ),
            ),
            child: LoginForm(),
          ),
        ],
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
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
                      CustomLoginInput(
                        labelText: usernameLabel,
                        controller: usernameController,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomLoginInput(
                        labelText: passwordLabel,
                        controller: passwordController,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Login...')),
                              );

                              // Authenticate user
                              bool authenticated = await authenticateUser(
                                  usernameController.text.trim(),
                                  passwordController.text.trim());
                              if (authenticated) {
                                // Navigate to main shop page if authentication is successful
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainShop(),
                                  ),
                                );
                              } else {
                                // Show error message if authentication fails
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Authentication failed.'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            minimumSize: const Size(250, 50),
                            shadowColor: const Color.fromARGB(255, 56, 56, 56),
                          ),
                          child: Text(
                            buttonText,
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

  Future<bool> authenticateUser(String username, String password) async {
    try {
      // Query Firestore to find a user with the provided email
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Usuarios')
          .where('username', isEqualTo: username)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Retrieve the user data
        Map<String, dynamic> userData = snapshot.docs.first.data();

        // Compare the passwords
        if (userData['password'] == password) {
          // Authentication successful
          return true;
        } else {
          // Incorrect password
          return false;
        }
      } else {
        // User not found
        return false;
      }
    } catch (e) {
      // Error occurred during authentication
      print('Authentication error: $e');
      return false;
    }
  }
}

class CustomLoginInput extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;

  const CustomLoginInput({
    required this.labelText,
    required this.controller,
  });

  @override
  _CustomLoginInputState createState() => _CustomLoginInputState();
}

class _CustomLoginInputState extends State<CustomLoginInput> {
  bool isObscured = true;

  @override
  Widget build(BuildContext context) {
    var hintTextKey =
        widget.labelText == 'Username:' || widget.labelText == 'Usuario:'
            ? 'usernameHint'
            : 'passwordHint';

    return FutureBuilder<List<String>>(
      future: Future.wait([
        getTranslatedString(context, hintTextKey),
        getTranslatedString(context, 'emptyFields'),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          var hintText = snapshot.data![0];
          var emptyFields = snapshot.data![1];

          return SizedBox(
            width: 300,
            child: TextFormField(
              controller: widget.controller,
              obscureText: widget.labelText == 'Password:' ||
                      widget.labelText == 'Contraseña:'
                  ? isObscured
                  : false,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return emptyFields;
                }
                return null;
              },
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'RobotoSlab',
                fontStyle: FontStyle.italic,
              ),
              decoration: InputDecoration(
                labelText: widget.labelText,
                labelStyle: const TextStyle(
                  fontSize: 16.0,
                  fontFamily: "RobotoSlab",
                  fontWeight: FontWeight.w200,
                ),
                hintText: hintText,
                hintStyle: const TextStyle(height: 3.0),
                suffixIcon: widget.labelText == 'Password:' ||
                        widget.labelText == 'Contraseña:'
                    ? IconButton(
                        icon: Icon(
                          isObscured ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isObscured = !isObscured;
                          });
                        },
                      )
                    : null,
              ),
            ),
          );
        }
      },
    );
  }
}
