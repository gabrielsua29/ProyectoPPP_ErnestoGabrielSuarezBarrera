class UserData {
  final String username;
  final String email;
  final String birthdate;
  final String password;
  final String bankCard;

  UserData({
    required this.username,
    required this.email,
    required this.birthdate,
    required this.password,
    required this.bankCard,
  });

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      birthdate: map['birthdate'] ?? '',
      password: map['password'] ?? '',
      bankCard: map['bankCard'] ?? '',
    );
  }

  UserData.empty()
      : username = '',
        email = '',
        birthdate = '',
        password = '',
        bankCard = '';
}
