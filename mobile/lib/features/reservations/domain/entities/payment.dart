import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

enum PaymentStatus {
  @JsonValue(0)
  pending, // Oczekiwanie na płatność
  @JsonValue(1)
  cancelled, // Anulowana
  @JsonValue(2)
  unpaid, // Nieopłacona
  @JsonValue(3)
  paid, // Opłacona
  @JsonValue(4)
  refunded, // Zwrócona
}

class Payment extends Equatable {
  final int id;
  final PaymentStatus status;
  final double price;

  const Payment({
    required this.id,
    required this.status,
    required this.price,
  });

  Payment copyWith({
    int? id,
    PaymentStatus? status,
    double? price,
  }) =>
      Payment(
        id: id ?? this.id,
        status: status ?? this.status,
        price: price ?? this.price,
      );

  @override
  List<Object?> get props => [
        id,
        status,
        price,
      ];
}
