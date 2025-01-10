import 'package:equatable/equatable.dart';

class CampingSection extends Equatable {
  final String name;
  final double basePrice;
  final double pricePerAdult;
  final double pricePerChild;

  const CampingSection({
    required this.name,
    required this.basePrice,
    required this.pricePerAdult,
    required this.pricePerChild,
  });

  CampingSection copyWith({
    String? name,
    double? basePrice,
    double? pricePerAdult,
    double? pricePerChild,
  }) {
    return CampingSection(
      name: name ?? this.name,
      basePrice: basePrice ?? this.basePrice,
      pricePerAdult: pricePerAdult ?? this.pricePerAdult,
      pricePerChild: pricePerChild ?? this.pricePerChild,
    );
  }

  @override
  List<Object?> get props => [
        name,
        basePrice,
        pricePerAdult,
        pricePerChild,
      ];
}
