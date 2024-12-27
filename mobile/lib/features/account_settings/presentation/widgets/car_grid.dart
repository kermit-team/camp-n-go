import 'package:campngo/config/constants.dart';
import 'package:campngo/features/account_settings/domain/entities/car.dart';
import 'package:campngo/features/account_settings/presentation/cubit/account_settings_cubit.dart';
import 'package:campngo/features/shared/widgets/custom_buttons.dart';
import 'package:campngo/features/shared/widgets/texts/standard_text.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarGridWidget extends StatelessWidget {
  final void Function(Car) onActionIconPressed;
  final void Function() onAddButtonPressed;

  const CarGridWidget({
    super.key,
    required this.onActionIconPressed,
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
                const Text("Brak samochodów"),
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
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two tiles per row
                  childAspectRatio: 1.5, // Square tiles
                  crossAxisSpacing: Constants.spaceS,
                  mainAxisSpacing: Constants.spaceS,
                ),
                itemCount: carList.length,
                itemBuilder: (context, index) {
                  final car = carList[index];
                  return CarTileItem(
                    car: car,
                    onActionIconPressed: onActionIconPressed,
                  );
                },
              ),
              const SizedBox(height: Constants.spaceS),
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

class CarTileItem extends StatelessWidget {
  final Car car;
  final void Function(Car) onActionIconPressed;

  const CarTileItem({
    super.key,
    required this.car,
    required this.onActionIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      elevation: 0,
      shape: Border.fromBorderSide(
        BorderSide(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      child: InkWell(
        onTap: () {},
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_car,
              color: Theme.of(context).colorScheme.onSurface,
              size: Constants.spaceL,
            ),
            const SizedBox(height: Constants.spaceS),
            StandardText(
              car.registrationPlate,
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}
