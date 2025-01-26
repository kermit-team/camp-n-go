import 'package:json_annotation/json_annotation.dart';

part 'create_reservation_request_dto.g.dart';

@JsonSerializable()
class CreateReservationRequestDto {
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

  CreateReservationRequestDto({
    required this.startDate,
    required this.endDate,
    required this.numberOfAdults,
    required this.numberOfChildren,
    required this.carId,
    required this.parcelId,
    this.comments,
  });

  Map<String, dynamic> toJson() => _$CreateReservationRequestDtoToJson(this);

  factory CreateReservationRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreateReservationRequestDtoFromJson(json);
}
