import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:macsys/util/ApiClient.dart';

import '../../services/remote_services.dart';
import 'filled_job_details_model.dart';
import 'job_details_model.dart';

var allVehicleDetail;

class JobsDetailsController extends GetxController {
  var allocated = 0, ongoing = 0;
  var msg;
  bool status = false;
  List allData = [];
  List<AssignVehicle> assignVehicle = [];
  var jobsList;
  var jobsListnew;
  var fStatus, fMsg;
  List<String> crewNamesList = [];
  List<DailyJob> dailyJob = [];
  DateTime? dateTimeWork;
  String noHours = "";
  String noMin = "";
  int reading = 0;
  String VehicleNo = "";
  String urea = "";
  String readingIn = "";
  String jobDesc = "";
  String imageLink = "";
  String transferstatus = "";

  List<AssignVehicle> filteredAssignVehicle = [];

  void filterList(String searchTerm) {
    if (searchTerm.isEmpty) {
      filteredAssignVehicle = assignVehicle;
    } else {
      filteredAssignVehicle = assignVehicle
          .where((vehicle) => vehicle.vehicleNo!
              .toLowerCase()
              .contains(searchTerm.toLowerCase()))
          .toList();
    }
    update();
  }

  Future getJobDetails(jobId) async {
    //filteredAssignVehicle.clear();
    // print("JOBID::$jobId");
    crewNamesList.clear();
    status = false;
    try {
      Map map = {"job_id": jobId};
      // // print("map  == $map");
      // // print("11111111111111111111111111111111111  == $map");
      jobsListnew = await ApiClient.gs.read('job_$jobId');
      // // print(
      //     "----------jobsListnewjobsListnew-----------------------$jobsListnew");

      if (jobsListnew != null) {
        print(
            "-------------------------IFFFFFFFFFFFFFFFFFFF-------------------");

        var jobsListData = jobDetailsModelFromJson(jobsListnew);
        jobsList = await jobsListData.jobs;

        // log("a----------jobsList-----------------------$jobsList");
        // log("In read call, data exists");

        // log("In reaad call");
        try {
          assignVehicle = await jobsList.assignVehicle;
          filteredAssignVehicle = await assignVehicle;

          status = true;
        } catch (e) {
          // print(e);
        }
        // print(assignVehicle.toString());
        // log("In Before loop, data exists");

        for (int i = 0; i <= assignVehicle.length - 1; i++) {
          if (assignVehicle[i].crewVehicleAllocation!.length != 0) {
            String crewNames = "";
            // log("In if up, data exists");

            for (int j = 0;
                j <= assignVehicle[i].crewVehicleAllocation!.length - 1;
                j++) {
              // log("In if down, data exists");

              String firstName =
                  assignVehicle[i].crewVehicleAllocation![j].firstName;
              String lastName =
                  assignVehicle[i].crewVehicleAllocation![j].lastName;
              crewNames += "${j + 1}) $firstName $lastName\n ";
            }
            crewNames = crewNames.substring(0, crewNames.length - 2);
            crewNamesList.add(crewNames);
          } else {
            String crewNames = "";
            crewNames = "No Crew Assign";
            crewNamesList.add(crewNames);
            // log("In else, data exists");
          }
          // transferStatusColor = assignVehicle[i].transferstatus == "same"
          //     ? Colors.white
          //     : Colors.amberAccent;
          // log(transferStatusColor as String);
        }
        // log("last-----------");
      } else {
        print("-------------------------elseeeeeeeeee-------------------");
        log('-------- ApiClient.version---------${ApiClient.box.read("version")}');

        var getDetails =
            await RemoteServices.postMethodWithToken('api/v1/jobs', map);
        // printInfo(info: "getDetailsHere  == ${getDetails.body}");
        // printInfo(info: "getDetai  == ${getDetails.statusCode}");

        allVehicleDetail = getDetails.body;
        if (getDetails.statusCode == 200) {
          print("status msgggggggg++++++++++++++++++++++++++++++++++++++ $msg");
          status = true;
          var apiDetails = jobDetailsModelFromJson(getDetails.body);
          // // print("asdhello12 $apiDetails");
          if (apiDetails.status == true) {
            msg = apiDetails.msg;
            ApiClient.gs.write('job_$jobId', getDetails.body);
            jobsList = apiDetails.jobs;
            //   jobsList = await ApiClient.box.read('jobsAllData');
            // log("a---------------------------------$jobsList");
            // printInfo(info: " is the jobs::: $jobsList");
            assignVehicle = jobsList.assignVehicle;
            filteredAssignVehicle = assignVehicle;

            // storVar = assignVehicle

            for (int i = 0; i <= assignVehicle.length - 1; i++) {
              if (assignVehicle[i].crewVehicleAllocation!.length != 0) {
                String crewNames = "";

                for (int j = 0;
                    j <= assignVehicle[i].crewVehicleAllocation!.length - 1;
                    j++) {
                  String firstName =
                      assignVehicle[i].crewVehicleAllocation![j].firstName;
                  String lastName =
                      assignVehicle[i].crewVehicleAllocation![j].lastName;
                  crewNames += "${j + 1}) $firstName $lastName\n ";
                }
                crewNames = crewNames.substring(0, crewNames.length - 2);
                crewNamesList.add(crewNames);
              } else {
                String crewNames = "";
                crewNames = "No Crew Assign";
                crewNamesList.add(crewNames);
              }
              // transferStatusColor = assignVehicle[i].transferstatus == "same"
              //     ? Colors.white
              //     : Colors.amberAccent;
              // log(transferStatusColor as String);
            }
          }
        } else {
          //  checkUpdate();
        }
      }
    } catch (e) {
      // print("catch  == $e");
      //   checkUpdate();
    }
    update();
  }

