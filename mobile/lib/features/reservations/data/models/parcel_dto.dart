import 'package:campngo/features/reservations/domain/entities/parcel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'parcel_dto.g.dart';

@JsonSerializable()
class ParcelDto {
  final int parcelNumber;
  final int maxPeople;
  final String description;
  final double parcelLength;
  final double parcelWidth;
  final bool hasElectricity;
  final bool hasWater;
  final bool hasGreyWaterDisposal;
  final bool isShaded;
  final double pricePerParcel;
  final double pricePerAdult;
  final double pricePerChild;
  final Map<String, dynamic>? additionalNotes;

  ParcelDto({
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

  factory ParcelDto.fromJson(Map<String, dynamic> json) =>
      _$ParcelDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ParcelDtoToJson(this);

  factory ParcelDto.fromEntity(Parcel parcel) => ParcelDto(
        parcelNumber: parcel.parcelNumber,
        maxPeople: parcel.maxPeople,
        description: parcel.description,
        parcelLength: parcel.parcelLength,
        parcelWidth: parcel.parcelWidth,
        hasElectricity: parcel.hasElectricity,
        hasWater: parcel.hasWater,
        hasGreyWaterDisposal: parcel.hasGreyWaterDisposal,
        isShaded: parcel.isShaded,
        pricePerParcel: parcel.pricePerParcel,
        pricePerAdult: parcel.pricePerAdult,
        pricePerChild: parcel.pricePerChild,
        additionalNotes: parcel.additionalNotes,
      );

  Parcel toEntity() => Parcel(
        parcelNumber: parcelNumber,
        maxPeople: maxPeople,
        description: description,
        parcelLength: parcelLength,
        parcelWidth: parcelWidth,
        hasElectricity: hasElectricity,
        hasWater: hasWater,
        hasGreyWaterDisposal: hasGreyWaterDisposal,
        isShaded: isShaded,
        pricePerParcel: pricePerParcel,
        pricePerAdult: pricePerAdult,
        pricePerChild: pricePerChild,
        additionalNotes: additionalNotes,
      );
}
