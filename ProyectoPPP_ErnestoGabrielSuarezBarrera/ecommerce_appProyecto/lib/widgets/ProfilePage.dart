import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'LoginPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Map<String, dynamic> userData;
  late TextEditingController expiryDateController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    expiryDateController = TextEditingController();
    _loadUserDataWithDelay(); // Load user data with delay
  }

  Future<void> _loadUserDataWithDelay() async {
    // Add a delay of 1 second before loading user data
    await Future.delayed(Duration(seconds: 1));
    await _loadUserData();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadUserData() async {
    try {
      // Get the path to the user.json file
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String filePath = '$appDocPath/user.json';

      // Read the contents of the file
      String jsonContent = await File(filePath).readAsString();

      // Parse the JSON content
      userData = jsonDecode(jsonContent);

      // Update the UI with the new data
      setState(() {});
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(), // Show loading indicator
            )
          : Stack(
              children: [
                ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Profile',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildProfileItem(
                      label: 'Username',
                      value: userData['username'] ?? '',
                    ),
                    _buildProfileItem(
                      label: 'Email',
                      value: userData['email'] ?? '',
                    ),
                    _buildProfileItem(
                      label: 'Birthdate',
                      value: userData['birthdate'] ?? '',
                    ),
                    Divider(height: 30, color: Colors.grey),
                    _buildProfileItem(
                      label: 'Bank Card',
                      value: userData['cardNumber'] ?? '',
                      onTap: _showCardDialog,
                    ),
                  ],
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: SizedBox(
                    width: 120,
                    height: 40,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: ElevatedButton(
                        onPressed: _showResetPasswordDialog,
                        child: Text('Reset Password'),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: SizedBox(
                    width: 120,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: _signOut,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.withOpacity(0.5),
                      ),
                      child: Text(
                        'Sign Out',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void _showResetPasswordDialog() {
    TextEditingController newPasswordController = TextEditingController();
    bool obscureText = true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Reset Password'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: newPasswordController,
                      obscureText: obscureText,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        suffixIcon: IconButton(
                          icon: Icon(obscureText
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    String newPassword = newPasswordController.text.trim();

                    // Retrieve email from local storage
                    String? userEmail = userData['email'];

                    if (userEmail != null) {
                      // Update password in Firestore
                      await _updatePasswordInFirestore(userEmail, newPassword);
                    }

                    // Close dialog
                    Navigator.of(context).pop();
                  },
                  child: Text('Reset'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _updatePasswordInFirestore(
      String userEmail, String newPassword) async {
    try {
      // Reference to the "Usuarios" collection in Firestore
      CollectionReference usuarios =
          FirebaseFirestore.instance.collection('Usuarios');

      // Query for the document where email matches the userEmail
      QuerySnapshot querySnapshot =
          await usuarios.where('email', isEqualTo: userEmail).get();

      // If there is a document matching the query, update its password field
      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.update({
          'password': newPassword,
        });

        print('Password updated in Firestore successfully!');
      } else {
        print('No document found with the email: $userEmail');
      }
    } catch (e) {
      print('Error updating password in Firestore: $e');
    }
  }

  Widget _buildProfileItem({
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    String displayedValue =
        label == 'Bank Card' ? _obscureCardNumber(value) : value;

    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                displayedValue,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
          Divider(height: 16, color: Colors.grey),
        ],
      ),
    );
  }

  String _obscureCardNumber(String cardNumber) {
    if (cardNumber.length <= 4) {
      return cardNumber; // If the card number has 4 or fewer characters, don't obscure
    }

    String obscuredPart = '*' *
        (cardNumber.length - 4); // Obscure all characters except the last four
    String lastFourDigits =
        cardNumber.substring(cardNumber.length - 4); // Get the last four digits
    return '$obscuredPart$lastFourDigits'; // Concatenate the obscured part with the last four digits
  }

  void _showCardDialog() {
    String? cardNumberError;

    TextEditingController cardNumberController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.credit_card),
              SizedBox(width: 8),
              Text(
                'Add or Modify Card',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: cardNumberController,
                  decoration: InputDecoration(
                    labelText: 'Card Number',
                    errorText: cardNumberError,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                String cardNumber = cardNumberController.text.trim();

                if (_isValidCardNumber(cardNumber)) {
                  // Retrieve email from local storage
                  String? userEmail = userData['email'];

                  if (userEmail != null) {
                    // Update card number in Firestore
                    await _updateCardNumberInFirestore(userEmail, cardNumber);
                  }

                  // Close dialog
                  Navigator.of(context).pop();
                } else {
                  setState(() {
                    cardNumberError = 'Invalid card number';
                  });
                }
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateCardNumberInFirestore(
      String userEmail, String cardNumber) async {
    try {
      // Reference to the "Usuarios" collection in Firestore
      CollectionReference usuarios =
          FirebaseFirestore.instance.collection('Usuarios');

      // Query for the document where email matches the userEmail
      QuerySnapshot querySnapshot =
          await usuarios.where('email', isEqualTo: userEmail).get();

      // If there is a document matching the query, update its cardNumber field
      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.update({
          'cardNumber': cardNumber,
        });

        print('Card number updated in Firestore successfully!');

        setState(() {
          userData['bankCard'] = cardNumber;
        });

        // Now update the JSON file with the new card number
        await _updateJsonFile();
      } else {
        print('No document found with the email: $userEmail');
      }
    } catch (e) {
      print('Error updating card number in Firestore: $e');
    }
  }

  Future<void> _updateJsonFile() async {
    try {
      // Get the path to the user.json file
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String filePath = '$appDocPath/user.json';

      // Update the card number in the JSON file
      userData['cardNumber'] = userData['bankCard'];

      // Write the updated JSON content to the file
      await File(filePath).writeAsString(jsonEncode(userData));
    } catch (e) {
      print('Error updating JSON file: $e');
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        expiryDateController.text =
            '${picked.month}/${picked.year.toString().substring(2)}';
      });
    }
  }

  void _signOut() async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String filePath = '$appDocPath/user.json';
      File file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error signing out: $e');
    }

    // Navigate to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  bool _isValidCardNumber(String cardNumber) {
    // Remove spaces and non-digit characters
    String sanitizedCardNumber = cardNumber.replaceAll(RegExp(r'\D'), '');

    // Check if it's a valid length
    if (sanitizedCardNumber.length < 13 || sanitizedCardNumber.length > 19) {
      return false;
    }

    // Check Luhn algorithm
    int sum = 0;
    bool alternate = false;
    for (int i = sanitizedCardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(sanitizedCardNumber[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }
}
