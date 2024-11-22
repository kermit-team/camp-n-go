import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? avatar;
  final String? idCard;

  const ProfileEntity({
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.avatar,
    this.idCard,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        firstName,
        lastName,
        phoneNumber,
        avatar,
        idCard,
      ];
}
