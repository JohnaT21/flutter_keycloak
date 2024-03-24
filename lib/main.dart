import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keycloakdemo/data/Repository/store_repository.dart';
import 'package:keycloakdemo/data/service/store_service.dart';
import 'package:keycloakdemo/pages/Dashboard.dart';
import 'package:keycloakdemo/pages/login_screen.dart';
import 'package:keycloakdemo/util/constant.dart';
import 'package:keycloakdemo/util/routing.dart';

import 'ServiceLocator.dart';
import 'data/bloc/store_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      BlocProvider(
        create: (context) => sl<StoreBloc>(),
        child: MaterialApp(
          onGenerateRoute: AppRoute.onGenerateRoute,
          // theme: ThemeData(primaryColor: C),
          initialRoute: LoginScreen.LoginScreenPageRouting,
          navigatorKey: AppConstant.navigatorKey,
          debugShowCheckedModeBanner: false,
        ),
      );
  }
}