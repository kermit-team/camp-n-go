import 'package:equatable/equatable.dart';

class AccountProfile extends Equatable {
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? avatar;
  final String? idCard;

  const AccountProfile({
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.avatar,
    this.idCard,
  });

  copyWith({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? avatar,
    String? idCard,
  }) =>
      AccountProfile(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        avatar: avatar ?? this.avatar,
        idCard: idCard ?? this.idCard,
      );

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        phoneNumber,
        avatar,
        idCard,
      ];
}
