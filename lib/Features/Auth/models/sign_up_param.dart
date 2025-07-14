import 'package:equatable/equatable.dart';

class SignUpParam extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String address;
  final String role;
  final String password;

  const SignUpParam({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.address,
    required this.role,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'address': address,
    'role': role,
    'password': password,
  };

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    address,
    role,
    password,
  ];
}
