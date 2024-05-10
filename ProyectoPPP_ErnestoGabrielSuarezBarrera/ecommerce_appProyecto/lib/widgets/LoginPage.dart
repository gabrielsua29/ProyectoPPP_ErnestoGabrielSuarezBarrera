import 'package:flutter/material.dart';
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
}

class CustomLoginInput extends StatefulWidget {
  final String labelText;

  const CustomLoginInput({
    required this.labelText,
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
              obscureText: isObscured,
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
                        icon: Container(
                          margin: const EdgeInsets.only(top: 22.0),
                          child: Icon(
                            isObscured
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
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
