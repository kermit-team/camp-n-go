import 'package:campngo/features/account_settings/domain/entities/car_entity.dart';
import 'package:campngo/features/account_settings/presentation/cubit/account_settings_cubit.dart';
import 'package:campngo/features/account_settings/presentation/cubit/account_settings_state.dart';
import 'package:campngo/features/shared/widgets/app_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarListWidget extends StatelessWidget {
  final void Function(CarEntity) onActionIconPressed;

  const CarListWidget({
    super.key,
    required this.onActionIconPressed,
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
            return ListView.builder(
              itemCount: carList.length,
              itemBuilder: (context, index) {
                final car = carList[index];
                return CarListItem(
                  car: car,
                  onActionIconPressed: onActionIconPressed,
                );
              },
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
  final CarEntity car;
  final void Function(CarEntity) onActionIconPressed;

  const CarListItem({
    super.key,
    required this.car,
    required this.onActionIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.directions_car),
          const SizedBox(width: 16),
          Expanded(
            child: Text(car.registrationPlate),
          ),
          IconButton(
            onPressed: () {
              onActionIconPressed(car);
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
    );
  }
}
