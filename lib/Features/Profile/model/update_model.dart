import 'package:equatable/equatable.dart';

class UpdateModel extends Equatable {
  final String fName;
  final String lName;
  final String address;
  final String email;
  final String? password;
  const UpdateModel({
    required this.fName,
    required this.lName,
    required this.address,
    required this.email,
    this.password,
  });

  factory UpdateModel.fromJson(Map<String, dynamic> json) {
    return UpdateModel(
      fName: json['firstName'],
      lName: json['lastName'],
      address: json['address'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() => password == null
      ? {
          'firstName': fName,
          'lastName': lName,
          'address': address,
          'email': email,
        }
      : {
          'firstName': fName,
          'lastName': lName,
          'address': address,
          'email': email,
          'password': password,
        };

  @override
  List<Object?> get props => [fName, lName, address, email, password];
}
