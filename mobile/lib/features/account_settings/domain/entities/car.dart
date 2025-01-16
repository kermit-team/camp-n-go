import 'package:equatable/equatable.dart';

class Car extends Equatable {
  final int id;
  final String registrationPlate;

  const Car({
    required this.id,
    required this.registrationPlate,
  });

  @override
  List<Object?> get props => [registrationPlate];
}
