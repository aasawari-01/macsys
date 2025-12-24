import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:macsys/util/ApiClient.dart';

import '../../services/remote_services.dart';

import 'job_model.dart';

class JobsController extends GetxController {
  var allocated = 0;
  var ongoing = 0;
  String jobStatusV = "ongoing";
  bool status = false;
  var msg;
  int isSupervisorAdmin = 0;
  List jobs = [];
  var jobStatus;
  List<VehicleStatus> vehStatus = [];
  var colors = [
    Colors.green.shade200,
    Colors.red.shade200,
    Colors.yellow.shade200,
    Colors.indigo.shade200,
    Colors.blue.shade200,
    Colors.cyan.shade200,
    Colors.teal.shade200,
    Colors.purple.shade200,
  ];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // getJobs("allocated");
  }

  // List<Result> jobResult = [];

  Future getJobs(String jobStatusV) async {
    status = false;
    jobStatus = jobStatusV;
    // print("HERE IS JOB STATUS:::$jobStatus");
    try {
      Map map = {"status": jobStatus};
      // print("map  == $map");
      log('-------- RemoteServices.version---------${ApiClient.box.read("version")}');

      print("-------------------getjobs-----------------");
      var getDetails =
          await RemoteServices.postMethodWithToken('api/v1/jobs', map);
      // // print("$isLoading");
      if (getDetails.statusCode == 200) {
        status = true;
        //log("{getDetails.body${getDetails.body}}");
        var apiDetails = jobsModelFromJson(getDetails.body);
        if (apiDetails.status == true) {
          /* isLoading = false;
          // print("$isLoading");*/

          status = apiDetails.status;
          msg = apiDetails.msg;
          jobs = apiDetails.jobs;
          isSupervisorAdmin = apiDetails.isSupervisorAdmin;

          // print("objectasdas here $isSupervisorAdmin");
          if (isSupervisorAdmin == 1) {
            vehStatus = apiDetails.vehicleStatuses!;
          } else {
            // print("HERE !!!ASDAS");
          }
        } else {
          // print("Values");
          //  checkUpdate();
        }
      } else {
        // print("Values");
        //  checkUpdate();
      }
    } catch (e) {
      // print("catch  == $e");
      //   checkUpdate();
    }
    update();
  }

  Future getMaintenanceQuotation() async {
    // print("Fetching Maintenance Quotation...");
    try {
      Map map = {"vehicle_id": 0};
      var getDetails = await RemoteServices.postMethodWithToken(
          'api/v1/get-maintenance-quotation', map);

      if (getDetails.statusCode == 200) {
        var response = jsonDecode(getDetails.body);

        if (response['status'] == 1) {
          // print("Success: ${response['data']}");
          jobs = response['data'];
        } else if (response['status'] == 0) {
          // print("No data available or status is 0");
          msg = response['message'] ?? "No message provided";
        }
      } else {
        // print("Error: ${getDetails.statusCode}");
      }
    } catch (e) {
      // print("Exception: $e");
    }

    update();
  }

//   Future getJobs(jobType) async{
//     // status = 0;
//     try {
//       Map map ={
//         "user_id": ApiClient.box.read('userId'),
//         "job_type":jobType
//       };
//       // // print("map  == $map");
//       var getDetails = await RemoteServices.postMethod('app/jobs',map);
//       if(getDetails.statusCode == 200){
//        var apiDetails = jobsModelFromJson(getDetails.body);
//        if(apiDetails.flag == 1){
//          vehicleStatus.clear();
//          vehicleStatus.add(apiDetails.vehicleStatus['working']);
//          vehicleStatus.add(apiDetails.vehicleStatus['maintenance']);
//          vehicleStatus.add(apiDetails.vehicleStatus['idle']);
//          printInfo(info: "${jsonEncode(apiDetails)}");
//          status = apiDetails.flag;
//          msg = apiDetails.msg;
//          jobResult = apiDetails.result;
//
//          // print("Vehicle status ${vehicleStatus}");
//          ApiClient.box.write('jobResultLength', jobResult.length);
//          // print("${ApiClient.box.read('supervisorsAdmin')}");
//          // print("${ApiClient.box.read('login')}");
//          for (Result job in jobResult) {
//
//            ApiClient.box.write('jobId', job!.id);
//            ApiClient.box.write('job', job!.job);
//            ApiClient.box.write('jobDate', job!.jobDate);
//            ApiClient.box.write('siteAddress', job!.siteAddress);
//            ApiClient.box.write('releasedDate', job!.releasedDate);
//            ApiClient.box.write('jobSubType', job!.jobSubType);
//            ApiClient.box.write('jobType', job!.jobType);
//          }
//          // List<dynamic> idList = ApiClient.box.read('id');
//
// // Print or use the values as needed
// //          idList.forEach((value) {
// //            // print(value);
// //            // print("HERE:::");
// //          });
//        }
//       }else{
//       //  checkUpdate();
//       }
//     }  catch (e) {
//       // print("HERE IS CONVERSTION ISSUE ");
//       // print("catch  == $e");
//    //   checkUpdate();
//     }
//
//     update();
//   }
}
