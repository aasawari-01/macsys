import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:macsys/component/home/home_view.dart';

import 'component/home/home_controller.dart';

import 'component/login/login_view.dart';
import 'util/ApiClient.dart';
import 'util/AppTheme.dart';
import 'util/SizeConfig.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]); // To turn of
  await GetStorage.init();
  print("Tokenvalue::${ApiClient.box.read("token")}");
  print("object");
  runApp(const MyApp());
  print("object");
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Macsys',
              theme: AppTheme.lightTheme,
              // initialRoute: ApiClient.box.read('login') == null?RouteName.getLoginRoute():ApiClient.box.read('login')?RouteName.getHomeView():RouteName.getLoginRoute(),
              // getPages:RouteName.routes,
              home: getPage(),
              // home: const Login(),
              // getPages:AppRoutes.appRoutes(),
            );
          },
        );
      },
    );
  }

  // Handel application component.login status.
  getPage() {
    try {
      if (ApiClient.box.read('login') == true) {
        var homeController = Get.put(HomeController());
        homeController.getJobs();
        return HomeView(); //Dashboard();
      } else {
        print("LOGOUTTEDD:::${ApiClient.box.read('login')}");
        return LoginView();
      }
    } catch (e) {
      return LoginView();
    }
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
