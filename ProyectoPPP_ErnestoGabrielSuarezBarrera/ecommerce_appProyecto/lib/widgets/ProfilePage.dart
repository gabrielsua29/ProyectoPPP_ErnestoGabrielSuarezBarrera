import 'package:ecommerce_app/widgets/LoginPage.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController expiryDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
              _buildProfileItem(label: 'Username', value: 'JohnDoe123'),
              _buildProfileItem(label: 'Email', value: 'johndoe@example.com'),
              _buildProfileItem(label: 'Birthdate', value: 'January 1, 1990'),
              Divider(height: 30, color: Colors.grey),
              _buildProfileItem(
                label: 'Bank Card',
                value: '**** **** **** 1234',
                onTap: _showCardDialog,
              ),
            ],
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

  Widget _buildProfileItem(
      {required String label, required String value, VoidCallback? onTap}) {
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
                value,
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

  void _showCardDialog() {
    String? cardNumberError;
    String? cardHolderNameError;
    String? expiryDateError;

    TextEditingController cardNumberController = TextEditingController();
    TextEditingController cardHolderNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add or Modify Card',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
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
                TextField(
                  controller: cardHolderNameController,
                  decoration: InputDecoration(
                    labelText: 'Cardholder Name',
                    errorText: cardHolderNameError,
                  ),
                ),
                TextField(
                  controller: expiryDateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Expiry Date',
                    errorText: expiryDateError,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                String cardNumber = cardNumberController.text.trim();
                String cardHolderName = cardHolderNameController.text.trim();
                String expiryDate = expiryDateController.text.trim();

                setState(() {
                  cardNumberError = cardNumber.isEmpty
                      ? 'Please enter card number'
                      : _isValidCardNumber(cardNumber)
                          ? null
                          : 'Invalid card number';
                  cardHolderNameError = cardHolderName.isEmpty
                      ? 'Please enter cardholder name'
                      : null;
                  expiryDateError =
                      expiryDate.isEmpty ? 'Please enter expiry date' : null;
                });

                if (cardNumber.isNotEmpty &&
                    cardHolderName.isNotEmpty &&
                    expiryDate.isNotEmpty &&
                    _isValidCardNumber(cardNumber)) {
                  // TODO: Save card data
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill all fields correctly'),
                      duration: Duration(seconds: 2),
                    ),
                  );
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

  void _signOut() {
    // Clear any user session data or authentication tokens
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
