import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/assets/i18n/utils/localeConfig.dart';

String usernameController = "";
String emailController = "";
String birthdateController = "";
String passwordController = "";

class RegisterPage extends StatelessWidget {
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
            child: RegisterForm(),
          ),
        ],
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  @override
  RegisterFormState createState() => RegisterFormState();
}

class RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  late Future<String> _newUserLabel;
  late Future<String> _usernameLabel;
  late Future<String> _passwordLabel;
  late Future<String> _emailLabel;
  late Future<String> _birthdateLabel;
  late Future<String> _emailUsed;
  late Future<String> _ageRestricted;
  late Future<String> _register;
  late Future<String> _usernameHint;
  late Future<String> _emailHint;
  late Future<String> _birthdateHint;
  late Future<String> _passwordHint;
  late Future<String> _emptyFieldError;
  late Future<String> _emailFormatError;

  @override
  void initState() {
    super.initState();
    _loadTranslations();
  }

  Future<void> _loadTranslations() async {
    _newUserLabel = getTranslatedString(context, 'newUser');
    _usernameLabel = getTranslatedString(context, 'usernameLabel');
    _passwordLabel = getTranslatedString(context, 'passwordLabel');
    _emailLabel = getTranslatedString(context, 'emailLabel');
    _birthdateLabel = getTranslatedString(context, 'birthdateLabel');
    _emailUsed = getTranslatedString(context, 'emailUsed');
    _ageRestricted = getTranslatedString(context, 'ageRestriction');
    _register = getTranslatedString(context, 'register');
    _usernameHint = getTranslatedString(context, 'usernameHint');
    _emailHint = getTranslatedString(context, 'emailHint');
    _birthdateHint = getTranslatedString(context, 'birthdateHint');
    _passwordHint = getTranslatedString(context, 'passwordHint');
    _emptyFieldError = getTranslatedString(context, 'emptyFieldError');
    _emailFormatError = getTranslatedString(context, 'emailFormatError');
  }

  void showEmailExistsError(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Error",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                FutureBuilder<String>(
                  future: _emailUsed,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else {
                      return Text(
                        snapshot.data ?? '',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      );
                    }
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showAgeRestrictionError(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Error",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                FutureBuilder<String>(
                  future: _ageRestricted,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else {
                      return Text(
                        snapshot.data ?? '',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      );
                    }
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showEmailFormatError(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Error",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                FutureBuilder<String>(
                  future: _emailFormatError,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else {
                      return Text(
                        snapshot.data ?? '',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      );
                    }
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void registerUser({
    required String username,
    required String email,
    required String birthDate,
    required String password,
  }) async {
    try {
      final existingUsers = await FirebaseFirestore.instance
          .collection('Usuarios')
          .where('email', isEqualTo: email)
          .get();

      if (existingUsers.docs.isNotEmpty) {
        showEmailExistsError(context);
        return;
      }

      DateTime parsedBirthDate = DateFormat('dd/MM/yyyy').parse(birthDate);

      // Calculate the user's age
      DateTime now = DateTime.now();
      int age = now.year - parsedBirthDate.year;
      if (now.month < parsedBirthDate.month ||
          (now.month == parsedBirthDate.month &&
              now.day < parsedBirthDate.day)) {
        age--;
      }

      if (age < 18) {
        // Show an error message
        showAgeRestrictionError(context);
        return;
      }

      await FirebaseFirestore.instance.collection('Usuarios').add({
        'username': username,
        'email': email,
        'birthDate': birthDate,
        'password': password,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User registered successfully!'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to register user: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: _loadTranslations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            return SingleChildScrollView(
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
                                margin: const EdgeInsets.only(
                                    bottom: 20.0, top: 3.0),
                                child: FutureBuilder<String>(
                                  future: _newUserLabel,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else {
                                      return Text(
                                        snapshot.data ?? '',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'RobotoSlab',
                                            fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.center,
                                      );
                                    }
                                  },
                                ),
                              ),
                              CustomRegisterInput(
                                labelText: _usernameLabel,
                                hintText: _usernameHint,
                                errorText: _emptyFieldError,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              CustomRegisterInput(
                                labelText: _emailLabel,
                                hintText: _emailHint,
                                errorText: _emptyFieldError,
                                validator: validateEmail,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              CustomRegisterInput(
                                labelText: _birthdateLabel,
                                hintText: _birthdateHint,
                                errorText: _emptyFieldError,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              CustomRegisterInput(
                                labelText: _passwordLabel,
                                hintText: _passwordHint,
                                errorText: _emptyFieldError,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 30.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState != null &&
                                        _formKey.currentState!.validate()) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Wait a few seconds...'),
                                        ),
                                      );
                                      // Add database register
                                      registerUser(
                                        username: usernameController,
                                        email: emailController,
                                        birthDate: birthdateController,
                                        password: passwordController,
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    minimumSize: const Size(250, 50),
                                    shadowColor:
                                        const Color.fromARGB(255, 56, 56, 56),
                                  ),
                                  child: FutureBuilder<String>(
                                    future: _register,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        return Text(
                                          snapshot.data ?? 'Register',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            letterSpacing: 0.5,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class CustomRegisterInput extends StatefulWidget {
  final Future<String> labelText;
  final Future<String> hintText;
  final Future<String> errorText;
  final String? Function(String?)? validator;

  const CustomRegisterInput({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.errorText,
    this.validator,
  }) : super(key: key);

  @override
  CustomRegisterInputState createState() => CustomRegisterInputState();
}

class CustomRegisterInputState extends State<CustomRegisterInput> {
  bool isObscured = true;
  TextEditingController dateCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateCtl = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: widget.labelText,
      builder: (context, labelTextSnapshot) {
        if (labelTextSnapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (labelTextSnapshot.hasData) {
          return _buildInputField(labelTextSnapshot.data!);
        } else {
          return Text('Error loading label');
        }
      },
    );
  }

  Widget _buildInputField(String labelText) {
    return FutureBuilder<String>(
      future: widget.hintText,
      builder: (context, hintTextSnapshot) {
        if (hintTextSnapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (hintTextSnapshot.hasData) {
          if (labelText == 'Fecha de nacimiento:' ||
              labelText == "Birthdate:") {
            return SizedBox(
              width: 300,
              child: TextFormField(
                validator: (value) {
                  if (widget.validator != null) {
                    return widget.validator!(value);
                  } else {
                    if (value == null || value.isEmpty) {
                      return hintTextSnapshot.data!;
                    }
                    return null;
                  }
                },
                controller: dateCtl,
                decoration: InputDecoration(
                  labelText: labelText,
                  labelStyle: const TextStyle(
                    fontSize: 16.0,
                    fontFamily: "RobotoSlab",
                    fontWeight: FontWeight.w200,
                  ),
                  hintText: hintTextSnapshot.data!,
                  hintStyle: const TextStyle(height: 3.0),
                  suffixIcon: Container(
                    margin: const EdgeInsets.only(top: 32.0),
                    child: const Icon(Icons.calendar_month),
                  ),
                ),
                onTap: () async {
                  DateTime? date = DateTime(1900);
                  FocusScope.of(context).requestFocus(FocusNode());

                  date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );

                  if (date != null) {
                    String formattedDate =
                        DateFormat('dd/MM/yyyy').format(date);
                    dateCtl.text = formattedDate;
                    birthdateController = formattedDate;
                  }
                },
              ),
            );
          } else if (labelText == 'Password:' || labelText == "Contraseña:") {
            return SizedBox(
              width: 300,
              child: TextFormField(
                obscureText: isObscured,
                validator: (value) {
                  if (widget.validator != null) {
                    return widget.validator!(value);
                  } else {
                    if (value == null || value.isEmpty) {
                      return hintTextSnapshot.data!;
                    }
                    return null;
                  }
                },
                onChanged: (value) {
                  passwordController = value;
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
                    fontWeight: FontWeight.w200,
                  ),
                  hintText: hintTextSnapshot.data!,
                  hintStyle: const TextStyle(height: 3.0),
                  suffixIcon:
                      labelText == 'Password:' || labelText == "Contraseña:"
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
          } else {
            return SizedBox(
              width: 300,
              child: TextFormField(
                validator: (value) {
                  if (widget.validator != null) {
                    return widget.validator!(value);
                  } else {
                    if (value == null || value.isEmpty) {
                      return hintTextSnapshot.data!;
                    }
                    return null;
                  }
                },
                onChanged: (value) {
                  if (labelText == "Username:" || labelText == "Usuario:") {
                    usernameController = value;
                  } else if (labelText == "Email:") {
                    emailController = value;
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
                    fontWeight: FontWeight.w200,
                  ),
                  hintText: hintTextSnapshot.data!,
                  hintStyle: const TextStyle(height: 3.0),
                ),
              ),
            );
          }
        } else {
          return Text('Error loading hint');
        }
      },
    );
  }
}

String validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email';
  }

  // Split the email address into local and domain parts
  List<String> parts = value.split('@');
  if (parts.length != 2) {
    return 'Please enter a valid email address';
  }

  String localPart = parts[0];
  String domainPart = parts[1];

  // Check if local part contains only valid characters
  if (localPart.isEmpty || localPart.contains(' ')) {
    return 'Please enter a valid email address';
  }

  // Check if domain part contains at least one dot and doesn't end with dot
  if (!domainPart.contains('.') || domainPart.endsWith('.')) {
    return 'Please enter a valid email address';
  }

  return '';
}
