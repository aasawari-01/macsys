import 'package:get/get_navigation/src/routes/get_route.dart';

import '../login/login_view.dart';
import 'home_view.dart';

class RouteName {

  static  String home='/home';
  static  String login='/';

  static  String getLoginRoute()=>login;
  static  String getHomeView()=>home;

  static  List<GetPage> routes = [
    GetPage(name: login, page:()=> LoginView()),
    GetPage(name: home, page:()=> HomeView(),),
  ];

}
