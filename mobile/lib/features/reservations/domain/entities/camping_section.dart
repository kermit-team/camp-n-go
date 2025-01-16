import 'package:equatable/equatable.dart';

class CampingSection extends Equatable {
  final int id;
  final String name;
  final double basePrice;
  final double pricePerAdult;
  final double pricePerChild;

  const CampingSection({
    required this.id,
    required this.name,
    required this.basePrice,
    required this.pricePerAdult,
    required this.pricePerChild,
  });

  CampingSection copyWith({
    int? id,
    String? name,
    double? basePrice,
    double? pricePerAdult,
    double? pricePerChild,
  }) =>
      CampingSection(
        id: id ?? this.id,
        name: name ?? this.name,
        basePrice: basePrice ?? this.basePrice,
        pricePerAdult: pricePerAdult ?? this.pricePerAdult,
        pricePerChild: pricePerChild ?? this.pricePerChild,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        basePrice,
        pricePerAdult,
        pricePerChild,
      ];
}
