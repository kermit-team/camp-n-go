import 'dart:developer';

import 'package:campngo/config/constants.dart';
import 'package:campngo/config/theme/app_theme.dart';
import 'package:campngo/core/validation/validations.dart';
import 'package:campngo/core/validation/validator.dart';
import 'package:campngo/features/account_settings/domain/entities/car.dart';
import 'package:campngo/features/reservations/presentation/cubit/reservation_summary_cubit.dart';
import 'package:campngo/features/shared/widgets/texts/standard_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoldenCarDropdown extends StatefulWidget {
  final String? label;
  final String? hintText;
  final List<Car> cars;
  final Car? selectedCar;
  final ValueChanged<Car?>? onChanged;
  final List<Validation<Car>>? validations;
  final bool enabled;

  const GoldenCarDropdown({
    super.key,
    this.label,
    this.hintText,
    required this.cars,
    this.selectedCar,
    this.onChanged,
    this.validations,
    this.enabled = true,
  });

  @override
  State<GoldenCarDropdown> createState() => _GoldenCarDropdownState();
}

class _GoldenCarDropdownState extends State<GoldenCarDropdown> {
  late Car? _selectedCar;
  late List<Car> _cars;

  @override
  void initState() {
    super.initState();
    _selectedCar = widget.selectedCar;
    _cars = widget.cars;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationSummaryCubit, ReservationSummaryState>(
        builder: (context, state) {
      return DropdownButtonFormField<Car>(
        value: _selectedCar,
        onChanged: (value) {
          log(value.toString());
          _selectedCar = value;
        },
        hint: StandardText(widget.hintText ?? ''),
        validator: Validator.apply(
          context: context,
          validations: widget.validations ?? [],
        ),
        items: _cars.map<DropdownMenuItem<Car>>((Car value) {
          return DropdownMenuItem<Car>(
            value: value,
            child: Text(value.registrationPlate),
          );
        }).toList(),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: AppTextStyles.hintTextStyle().copyWith(),
          label: widget.label != null
              ? Text(
                  widget.label!,
                )
              : null,
          labelStyle: AppTextStyles.hintTextStyle()
              .copyWith(fontSize: Constants.textSizeMS),
          disabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          errorMaxLines: 2,
          prefixIcon: Padding(
            padding: EdgeInsets.only(right: Constants.spaceXS),
            child: Icon(
              Icons.directions_car,
              size: Constants.textSizeMS,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(),
        ),
        alignment: Alignment.centerLeft,
      );
    });
  }
}
