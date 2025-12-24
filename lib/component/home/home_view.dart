import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:macsys/component/fuel_manager/fuel_transaction_view.dart';

import '../../maintaince/ongoing_maintaince_view.dart';
import '../../util/ApiClient.dart';
import '../../util/SizeConfig.dart';
import '../../util/confirmation_dialog.dart';
import '../../util/custom_dialog.dart';
import '../../util/fuel_selection_dialog.dart';
import '../custom_widget/check_internet.dart';
import '../custom_widget/colorsC.dart';
import '../custom_widget/cust_text.dart';
import '../fuel_manager/fuel_controller.dart';
import '../fuel_manager/fuel_add_view.dart';
import '../jobs/job_controller.dart';
import '../jobs/job_view.dart';

import '../login/login_view.dart';
import '../profile/profile_view.dart';
import 'home_controller.dart';

class HomeView extends StatelessWidget {
  var homeController = Get.put(HomeController());
  var fuelController = Get.put(FuelController());

  @override
  Widget build(BuildContext context) {
    // ApiClient.box.read("version");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrimaryDark,
        title: Padding(
          padding: EdgeInsets.only(left: 5 * SizeConfig.widthMultiplier),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustText(
                  name: "Dashboard",
                  size: 2.2,
                  colors: Colors.white,
                  fontWeightName: FontWeight.w600),
              CustText(
                  name: "Version ${ApiClient.box.read("version")}",
                  size: 1.4,
                  colors: Colors.white,
                  fontWeightName: FontWeight.w600),
            ],
          ),
        ),
        actions: <Widget>[
          //IconButton
          IconButton(
            icon: const Icon(
              Icons.perm_identity,
              color: Colors.white,
            ),
            tooltip: 'Profile',
            onPressed: () async {
              var jobsController = Get.put(JobsController());
              await jobsController.getJobs("allocated");
              Get.to(ProfileView());
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            tooltip: 'Logout',
            onPressed: () {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) => ConfirmationDialog(
                        title: "Logout",
                        msg: "Are you sure you want to Log Out? ",
                        onSelected: (flag) async {
                          // print("selected : $flag");
                          if (flag) {
                            homeController.logout();
                            Get.offAll(() => LoginView());
                            // Get.offAll(LoginView());
                          }
                        },
                      ));
            },
          ), //IconButton
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: 100 * SizeConfig.heightMultiplier,
            width: 100 * SizeConfig.widthMultiplier,
            child: Image.asset(
              'assets/icons/ic_home.png',
              fit: BoxFit.fitHeight,
            ),
          ),
          GetBuilder<HomeController>(
            init: HomeController(),
            builder: (controller) => Center(
              child: Padding(
                padding: EdgeInsets.only(
                    left: 2 * SizeConfig.widthMultiplier,
                    right: 2 * SizeConfig.widthMultiplier),
                child: Padding(
                  padding: EdgeInsets.all(2 * SizeConfig.widthMultiplier),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (await CheckInternet.checkInternet()) {
                            homeController.goToPageFirst(context);
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => CustomDialog(
                                    "Please check your internet connection"));
                          }
                          //Get.to(DailyJobSheetView("","","",""));
                        },
                        child: Container(
                          height: 40 * SizeConfig.heightMultiplier,
                          width: 100 * SizeConfig.widthMultiplier,
                          color: Colors.white.withOpacity(0.7),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 12 * SizeConfig.heightMultiplier,
                                  width: 20 * SizeConfig.widthMultiplier,
                                  child: Image.asset(
                                    'assets/icons/ongoing_jobs.png',
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                                SizedBox(
                                    height: 2 * SizeConfig.heightMultiplier),
                                CustText(
                                    name: homeController
                                        .getTitleHomeOne(homeController.userId),
                                    // homeController.UserId==1?"Ongoing Jobs : ${homeController.ongoing}":homeController.UserId==2?"Purchase Fuel":"Ongoing Maintenance Vehicle",
                                    size: 2.2,
                                    colors: Colors.black,
                                    fontWeightName: FontWeight.w600)
                              ]),
                        ),
                      ),
                      SizedBox(height: 3 * SizeConfig.heightMultiplier),
                      GestureDetector(
                        onTap: () async {
                          if (await CheckInternet.checkInternet()) {
                            homeController.goToPageSecond();
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => CustomDialog(
                                    "Please check your internet connection"));
                          }
                        },
                        child: Container(
                          height: 40 * SizeConfig.heightMultiplier,
                          width: 100 * SizeConfig.widthMultiplier,
                          color: Colors.white.withOpacity(0.7),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 12 * SizeConfig.heightMultiplier,
                                  width: 20 * SizeConfig.widthMultiplier,
                                  child: Image.asset(
                                    'assets/icons/allocated_jobs.png',
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                                SizedBox(
                                    height: 2 * SizeConfig.heightMultiplier),
                                CustText(
                                    name: homeController
                                        .getTitleHomeTwo(homeController.userId),
                                    // homeController.UserId==1?"Allocated Jobs : ${homeController.allocated}":homeController.UserId==2?"Transaction History":"Maintenance Vehicle History",
                                    size: 2.2,
                                    colors: Colors.black,
                                    fontWeightName: FontWeight.w600)
                              ]),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
