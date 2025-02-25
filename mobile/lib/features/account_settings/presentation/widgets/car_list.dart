import 'package:campngo/config/constants.dart';
import 'package:campngo/features/account_settings/domain/entities/car.dart';
import 'package:campngo/features/account_settings/presentation/cubit/account_settings_cubit.dart';
import 'package:campngo/features/shared/widgets/custom_buttons.dart';
import 'package:campngo/features/shared/widgets/texts/standard_text.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarListWidget extends StatelessWidget {
  final void Function(Car) onListTilePressed;
  final void Function() onAddButtonPressed;

  const CarListWidget({
    super.key,
    required this.onListTilePressed,
    required this.onAddButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountSettingsCubit, AccountSettingsState>(
      builder: (context, state) {
        if (state.accountEntity != null) {
          if (state.accountEntity!.carList.isEmpty) {
            return Column(
              children: [
                CustomButton(
                  text: LocaleKeys.addCar.tr(),
                  onPressed: onAddButtonPressed,
                  prefixIcon: Icons.add,
                ),
              ],
            );
          }

          final carList = state.accountEntity!.carList;

          return Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(0),
                itemCount: carList.length,
                itemBuilder: (context, index) {
                  final car = carList[index];
                  return CarListItem(
                    car: car,
                    onListTilePressed: onListTilePressed,
                  );
                },
              ),
              CustomButton(
                text: LocaleKeys.addCar.tr(),
                onPressed: onAddButtonPressed,
                prefixIcon: Icons.add,
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class CarListItem extends StatelessWidget {
  final Car car;
  final void Function(Car) onListTilePressed;
  final bool isAssigned;
  final bool showDots;

  const CarListItem({
    super.key,
    required this.car,
    required this.onListTilePressed,
    this.isAssigned = false,
    this.showDots = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Constants.spaceS),
      child: InkWell(
        onTap: () {
          onListTilePressed(car);
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: Constants.spaceMS,
            vertical: Constants.spaceM,
          ),
          decoration: BoxDecoration(
            color: isAssigned ? Theme.of(context).colorScheme.primary : null,
            border: Border.fromBorderSide(
              BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(
                Icons.directions_car,
                color: Theme.of(context).colorScheme.onSurface,
                size: Constants.textSizeM,
              ),
              SizedBox(width: Constants.spaceM),
              StandardText(
                car.registrationPlate,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              showDots
                  ? Icon(
                      Icons.more_horiz,
                      color: Theme.of(context).colorScheme.onSurface,
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
