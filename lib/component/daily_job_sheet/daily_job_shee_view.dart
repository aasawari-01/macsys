import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:macsys/component/custom_widget/cust_text_start.dart';
import 'package:macsys/component/daily_job_sheet/daily_job_sheet_controller.dart';
import 'package:macsys/component/job_details/job_details_controller.dart';
import 'package:macsys/component/jobs/job_controller.dart';
import 'package:macsys/maintaince/maintaince_view_supervisor.dart';
import 'package:macsys/services/remote_services.dart';
import 'package:macsys/util/confirmation_dialog_daily.dart';
import 'package:macsys/util/confirmcard_dialog.dart';
import 'package:macsys/util/dropdown_dialog.dart';
import 'package:remixicon/remixicon.dart';
import '../../maintaince/maintainance_view.dart';
import '../../maintaince/maintaince_controller.dart';
import '../../util/ApiClient.dart';
import '../../util/SizeConfig.dart';
import '../../util/custom_dialog.dart';
import '../custom_widget/check_internet.dart';
import '../custom_widget/colorsC.dart';
import '../custom_widget/cust_text.dart';
import '../custom_widget/custom_loading_popup.dart';
import '../custom_widget/photo_view.dart';
import 'time_sectetion.dart';

class DailyJobSheetView extends StatelessWidget {
  var vehicleDetails, dateTime, jobID, vehicleImage, siteid, btnStatus;
  DailyJobSheetView(
      vehicleDetails, dateTime, jobID, vehicleImage, siteid, btnStatus) {
    this.vehicleDetails = vehicleDetails;
    this.dateTime = dateTime;
    this.jobID = jobID;
    this.vehicleImage = vehicleImage;
    this.siteid = siteid;
    this.btnStatus = btnStatus;
  }

  var DJSController = Get.put(DailyJobSheetController());
  final JobsController jobsController = Get.put(JobsController());
  var jobsDetailsController = Get.put(JobsDetailsController());
  double lastReading = 0.0;
  double currentReading = 0.0;
  double readmaxValidation = 500.0;
  final MaintenanceController maintenanceController =
      Get.put(MaintenanceController());
  final FocusNode jobDescFocus = FocusNode();
  final FocusNode machineReadingFocus = FocusNode();
  final FocusNode fuelAddedFocus = FocusNode();
  final FocusNode ureaFocus = FocusNode();
  int i = 0;

