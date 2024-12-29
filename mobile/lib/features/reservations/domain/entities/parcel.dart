import 'package:equatable/equatable.dart';

class Parcel extends Equatable {
  final int parcelNumber;
  final int maxPeople; // Maximum number of people
  final String description;
  final double parcelLength; // Parcel length
  final double parcelWidth; // Parcel width
  final bool hasElectricity; // Electricity connection
  final bool hasWater; // Water connection
  final bool hasGreyWaterDisposal; // Grey water disposal
  final bool isShaded; // Shaded
  final double pricePerParcel; // New field: Price per parcel
  final double pricePerAdult; // New field: Price per adult
  final double pricePerChild; // New field: Price per child
  final Map<String, dynamic>?
      additionalNotes; // Additional notes (optional JSON)

  const Parcel({
    required this.parcelNumber,
    required this.maxPeople,
    required this.description,
    required this.parcelLength,
    required this.parcelWidth,
    required this.hasElectricity,
    required this.hasWater,
    required this.hasGreyWaterDisposal,
    required this.isShaded,
    required this.pricePerParcel,
    required this.pricePerAdult,
    required this.pricePerChild,
    this.additionalNotes,
  });

  Parcel copyWith({
    int? parcelNumber,
    int? maxPeople,
    String? description,
    double? parcelLength,
    double? parcelWidth,
    bool? hasElectricity,
    bool? hasWater,
    bool? hasGreyWaterDisposal,
    bool? isShaded,
    double? pricePerParcel,
    double? pricePerAdult,
    double? pricePerChild,
    Map<String, dynamic>? additionalNotes,
  }) =>
      Parcel(
        parcelNumber: parcelNumber ?? this.parcelNumber,
        maxPeople: maxPeople ?? this.maxPeople,
        description: description ?? this.description,
        parcelLength: parcelLength ?? this.parcelLength,
        parcelWidth: parcelWidth ?? this.parcelWidth,
        hasElectricity: hasElectricity ?? this.hasElectricity,
        hasWater: hasWater ?? this.hasWater,
        hasGreyWaterDisposal: hasGreyWaterDisposal ?? this.hasGreyWaterDisposal,
        isShaded: isShaded ?? this.isShaded,
        pricePerParcel: pricePerParcel ?? this.pricePerParcel,
        pricePerAdult: pricePerAdult ?? this.pricePerAdult,
        pricePerChild: pricePerChild ?? this.pricePerChild,
        additionalNotes: additionalNotes ?? this.additionalNotes,
      );

  @override
  List<Object?> get props => [
        parcelNumber,
        maxPeople,
        description,
        parcelLength,
        parcelWidth,
        hasElectricity,
        hasWater,
        hasGreyWaterDisposal,
        isShaded,
        pricePerParcel,
        pricePerAdult,
        pricePerChild,
        additionalNotes,
      ];
}