  // Future getJobDetails(jobId) async {
  //   //filteredAssignVehicle.clear();
  //   // print("JOBID::$jobId");
  //   crewNamesList.clear();
  //   status = false;
  //   try {
  //     Map map = {"job_id": jobId};
  //     // print("map  == $map");
  //     // print("11111111111111111111111111111111111  == $map");

  //     var getDetails =
  //         await RemoteServices.postMethodWithToken('api/v1/jobs', map);
  //     printInfo(info: "getDetailsHere  == ${getDetails.body}");
  //     printInfo(info: "getDetai  == ${getDetails.statusCode}");

  //     allVehicleDetail = getDetails.body;
  //     if (getDetails.statusCode == 200) {
  //       // print("asdhello $msg");
  //       status = true;
  //       var apiDetails = jobDetailsModelFromJson(getDetails.body);
  //       // print("asdhello12 $apiDetails");
  //       if (apiDetails.status == true) {
  //         msg = apiDetails.msg;
  //         await ApiClient.box.write('jobsAllData', apiDetails.jobs);
  //         jobsList = apiDetails.jobs;

  //         printInfo(info: " is the jobs::: $jobsList");
  //         assignVehicle = jobsList.assignVehicle;
  //         filteredAssignVehicle = assignVehicle;

  //         // storVar = assignVehicle

  //         for (int i = 0; i <= assignVehicle.length - 1; i++) {
  //           if (assignVehicle[i].crewVehicleAllocation!.length != 0) {
  //             String crewNames = "";

  //             for (int j = 0;
  //                 j <= assignVehicle[i].crewVehicleAllocation!.length - 1;
  //                 j++) {
  //               String firstName =
  //                   assignVehicle[i].crewVehicleAllocation![j].firstName;
  //               String lastName =
  //                   assignVehicle[i].crewVehicleAllocation![j].lastName;
  //               crewNames += "${j + 1}) $firstName $lastName\n ";
  //             }
  //             crewNames = crewNames.substring(0, crewNames.length - 2);
  //             crewNamesList.add(crewNames);
  //           } else {
  //             String crewNames = "";
  //             crewNames = "No Crew Assign";
  //             crewNamesList.add(crewNames);
  //           }
  //           // transferStatusColor = assignVehicle[i].transferstatus == "same"
  //           //     ? Colors.white
  //           //     : Colors.amberAccent;
  //           // log(transferStatusColor as String);
  //         }
  //       } else {
  //         //  checkUpdate();
  //       }
  //     }
  //   } catch (e) {
  //     // print("catch  == $e");
  //     //   checkUpdate();
  //   }
  //   update();
  // }

  // /// Function to handle the transfer status for a vehicle
  // Color handleTransferStatus(dynamic vehicle) {
  //   String transferStatus = vehicle.transferStatus ?? "unknown";

  //   if (transferStatus == "same") {
  //     log("Same" as String);

  //     return Colors.white;
  //   } else if (transferStatus == "different") {
  //     log("different" as String);

  //     return Colors.yellow;
  //   } else {
  //     log("different" as num);

  //     return Colors.yellow;
  //   }
  // }

  Future getFilledVehicles(vehicleId) async {
    // // print("JOBID::$vehicleId");
    crewNamesList.clear();
    status = false;
    try {
      Map map = {
        "vehicle_id": "$vehicleId",
      };
      // // print("map  == $map");
      var getDetails =
          await RemoteServices.postMethodWithToken('api/v1/job-sheet', map);
      // // print("$map");
      // printInfo(info: "getDetails :: ${getDetails.body}");
      allVehicleDetail = getDetails.body;
      if (getDetails.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(getDetails.body);
        final Map<String, dynamic> dailyReport = jsonResponse['daily_report'];
        // // print("HERE REPORT::$dailyReport");
        noHours = dailyReport["no_of_hours"] ?? "";
        noMin = dailyReport["no_of_minutes"] ?? "";
        reading = dailyReport["reading"] ?? "";
        readingIn = dailyReport["reading_in"] ?? "";
        jobDesc = dailyReport["job_desc"] ?? "";
        dateTimeWork = dailyReport["updated_at"] ?? "";
        urea = dailyReport["urea"] ?? "";
        VehicleNo = dailyReport["vehicle_no"] ?? "";

        // // print("urasdasdasdasdasdasdaea$urea$jobDesc$noHours");
      } else {
        //  checkUpdate();
      }
    } catch (e) {
      // print("catch  == $e");
      //   checkUpdate();
    }
    update();
  }

// void updateColor() {
//   update();
// }

// static Color color = Colors.white;
// getTransferStatusColor(transferStatus, jobId, currentJobId) {
//   if (transferStatus == "different") {
//     return jobId == currentJobId ? Colors.red[200]! : Colors.green[200]!;
//   }
//   return Colors.red;
// }

  Map<int, Color> itemColors = {};

  // Function to change color based on index
  void changeColor(int index) {
    if (itemColors[index] == Colors.white) {
      itemColors[index] = Colors.red;
    } else if (itemColors[index] == Colors.red) {
      itemColors[index] = Colors.green;
    } else {
      itemColors[index] = Colors.white;
    }
    update(); // Notify UI to rebuild
  }
}
