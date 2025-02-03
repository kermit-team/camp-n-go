import 'dart:developer';

import 'package:campngo/config/constants.dart';
import 'package:campngo/core/resources/submission_status.dart';
import 'package:campngo/core/validation/validations.dart';
import 'package:campngo/features/contact_form/cubit/contact_form_cubit.dart';
import 'package:campngo/features/contact_form/widgets/contact_form_text_field.dart';
import 'package:campngo/features/shared/widgets/app_body.dart';
import 'package:campngo/features/shared/widgets/app_snack_bar.dart';
import 'package:campngo/features/shared/widgets/custom_buttons.dart';
import 'package:campngo/features/shared/widgets/golden_text_field.dart';
import 'package:campngo/features/shared/widgets/icon_app_bar.dart';
import 'package:campngo/features/shared/widgets/texts/standard_text.dart';
import 'package:campngo/features/shared/widgets/texts/title_text.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:campngo/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ContactFormPage extends StatefulWidget {
  final bool authenticated;

  const ContactFormPage({
    super.key,
    this.authenticated = false,
  });

  @override
  State<ContactFormPage> createState() => _ContactFormPageState();
}

class _ContactFormPageState extends State<ContactFormPage> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController emailController;
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    emailController = TextEditingController();
    textController = TextEditingController();
    _getEmail();
  }

  Future<void> _getEmail() async {
    if (widget.authenticated) {
      final savedEmail = await serviceLocator<FlutterSecureStorage>().read(
        key: 'email',
      );
      setState(() {
        emailController.text = savedEmail ?? '';
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBody(
      child: Column(
        children: [
          const IconAppBar(),
          TitleText(LocaleKeys.contact.tr()),
          SizedBox(height: Constants.spaceS),
          StandardText(LocaleKeys.sendMessageToUs.tr()),
          SizedBox(height: Constants.spaceL),
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GoldenTextField(
                  controller: emailController,
                  enabled: !widget.authenticated,
                  hintText: LocaleKeys.email.tr(),
                  validations: const [
                    RequiredValidation(),
                    EmailValidation(),
                  ],
                ),
                SizedBox(height: Constants.spaceM),
                ContactFormTextField(
                  controller: textController,
                  hintText: LocaleKeys.content.tr(),
                  validations: const [RequiredValidation()],
                ),
                SizedBox(height: Constants.spaceM),
                BlocConsumer<ContactFormCubit, ContactFormState>(
                  listener: (context, state) {
                    switch (state.sendStatus) {
                      case SubmissionStatus.initial:
                      case SubmissionStatus.loading:
                        break;
                      case SubmissionStatus.success:
                        emailController.text = '';
                        textController.text = '';
                        AppSnackBar.showSnackBar(
                            context: context, text: LocaleKeys.emailSent.tr());

                      case SubmissionStatus.failure:
                        AppSnackBar.showErrorSnackBar(
                            context: context,
                            text: LocaleKeys.sendingEmailError.tr());
                    }
                  },
                  builder: (context, state) {
                    if (state.sendStatus != SubmissionStatus.loading) {
                      return CustomButton(
                        text: LocaleKeys.send.tr(),
                        onPressed: () {
                          if (_formKey.currentState?.validate() == true) {
                            log(_formKey.currentState!.validate().toString());
                            context.read<ContactFormCubit>().sendContactEmail(
                                email: emailController.text.trim(),
                                content: textController.text.trim());
                          }
                        },
                        isLoading: state.sendStatus == SubmissionStatus.loading,
                      );
                    } else {
                      return CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
