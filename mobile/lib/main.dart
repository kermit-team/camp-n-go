import 'package:campngo/config/constants.dart';
import 'package:campngo/config/routes/app_router.dart';
import 'package:campngo/config/theme/app_theme.dart';
import 'package:campngo/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:campngo/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

//generate translations command:
//flutter pub run easy_localization:generate -S "assets/translations" -O "lib/generated" -f keys -o locale_keys.g.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initializeDependencies();
  runApp(EasyLocalization(
    supportedLocales: const [
      Locale('pl'),
      Locale('en'),
    ],
    path: "assets/translations",
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (p0, p1, p2) {
        return const MaterialApp(
          title: 'Flutter Demo',
          home: MyHomePage(title: 'Flutter Demo Home Page'),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (BuildContext context) =>
          serviceLocator<AuthCubit>()..appStarted(),
      child: Builder(
        builder: (context) => MaterialApp.router(
          title: Constants.appName,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: theme(),
          // routerConfig: context,
          routerConfig: AppRouter().router,
        ),
      ),
    );
  }
}
