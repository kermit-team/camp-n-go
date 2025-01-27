import 'dart:developer';

import 'package:campngo/config/constants.dart';
import 'package:campngo/core/resources/submission_status.dart';
import 'package:campngo/core/validation/validations.dart';
import 'package:campngo/features/account_settings/domain/entities/account.dart';
import 'package:campngo/features/account_settings/domain/entities/car.dart';
import 'package:campngo/features/account_settings/presentation/cubit/account_settings_cubit.dart';
import 'package:campngo/features/account_settings/presentation/widgets/car_list.dart';
import 'package:campngo/features/account_settings/presentation/widgets/show_add_car_dialog.dart';
import 'package:campngo/features/account_settings/presentation/widgets/show_car_details_dialog.dart';
import 'package:campngo/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:campngo/features/shared/widgets/app_body.dart';
import 'package:campngo/features/shared/widgets/app_snack_bar.dart';
import 'package:campngo/features/shared/widgets/custom_buttons.dart';
import 'package:campngo/features/shared/widgets/display_text_field.dart';
import 'package:campngo/features/shared/widgets/texts/standard_text.dart';
import 'package:campngo/features/shared/widgets/texts/title_text.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:campngo/injection_container.dart';
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
        switch (state.carOperationStatus) {
          case CarOperationStatus.unknown:
          case CarOperationStatus.loading:
            break;
          case CarOperationStatus.notDeleted:
            AppSnackBar.showErrorSnackBar(
              context: context,
              text: "${LocaleKeys.carNotDeleted.tr()}: ${state.exception}",
            );
          case CarOperationStatus.deleted:
            AppSnackBar.showSnackBar(
              context: context,
              text: LocaleKeys.carDeletedSuccessfully.tr(),
            );
          case CarOperationStatus.notAdded:
            AppSnackBar.showErrorSnackBar(
              context: context,
              text: "${LocaleKeys.carNotAdded.tr()}: ${state.exception}",
            );
          case CarOperationStatus.added:
            AppSnackBar.showSnackBar(
              context: context,
              text: LocaleKeys.carAddedSuccessfully.tr(),
            );
          case CarOperationStatus.alreadyExists:
            AppSnackBar.showErrorSnackBar(
              context: context,
              text: LocaleKeys.carAlreadyExists.tr(),
            );
        }
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
                text: LocaleKeys.propertyChanged.tr(),
              );
            }
        }
        switch (state.editPasswordStatus) {
          case EditPasswordStatus.unknown:
          case EditPasswordStatus.loading:
            break;
          case EditPasswordStatus.failure:
            AppSnackBar.showErrorSnackBar(
              context: context,
              text: state.exception.toString(),
            );
          case EditPasswordStatus.success:
            AppSnackBar.showSnackBar(
              context: context,
              text: LocaleKeys.passwordChanged.tr(),
            );
        }

        switch (state.deleteAccountStatus) {
          case SubmissionStatus.initial:
          case SubmissionStatus.loading:
            break;
          case SubmissionStatus.success:
            if (context.mounted) {
              AppSnackBar.showSnackBar(
                context: context,
                text: LocaleKeys.accountDeleted.tr(),
              );
            }
            serviceLocator<AuthCubit>().logout();
          case SubmissionStatus.failure:
            AppSnackBar.showSnackBar(
              context: context,
              text: LocaleKeys.accountNotDeleted.tr(),
            );
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
                    SizedBox(height: Constants.spaceS),
                    StandardText(LocaleKeys.updateUserData.tr()),
                    SizedBox(height: Constants.spaceL),
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
                    SizedBox(height: Constants.spaceS),
                    StandardText(LocaleKeys.updateUserData.tr()),
                    SizedBox(height: Constants.spaceL),
                    StandardText(
                      LocaleKeys.dataNotLoaded.tr(),
                    ),
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
                      SizedBox(height: Constants.spaceS),
                      StandardText(LocaleKeys.updateUserData.tr()),
                      SizedBox(height: Constants.spaceL),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            DisplayTextField(
                              label: LocaleKeys.firstName.tr(),
                              text:
                                  state.accountEntity?.profile.firstName ?? '',
                              validations: const [
                                RequiredValidation(),
                                NameValidation(),
                              ],
                              onDialogSavePressed: (String newValue) {
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
                              text: state.accountEntity?.profile.lastName ?? '',
                              validations: const [
                                RequiredValidation(),
                                NameValidation(),
                              ],
                              onDialogSavePressed: (String newValue) {
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
                              canBeModified: false,
                              text: state.accountEntity?.email ?? '',
                              validations: const [
                                RequiredValidation(),
                                EmailValidation()
                              ],
                              onDialogSavePressed: (String newValue) {
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
                              text: state.accountEntity?.profile.phoneNumber ??
                                  '',
                              onPhoneNumberSavePressed: (String phoneNumber) {
                                context
                                    .read<AccountSettingsCubit>()
                                    .editProperty(
                                      property: AccountProperty.phoneNumber,
                                      newValue: phoneNumber,
                                    );
                                log("New value for phoneNumber: $phoneNumber");
                              },
                            ),
                            DisplayTextField(
                              label: LocaleKeys.idNumber.tr(),
                              text: state.accountEntity?.profile.idCard ?? '',
                              validations: const [IdCardValidation()],
                              asterixString: true,
                              onDialogSavePressed: (String newValue) {
                                context
                                    .read<AccountSettingsCubit>()
                                    .editProperty(
                                      property: AccountProperty.idCard,
                                      newValue: newValue,
                                    );
                                log("New value for firstName: $newValue");
                              },
                            ),
                            DisplayTextField(
                              label: LocaleKeys.password.tr(),
                              text: "·············",
                              isPassword: true,
                              validations: const [RequiredValidation()],
                              onPasswordDialogSavePressed: (
                                String oldPassword,
                                String newPassword,
                              ) {
                                context
                                    .read<AccountSettingsCubit>()
                                    .editPassword(
                                      oldPassword: oldPassword,
                                      newPassword: newPassword,
                                    );
                              },
                            ),
                            SizedBox(height: Constants.spaceS),
                            const StandardText("Your cars"),
                            SizedBox(height: Constants.spaceM),
                            CarListWidget(
                              onListTilePressed: (Car car) {
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
                                showAddCarDialog(
                                  context: context,
                                  validations: [
                                    const RequiredValidation(),
                                  ],
                                  onSubmit: (registrationPlate) {
                                    context.read<AccountSettingsCubit>().addCar(
                                          registrationPlate: registrationPlate,
                                        );
                                  },
                                );
                              },
                            ),
                            SizedBox(height: Constants.spaceXL),
                            CustomButton(
                              text: LocaleKeys.deleteAccount.tr(),
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onError,
                              prefixIcon: Icons.highlight_remove,
                              onPressed: () {
                                _showDeleteAccountConfirmationDialog(
                                  context: context,
                                  onDelete: context
                                      .read<AccountSettingsCubit>()
                                      .deleteAccount,
                                );
                              },
                            ),
                            SizedBox(height: Constants.spaceL),
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

  void _showDeleteAccountConfirmationDialog({
    required BuildContext context,
    required Function() onDelete,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(LocaleKeys.deleteAccount.tr()),
        content: Text(
          LocaleKeys.anonymizeAccountConfirmation.tr(),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(LocaleKeys.cancel.tr()),
          ),
          TextButton(
            onPressed: () {
              onDelete();
              Navigator.of(context).pop();
            },
            child: Text(
              LocaleKeys.delete.tr(),
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
