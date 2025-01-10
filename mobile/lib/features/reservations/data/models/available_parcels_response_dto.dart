import 'package:campngo/features/reservations/data/models/parcel_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'available_parcels_response_dto.g.dart';

@JsonSerializable()
class AvailableParcelsResponseDto {
  @JsonKey(name: 'results')
  final List<ParcelDto> parcels;
  @JsonKey(name: 'page')
  final int currentPage;
  @JsonKey(name: 'count')
  final int totalItems;

  AvailableParcelsResponseDto({
    required this.parcels,
    required this.currentPage,
    required this.totalItems,
  });

  factory AvailableParcelsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AvailableParcelsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AvailableParcelsResponseDtoToJson(this);
}
