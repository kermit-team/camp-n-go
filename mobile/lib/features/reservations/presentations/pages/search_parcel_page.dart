import 'dart:developer';

import 'package:campngo/config/constants.dart';
import 'package:campngo/features/reservations/presentations/widgets/golden_date_picker_field.dart';
import 'package:campngo/features/reservations/presentations/widgets/golden_number_picker_field.dart';
import 'package:campngo/features/shared/widgets/app_body.dart';
import 'package:campngo/features/shared/widgets/app_snack_bar.dart';
import 'package:campngo/features/shared/widgets/custom_buttons.dart';
import 'package:campngo/features/shared/widgets/texts/standard_text.dart';
import 'package:campngo/features/shared/widgets/texts/title_text.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:campngo/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchParcelPage extends StatefulWidget {
  const SearchParcelPage({super.key});

  @override
  State<SearchParcelPage> createState() => _SearchParcelPageState();
}

class _SearchParcelPageState extends State<SearchParcelPage> {
  late DateTime startDateTime;
  late DateTime endDateTime;
  late int numberOfAdults;
  late int numberOfChildren;

  @override
  void initState() {
    super.initState();
    startDateTime = DateTime.now();
    endDateTime = DateTime.now();
    numberOfAdults = 0;
    numberOfChildren = 0;
  }

  @override
  Widget build(BuildContext context) {
    return AppBody(
      child: Column(
        children: [
          TitleText(LocaleKeys.selectPlace.tr()),
          //TODO: translate
          const SizedBox(height: Constants.spaceS),
          StandardText(LocaleKeys.enterRequiredData.tr()),
          const SizedBox(height: Constants.spaceL),
          GoldenDatePickerField(
            labelText: LocaleKeys.startDate.tr(),
            onChanged: (value) {
              //TODO: add edited date submit
            },
          ),
          const SizedBox(height: Constants.spaceM),

          GoldenDatePickerField(
            labelText: LocaleKeys.endDate.tr(),
            onChanged: (value) {
              //TODO: add edited date submit
            },
          ),
          const SizedBox(height: Constants.spaceM),

          GoldenNumberPickerField(
            labelText: LocaleKeys.numberOfAdults.tr(),
            initialValue: 0,
            onChanged: (value) {
              setState(() {
                numberOfAdults = value!;
                log("Number of adults: $numberOfAdults");
              });
            },
          ),
          const SizedBox(height: Constants.spaceM),

          GoldenNumberPickerField(
            labelText: LocaleKeys.numberOfChildren.tr(),
            initialValue: 0,
            onChanged: (value) {
              numberOfChildren = value!;
              log("Number of children: $numberOfChildren");
            },
          ),
          const SizedBox(height: Constants.spaceM),

          CustomButton(
            text: LocaleKeys.searchParcel.tr(),
            onPressed: () {
              AppSnackBar.showSnackBar(
                context: context,
                text: "Szukaj parceli",
              );
              serviceLocator<GoRouter>().push("/parcelList");
            },
          ),
        ],
      ),
    );
  }
}
