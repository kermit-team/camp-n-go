import 'package:equatable/equatable.dart';

class Car extends Equatable {
  // final String identifier;
  final String registrationPlate;

  const Car({
    // required this.identifier,
    required this.registrationPlate,
  });

  @override
  List<Object?> get props => [
        // identifier,
        registrationPlate,
      ];
}
