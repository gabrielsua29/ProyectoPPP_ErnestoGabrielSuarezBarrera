import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      body: Stack(
        children: [
          Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("lib/assets/images/Login_BG.jpg"),
                    fit: BoxFit.cover),
              ),
              child: RegisterForm()),
        ],
      ),
    ));
  }
}

class RegisterForm extends StatefulWidget {
  @override
  RegisterFormState createState() => RegisterFormState();
}

class RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    const usernameLabel = 'Username:';
    const passwordLabel = 'Password:';
    const emailLabel = 'Email:';
    const bornLabel = 'Fecha de nacimiento:';
    const userBoxLabel = 'Nuevo usuario';

    return (Center(
      child: SingleChildScrollView(
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
                        const Icon(
                          Icons.account_circle,
                          size: 90.0,
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 20.0, top: 3.0),
                          child: const Text(
                            userBoxLabel,
                            style: TextStyle(
                                fontFamily: "RobotoSlab",
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0),
                          ),
                        ),
                        const CustomRegisterInput(labelText: usernameLabel),
                        const SizedBox(
                          height: 30,
                        ),
                        const CustomRegisterInput(labelText: emailLabel),
                        const SizedBox(
                          height: 30,
                        ),
                        const CustomRegisterInput(labelText: bornLabel),
                        const SizedBox(
                          height: 30,
                        ),
                        const CustomRegisterInput(labelText: passwordLabel),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 30.0),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState != null &&
                                  _formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Wait a few seconds...')));
                                //Add database login
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              minimumSize: const Size(250, 50),
                              shadowColor:
                                  const Color.fromARGB(255, 56, 56, 56),
                            ),
                            child: const Text(
                              'Register',
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
              ))
        ],
      )),
    ));
  }
}

class CustomRegisterInput extends StatefulWidget {
  final String labelText;
  final String? Function(String?)? validator;

  const CustomRegisterInput({
    super.key,
    required this.labelText,
    this.validator,
  });

  @override
  CustomRegisterInputState createState() => CustomRegisterInputState();
}

class CustomRegisterInputState extends State<CustomRegisterInput> {
  bool isObscured = true;
  DateTime? selectedDate;
  TextEditingController dateCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateCtl = TextEditingController(); // Initialize the controller
  }

  @override
  Widget build(BuildContext context) {
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
                fontFamily: 'RobotoSlab',
                fontWeight: FontWeight.w200),
            hintText: 'Introduzca su usuario...',
            hintStyle: const TextStyle(height: 3.0),
          ),
        ),
      );
    } else if (labelText == 'Email:') {
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
                fontFamily: 'RobotoSlab',
                fontWeight: FontWeight.w200),
            hintText: 'Introduzca su email...',
            hintStyle: const TextStyle(height: 3.0),
          ),
        ),
      );
    } else if (labelText == 'Fecha de nacimiento:') {
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
            controller: dateCtl,
            decoration: InputDecoration(
                labelText: 'Fecha de nacimiento:',
                labelStyle: const TextStyle(
                    fontSize: 16.0,
                    fontFamily: "RobotoSlab",
                    fontWeight: FontWeight.w200),
                hintText: '',
                hintStyle: const TextStyle(height: 3.0),
                suffixIcon: Container(
                    margin: const EdgeInsets.only(top: 32.0),
                    child: const Icon(Icons.calendar_month))),

            // Cuando el usuario toca el TextFormField se abre un DatePicker
            onTap: () async {
              DateTime? date = DateTime(1900);
              FocusScope.of(context).requestFocus(new FocusNode());

              date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now());

              print('Exiting on tap');

              if (date != null) {
                // Formatear fecha y mostrar
                String formattedDate = DateFormat('dd/MM/yyyy').format(date);
                dateCtl.text = formattedDate;
              }
            },
          ));
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
