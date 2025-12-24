import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:macsys/component/custom_widget/custom_loading_popup.dart';
import 'package:macsys/component/login/login_view.dart';
import 'package:macsys/maintaince/maintaince_controller.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../maintaince/ongoing_maintaince_view.dart';
import '../../maintaince/vehicle_maintenece_model.dart';
import '../../services/remote_services.dart';
import '../../util/ApiClient.dart';
import '../fuel_manager/fuel_add_view.dart';
import '../fuel_manager/fuel_controller.dart';
import '../fuel_manager/fuel_transaction_view.dart';
import '../jobs/job_controller.dart';
import '../jobs/job_view.dart';
import '../login/login_controller.dart';
import 'home_model.dart';

class HomeController extends GetxController {
  bool fuelManager = false;
  bool superVisorsAdmin = false;
  var allocated = 0, ongoing = 0;
  var status, msg;
  int userId = 1;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // getVersion();
    cleanData();
    // ApiClient.box.write('token',"61e03c65981c20eb3796e4ca29cd3df3d71fabd4a5");
  }

  Future getJobs() async {
    try {
      var getDetails = await RemoteServices.fetchGetData('api/v1/dashboard');
      // // print("${getDetails.body}");
      if (getDetails.statusCode == 200) {
        // // print("here us the status ${getDetails.statusCode}");
        // // print("here is the body ${jsonDecode(getDetails.body)}");
        var body = jsonDecode(getDetails.body);
        var isValidStatus = body['status'];
        // // print("isValidStatus :: ${isValidStatus}");
        if (isValidStatus == false) {
          ApiClient.box.write('login', false);
          Get.offAll(LoginView());
        }
        var apiDetails = homeModelFromJson(getDetails.body);
        allocated = apiDetails.allocated;
        ongoing = apiDetails.ongoing;
        // // print("JOBS::${apiDetails}");
        if (ApiClient.box.read('skills') == "Diesel Manager") {
          // // print("Here is the Diesel ManagerHere is the Diesel Manager");
          userId = 2;
        } else if (ApiClient.box.read('skills') == "Supervisors Admin") {
          userId = 3;
        } else if (ApiClient.box.read('skills') == "P&M" ||
            ApiClient.box.read('skills') == "Maintenance Supervisor") {
          userId = 4;
          ApiClient.role = await ApiClient.box.read('skills') == "P&M";
          ApiClient.roleisMSupervisor =
              await ApiClient.box.read('skills') == "Maintenance Supervisor";
        } else {
          userId = 1;
        }
      } else {
        // checkUpdate();
        userId = 1;
        // // print("Exception");
      }
    } catch (e) {
      // print("catch  == $e");
      //   checkUpdate();
    }

    update();
  }

  goToPageFirst(context) async {
    switch (userId) {
      case 1:
        // // print(":Heelivbbbbbb");
        var jobsController = Get.put(JobsController());
        await jobsController.getJobs("ongoing");
        if (jobsController.jobs.isNotEmpty) {
          Get.to(() => JobsView());
          // // print("jobsController.status");
        }
      case 2:
        var fuelController = Get.put(FuelController());
        fuelController.cleanData();
        await fuelController.getFuel();
        Get.to(() => FuelView());
      // // print(":Heeliaaaa");
      case 3:
        if (ongoing != 0) {
          var jobsController = Get.put(JobsController());
          await jobsController.getJobs("ongoing");
          Get.to(() => JobsView());
        }
      // // print(":Heelsssi");
      case 4:
        var maintenanceController = Get.put(MaintenanceController());
        // maintenanceController.getVehicleMaintenance(false,0);
        showDialog(
            context: context,
            builder: (BuildContext context) => CustomLoadingPopup());
        await maintenanceController.getVehicleMaintenanceList(false, 0, false);
        Get.back();

        Get.to(() => MaintenanceVehicleView());
      // // print("HERE IS AFTER${status}");
      // // print(":Heelhasda");
      default:
        var jobsController = Get.put(JobsController());
        jobsController.jobStatusV = "ongoing";
        await jobsController.getJobs("ongoing");
        // // print("jobsController.status");
        Get.to(() => JobsView());
      // // print("HERE IS AFTER${jobsController.status}");
    }
    // // print("Here");
    update();
  }

  goToPageSecond() async {
    var jobsController = Get.put(JobsController());
    jobsController.jobStatusV = "allocated";
    switch (userId) {
      case 1:
        // // print(":Heelivbbbbbb");
        var jobsController = Get.put(JobsController());
        jobsController.jobStatusV = "allocated";
        await jobsController.getJobs("allocated");
        // // print("jobsController.status");
        Get.to(() => JobsView());
      case 2:
        var fuelController = Get.put(FuelController());
        fuelController.cleanData();
        await fuelController.getTransaction();
        Get.to(() => FuelTransactionView());
      //  // print(":Heeliaaaa");
      case 3:
        if (allocated != 0) {
          await jobsController.getJobs("allocated");
          Get.to(() => JobsView());
        }
      // // print(":Heelsssi");
      case 4:
        Get.to(() => MaintenanceVehicleView());
      // // print("HERE IS AFTER${status}");
      // // print(":Heelhasda");
      default:
        var jobsController = Get.put(JobsController());
        Get.to(() => JobsView());
        // print("HERE IS AFTER${jobsController.status}");
        if (allocated != 0) {
          await jobsController.getJobs("allocated");
          Get.to(() => JobsView());
        }
        update();
    }
    //// print("Here");
  }

  String getTitleHomeOne(int userId) {
    switch (userId) {
      case 1:
        // print(":Heeli");
        return "Ongoing Jobs : ${ongoing}";
      case 2:
        return "Purchase Diesel";
      case 3:
        return "Ongoing Jobs : ${ongoing}";
      case 4:
        return "Ongoing Maintenance Vehicle";
      default:
        return "Please Wait";
    }
  }

  String getTitleHomeTwo(int userId) {
    switch (userId) {
      case 1:
        return "Allocated Jobs : ${allocated}";
      case 2:
        return "Transaction History";
      case 3:
        return "Allocated Jobs : ${allocated}";
      case 4:
        return "Maintenance Vehicle History";
      default:
        return "Please Wait";
    }
  }
  /*Future getJobs() async{
    try {
      Map map ={
        "user_id": ApiClient.box.read('userId')
      };
      // print("map  == $map");
      var getDetails = await RemoteServices.fetchGetData('api/v1/jobs');
      // print("${getDetails.body}");
      // if(getDetails.statusCode == 200){
      //   var apiDetails = homeModelFromJson(getDetails.body);
      //   if(apiDetails.flag == 1){
      //     status = apiDetails.flag;
      //     msg = apiDetails.msg;
      //     allocated = apiDetails.allocated!;
      //     ongoing = apiDetails.ongoing!;
      //     // print("Details${apiDetails.msg!}");
      //     // print("Details${apiDetails.allocated!}");
      //     // print("Details${apiDetails.ongoing!}");
      //   }
      // }else{
      //   //  checkUpdate();
      // }
    }  catch (e) {
      // print("catch  == $e");
      //   checkUpdate();
    }

    update();
  }*/

  Future<void> logout() async {
    // print("Before ${ApiClient.box.read("login")}");
    ApiClient.box.write('token', "");
    ApiClient.box.write('login', false);
    ApiClient.box.write('userId', "");
    ApiClient.box.write('superName', "");
    ApiClient.box.write('superEmail', "");
    ApiClient.box.write('superMobile', "");
    ApiClient.box.write('crewEmail', "");
    ApiClient.box.write('crewMobile', "");
    ApiClient.box.write('image', "");
    ApiClient.box.write('userId', "");
    ApiClient.box.write('skills', "");
    ApiClient.box.write('status', "0");
    ApiClient.box.write('supervisorsAdmin', "0");

    ApiClient.gs.erase();
    // print("All data in GetStorage has been erased.");

    // print("After :${ApiClient.box.read("login")}");

    // print("VALUESS::${ApiClient.box.getValues()}");
    // print("BEFORE ${ApiClient.box.read('login')}");
    Get.deleteAll();
    update();
    // print("${ApiClient.box.read('login')}");
    loginStatus = false;
  }

  double TotalPurchaseBalance = 0.0;
  double TotalUsedFuel = 0.0;
  double TotalRemainingFuel = 0.0;

  updatePurchaseBalance(PFuel) {
    TotalPurchaseBalance = PFuel;
    update();
  }

  updateUsedBalance(UFuel) {
    TotalUsedFuel = UFuel;
    update();
  }

  updateRemainingFuel(RFuel) {
    TotalRemainingFuel = RFuel;
    update();
  }

  cleanData() {
    TotalUsedFuel = 0.0;
    TotalPurchaseBalance = 0.0;
    TotalRemainingFuel = 0.0;
    update();
  }
}
