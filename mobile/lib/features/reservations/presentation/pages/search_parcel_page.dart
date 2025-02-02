import 'dart:developer';

import 'package:campngo/config/constants.dart';
import 'package:campngo/config/routes/app_routes.dart';
import 'package:campngo/features/reservations/domain/entities/get_parcel_list_params.dart';
import 'package:campngo/features/reservations/presentation/widgets/golden_date_range_picker_field.dart';
import 'package:campngo/features/reservations/presentation/widgets/golden_number_picker_field.dart';
import 'package:campngo/features/shared/widgets/app_body.dart';
import 'package:campngo/features/shared/widgets/custom_buttons.dart';
import 'package:campngo/features/shared/widgets/icon_app_bar.dart';
import 'package:campngo/features/shared/widgets/texts/standard_text.dart';
import 'package:campngo/features/shared/widgets/texts/title_text.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchParcelPage extends StatefulWidget {
  final bool authenticated;

  const SearchParcelPage({
    super.key,
    this.authenticated = false,
  });

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
    endDateTime = DateTime.now().add(const Duration(days: 1));
    numberOfAdults = 1;
    numberOfChildren = 0;
  }

  @override
  Widget build(BuildContext context) {
    return AppBody(
      child: Column(
        children: [
          const IconAppBar(),
          TitleText(LocaleKeys.campngo.tr()),
          SizedBox(height: Constants.spaceS),
          StandardText(LocaleKeys.enterRequiredData.tr()),
          SizedBox(height: Constants.spaceL),
          GoldenDateRangePickerField(
            labelText: LocaleKeys.startDate.tr(),
            onChanged: (dateRange) {
              setState(() {
                startDateTime = dateRange?.start ?? DateTime.now();
                endDateTime = dateRange?.end ??
                    DateTime.now().add(
                      const Duration(days: 1),
                    );
              });
            },
          ),
          SizedBox(height: Constants.spaceM),
          GoldenNumberPickerField(
            labelText: LocaleKeys.numberOfAdults.tr(),
            initialValue: 1,
            onChanged: (value) {
              setState(() {
                numberOfAdults = value!;
                log("Number of adults: $numberOfAdults");
              });
            },
          ),
          SizedBox(height: Constants.spaceM),
          GoldenNumberPickerField(
            labelText: LocaleKeys.numberOfChildren.tr(),
            initialValue: 0,
            onChanged: (value) {
              numberOfChildren = value!;
              log("Number of children: $numberOfChildren");
            },
          ),
          SizedBox(height: Constants.spaceM),
          CustomButton(
            text: LocaleKeys.searchParcel.tr(),
            onPressed: () {
              if (numberOfAdults != 0 && startDateTime.isBefore(endDateTime)) {
                final params = GetParcelListParams(
                  startDate: startDateTime,
                  endDate: endDateTime,
                  adults: numberOfAdults,
                  children: numberOfChildren,
                );
                context.push(
                  AppRoutes.parcelList.route,
                  extra: {
                    'params': params,
                    'page': 1,
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
