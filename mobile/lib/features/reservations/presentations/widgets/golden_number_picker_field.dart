import 'package:campngo/config/constants.dart';
import 'package:campngo/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

class GoldenNumberPickerField extends StatefulWidget {
  final String labelText;
  final int initialValue;
  final ValueChanged<int?> onChanged;

  const GoldenNumberPickerField({
    super.key,
    required this.labelText,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<GoldenNumberPickerField> createState() =>
      _GoldenNumberPickerFieldState();
}

class _GoldenNumberPickerFieldState extends State<GoldenNumberPickerField> {
  late int _selectedNumber;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    _selectedNumber = widget.initialValue;
    controller = TextEditingController(
      text: "$_selectedNumber",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
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
              width: double.maxFinite,
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
                child: Text(
                  _selectedNumber.toString(),
                  textAlign: TextAlign.left,
                  style: AppTextStyles.mainTextStyle(),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: Constants.spaceS),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                color: Theme.of(context).colorScheme.onSurface,
                onPressed: () {
                  if (_selectedNumber > 0) {
                    setState(() {
                      _selectedNumber--;
                      widget.onChanged(_selectedNumber);
                    });
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.add),
                color: Theme.of(context).colorScheme.onSurface,
                onPressed: () {
                  if (_selectedNumber < 99) {
                    setState(() {
                      _selectedNumber++;
                      widget.onChanged(_selectedNumber);
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
