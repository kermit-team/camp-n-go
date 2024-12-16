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
    return BlocConsumer<AccountSettingsCubit, AccountSettingsState>(
      listener: (context, state) {
        switch (state.carOperationStatus) {
          case CarOperationStatus.unknown:
          case CarOperationStatus.loading:
            break;

          case CarOperationStatus.notDeleted:
          case CarOperationStatus.notAdded:
            AppSnackBar.showErrorSnackBar(
              context: context,
              text: state.exception.toString(),
              //TODO: add error translations
            );

          case CarOperationStatus.deleted:
            AppSnackBar.showSnackBar(
              context: context,
              text: "Car deleted successfully",
            );
            break;
          case CarOperationStatus.added:
            AppSnackBar.showSnackBar(
              context: context,
              text: "Car added successfully",
            );
            break;
        }
      },
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

class CarListItem extends StatelessWidget {
  final Car car;
  final void Function(Car) onListTilePressed;

  const CarListItem({
    super.key,
    required this.car,
    required this.onListTilePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Constants.spaceS),
      child: InkWell(
        onTap: () {
          onListTilePressed(car);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Constants.spaceMS,
            vertical: Constants.spaceM,
          ),
          decoration: BoxDecoration(
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
              const SizedBox(width: Constants.spaceM),
              StandardText(
                car.registrationPlate,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              Icon(
                Icons.more_horiz,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
