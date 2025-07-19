import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String fName;
  final String lName;
  final String address;
  final String email;
   String role;
  final String? token;
  final String? avatar;

   UserModel({
    required this.id,
    required this.fName,
    required this.lName,
    required this.address,
    required this.email,
    required this.role,
    this.token,
    this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fName: json['firstName'],
      lName: json['lastName'],
      address: json['address'],
      email: json['email'],
      role: json['role'],
      token: json['token'],
      avatar: json['avatar'],
    );
  }

 factory UserModel.fromJson2(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      fName: json['firstName'],
      lName: json['lastName'],
      address: json['address'],
      email: json['email'],
      role: json['role'],
      token: json['token'],
      avatar: json['avatar'],
    );
  }
  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': fName,
    'lastName': lName,
    'address': address,
    'email': email,
    'role': role,
    'token': token,
  };

Map<String, dynamic> toJsonForUpdate() => {
  'firstName': fName,
  'lastName': lName,
  'address': address,
  'role': role,
  'email': email,
};

  @override
  List<Object?> get props => [id, fName, lName, address, email, role];
}
