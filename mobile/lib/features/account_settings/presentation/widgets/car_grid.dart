import 'package:campngo/config/constants.dart';
import 'package:campngo/features/account_settings/domain/entities/car.dart';
import 'package:campngo/features/account_settings/presentation/cubit/account_settings_cubit.dart';
import 'package:campngo/features/shared/widgets/app_snack_bar.dart';
import 'package:campngo/features/shared/widgets/custom_buttons.dart';
import 'package:campngo/features/shared/widgets/standard_text.dart';
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
        switch (state.carListStatus) {
          case CarListStatus.failure:
            AppSnackBar.showSnackBar(
              context: context,
              text: state.exception!.toString(),
            );
            return const SizedBox();

          case CarListStatus.unknown:
            return const Text("Brak samochodów");

          case CarListStatus.loading:
            return CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onSurface,
            );

          case CarListStatus.success:
            final carList = state.carList!;
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

          default:
            AppSnackBar.showSnackBar(
              context: context,
              text: "Something went wrong",
            );
            return const CircularProgressIndicator(
              color: Colors.red,
            );
        }
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
