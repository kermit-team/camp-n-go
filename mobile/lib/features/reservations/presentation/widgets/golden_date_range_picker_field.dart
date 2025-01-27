import 'dart:io';

import 'package:campngo/config/constants.dart';
import 'package:campngo/config/theme/app_theme.dart';
import 'package:campngo/features/shared/widgets/texts/standard_text.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GoldenDateRangePickerField extends StatefulWidget {
  final String labelText;
  final DateTime? initialEndDateTime;
  final DateTime? initialStartDateTime;
  final ValueChanged<DateTimeRange?> onChanged;

  const GoldenDateRangePickerField({
    super.key,
    required this.labelText,
    this.initialStartDateTime,
    this.initialEndDateTime,
    required this.onChanged,
  });

  @override
  State<GoldenDateRangePickerField> createState() =>
      _GoldenDateRangePickerFieldState();
}

class _GoldenDateRangePickerFieldState
    extends State<GoldenDateRangePickerField> {
  late DateTimeRange _dateRange;

  @override
  void initState() {
    super.initState();
    _dateRange = DateTimeRange(
      start: widget.initialStartDateTime ??
          DateTime.now(),
      end: widget.initialEndDateTime ??
          DateTime.now().add(const Duration(days: 1)),
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    if (Platform.isAndroid) {
      final DateTimeRange? pickedDateRange = await showDateRangePicker(
        context: context,
        initialDateRange: _dateRange,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
        cancelText: LocaleKeys.cancel.tr(),
        confirmText: LocaleKeys.save.tr(),
      );
      if (pickedDateRange != null) {
        setState(() {
          _dateRange = pickedDateRange;
          widget.onChanged(_dateRange);
        });
      }
    } else if (Platform.isIOS) {
      await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: CupertinoColors.systemBackground.resolveFrom(context),
            child: SafeArea(
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Adjust the Column to take minimum space
                children: [
                  SizedBox(
                    height:
                        200, // Set a fixed height for the date picker if necessary
                    child: CupertinoDatePicker(
                      use24hFormat: true,
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: _dateRange.start,
                      onDateTimeChanged: (DateTime newDateTime) {
                        setState(() {
                          _dateRange = DateTimeRange(
                            start: newDateTime,
                            end: _dateRange.end,
                          );
                          widget.onChanged(_dateRange);
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height:
                        200, // Set a fixed height for the date picker if necessary
                    child: CupertinoDatePicker(
                      use24hFormat: true,
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: _dateRange.start,
                      onDateTimeChanged: (DateTime newDateTime) {
                        setState(() {
                          _dateRange = DateTimeRange(
                            start: _dateRange.start,
                            end: newDateTime,
                          );
                          widget.onChanged(_dateRange);
                        });
                      },
                    ),
                  ),
                  CupertinoButton(
                    child: Text(
                      LocaleKeys.save.tr(),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectDateTime(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Constants.spaceXXS),
          Row(
            children: [
              Text(
                widget.labelText,
                style: AppTextStyles.hintTextStyle().copyWith(
                  fontSize: Constants.spaceMS,
                ),
              ),
              const Spacer(),
            ],
          ),
          SizedBox(height: Constants.spaceXXS),
          Container(
            decoration: BoxDecoration(
              border: BorderDirectional(
                bottom:
                    BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 7,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      DateFormat('yyyy-MM-dd').format(_dateRange.start),
                      textAlign: TextAlign.left,
                      style: AppTextStyles.mainTextStyle(),
                    ),
                  ),
                  Icon(
                    Icons.calendar_month,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: Constants.spaceM + Constants.spaceXXS),
          Row(
            children: [
              Text(
                widget.labelText,
                style: AppTextStyles.hintTextStyle().copyWith(
                  fontSize: Constants.spaceMS,
                ),
              ),
              const Spacer(),
            ],
          ),
          SizedBox(height: Constants.spaceXXS),
          Container(
            decoration: BoxDecoration(
              border: BorderDirectional(
                bottom:
                    BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 7,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      DateFormat('yyyy-MM-dd').format(_dateRange.end),
                      textAlign: TextAlign.left,
                      style: AppTextStyles.mainTextStyle(),
                    ),
                  ),
                  Icon(
                    Icons.calendar_month,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ],
              ),
            ),
          ),
          if (!_dateRange.end.isAfter(_dateRange.start))
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Constants.spaceXXS),
                StandardText(
                  LocaleKeys.invalidDateRange.tr(),
                  style: AppTextStyles.errorTextStyle(
                    fontSize: Constants.textSizeXS,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
