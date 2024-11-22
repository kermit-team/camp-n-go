import 'package:equatable/equatable.dart';

class AuthCredentials extends Equatable {
  final String email;
  final String password;

  const AuthCredentials({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {"email": email, "password": password};

  @override
  List<Object?> get props => [email, password];
}
