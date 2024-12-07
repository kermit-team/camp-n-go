import 'dart:developer';

import 'package:campngo/config/constants.dart';
import 'package:campngo/core/validation/validations.dart';
import 'package:campngo/features/account_settings/domain/entities/account_entity.dart';
import 'package:campngo/features/account_settings/domain/entities/car_entity.dart';
import 'package:campngo/features/account_settings/presentation/cubit/account_settings_cubit.dart';
import 'package:campngo/features/account_settings/presentation/cubit/account_settings_state.dart';
import 'package:campngo/features/account_settings/presentation/widgets/car_list.dart';
import 'package:campngo/features/account_settings/presentation/widgets/display_text_field.dart';
import 'package:campngo/features/account_settings/presentation/widgets/show_car_details_dialog.dart';
import 'package:campngo/features/shared/widgets/app_body.dart';
import 'package:campngo/features/shared/widgets/app_snack_bar.dart';
import 'package:campngo/features/shared/widgets/standard_text.dart';
import 'package:campngo/features/shared/widgets/title_text.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountSettingsCubit, AccountSettingsState>(
      listener: (context, state) {
        switch (state.editPropertyStatus) {
          case EditPropertyStatus.unknown:
          case EditPropertyStatus.loading:
            break;
          case EditPropertyStatus.failure:
            AppSnackBar.showErrorSnackBar(
              context: context,
              text: state.exception.toString(),
            );
          case EditPropertyStatus.success:
            {
              AppSnackBar.showSnackBar(
                context: context,
                text: "Nowa wartość pola została ustawiona",
              );
              context.read<AccountSettingsCubit>().getAccountData();
            }
        }
      },
      builder: (context, state) {
        switch (state.status) {
          case LoadAccountSettingsStatus.loading:
          case LoadAccountSettingsStatus.initial:
            {
              return AppBody(
                child: Column(
                  children: [
                    TitleText(LocaleKeys.accountSettings.tr()),
                    const SizedBox(height: Constants.spaceS),
                    StandardText(LocaleKeys.updateUserData.tr()),
                    const SizedBox(height: Constants.spaceL),
                    const CircularProgressIndicator()
                  ],
                ),
              );
            }
          case LoadAccountSettingsStatus.failure:
            {
              return AppBody(
                child: Column(
                  children: [
                    TitleText(LocaleKeys.accountSettings.tr()),
                    const SizedBox(height: Constants.spaceS),
                    StandardText(LocaleKeys.updateUserData.tr()),
                    const SizedBox(height: Constants.spaceL),
                    const StandardText(
                        "Dane nie zostały załadowane prawidłowo"),
                  ],
                ),
              );
            }
          case LoadAccountSettingsStatus.success:
            {
              return AppBody(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TitleText(LocaleKeys.accountSettings.tr()),
                      const SizedBox(height: Constants.spaceS),
                      StandardText(LocaleKeys.updateUserData.tr()),
                      const SizedBox(height: Constants.spaceL),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            DisplayTextField(
                              label: LocaleKeys.firstName.tr(),
                              text: state.accountEntity?.firstName ?? '',
                              validations: const [RequiredValidation()],
                              onHyperlinkPressed: (String newValue) {
                                context
                                    .read<AccountSettingsCubit>()
                                    .editProperty(
                                      property: AccountProperty.firstName,
                                      newValue: newValue,
                                    );
                                log("New value for firstName: $newValue");
                              },
                            ),
                            DisplayTextField(
                              label: LocaleKeys.lastName.tr(),
                              text: state.accountEntity?.lastName ?? '',
                              validations: const [RequiredValidation()],
                              onHyperlinkPressed: (String newValue) {
                                context
                                    .read<AccountSettingsCubit>()
                                    .editProperty(
                                      property: AccountProperty.lastName,
                                      newValue: newValue,
                                    );
                                log("New value for firstName: $newValue");
                              },
                            ),
                            DisplayTextField(
                              label: LocaleKeys.email.tr(),
                              text: state.accountEntity?.email ?? '',
                              validations: const [
                                RequiredValidation(),
                                EmailValidation()
                              ],
                              onHyperlinkPressed: (String newValue) {
                                context
                                    .read<AccountSettingsCubit>()
                                    .editProperty(
                                      property: AccountProperty.email,
                                      newValue: newValue,
                                    );
                                log("New value for firstName: $newValue");
                              },
                            ),
                            DisplayTextField(
                              label: LocaleKeys.phoneNumber.tr(),
                              text: state.accountEntity?.phoneNumber ?? '',
                              validations: const [RequiredValidation()],
                              onHyperlinkPressed: (String newValue) {
                                context
                                    .read<AccountSettingsCubit>()
                                    .editProperty(
                                      property: AccountProperty.phoneNumber,
                                      newValue: newValue,
                                    );
                                log("New value for firstName: $newValue");
                              },
                            ),
                            DisplayTextField(
                              label: LocaleKeys.idNumber.tr(),
                              text: state.accountEntity?.idNumber ?? '',
                              validations: const [RequiredValidation()],
                              onHyperlinkPressed: (String newValue) {
                                context
                                    .read<AccountSettingsCubit>()
                                    .editProperty(
                                      property: AccountProperty.idNumber,
                                      newValue: newValue,
                                    );
                                log("New value for firstName: $newValue");
                              },
                            ),
                            DisplayTextField(
                              label: LocaleKeys.password.tr(),
                              text: state.accountEntity?.password ?? '',
                              isPassword: true,
                              validations: const [RequiredValidation()],
                              onHyperlinkPressed: (String newValue) {
                                context
                                    .read<AccountSettingsCubit>()
                                    .editProperty(
                                      property: AccountProperty.password,
                                      newValue: newValue,
                                    );
                                log("New value for firstName: $newValue");
                              },
                            ),
                            const SizedBox(height: Constants.spaceS),
                            TextButton(
                              onPressed: context
                                  .read<AccountSettingsCubit>()
                                  .getCarList,
                              child: const StandardText("Your cars"),
                            ),
                            const SizedBox(height: Constants.spaceM),
                            CarListWidget(
                              onListTilePressed: (CarEntity car) {
                                showCarDetailsDialog(
                                    context: context,
                                    registrationPlate: car.registrationPlate,
                                    onDelete: () {
                                      context
                                          .read<AccountSettingsCubit>()
                                          .deleteCar(car: car);
                                    });
                              },
                              onAddButtonPressed: () {
                                AppSnackBar.showSnackBar(
                                  context: context,
                                  text: "Dodawanie nowego samochodu",
                                );
                              },
                            ),
                            const SizedBox(height: Constants.spaceL),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
        }
      },
    );
  }
}
