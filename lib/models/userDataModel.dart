class User {
  final String dob;
  final String email;
  final String gender;
  final String name;
  final String phoneNumber;
  final String address;

  User({
    required this.dob,
    required this.email,
    required this.gender,
    required this.name,
    required this.phoneNumber,
    required this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      gender: json['gender'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      dob: json['dob'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'dob': dob,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'address': address,
    };
  }
}
