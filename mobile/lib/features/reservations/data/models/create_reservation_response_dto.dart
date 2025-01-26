import 'package:json_annotation/json_annotation.dart';

part 'create_reservation_response_dto.g.dart';

@JsonSerializable()
class CreateReservationResponseDto {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'date_from')
  final String startDate;
  @JsonKey(name: 'date_to')
  final String endDate;
  @JsonKey(name: 'number_of_adults')
  final int numberOfAdults;
  @JsonKey(name: 'number_of_children')
  final int numberOfChildren;
  @JsonKey(name: 'car')
  final int carId;
  @JsonKey(name: 'camping_plot')
  final int parcelId;
  @JsonKey(name: 'comments')
  final String? comments;
  @JsonKey(name: 'checkout_url')
  final String stripeUrl;

  CreateReservationResponseDto({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.numberOfAdults,
    required this.numberOfChildren,
    required this.carId,
    required this.parcelId,
    this.comments,
    required this.stripeUrl,
  });

  factory CreateReservationResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CreateReservationResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateReservationResponseDtoToJson(this);
}