  @override
  Widget build(BuildContext context) {
    // if (i == 0) {
    //   i++;
    // }
    //
    // DJSController.getStatusData(vehicleDetails.vehicleId);

    return SafeArea(
      bottom: true,
      top: true,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorPrimaryDark,
          leading: GestureDetector(
              onTap: () {
                DJSController.cleanData();
                Navigator.pop(context);
              },
              child: SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  Remix.arrow_left_line,
                  size: 6 * SizeConfig.imageSizeMultiplier,
                  color: Colors.white,
                ),
              )),
          title: CustText(
              name: "Daily Job Sheet",
              size: 2.2,
              colors: Colors.white,
              fontWeightName: FontWeight.w600),
        ),
        body: GetBuilder<DailyJobSheetController>(
          init: DailyJobSheetController(),
          builder: (controller) => Padding(
            padding: EdgeInsets.all(2 * SizeConfig.widthMultiplier),
            child: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    //   height: 40 * SizeConfig.heightMultiplier,
                    width: 100 * SizeConfig.widthMultiplier,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.all(
                            Radius.circular(1 * SizeConfig.widthMultiplier)),
                        border: Border.all(
                            width: 0.3 * SizeConfig.widthMultiplier,
                            color: Colors.grey,
                            strokeAlign: BorderSide.strokeAlignCenter)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              height: 5.5 * SizeConfig.heightMultiplier,
                              width: 100 * SizeConfig.widthMultiplier,
                              color: colorPrimary,
                              child: Center(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      log(siteid.toString() +
                                          "***********************");

                                      log(siteid.toString() +
                                          "***********************");
                                      log(btnStatus.toString());
                                    },
                                    child: CustText(
                                        name: "Basic Information",
                                        size: 1.8,
                                        colors: Colors.white,
                                        fontWeightName: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    width: SizeConfig.widthMultiplier * 2,
                                  ),
                                ],
                              ))),
                          SizedBox(
                            height: 0.5 * SizeConfig.heightMultiplier,
                          ),
                          Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 2 * SizeConfig.widthMultiplier,
                                      ),
                                      CustTextStart(
                                          name: "Vehicle No:",
                                          size: 1.8,
                                          colors: Colors.black,
                                          fontWeightName: FontWeight.w600),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 1 * SizeConfig.heightMultiplier,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 2 * SizeConfig.widthMultiplier,
                                      ),
                                      CustTextStart(
                                          name: "${vehicleDetails.vehicleNo}",
                                          size: 2,
                                          colors: colorPrimaryDark,
                                          fontWeightName: FontWeight.w600),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 1 * SizeConfig.heightMultiplier,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 2 * SizeConfig.widthMultiplier,
                                      ),
                                      CustTextStart(
                                          name: "Job Date :",
                                          size: 1.8,
                                          colors: Colors.black,
                                          fontWeightName: FontWeight.w600),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 1 * SizeConfig.heightMultiplier,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 2 * SizeConfig.widthMultiplier,
                                      ),
                                      Icon(Remix.calendar_todo_fill,
                                          size: 6 *
                                              SizeConfig.imageSizeMultiplier,
                                          color: Colors.black),
                                      SizedBox(
                                        width: 2 * SizeConfig.widthMultiplier,
                                      ),
                                      CustTextStart(
                                          name:
                                              "${DJSController.jobDate == " " ? ApiClient.convertDate(DJSController.currDate.toString()) : DJSController.jobDate}",
                                          size: 1.8,
                                          colors: Colors.black38,
                                          fontWeightName: FontWeight.w600),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 1 * SizeConfig.heightMultiplier,
                                  ),
                                  SizedBox(
                                    height: 1 * SizeConfig.heightMultiplier,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 4 * SizeConfig.widthMultiplier,
                              ),
                              Container(
                                height: 15 * SizeConfig.heightMultiplier,
                                width: 35 * SizeConfig.widthMultiplier,
                                // color: Colors.red,
                                child: vehicleImage == null
                                    ? Image.asset(
                                        'assets/icons/no_image_found.jpg')
                                    : Image.network(vehicleImage),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 0.4 * SizeConfig.heightMultiplier,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 2 * SizeConfig.widthMultiplier,
                              ),
                              CustTextStart(
                                  name: "Last Reading :",
                                  size: 1.8,
                                  colors: Colors.black,
                                  fontWeightName: FontWeight.w600),
                              SizedBox(
                                width: 2 * SizeConfig.widthMultiplier,
                              ),
                              CustTextStart(
                                  name: DJSController.readingData == null
                                      ? ""
                                      : DJSController.readingData,
                                  size: 1.8,
                                  colors: Colors.black,
                                  fontWeightName: FontWeight.w600),
                            ],
                          ),
                          SizedBox(
                            height: 1 * SizeConfig.heightMultiplier,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 2 * SizeConfig.widthMultiplier,
                              ),
                              CustTextStart(
                                  name: "Reading In :",
                                  size: 1.8,
                                  colors: Colors.black,
                                  fontWeightName: FontWeight.w600),
                              SizedBox(
                                width: 2 * SizeConfig.widthMultiplier,
                              ),
                              CustTextStart(
                                  name: DJSController.readingIn == null
                                      ? ""
                                      : DJSController.readingIn,
                                  size: 1.8,
                                  colors: Colors.black,
                                  fontWeightName: FontWeight.w600),
                            ],
                          ),
                          SizedBox(height: 1.5 * SizeConfig.heightMultiplier),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  var maintaincecontroller =
                                      Get.put(MaintenanceController());

                                  if (await CheckInternet.checkInternet()) {
                                    //   Get.back();
                                    log('In Ifffffffffffffffffffffffffff -------${DJSController.isDraft}');

                                    if (btnStatus == "Transfer") {
                                      log('Ifffffffffffffffffffffffffff ${DJSController.isDraft}');

                                      if (DJSController.isDraft.toString() !=
                                              "1" ||
                                          DJSController.isDraft == '' ||
                                          DJSController.isDraft == null) {
                                        log('In Ifffffffffffffffffffffffffff');
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              CustomDialogDropdown(
                                                  "Enter option",
                                                  vehicleDetails,
                                                  siteid,
                                                  btnStatus,
                                                  jobID),
                                        );
                                      } else {
                                        log('In Elseeeeeeeeeeeeeeeeeeeee');

                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                CustomDialog(
                                                    "Please Submit Daily JobSheet"));
                                      }
                                    } else if (btnStatus == "Revert") {
                                      // showDialog(
                                      //   context: context,
                                      //   builder: (BuildContext context) =>
                                      //       CustomLoadingPopup(),
                                      // );

                                      await showDialog(
                                        barrierDismissible: true,
                                        context: context,
                                        builder: (BuildContext context) =>
                                            ConfirmationCardDialog(
                                          msg:
                                              "Are you sure, Do you want to revert a vehicle",
                                          onSelected: (bool confirmed) async {
                                            if (confirmed) {
                                              var maintaincecontroller =
                                                  Get.put(
                                                      MaintenanceController());

                                              await maintaincecontroller
                                                  .transferVehicle(siteid, [
                                                vehicleDetails.vehicleId
                                              ]);
                                              log("Revert Value");
                                              log(vehicleDetails.vehicleId
                                                  .toString());
                                              log(siteid.toString());
                                            }
                                          },
                                          jobId: jobID,
                                        ),
                                      );

                                      log(jobID);
                                    } else {
                                      await showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            ConfirmationCardDialog(
                                          msg:
                                              "Are you sure, Do you want to accept a vehicle",
                                          transfer: isTransfer,
                                          onSelected: (bool confirmed) async {
                                            if (confirmed) {
                                              var maintaincecontroller =
                                                  Get.put(
                                                      MaintenanceController());

                                              await maintaincecontroller
                                                  .transferVehicle(
                                                siteid,
                                                [vehicleDetails.vehicleId],
                                                isTransfer: 1,
                                              );
                                              log("Accept Value");
                                              log(vehicleDetails.vehicleId
                                                  .toString());
                                              log(siteid.toString());
                                            }
                                          },
                                          jobId:
                                              jobsDetailsController.jobsList.id,
                                        ),
                                      );

                                      log(jobID);
                                    }
                                    // Get.off(JobsDetilasView(
                                    //     "${jobsController.jobStatus}", 0));
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            CustomDialog(
                                                "Please check your internet connection"));
                                  }

                                  // Get.off(JobsDetilasView(
                                  //     "${jobsController.jobStatus}", 0));
                                },
                                child: Container(
                                    height: 5.5 * SizeConfig.heightMultiplier,
                                    width: 35 * SizeConfig.widthMultiplier,
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(2 *
                                                SizeConfig.widthMultiplier)),
                                        border: Border.all(
                                            width: 0.0 *
                                                SizeConfig.widthMultiplier,
                                            color: Colors.grey,
                                            strokeAlign:
                                                BorderSide.strokeAlignCenter)),
                                    child: Center(
                                        child: CustText(
                                            name: btnStatus,
                                            size: 1.8,
                                            colors: Colors.black,
                                            fontWeightName: FontWeight.w600))),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.5 * SizeConfig.heightMultiplier),
                        ])),
                // Text("$vehStatus"),

                btnStatus == "Transfer"
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print(
                                      "Gesture  Working  ${DJSController.vehStatus}");
                                  DJSController.updateStatus("In Working");
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                      value: "In Working",
                                      groupValue: DJSController.vehStatus,
                                      //groupValue: vehicleDetails.vehStatus,
                                      visualDensity: VisualDensity(
                                        vertical: 0,
                                        horizontal: -4,
                                      ),
                                      activeColor: colorPrimary,
                                      focusColor: colorPrimary,
                                      onChanged: (value) {
                                        DJSController.updateStatus(
                                            "In Working");
                                        print(
                                            "ONCHANGE Working  ${DJSController.vehStatus}");
                                      },
                                    ),
                                    CustTextStart(
                                        name: "In Working",
                                        size: 1.6,
                                        colors: Colors.black,
                                        fontWeightName: FontWeight.w400),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.widthMultiplier * 1,
                              ),
                              GestureDetector(
                                onTap: () {
                                  print(
                                      "Gesture  Working ***************  ${DJSController.vehStatus}");
                                  DJSController.updateStatus(
                                      "Awaiting Maintenance");
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                        value: "Awaiting Maintenance",
                                        groupValue: DJSController.vehStatus,
                                        //groupValue: vehicleDetails.vehStatus,
                                        activeColor: colorPrimary,
                                        focusColor: colorPrimary,
                                        visualDensity: VisualDensity(
                                          vertical: 0,
                                          horizontal: -4,
                                        ),
                                        onChanged: (value) async {
                                          DJSController.updateStatus(
                                              "Awaiting Maintenance");
                                          {
                                            DJSController.updateStatus(
                                                "Awaiting Maintenance");
                                            var maintenanceController = Get.put(
                                                MaintenanceController());
                                            maintenanceController.cleanData();
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) =>
                                                  CustomLoadingPopup(),
                                            );
                                            maintenanceController
                                                .instructionList
                                                .clear();

                                            maintenanceController.controllers
                                                .clear();
                                            maintenanceController
                                                .maintenanceReason
                                                .clear();

                                            await maintenanceController
                                                .getMaintenanceDetails(
                                                    vehicleDetails.vehicleId);

                                            await maintenanceController
                                                .getVehicleMaintenanceList(
                                                    true,
                                                    vehicleDetails.vehicleId,
                                                    true);
                                            Get.back();
                                            // await maintenanceController
                                            //     .getVehicleMaintenance(false,
                                            //         vehicleDetails.vehicleId);

                                            // if (maintenanceController
                                            //         .vehicleMaintenanceDetail !=
                                            //     null) {
                                            // maintenanceController.cleanData();
                                            //  if (decoded['status'] == 1) {
                                            //   // Navigate to Approve page
                                            //   print("Navigating to Approve page...");
                                            // } else if (decoded['status'] == 0) {
                                            //   // Navigate to Details page
                                            //   print("Navigating to Details page...");
                                            // }

                                            //     if (maintenanceController
                                            //             .vehicleMaintenanceDetail!
                                            //             .status ==
                                            //         1) {
                                            //       var maintenanceController =
                                            //           Get.put(
                                            //               MaintenanceController());
                                            //       await Get.to(
                                            //           MaintenanceViewSupervisor(
                                            //               await maintenanceController
                                            //                   .vehicleDetailsData));

                                            //       print(MaintenanceController
                                            //           .statusData1);
                                            //     }
                                            //     // Get.to(ShowMaintenanceSheet(vehicleDetails.id));
                                            //   } else {
                                            //     maintenanceController
                                            //         .textFieldAdd();
                                            //     maintenanceController.addField();
                                            //     Get.to(MaintenanceView(
                                            //       VehicleName:
                                            //           vehicleDetails.vehicleNo,
                                            //       vehicleID:
                                            //           vehicleDetails.vehicleId,
                                            //       details: vehicleDetails,
                                            //       jobId: jobID,
                                            //     ));
                                            //   }
                                            // }

                                            if (maintenanceController
                                                    .vehicleMaintenanceDetail !=
                                                null) {
                                              // maintenanceController.cleanData();
                                              if (maintenanceController
                                                      .vehicleMaintenanceDetail!
                                                      .status ==
                                                  1) {
                                                maintenanceController
                                                    .addField();

                                                Get.to(MaintenanceViewSupervisor(
                                                    await maintenanceController
                                                        .vehicleDetailsData));
                                                // Get.to(ShowMaintenanceSheet(vehicleDetails.id));
                                              } else {
                                                // Get.to(AddMaintenanceSheet(
                                                //     vehicleDetails.id));
                                                // maintenanceController.textFieldAdd();
                                                // maintenanceController.addField();
                                                Get.to(MaintenanceView(
                                                  VehicleName:
                                                      vehicleDetails.vehicleNo,
                                                  vehicleID:
                                                      vehicleDetails.vehicleId,
                                                  details: vehicleDetails,
                                                  jobId: jobID,
                                                ));
                                              }
                                            } else {
                                              // maintenanceController.textFieldAdd();
                                              // maintenanceController.addField();

                                              Get.to(MaintenanceView(
                                                VehicleName:
                                                    vehicleDetails.vehicleNo,
                                                vehicleID:
                                                    vehicleDetails.vehicleId,
                                                details: vehicleDetails,
                                                jobId: jobID,
                                              ));
                                            }
                                          }
                                        }),
                                    GestureDetector(
                                      onTap: () async {
                                        print(
                                            "here is the vehiocle id ::#${vehicleDetails.vehicleId}  \n\n");
                                        DJSController.updateStatus(
                                            "Awaiting Maintenance");
                                        var maintenanceController =
                                            Get.put(MaintenanceController());
                                        maintenanceController.cleanData();
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) =>
                                              CustomLoadingPopup(),
                                        );
                                        maintenanceController.instructionList
                                            .clear();
                                        maintenanceController.controllers
                                            .clear();
                                        maintenanceController.maintenanceReason
                                            .clear();

                                        await maintenanceController
                                            .getMaintenanceDetails(
                                                vehicleDetails.vehicleId);
                                        await maintenanceController
                                            .getVehicleMaintenanceList(true,
                                                vehicleDetails.vehicleId, true);
                                        Get.back();
                                        if (maintenanceController
                                                .vehicleMaintenanceDetail !=
                                            null) {
                                          // maintenanceController.cleanData();
                                          if (maintenanceController
                                                  .vehicleMaintenanceDetail!
                                                  .status ==
                                              1) {
                                            //  maintenanceController.addField();

                                            Get.to(MaintenanceViewSupervisor(
                                                await maintenanceController
                                                    .vehicleDetailsData));
                                            // Get.to(ShowMaintenanceSheet(vehicleDetails.id));
                                          } else {
                                            // Get.to(AddMaintenanceSheet(
                                            //     vehicleDetails.id));
                                            // maintenanceController.textFieldAdd();
                                            // maintenanceController.addField();
                                            Get.to(MaintenanceView(
                                              VehicleName:
                                                  vehicleDetails.vehicleNo,
                                              vehicleID:
                                                  vehicleDetails.vehicleId,
                                              details: vehicleDetails,
                                              jobId: jobID,
                                            ));
                                          }
                                        } else {
                                          // maintenanceController.textFieldAdd();
                                          // maintenanceController.addField();

                                          Get.to(MaintenanceView(
                                            VehicleName:
                                                vehicleDetails.vehicleNo,
                                            vehicleID: vehicleDetails.vehicleId,
                                            details: vehicleDetails,
                                            jobId: jobID,
                                          ));
                                        }
                                      },
                                      child: CustTextStart(
                                          name: "Maintenance",
                                          size: 1.6,
                                          colors: Colors.black,
                                          fontWeightName: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.widthMultiplier * 1,
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.updateStatus("Idle");
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                      value: "Idle",
                                      activeColor: colorPrimary,
                                      focusColor: colorPrimary,
                                      visualDensity: VisualDensity(
                                        vertical: 0,
                                        horizontal: -4,
                                      ),
                                      groupValue: DJSController.vehStatus,
                                      // groupValue: vehicleDetails.vehStatus,
                                      onChanged: (value) {
                                        DJSController.updateStatus("Idle");
                                        print(
                                            "ONCHANGE IDLE  ${DJSController.vehStatus}");
                                      },
                                    ),
                                    CustTextStart(
                                        name: "Idle",
                                        size: 1.6,
                                        colors: Colors.black,
                                        fontWeightName: FontWeight.w400),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 2 * SizeConfig.widthMultiplier,
                              ),
                              CustTextStart(
                                  name: "Job Start and End Time : ",
                                  size: 1.8,
                                  colors: Colors.black,
                                  fontWeightName: FontWeight.w600),
                            ],
                          ),
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            //physics: ,
                            primary: false,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: DJSController.workTime.length,
                            itemBuilder: (BuildContext context, int index) =>
                                Container(
                              // height: 10 * SizeConfig.heightMultiplier,
                              width: 100 * SizeConfig.widthMultiplier,
                              color: Colors.white.withOpacity(0.7),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if ((index + 1) ==
                                              DJSController.workTime.length) {
                                            ApiClient.twoDateDifference(
                                                            DJSController.workTime[
                                                                        index][
                                                                    "e_date"] ??
                                                                DateTime.now(),
                                                            DateTime.now()) ==
                                                        0 ||
                                                    ApiClient.twoDateDifference(
                                                            DJSController.workTime[
                                                                        index][
                                                                    "e_date"] ??
                                                                0,
                                                            DateTime.now()) ==
                                                        null
                                                ? showDialog(
                                                    barrierDismissible: true,
                                                    context: context,
                                                    builder:
                                                        (BuildContext
                                                                context) =>
                                                            timeSectetion(
                                                              time: index == 0
                                                                  ? DateTime(
                                                                      DateTime.now()
                                                                          .year,
                                                                      DateTime.now()
                                                                          .month,
                                                                      DateTime.now()
                                                                          .day,
                                                                      0,
                                                                      00,
                                                                      00)
                                                                  : ApiClient.twoDateDifference(DJSController.workTime[index - 1]["e_date"] ?? DateTime.now(), DateTime.now()) ==
                                                                          0
                                                                      ? DJSController.workTime[index - 1]
                                                                              [
                                                                              'eTime'] ??
                                                                          0
                                                                      : DateTime(
                                                                          DateTime.now()
                                                                              .year,
                                                                          DateTime.now()
                                                                              .month,
                                                                          DateTime.now()
                                                                              .day,
                                                                          0,
                                                                          00,
                                                                          00),
                                                              //DateTime(02,58,00),
                                                              isstartTime: true,
                                                              index: index,
                                                              worktime:
                                                                  DJSController
                                                                      .workTime,
                                                            ))
                                                /*      :
                                  showDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (BuildContext context) =>
                                          timeSectetion(
                                            time: (index == 0)?
                                            DJSController.workTime[index]["start_time"] !="00:00"
                                                ? DateTime(DateTime.now().year,
                                                DateTime.now().month,
                                                DateTime.now().day,
                                                0,
                                                00,
                                                00)
                                                : DJSController.workTime[index]['sTime']
                                                : DJSController.workTime[index - 1]['eTime'],
                                            //DateTime(02,58,00),
                                            isstartTime: true,
                                            index: index,
                                          ))*/
                                                : Container();
                                          }
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                                height: 1 *
                                                    SizeConfig
                                                        .heightMultiplier),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 2 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                ),
                                                Icon(Remix.history_line,
                                                    size: 6 *
                                                        SizeConfig
                                                            .imageSizeMultiplier,
                                                    color: Colors.black),
                                                SizedBox(
                                                  width: 2 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                ),
                                                CustTextStart(
                                                  name: DJSController
                                                          .workTime[index]
                                                      ["start_time"],
                                                  size: 1.8,
                                                  colors: Colors.black,
                                                  fontWeightName:
                                                      FontWeight.w600,
                                                ),
                                              ],
                                            ),
                                            // SizedBox(height: 1 * SizeConfig.heightMultiplier),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: SizeConfig
                                                              .widthMultiplier *
                                                          9,
                                                    ),
                                                    CustTextStart(
                                                        name: DJSController.workTime[
                                                                        index][
                                                                    "s_date"] !=
                                                                null
                                                            ? "${ApiClient.convertCurrDate(DJSController.workTime[index]["s_date"].toString())}"
                                                            : "${ApiClient.convertCurrDate(DateTime.now().toString())}",
                                                        size: 1.4,
                                                        colors: Colors.black54,
                                                        fontWeightName:
                                                            FontWeight.w400),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 2 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 2 *
                                                          SizeConfig
                                                              .widthMultiplier,
                                                    ),
                                                    CustTextStart(
                                                        name: "Work Time :",
                                                        size: 1.6,
                                                        colors: Colors.black,
                                                        fontWeightName:
                                                            FontWeight.w600),
                                                    SizedBox(
                                                      width: 2 *
                                                          SizeConfig
                                                              .widthMultiplier,
                                                    ),
                                                    CustTextStart(
                                                        name: DJSController
                                                                .workTime[index]
                                                            ["Work_time"],
                                                        size: 1.8,
                                                        colors: Colors.black,
                                                        fontWeightName:
                                                            FontWeight.w400),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                                height: 1 *
                                                    SizeConfig
                                                        .heightMultiplier),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          print(
                                              "${DJSController.workTime[index]["end_time"]}");
                                          if (DJSController.workTime[index]
                                                  ["start_time"] !=
                                              "00:00") {
                                            if ((index + 1) ==
                                                DJSController.workTime.length) {
                                              ApiClient.twoDateDifference(
                                                          DJSController.workTime[index]
                                                                  ["s_date"] ??
                                                              DateTime.now(),
                                                          DateTime.now()) ==
                                                      0
                                                  ? showDialog(
                                                      barrierDismissible: true,
                                                      context: context,
                                                      builder: (BuildContext context) =>
                                                          timeSectetion(
                                                            time: DJSController
                                                                    .workTime[
                                                                index]['sTime'],
                                                            isstartTime: false,
                                                            index: index,
                                                            worktime:
                                                                DJSController
                                                                    .workTime,
                                                          ))
                                                  : ApiClient.twoDateDifference(
                                                                  DJSController
                                                                          .workTime[index]
                                                                      [
                                                                      "s_date"],
                                                                  DateTime
                                                                      .now()) ==
                                                              1 ||
                                                          ApiClient.twoDateDifference(
                                                                  DJSController
                                                                          .workTime[index]
                                                                      ["s_date"],
                                                                  DateTime.now()) ==
                                                              null
                                                      ? showDialog(
                                                          barrierDismissible: true,
                                                          context: context,
                                                          builder: (BuildContext context) => timeSectetion(
                                                                time: DateTime(
                                                                    DateTime.now()
                                                                        .year,
                                                                    DateTime.now()
                                                                        .month,
                                                                    DateTime.now()
                                                                        .day,
                                                                    0,
                                                                    00,
                                                                    00),
                                                                isstartTime:
                                                                    false,
                                                                index: index,
                                                                worktime:
                                                                    DJSController
                                                                        .workTime,
                                                              ))
                                                      : Container();
                                            }
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  CustomDialog(
                                                      "Please select Start Time First"),
                                            );
                                          }
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                                height: 1 *
                                                    SizeConfig
                                                        .heightMultiplier),
                                            Row(
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 2 *
                                                          SizeConfig
                                                              .widthMultiplier,
                                                    ),
                                                    Icon(Remix.history_line,
                                                        size: 6 *
                                                            SizeConfig
                                                                .imageSizeMultiplier,
                                                        color: Colors.black),
                                                    SizedBox(
                                                      width: 2 *
                                                          SizeConfig
                                                              .widthMultiplier,
                                                    ),
                                                    CustTextStart(
                                                        name: DJSController
                                                                .workTime[index]
                                                            ["end_time"],
                                                        size: 1.8,
                                                        colors: Colors.black,
                                                        fontWeightName:
                                                            FontWeight.w600),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: SizeConfig
                                                          .widthMultiplier *
                                                      10,
                                                ),
                                                CustTextStart(
                                                    name: DJSController.workTime[
                                                                    index]
                                                                ["e_date"] !=
                                                            null
                                                        ? "${ApiClient.convertCurrDate(DJSController.workTime[index]["e_date"].toString())}"
                                                        : "${ApiClient.convertCurrDate(DateTime.now().toString())}",
                                                    size: 1.4,
                                                    colors: Colors.black54,
                                                    fontWeightName:
                                                        FontWeight.w400),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 4.3 *
                                                  SizeConfig.heightMultiplier,
                                            ),
                                            SizedBox(
                                                height: 1 *
                                                    SizeConfig
                                                        .heightMultiplier),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              height: 1 *
                                                  SizeConfig.heightMultiplier),
                                          (index + 1) ==
                                                  DJSController.workTime.length
                                              ? Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 2 *
                                                          SizeConfig
                                                              .widthMultiplier,
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          DJSController
                                                              .addWorkTime(
                                                                  index, false);
                                                        },
                                                        child: DJSController
                                                                    .workTime
                                                                    .length !=
                                                                1
                                                            ? /*DJSController.jobDate.compareTo(currentDate)==00 */ /*!= currentDate*/ /* && (DJSController.workTime.last["end_date"]) != currentDate ?*/
                                                            ApiClient.twoDateDifference(DJSController.workTime[index]["s_date"], DateTime.now()) ==
                                                                        0 ||
                                                                    ApiClient.twoDateDifference(
                                                                            DJSController.workTime[index][
                                                                                "s_date"],
                                                                            DateTime
                                                                                .now()) ==
                                                                        null
                                                                ? Icon(
                                                                    Remix
                                                                        .checkbox_indeterminate_fill,
                                                                    size: 7 *
                                                                        SizeConfig
                                                                            .imageSizeMultiplier,
                                                                    color:
                                                                        colorPrimary)
                                                                : Container()
                                                            : Container() /*:Container()*/),
                                                    SizedBox(
                                                      width: 4 *
                                                          SizeConfig
                                                              .widthMultiplier,
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          if (DJSController
                                                              .checkEndTime()) {
                                                            DJSController
                                                                .addWorkTime(
                                                                    index,
                                                                    true);
                                                          } else {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    CustomDialog(
                                                                        "Please select Time "));
                                                          }
                                                        },
                                                        child: Icon(
                                                            Remix.add_box_fill,
                                                            size: 7 *
                                                                SizeConfig
                                                                    .imageSizeMultiplier,
                                                            color:
                                                                colorPrimary)),
                                                    SizedBox(
                                                        width: 2 *
                                                            SizeConfig
                                                                .widthMultiplier),
                                                  ],
                                                )
                                              : Container(
                                                  width: 20 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                              //   height: 40 * SizeConfig.heightMultiplier,
                              width: 100 * SizeConfig.widthMultiplier,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.all(Radius.circular(
                                    1 * SizeConfig.widthMultiplier)),
                                border: Border.all(
                                    width: 0.0 * SizeConfig.widthMultiplier,
                                    color: Colors.grey,
                                    strokeAlign: BorderSide.strokeAlignCenter),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height:
                                            0.5 * SizeConfig.heightMultiplier,
                                      ),
                                      Row(
                                        children: [
                                          CustTextStart(
                                              name: "No. of Hours :",
                                              size: 1.8,
                                              colors: Colors.black,
                                              fontWeightName: FontWeight.w400),
                                          SizedBox(
                                            width:
                                                2 * SizeConfig.widthMultiplier,
                                          ),
                                          CustTextStart(
                                              // name: "${DJSController.totalH}",
                                              name: "${DJSController.totalH}",
                                              size: 2,
                                              colors: Colors.black,
                                              fontWeightName: FontWeight.w600),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 1 * SizeConfig.heightMultiplier,
                                      ),
                                      Row(
                                        children: [
                                          CustTextStart(
                                              name: "No. of Minutes :",
                                              size: 1.8,
                                              colors: Colors.black,
                                              fontWeightName: FontWeight.w400),
                                          SizedBox(
                                            width:
                                                2 * SizeConfig.widthMultiplier,
                                          ),
                                          CustTextStart(
                                              name: "${DJSController.totalM}",
                                              size: 2,
                                              colors: Colors.black,
                                              fontWeightName: FontWeight.w600),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 1 * SizeConfig.heightMultiplier,
                                      ),
                                      CustTextStart(
                                          name: "Job Description",
                                          size: 1.8,
                                          colors: Colors.black,
                                          fontWeightName: FontWeight.w600),
                                      SizedBox(
                                          height:
                                              1 * SizeConfig.heightMultiplier),
                                      Container(
                                        height:
                                            10 * SizeConfig.heightMultiplier,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(2 *
                                                  SizeConfig.widthMultiplier)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 2 *
                                                  SizeConfig.widthMultiplier,
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: TextFormField(
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.openSans(
                                              textStyle: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 1.6 *
                                                    SizeConfig.textMultiplier,
                                              ),
                                            ),
                                            // controller: DJSController.JobDescriptionController,
                                            controller: DJSController
                                                .JobDescriptionController,
                                            // controller : controller.JobDescriptionController,

                                            cursorColor: Colors.black,
                                            textInputAction:
                                                TextInputAction.next,
                                            focusNode: jobDescFocus,
                                            onFieldSubmitted: (term) {
                                              print("Decription");
                                              _fieldFocusChange(
                                                  context,
                                                  jobDescFocus,
                                                  machineReadingFocus);
                                            },
                                            maxLines: 5,
                                            decoration: InputDecoration(
                                              // labelText: "Enter Email",
                                              // isDense: true,
                                              contentPadding: EdgeInsets.only(
                                                top: 2 *
                                                    SizeConfig.widthMultiplier,
                                                left: 2 *
                                                    SizeConfig.widthMultiplier,
                                                right: 2 *
                                                    SizeConfig.widthMultiplier,
                                              ),
                                              constraints:
                                                  BoxConstraints.tightFor(
                                                      height: 10 *
                                                          SizeConfig
                                                              .heightMultiplier),
                                              fillColor:
                                                  const Color(0xFF689fef),
                                              /*contentPadding: new EdgeInsets.symmetric(
                                                  vertical:
                                                  2 * SizeConfig.widthMultiplier,
                                                  horizontal:
                                                  2 * SizeConfig.widthMultiplier),*/
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(2 *
                                                        SizeConfig
                                                            .widthMultiplier),
                                                borderSide: const BorderSide(
                                                  color: Color(0xFF689fef),
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(2 *
                                                        SizeConfig
                                                            .widthMultiplier),
                                                borderSide: const BorderSide(
                                                  color: Colors.transparent,
                                                ),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(2 *
                                                        SizeConfig
                                                            .widthMultiplier),
                                                borderSide: const BorderSide(
                                                  color: Color(0xFF689fef),
                                                  // width: 2.0,
                                                ),
                                              ),
                                              hintText: "Enter Job Description",
                                              hintStyle: GoogleFonts.openSans(
                                                  textStyle: TextStyle(
                                                color: const Color(0xFF888888),
                                                fontSize: 1.6 *
                                                    SizeConfig.textMultiplier,
                                                fontWeight: FontWeight.w400,
                                              )),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DJSController.jobDescription != ''
                                          ? CustText(
                                              name:
                                                  DJSController.jobDescription,
                                              size: 1.6,
                                              colors: Colors.red,
                                              fontWeightName: FontWeight.w400)
                                          : Container(),
                                    ]),
                              )),
                          SizedBox(
                            height: 1 * SizeConfig.heightMultiplier,
                          ),
                          Container(
                              //   height: 40 * SizeConfig.heightMultiplier,
                              width: 100 * SizeConfig.widthMultiplier,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          1 * SizeConfig.widthMultiplier)),
                                  border: Border.all(
                                      width: 0.0 * SizeConfig.widthMultiplier,
                                      color: Colors.grey,
                                      strokeAlign:
                                          BorderSide.strokeAlignCenter)),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        height:
                                            5.5 * SizeConfig.heightMultiplier,
                                        width: 100 * SizeConfig.widthMultiplier,
                                        color: colorPrimary,
                                        child: Center(
                                            child: CustText(
                                                name: "Machine Reading",
                                                size: 1.8,
                                                colors: Colors.white,
                                                fontWeightName:
                                                    FontWeight.w600))),
                                    SizedBox(
                                      height: 1 * SizeConfig.heightMultiplier,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 2 * SizeConfig.widthMultiplier,
                                        ),
                                        CustTextStart(
                                            name: "Reading :",
                                            size: 1.8,
                                            colors: Colors.black,
                                            fontWeightName: FontWeight.w400),
                                        SizedBox(
                                          width:
                                              10 * SizeConfig.widthMultiplier,
                                        ),
                                        Container(
                                          height:
                                              5.5 * SizeConfig.heightMultiplier,
                                          width:
                                              40 * SizeConfig.widthMultiplier,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(1 *
                                                    SizeConfig
                                                        .widthMultiplier)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 2 *
                                                    SizeConfig.widthMultiplier,
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: TextFormField(
                                              textAlign: TextAlign.start,
                                              style: GoogleFonts.openSans(
                                                textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 1.6 *
                                                      SizeConfig.textMultiplier,
                                                ),
                                              ),
                                              controller: DJSController
                                                  .machineReadingController,
                                              cursorColor: Colors.black,
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
                                                      decimal: true),
                                              inputFormatters: <TextInputFormatter>[
                                                // FilteringTextInputFormatter.digitsOnly
                                                FilteringTextInputFormatter
                                                    .allow(RegExp('[0-9.]+'))
                                              ],
                                              textInputAction:
                                                  TextInputAction.next,
                                              focusNode: machineReadingFocus,
                                              onFieldSubmitted: (term) {
                                                _fieldFocusChange(
                                                    context,
                                                    machineReadingFocus,
                                                    fuelAddedFocus);
                                              },
                                              onChanged: (value) {
                                                DJSController.machineReading =
                                                    value;
                                                DJSController
                                                    .machineReadingController
                                                    .text = value;
                                                print(
                                                    "Updated Machine Reading: ${DJSController.machineReading}");
                                              },
                                              maxLength: 9,
                                              decoration: InputDecoration(
                                                // labelText: "Enter Email",
                                                // isDense: true,
                                                counterText: "",
                                                contentPadding: EdgeInsets.only(
                                                  top: -0.5 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                  left: 2 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                  right: 2 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                ),
                                                constraints:
                                                    BoxConstraints.tightFor(
                                                        height: 5.5 *
                                                            SizeConfig
                                                                .heightMultiplier),
                                                fillColor:
                                                    const Color(0xFF689fef),
                                                /*contentPadding: new EdgeInsets.symmetric(
                                                vertical:
                                                2 * SizeConfig.widthMultiplier,
                                                horizontal:
                                                2 * SizeConfig.widthMultiplier),*/
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(1 *
                                                          SizeConfig
                                                              .widthMultiplier),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFF689fef),
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(1 *
                                                          SizeConfig
                                                              .widthMultiplier),
                                                  borderSide: const BorderSide(
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(1 *
                                                          SizeConfig
                                                              .widthMultiplier),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFF689fef),
                                                    // width: 2.0,
                                                  ),
                                                ),
                                                hintText: "Machine Reading",
                                                hintStyle: GoogleFonts.openSans(
                                                    textStyle: TextStyle(
                                                  color:
                                                      const Color(0xFF888888),
                                                  fontSize: 1.6 *
                                                      SizeConfig.textMultiplier,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Row(
                                    //   children: [
                                    //     SizedBox(
                                    //       width: 28 * SizeConfig.widthMultiplier,
                                    //     ),
                                    //     DJSController.machineReading != ''
                                    //         ? CustText(
                                    //             name:
                                    //                 DJSController.machineReading,
                                    //             size: 1.6,
                                    //             colors: Colors.red,
                                    //             fontWeightName: FontWeight.w400)
                                    //         : Container(),
                                    //   ],
                                    // ),
                                    SizedBox(
                                      height: 1 * SizeConfig.heightMultiplier,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 2 * SizeConfig.widthMultiplier,
                                        ),
                                        CustTextStart(
                                            name: "Capture Reading :",
                                            size: 1.8,
                                            colors: Colors.black,
                                            fontWeightName: FontWeight.w400),
                                        SizedBox(
                                          width: 8 * SizeConfig.widthMultiplier,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            print("object");
                                            print("${DJSController.image}");
                                            print("object");
                                            print(
                                                "${DJSController.monitoringImg}");
                                            print("object");
                                            DJSController.image != null
                                                ? showDialog(
                                                    barrierDismissible: true,
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        PhotoView(
                                                      photoLink:
                                                          DJSController.image!,
                                                      flag: true,
                                                    ),
                                                  )
                                                : DJSController.monitoringImg !=
                                                        ""
                                                    ? showDialog(
                                                        barrierDismissible:
                                                            true,
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            PhotoView(
                                                          photoLink:
                                                              '${RemoteServices.baseUrl + DJSController.monitoringImg}',
                                                          flag: false,
                                                        ),
                                                      )
                                                    : DJSController.get_image(
                                                        ImageSource.camera,
                                                      );
                                          },
                                          child: SafeArea(
                                            bottom: true,
                                            top: true,
                                            child: Container(
                                              height: 15 *
                                                  SizeConfig.widthMultiplier,
                                              width: 15 *
                                                  SizeConfig.widthMultiplier,
                                              child: DJSController.image != null
                                                  ? Image.file(
                                                      DJSController.image!,
                                                      fit: BoxFit.fitHeight,
                                                    )
                                                  : DJSController
                                                              .monitoringImg !=
                                                          ""
                                                      ? Image.network(
                                                          '${RemoteServices.baseUrl + DJSController.monitoringImg}',
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Icon(
                                                          Remix.camera_fill,
                                                          size: 15 *
                                                              SizeConfig
                                                                  .imageSizeMultiplier,
                                                          color: Colors.black,
                                                        ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5 * SizeConfig.widthMultiplier,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            // DJSController.get_image(
                                            //   ImageSource.camera,
                                            // );

                                            DJSController.get_image(
                                              ImageSource.camera,
                                            );
                                          },
                                          child: DJSController.image != null ||
                                                  DJSController.monitoringImg !=
                                                      ""
                                              ? Row(
                                                  children: [
                                                    CustText(
                                                        name: "Retake",
                                                        size: 1.7,
                                                        colors: Colors.black,
                                                        fontWeightName:
                                                            FontWeight.w600),
                                                    SizedBox(
                                                      width: 1 *
                                                          SizeConfig
                                                              .widthMultiplier,
                                                    ),
                                                    Icon(Remix.restart_fill,
                                                        size: 4 *
                                                            SizeConfig
                                                                .imageSizeMultiplier,
                                                        color: colorPrimary),
                                                  ],
                                                )
                                              : Container(),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        height:
                                            1 * SizeConfig.heightMultiplier),
                                  ])),
                          SizedBox(
                            height: 1 * SizeConfig.heightMultiplier,
                          ),
                          Container(
                              //   height: 40 * SizeConfig.heightMultiplier,
                              width: 100 * SizeConfig.widthMultiplier,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          1 * SizeConfig.widthMultiplier)),
                                  border: Border.all(
                                      width: 0.0 * SizeConfig.widthMultiplier,
                                      color: Colors.grey,
                                      strokeAlign:
                                          BorderSide.strokeAlignCenter)),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        height:
                                            5.5 * SizeConfig.heightMultiplier,
                                        width: 100 * SizeConfig.widthMultiplier,
                                        color: colorPrimary,
                                        child: Center(
                                            child: CustText(
                                                name: "Fuel Consumption",
                                                size: 1.8,
                                                colors: Colors.white,
                                                fontWeightName:
                                                    FontWeight.w600))),
                                    SizedBox(
                                      height: 1 * SizeConfig.heightMultiplier,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 2 * SizeConfig.widthMultiplier,
                                        ),
                                        CustTextStart(
                                            name: "Filled from : ",
                                            size: 1.8,
                                            colors: Colors.black,
                                            fontWeightName: FontWeight.w400),
                                        GestureDetector(
                                          onTap: () {
                                            DJSController.updateFuelStatus(
                                                "Tanker");
                                          },
                                          child: Row(
                                            children: [
                                              Radio(
                                                value: "Tanker",
                                                groupValue:
                                                    DJSController.fuelStatus,
                                                visualDensity: VisualDensity(
                                                  vertical: 0,
                                                  horizontal: -4,
                                                ),
                                                activeColor: colorPrimary,
                                                focusColor: colorPrimary,
                                                onChanged: (value) {
                                                  DJSController
                                                      .updateFuelStatus(
                                                          "Tanker");
                                                  print(
                                                      "Fuel TankerFuel Tanker  ${DJSController.fuelStatus}");
                                                },
                                              ),
                                              CustTextStart(
                                                  name: "Fuel Tanker",
                                                  size: 1.6,
                                                  colors: Colors.black,
                                                  fontWeightName:
                                                      FontWeight.w400),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: SizeConfig.widthMultiplier * 1,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            print(
                                                "Storage  ${DJSController.fuelStatus}");
                                            DJSController.updateFuelStatus(
                                                "Storage");
                                          },
                                          child: Row(
                                            children: [
                                              Radio(
                                                value: "Storage",
                                                groupValue:
                                                    DJSController.fuelStatus,
                                                activeColor: colorPrimary,
                                                focusColor: colorPrimary,
                                                visualDensity: VisualDensity(
                                                  vertical: 0,
                                                  horizontal: -4,
                                                ),
                                                onChanged: (value) {
                                                  DJSController
                                                      .updateFuelStatus(
                                                          "Storage");
                                                  print(
                                                      "Storage ${DJSController.fuelStatus}");
                                                },
                                              ),
                                              CustTextStart(
                                                  name: "Storage",
                                                  size: 1.6,
                                                  colors: Colors.black,
                                                  fontWeightName:
                                                      FontWeight.w400),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 1 * SizeConfig.heightMultiplier,
                                    ),
                                    ListView.builder(
                                        padding: EdgeInsets.zero,
                                        //physics: ,
                                        primary: false,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: DJSController
                                            .textFieldValues.length,
                                        itemBuilder: (BuildContext context,
                                                int innerIndex) =>
                                            Container(
                                                // height: 10 * SizeConfig.heightMultiplier,
                                                width: 100 *
                                                    SizeConfig.widthMultiplier,
                                                color: Colors.white
                                                    .withOpacity(0.7),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 1.5 *
                                                              SizeConfig
                                                                  .widthMultiplier,
                                                        ),
                                                        CustTextStart(
                                                            name:
                                                                "Fuel Added              :",
                                                            size: 1.8,
                                                            colors:
                                                                Colors.black,
                                                            fontWeightName:
                                                                FontWeight
                                                                    .w400),
                                                        SizedBox(
                                                          width: 10 *
                                                              SizeConfig
                                                                  .widthMultiplier,
                                                        ),
                                                        Container(
                                                          height: 5.5 *
                                                              SizeConfig
                                                                  .heightMultiplier,
                                                          width: 27 *
                                                              SizeConfig
                                                                  .widthMultiplier,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius
                                                                .all(Radius
                                                                    .circular(1 *
                                                                        SizeConfig
                                                                            .widthMultiplier)),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black12,
                                                                blurRadius: 2 *
                                                                    SizeConfig
                                                                        .widthMultiplier,
                                                              ),
                                                            ],
                                                          ),
                                                          child: Center(
                                                            child:
                                                                TextFormField(
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: GoogleFonts
                                                                  .openSans(
                                                                      textStyle:
                                                                          TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 1.6 *
                                                                    SizeConfig
                                                                        .textMultiplier,
                                                              )),
                                                              controller:
                                                                  DJSController
                                                                          .textControllers[
                                                                      innerIndex],
                                                              onChanged:
                                                                  (value) {
                                                                print(
                                                                    "object$value index $innerIndex");
                                                                DJSController
                                                                    .onValueChanged(
                                                                        innerIndex,
                                                                        value);
                                                              },
                                                              enabled: innerIndex ==
                                                                  DJSController
                                                                      .activeIndex,
                                                              cursorColor:
                                                                  Colors.black,
                                                              keyboardType: TextInputType
                                                                  .numberWithOptions(
                                                                      decimal:
                                                                          true),
                                                              inputFormatters: <TextInputFormatter>[
                                                                FilteringTextInputFormatter
                                                                    .allow(RegExp(
                                                                        '[0-9.]+'))
                                                              ],
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .next,
                                                              focusNode:
                                                                  fuelAddedFocus,
                                                              onFieldSubmitted:
                                                                  (term) {
                                                                _fieldFocusChange(
                                                                    context,
                                                                    fuelAddedFocus,
                                                                    ureaFocus);
                                                              },
                                                              maxLength: 5,
                                                              decoration:
                                                                  InputDecoration(
                                                                // labelText: "Enter Email",
                                                                // isDense: true,
                                                                counterText: "",
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .only(
                                                                  top: -0.5 *
                                                                      SizeConfig
                                                                          .widthMultiplier,
                                                                  left: 2 *
                                                                      SizeConfig
                                                                          .widthMultiplier,
                                                                  right: 2 *
                                                                      SizeConfig
                                                                          .widthMultiplier,
                                                                ),
                                                                constraints: BoxConstraints.tightFor(
                                                                    height: 5.5 *
                                                                        SizeConfig
                                                                            .heightMultiplier),
                                                                fillColor:
                                                                    const Color(
                                                                        0xFF689fef),
                                                                /*contentPadding: new EdgeInsets.symmetric(
                                                vertical:
                                                2 * SizeConfig.widthMultiplier,
                                                horizontal:
                                                2 * SizeConfig.widthMultiplier),*/
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(1 *
                                                                          SizeConfig
                                                                              .widthMultiplier),
                                                                  borderSide:
                                                                      const BorderSide(
                                                                    color: Color(
                                                                        0xFF689fef),
                                                                  ),
                                                                ),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(1 *
                                                                          SizeConfig
                                                                              .widthMultiplier),
                                                                  borderSide:
                                                                      const BorderSide(
                                                                    color: Colors
                                                                        .transparent,
                                                                  ),
                                                                ),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(1 *
                                                                          SizeConfig
                                                                              .widthMultiplier),
                                                                  borderSide:
                                                                      const BorderSide(
                                                                    color: Color(
                                                                        0xFF689fef),
                                                                    // width: 2.0,
                                                                  ),
                                                                ),
                                                                hintText:
                                                                    "Add Fuel Here",
                                                                hintStyle: GoogleFonts
                                                                    .openSans(
                                                                        textStyle:
                                                                            TextStyle(
                                                                  color: const Color(
                                                                      0xFF888888),
                                                                  fontSize: 1.6 *
                                                                      SizeConfig
                                                                          .textMultiplier,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                )),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 5 *
                                                              SizeConfig
                                                                  .widthMultiplier,
                                                        ),
                                                        /*innerIndex == DJSController.activeIndex && innerIndex > 0*/
                                                        (innerIndex + 1) ==
                                                                    DJSController
                                                                        .textControllers
                                                                        .length &&
                                                                innerIndex > 0
                                                            ? GestureDetector(
                                                                onTap: () {
                                                                  DJSController
                                                                      .addField(
                                                                          innerIndex,
                                                                          false);
                                                                  // DJSController.deleteField(innerIndex);
                                                                },
                                                                child: Icon(
                                                                    Remix
                                                                        .checkbox_indeterminate_fill,
                                                                    size: 7 *
                                                                        SizeConfig
                                                                            .imageSizeMultiplier,
                                                                    color:
                                                                        colorPrimary),
                                                              )
                                                            : Container(),
                                                        (innerIndex + 1) ==
                                                                DJSController
                                                                    .textControllers
                                                                    .length
                                                            ? GestureDetector(
                                                                onTap: () {
                                                                  print(
                                                                      "HERE${DJSController.textFieldValues[0]}");
                                                                  DJSController.fuelValidation(
                                                                              innerIndex) ==
                                                                          true
                                                                      ? showDialog(
                                                                          context:
                                                                              context,
                                                                          builder: (BuildContext context) =>
                                                                              CustomDialog("Please Add Fuel !"))
                                                                      : Container();
                                                                },
                                                                child: Icon(
                                                                    Remix
                                                                        .add_box_fill,
                                                                    size: 7 *
                                                                        SizeConfig
                                                                            .imageSizeMultiplier,
                                                                    color:
                                                                        colorPrimary),
                                                              )
                                                            : Container(),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 1 *
                                                          SizeConfig
                                                              .heightMultiplier,
                                                    ),
                                                  ],
                                                ))),
                                    Row(
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width:
                                              50 * SizeConfig.widthMultiplier,
                                        ),
                                        DJSController.emptyFuel
                                            ? CustText(
                                                name: "Please Enter Fuel",
                                                size: 1.6,
                                                colors: Colors.red,
                                                fontWeightName: FontWeight.w400)
                                            : Container(),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 1 * SizeConfig.heightMultiplier,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 2 * SizeConfig.widthMultiplier,
                                        ),
                                        CustTextStart(
                                            name:
                                                "Urea Percentage\nLevel                         :",
                                            size: 1.8,
                                            colors: Colors.black,
                                            fontWeightName: FontWeight.w400),
                                        SizedBox(
                                          width:
                                              10 * SizeConfig.widthMultiplier,
                                        ),
                                        Container(
                                          height:
                                              5.5 * SizeConfig.heightMultiplier,
                                          width:
                                              40 * SizeConfig.widthMultiplier,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(1 *
                                                    SizeConfig
                                                        .widthMultiplier)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 2 *
                                                    SizeConfig.widthMultiplier,
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: TextFormField(
                                              textAlign: TextAlign.start,
                                              style: GoogleFonts.openSans(
                                                  textStyle: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 1.6 *
                                                    SizeConfig.textMultiplier,
                                              )),
                                              controller:
                                                  DJSController.ureaController,
                                              cursorColor: Colors.black,
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
                                                      decimal: true),
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .allow(RegExp('[0-9.]+'))
                                              ],
                                              textInputAction:
                                                  TextInputAction.done,
                                              focusNode: ureaFocus,
                                              onFieldSubmitted: (value) {
                                                ureaFocus.unfocus();
                                                //  _calculator();
                                              },
                                              maxLength: 5,
                                              decoration: InputDecoration(
                                                // labelText: "Enter Email",
                                                // isDense: true,
                                                counterText: "",
                                                contentPadding: EdgeInsets.only(
                                                  top: -0.5 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                  left: 2 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                  right: 2 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                ),
                                                constraints:
                                                    BoxConstraints.tightFor(
                                                        height: 5.5 *
                                                            SizeConfig
                                                                .heightMultiplier),
                                                fillColor:
                                                    const Color(0xFF689fef),
                                                /*contentPadding: new EdgeInsets.symmetric(
                                                vertical:
                                                2 * SizeConfig.widthMultiplier,
                                                horizontal:
                                                2 * SizeConfig.widthMultiplier),*/
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(1 *
                                                          SizeConfig
                                                              .widthMultiplier),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFF689fef),
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(1 *
                                                          SizeConfig
                                                              .widthMultiplier),
                                                  borderSide: const BorderSide(
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(1 *
                                                          SizeConfig
                                                              .widthMultiplier),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFF689fef),
                                                    // width: 2.0,
                                                  ),
                                                ),
                                                hintText: "Urea",
                                                hintStyle: GoogleFonts.openSans(
                                                    textStyle: TextStyle(
                                                  color:
                                                      const Color(0xFF888888),
                                                  fontSize: 1.6 *
                                                      SizeConfig.textMultiplier,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 2 * SizeConfig.heightMultiplier,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 2 * SizeConfig.widthMultiplier,
                                        ),
                                        GestureDetector(
                                          child: CustTextStart(
                                              name:
                                                  "Fuel In                      :",
                                              size: 1.8,
                                              colors: Colors.black,
                                              fontWeightName: FontWeight.w400),
                                        ),
                                        SizedBox(
                                          width: 8 * SizeConfig.widthMultiplier,
                                        ),
                                        CustTextStart(
                                            name: "Litres ",
                                            size: 1.8,
                                            colors: Colors.black,
                                            fontWeightName: FontWeight.w400),
                                      ],
                                    ),
                                    SizedBox(
                                        height:
                                            1 * SizeConfig.heightMultiplier),
                                  ])),
                          SizedBox(
                            height: 3 * SizeConfig.heightMultiplier,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  DJSController.checkEndTime();
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  print(
                                      "Machine Reading 1: ${double.tryParse(DJSController.machineReadingController.text.toString())}");
                                  print(
                                      "Machine Reading 2: ${DJSController.machineReadingController.text}");
                                  bool readValidation = false;

                                  if (DJSController
                                              .machineReadingController.text
                                              .trim() ==
                                          '' ||
                                      DJSController
                                              .machineReadingController.text
                                              .trim() ==
                                          null) {
                                    readValidation = true;
                                  } else {
                                    print(
                                        "readValidation 12: ${readValidation}");
                                    readValidation = double.tryParse(
                                            DJSController
                                                .machineReadingController.text
                                                .trim()
                                                .toString())! >=
                                        double.tryParse(DJSController
                                            .readingData
                                            .toString())!;
                                    currentReading = double.tryParse(
                                        DJSController
                                            .machineReadingController.text)!;
                                    lastReading = double.tryParse(
                                        DJSController.readingData.toString())!;
                                  }
                                  if (readValidation ||
                                      DJSController
                                              .machineReadingController.text ==
                                          '' ||
                                      double.tryParse(DJSController
                                              .machineReadingController.text) ==
                                          0) {
                                    if (await CheckInternet.checkInternet()) {
                                      log('----------------in internet ');
                                      log('----last-----${lastReading.toString()}');
                                      log('----current-----${currentReading.toString()}');
                                      if (lastReading != 0.0) {
                                        log('----last-----${lastReading.toString()}');
                                        log('----current-----${currentReading.toString()}');
                                        readmaxValidation =
                                            (DJSController.readingIn ?? "Km") ==
                                                    "Km"
                                                ? 500.0
                                                : 24.0;
                                        if (currentReading - lastReading >=
                                            readmaxValidation) {
                                          bool? isConfirmed = await showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                ConfirmationDialogDaily((DJSController
                                                                .readingIn ??
                                                            "Km") ==
                                                        "Km"
                                                    ? 'Reading Difference should not be greater than 500 Kms, Are you sure you want to add ?'
                                                    : 'Reading Difference should not be greater than 24 Hrs, Are you sure you want to add ?'),
                                          );

                                          if (isConfirmed == true) {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) =>
                                                  CustomLoadingPopup(),
                                            );

                                            await DJSController
                                                .addDailyJobSheet(
                                                    vehicleDetails.vehicleId,
                                                    jobID,
                                                    context,
                                                    1,
                                                    1);

                                            Get.back(); // Close the loading dialog.
                                          } else {
                                            log("User canceled the operation.");
                                          }
                                        } else {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) =>
                                                CustomLoadingPopup(),
                                          );
                                          await DJSController.addDailyJobSheet(
                                              vehicleDetails.vehicleId,
                                              jobID,
                                              context,
                                              1,
                                              0);
                                          await ApiClient.box
                                              .remove('job_$jobID');
                                          Get.back(); // Close the loading dialog.
                                        }
                                      } else {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) =>
                                              CustomLoadingPopup(),
                                        );
                                        await DJSController.addDailyJobSheet(
                                            vehicleDetails.vehicleId,
                                            jobID,
                                            context,
                                            1,
                                            0);
                                        Get.back(); // Close the loading dialog.
                                      }
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              CustomDialog(
                                                  "Please check your internet connection"));
                                    }
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            CustomDialog(
                                                "Please select Reading greater than previous reading "));
                                  }

                                  /*       if(DJSController.machineReading =='' && DJSController.fuelAdded ==''
                              && DJSController.urea =='' && DJSController.jobDescription ==''){
      
      
      
                        }*/
                                  if (DJSController.isProcessing.value) return;
                                  DJSController.isProcessing.value = true;
                                },
                                child: Container(
                                    height: 5.5 * SizeConfig.heightMultiplier,
                                    width: 35 * SizeConfig.widthMultiplier,
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(2 *
                                                SizeConfig.widthMultiplier)),
                                        border: Border.all(
                                            width: 0.0 *
                                                SizeConfig.widthMultiplier,
                                            color: Colors.grey,
                                            strokeAlign:
                                                BorderSide.strokeAlignCenter)),
                                    child: Center(
                                        child: CustText(
                                            name: "Save in Draft",
                                            size: 1.8,
                                            colors: Colors.black,
                                            fontWeightName: FontWeight.w600))),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 3 * SizeConfig.heightMultiplier,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  // print(
                                  //     "Machine Reading: ${DJSController.machineReading}");

                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  if (DJSController.vehStatus ==
                                          "In Working" /* ||
                            DJSController.vehStatus == "Awaiting Maintenance"*/
                                      ) {
                                    print(
                                        "Machine Reading 1: ${double.tryParse(DJSController.machineReadingController.text.toString())}");

                                    bool readValidation = false;
                                    if (DJSController
                                        .machineReadingController.text
                                        .trim()
                                        .isNotEmpty) {
                                      readValidation = double.tryParse(
                                              DJSController
                                                  .machineReadingController.text
                                                  .trim()
                                                  .toString())! >=
                                          double.tryParse(DJSController
                                              .readingData
                                              .toString())!;
                                      print(
                                          "readValidation 1: ${readValidation}");
                                    } else {
                                      readValidation = true;
                                    }
                                    // int? machineReading =
                                    //      int.tryParse(machineReadingController.text.toString());
                                    // int? readingDatafinal = int.tryParse(readingData.toString());
                                    // print("Machine Reading: $machineReading");
                                    // print("Reading Data: $readingData");

                                    DJSController.Validation();
                                    // if (DJSController.isProcessing.value) return;

                                    // DJSController.isProcessing.value = true;
                                    {
                                      if (DJSController.checkEndTime()) {
                                        if (DJSController.jobDescription ==
                                                        '' &&
                                                    DJSController
                                                                .textFieldValues[
                                                            0] !=
                                                        "" &&
                                                    DJSController
                                                            .machineReadingController
                                                            .text ==
                                                        '' ||
                                                double.tryParse(DJSController
                                                        .machineReadingController
                                                        .text) ==
                                                    0 ||
                                                // ignore: unnecessary_null_comparison
                                                DJSController
                                                        .machineReadingController
                                                        .text ==
                                                    null ||
                                                readValidation
                                            // (machineReading! >= readingData!)

                                            ) {
                                          if (DJSController.image != null ||
                                              DJSController.monitoringImg !=
                                                  "") {
                                            //           if (await CheckInternet
                                            //               .checkInternet()) {
                                            //             showDialog(
                                            //                 context: context,
                                            //                 builder:
                                            //                     (BuildContext context) =>
                                            //                         CustomLoadingPopup());
                                            //             print(
                                            //                 "Machine Reading: Api Calll ${DJSController.machineReading}");

                                            //             await DJSController
                                            //                 .addDailyJobSheet(
                                            //                     vehicleDetails.vehicleId,
                                            //                     jobID,
                                            //                     context,
                                            //                     0);
                                            //             Get.back();
                                            //             // print("DJSController.status :: ${DJSController.status}");
                                            //             /*     if(DJSController.status == 1){
                                            //    Navigator.pop(context);
                                            //    showDialog(context: context, builder: (BuildContext context) => CustomDialog(DJSController.msg));
                                            //  }else{
                                            //    showDialog(context: context, builder: (BuildContext context) => CustomDialog(DJSController.msg));
                                            //  }*/
                                            //           }

                                            bool readValidation = false;

                                            if (DJSController
                                                        .machineReadingController
                                                        .text
                                                        .trim() ==
                                                    '' ||
                                                DJSController
                                                        .machineReadingController
                                                        .text
                                                        .trim() ==
                                                    null) {
                                              readValidation = true;
                                            } else {
                                              print(
                                                  "readValidation 12: ${readValidation}");
                                              readValidation = double.tryParse(
                                                      DJSController
                                                          .machineReadingController
                                                          .text
                                                          .trim()
                                                          .toString())! >=
                                                  double.tryParse(DJSController
                                                      .readingData
                                                      .toString())!;
                                              currentReading = double.tryParse(
                                                  DJSController
                                                      .machineReadingController
                                                      .text)!;
                                              lastReading = double.tryParse(
                                                  DJSController.readingData
                                                      .toString())!;
                                            }
                                            if (readValidation ||
                                                DJSController
                                                        .machineReadingController
                                                        .text ==
                                                    '' ||
                                                double.tryParse(DJSController
                                                        .machineReadingController
                                                        .text) ==
                                                    0) {
                                              if (await CheckInternet
                                                  .checkInternet()) {
                                                log('----------------in internet ');
                                                log('----last-----${lastReading.toString()}');
                                                log('----current-----${currentReading.toString()}');
                                                if (lastReading != 0.0) {
                                                  log('----last-----${lastReading.toString()}');
                                                  log('----current-----${currentReading.toString()}');
                                                  readmaxValidation =
                                                      (DJSController.readingIn ??
                                                                  "Km") ==
                                                              "Km"
                                                          ? 500.0
                                                          : 24.0;
                                                  if (currentReading -
                                                          lastReading >=
                                                      readmaxValidation) {
                                                    bool? isConfirmed =
                                                        await showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          ConfirmationDialogDaily(
                                                              (DJSController.readingIn ??
                                                                          "Km") ==
                                                                      "Km"
                                                                  ? 'Reading Difference should not be greater than 500 Kms, Are you sure you want to add ?'
                                                                  : 'Reading Difference should not be greater than 24 Hrs, Are you sure you want to add ?'),
                                                    );

                                                    if (isConfirmed == true) {
                                                      showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        builder: (BuildContext
                                                                context) =>
                                                            CustomLoadingPopup(),
                                                      );

                                                      await DJSController
                                                          .addDailyJobSheet(
                                                              vehicleDetails
                                                                  .vehicleId,
                                                              jobID,
                                                              context,
                                                              0,
                                                              1);

                                                      Get.back(); // Close the loading dialog.
                                                    } else {
                                                      log("User canceled the operation.");
                                                    }
                                                  } else {
                                                    showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (BuildContext
                                                              context) =>
                                                          CustomLoadingPopup(),
                                                    );
                                                    await DJSController
                                                        .addDailyJobSheet(
                                                            vehicleDetails
                                                                .vehicleId,
                                                            jobID,
                                                            context,
                                                            0,
                                                            0);
                                                    Get.back(); // Close the loading dialog.
                                                  }
                                                } else {
                                                  showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (BuildContext
                                                            context) =>
                                                        CustomLoadingPopup(),
                                                  );
                                                  await DJSController
                                                      .addDailyJobSheet(
                                                          vehicleDetails
                                                              .vehicleId,
                                                          jobID,
                                                          context,
                                                          0,
                                                          0);
                                                  Get.back(); // Close the loading dialog.
                                                }
                                              } else {
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        CustomDialog(
                                                            "Please check your internet connection"));
                                              }
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                          context) =>
                                                      CustomDialog(
                                                          "Please select Reading greater than previous reading "));
                                            }
                                          } else {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext
                                                        context) =>
                                                    CustomDialog(
                                                        "Please Upload Image"));
                                          }
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  CustomDialog(
                                                      "Please select Reading greater than previous reading "));
                                        }
                                      } else {
                                        // showDialog(
                                        //     context: context,
                                        //     builder: (BuildContext context) =>
                                        //         CustomDialog(
                                        //             "Please select Reading greater than previous reading "));
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                CustomDialog(
                                                    "Please select end time "));
                                      }
                                    }
                                  } else {
                                    if (await CheckInternet.checkInternet()) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              CustomLoadingPopup());
                                      await DJSController.addDailyJobSheet(
                                          vehicleDetails.vehicleId,
                                          jobID,
                                          context,
                                          0,
                                          0);

                                      Get.back();
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              CustomDialog(
                                                  "Please check your internet connection"));
                                    }
                                  }
                                },
                                child: Container(
                                    height: 5.5 * SizeConfig.heightMultiplier,
                                    width: 35 * SizeConfig.widthMultiplier,
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(2 *
                                                SizeConfig.widthMultiplier)),
                                        border: Border.all(
                                            width: 0.0 *
                                                SizeConfig.widthMultiplier,
                                            color: Colors.grey,
                                            strokeAlign:
                                                BorderSide.strokeAlignCenter)),
                                    child: Center(
                                        child: CustText(
                                            name: "Submit",
                                            size: 1.8,
                                            colors: Colors.black,
                                            fontWeightName: FontWeight.w600))),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 3 * SizeConfig.heightMultiplier,
                          ),
                        ],
                      )
                    : Container(),
              ],
            )),
          ),
        ),
      ),
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
