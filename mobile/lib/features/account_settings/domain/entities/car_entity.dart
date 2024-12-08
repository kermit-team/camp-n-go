import 'package:equatable/equatable.dart';

class CarEntity extends Equatable {
  final String identifier;
  final String registrationPlate;

  const CarEntity({
    required this.identifier,
    required this.registrationPlate,
  });

  @override
  List<Object?> get props => [
        identifier,
        registrationPlate,
      ];
}
