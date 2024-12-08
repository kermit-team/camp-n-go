import 'dart:io';

import 'package:campngo/config/constants.dart';
import 'package:campngo/config/theme/app_theme.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GoldenDatePickerField extends StatefulWidget {
  final String labelText;
  final DateTime? initialValue;
  final ValueChanged<DateTime?> onChanged;

  const GoldenDatePickerField({
    super.key,
    required this.labelText,
    this.initialValue,
    required this.onChanged,
  });

  @override
  State<GoldenDatePickerField> createState() => _GoldenDatePickerFieldState();
}

class _GoldenDatePickerFieldState extends State<GoldenDatePickerField> {
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.initialValue ?? DateTime.now();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    if (Platform.isAndroid) {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDateTime ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
        cancelText: LocaleKeys.cancel.tr(),
        confirmText: LocaleKeys.save.tr(),
      );
      if (pickedDate != null && pickedDate != _selectedDateTime) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
          );
          widget.onChanged(_selectedDateTime);
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
                      initialDateTime: _selectedDateTime ?? DateTime.now(),
                      onDateTimeChanged: (DateTime newDateTime) {
                        setState(() {
                          _selectedDateTime = newDateTime;
                          widget.onChanged(_selectedDateTime);
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
        children: [
          const SizedBox(height: Constants.spaceXXS),
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
          const SizedBox(height: Constants.spaceXXS),
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
                      _selectedDateTime != null
                          ? DateFormat('yyyy-MM-dd').format(_selectedDateTime!)
                          : widget.labelText,
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
        ],
      ),
    );
  }
}
