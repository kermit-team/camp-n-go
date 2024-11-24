import 'package:campngo/config/constants.dart';
import 'package:campngo/config/theme/app_theme.dart';
import 'package:campngo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:campngo/features/auth/presentation/bloc/auth_event.dart';
import 'package:campngo/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

//generate translations command:
//flutter pub run easy_localization:generate -S "assets/translations" -O "lib/generated" -f keys -o locale_keys.g.dart

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDependencies();
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
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
    return BlocProvider<AuthBloc>(
      create: (BuildContext context) =>
          serviceLocator<AuthBloc>()..add(InitialLogin()),
      child: Builder(
        builder: (context) => MaterialApp.router(
          title: Constants.appName,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: theme(),
          routerConfig: serviceLocator<GoRouter>(),
        ),
      ),
    );
  }
}
