// available_parcels_response_dto.dart

import 'package:campngo/features/reservations/data/models/parcel_dto.dart';
import 'package:campngo/features/reservations/data/models/parcel_list_item_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'available_parcels_response_dto.g.dart';

@JsonSerializable()
class AvailableParcelsResponseDto {
  @JsonKey(name: 'count')
  final int totalItems;
  @JsonKey(name: 'links')
  final LinksDto links;
  @JsonKey(name: 'page')
  final int currentPage;
  @JsonKey(name: 'results')
  final List<ParcelListItemDto> parcels;

  AvailableParcelsResponseDto({
    required this.totalItems,
    required this.links,
    required this.currentPage,
    required this.parcels,
  });

  factory AvailableParcelsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AvailableParcelsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AvailableParcelsResponseDtoToJson(this);
}

@JsonSerializable()
class LinksDto {
  final String? next;
  final String? previous;

  LinksDto({
    this.next,
    this.previous,
  });

  factory LinksDto.fromJson(Map<String, dynamic> json) =>
      _$LinksDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LinksDtoToJson(this);
}
