import 'package:equatable/equatable.dart';

class Car extends Equatable {
  final String registrationPlate;
  final bool assignedToReservation;

  const Car({
    required this.registrationPlate,
    this.assignedToReservation = false,
  });

  @override
  List<Object?> get props => [registrationPlate, assignedToReservation];
}
