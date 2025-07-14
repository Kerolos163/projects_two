import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String fName;
  final String lName;
  final String address;
  final String email;
  final String role;
  final String token;

  const UserModel({
    required this.id,
    required this.fName,
    required this.lName,
    required this.address,
    required this.email,
    required this.role,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fName: json['First Name'],
      lName: json['Last Name'],
      address: json['address'],
      email: json['email'],
      role: json['role'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'First Name': fName,
    'Last Name': lName,
    'address': address,
    'email': email,
    'role': role,
    'token': token,
  };

  @override
  List<Object?> get props => [id, fName, lName, address, email, role, token];
}
