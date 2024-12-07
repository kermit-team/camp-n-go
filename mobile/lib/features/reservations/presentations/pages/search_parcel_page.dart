import 'dart:developer';

import 'package:campngo/config/constants.dart';
import 'package:campngo/features/shared/widgets/app_body.dart';
import 'package:campngo/features/shared/widgets/golden_date_picker_field.dart';
import 'package:campngo/features/shared/widgets/golden_number_picker_field.dart';
import 'package:campngo/features/shared/widgets/standard_text.dart';
import 'package:campngo/features/shared/widgets/title_text.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SearchParcelPage extends StatefulWidget {
  const SearchParcelPage({super.key});

  @override
  State<SearchParcelPage> createState() => _SearchParcelPageState();
}

class _SearchParcelPageState extends State<SearchParcelPage> {
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
              log("value on search page: $value");
            },
          ),
          const SizedBox(height: Constants.spaceM),
          GoldenNumberPickerField(
            labelText: LocaleKeys.numberOfChildren.tr(),
            initialValue: 0,
            onChanged: (value) {
              log("value on search page: $value");
            },
          ),
        ],
      ),
    );
  }
}
