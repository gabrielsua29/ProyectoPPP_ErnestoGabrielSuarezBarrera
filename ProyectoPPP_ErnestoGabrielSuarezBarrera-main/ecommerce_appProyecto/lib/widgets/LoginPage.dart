import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginForm(),
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
    const usernameLabel = 'Username:';
    const passwordLabel = 'Password:';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const CustomLoginInput(labelText: usernameLabel),
                const SizedBox(
                  height: 30,
                ),
                const CustomLoginInput(labelText: passwordLabel),
                const SizedBox(
                  height: 30,
                ),
                SizedBox( 
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Login...')));
                            //Add database login
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        minimumSize: const Size(250, 50),
                        shadowColor: const Color.fromARGB(255, 56, 56, 56),
                        ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
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
            hintText: "Introduzca su usuario..."
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
            hintText: "Introduzca su contraseña...",
            suffixIcon: IconButton(
            icon: Icon(
              isObscured ? Icons.visibility : Icons.visibility_off,
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
