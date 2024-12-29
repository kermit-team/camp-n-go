import 'package:campngo/features/reservations/data/models/parcel_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'available_parcels_response_dto.g.dart';

@JsonSerializable()
class AvailableParcelsResponseDto {
  final List<ParcelDto> parcels;
  @JsonKey(name: 'current_page')
  final int currentPage;
  @JsonKey(name: 'items_per_page')
  final int itemsPerPage;
  @JsonKey(name: 'total_items')
  final int totalItems;

  AvailableParcelsResponseDto({
    required this.parcels,
    required this.currentPage,
    required this.itemsPerPage,
    required this.totalItems,
  });

  factory AvailableParcelsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AvailableParcelsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AvailableParcelsResponseDtoToJson(this);
}
