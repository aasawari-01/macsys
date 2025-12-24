import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:macsys/component/custom_widget/custom_loading_popup.dart';
import 'package:macsys/component/job_details/job_details_controller.dart';
import 'package:macsys/component/jobs/job_controller.dart';
import 'package:macsys/maintaince/maintainance_view.dart';
import 'package:macsys/maintaince/maintaince_controller.dart';
import 'package:macsys/maintaince/maintaince_view_supervisor.dart';
import 'package:macsys/maintaince/vehicle_maintaince_list_model.dart';
import 'package:remixicon/remixicon.dart';

import '../../services/remote_services.dart';
import '../../util/ApiClient.dart';
import '../../util/CustomLoading.dart';
import '../../util/SizeConfig.dart';
import '../custom_widget/colorsC.dart';
import '../custom_widget/cust_text.dart';
import '../custom_widget/cust_text_start.dart';
import '../daily_job_sheet/daily_job_shee_view.dart';
import '../daily_job_sheet/daily_job_sheet_controller.dart';

class JobsDetilasView extends StatelessWidget {
  var jobID;
  DateTime dateTime = DateTime.now();

  JobsDetilasView(jobID, VehicleDetails) {
    this.jobID = jobID;
  }

  final FocusNode searchReadingFocus = FocusNode();
  var jobsDetailsController = Get.put(JobsDetailsController());
  var maintenanceController = Get.put(MaintenanceController());
  var jobsController = Get.put(JobsController());

  var DJSController = Get.put(DailyJobSheetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrimaryDark,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: SizedBox(
            width: 50,
            height: 50,
            child: Icon(
              Remix.arrow_left_line,
              size: 6 * SizeConfig.imageSizeMultiplier,
              color: Colors.white,
            ),
          ),
        ),
        title: CustText(
            name: "Job Details",
            size: 2.2,
            colors: Colors.white,
            fontWeightName: FontWeight.w600),
        actions: [
          GestureDetector(
            onTap: () async {
              var jobsDetailsController = Get.put(JobsDetailsController());
              String jobId = "${jobsDetailsController.jobsList.id}";
              await ApiClient.gs.remove('job_$jobId');
              var removedData = await ApiClient.gs.read('job_$jobID');
              log("job_$jobID from GetStorage after removal: $removedData");
              await jobsDetailsController.getJobDetails(
                "${jobId}",
              );
            },
            child: Container(
              width: 50,
              height: 50,
              child: Icon(
                Icons.refresh_sharp,
                size: 28,
                color: Colors.white,
              ),
            ),
          ),
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
          Container(
            height: 100 * SizeConfig.heightMultiplier,
            width: 100 * SizeConfig.widthMultiplier,
            color: Colors.white.withOpacity(0.9),
            child: GetBuilder<JobsDetailsController>(
              init: JobsDetailsController(),
              builder: (controller) => jobsDetailsController.status == true
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(2 * SizeConfig.widthMultiplier),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  child: Container(
                                      width: 90 * SizeConfig.widthMultiplier,
                                      child: CustTextStart(
                                          name:
                                              "Before start work read/ understand job details carefully",
                                          size: 1.8,
                                          colors: colorPrimary,
                                          fontWeightName: FontWeight.w600)),
                                ),
                              ],
                            ),
                            SizedBox(height: 1 * SizeConfig.heightMultiplier),
                            showDetails("Job Date",
                                "${ApiClient.convertDate(jobsDetailsController.jobsList.fromDate.toString())}"),
                            SizedBox(height: 1 * SizeConfig.heightMultiplier),
                            showDetails("Customer Name",
                                "${jobsDetailsController.jobsList.supervisorDetail.firstName} ${jobsDetailsController.jobsList.supervisorDetail.lastName}"),
                            SizedBox(height: 1 * SizeConfig.heightMultiplier),
                            // showDetails("Supervisor's Name","${jobsDetailsController.jobDetailsResult[0].supervisorName}"),
                            showDetails("Supervisor's Name",
                                "${jobsDetailsController.jobsList.customerName} "),
                            SizedBox(height: 1 * SizeConfig.heightMultiplier),
                            showDetails("Supervisor's Number",
                                "${jobsDetailsController.jobsList.supervisorDetail.personalMobile}"),
                            SizedBox(height: 1 * SizeConfig.heightMultiplier),
                            showDetails("Supervisor's Email",
                                "${jobsDetailsController.jobsList.supervisorDetail.personalEmail}"),
                            SizedBox(height: 1 * SizeConfig.heightMultiplier),
                            showDetails("Site Address",
                                "${jobsDetailsController.jobsList.siteAddress}"),

                            SizedBox(height: 1 * SizeConfig.heightMultiplier),
                            showDetails("Job Type",
                                "${jobsDetailsController.jobsList.type}"),

                            SizedBox(height: 1 * SizeConfig.heightMultiplier),
                            showDetails("Notes",
                                "${jobsDetailsController.jobsList.notes}"),
                            SizedBox(height: 1 * SizeConfig.heightMultiplier),
                            showDetails("Created Date",
                                "${ApiClient.convertDate(jobsDetailsController.jobsList.createdAt.toString())}"),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: TextFormField(
                                  onChanged: (term) {
                                    jobsDetailsController.filterList(term);
                                  },

                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 1.6 * SizeConfig.textMultiplier,
                                    ),
                                  ),
                                  // controller: DJSController.JobDescriptionController,
                                  cursorColor: Colors.black,
                                  textInputAction: TextInputAction.next,
                                  focusNode: searchReadingFocus,
                                  onFieldSubmitted: (term) {
                                    _fieldFocusChange(
                                        context, searchReadingFocus);
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.black,
                                      size: 6 * SizeConfig.imageSizeMultiplier,
                                    ),
                                    // labelText: "Enter Email",
                                    // isDense: true,
                                    contentPadding: EdgeInsets.only(
                                      top: 2 * SizeConfig.widthMultiplier,
                                      left: 2 * SizeConfig.widthMultiplier,
                                      right: 2 * SizeConfig.widthMultiplier,
                                    ),
                                    constraints: BoxConstraints.tightFor(
                                        height:
                                            5 * SizeConfig.heightMultiplier),
                                    fillColor: const Color(0xFF689fef),
                                    /*contentPadding: new EdgeInsets.symmetric(
                                              vertical:
                                              2 * SizeConfig.widthMultiplier,
                                              horizontal:
                                              2 * SizeConfig.widthMultiplier),*/
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          2 * SizeConfig.widthMultiplier),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF689fef),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          2 * SizeConfig.widthMultiplier),
                                      borderSide: const BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          2 * SizeConfig.widthMultiplier),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF689fef),
                                        // width: 2.0,
                                      ),
                                    ),
                                    hintText: "Search Vehicle",
                                    labelStyle: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                      color: const Color(0xFF888888),
                                      fontSize: 1.6 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.w400,
                                    )),
                                    hintStyle: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                      color: const Color(0xFF888888),
                                      fontSize: 1.6 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.w400,
                                    )),
                                  ),
                                ),
                              ),
                            ),

                            ListView.builder(
                              padding: EdgeInsets.zero,
                              // physics:ScrollPhysics() ,
                              primary: false,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: jobsDetailsController
                                  .filteredAssignVehicle.length,

                              itemBuilder: (BuildContext context, int index) {
                                if (jobsDetailsController.itemColors.isEmpty &&
                                    jobsDetailsController
                                        .filteredAssignVehicle.isNotEmpty) {
                                  for (int i = 0;
                                      i <
                                          jobsDetailsController
                                              .filteredAssignVehicle.length;
                                      i++) {
                                    jobsDetailsController.itemColors[i] =
                                        Colors.white;
                                  }
                                }
                                return Padding(
                                  padding: EdgeInsets.only(
                                      top: 0.5 * SizeConfig.heightMultiplier,
                                      bottom:
                                          0.5 * SizeConfig.heightMultiplier),
                                  child: GestureDetector(
                                    onTap: () async {
                                      // jobsDetailsController.filteredAssignVehicle[0].truckPlantUnitNo
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              CustomLoadingPopup());
                                      var maintenanceController =
                                          Get.put(MaintenanceController());
                                      maintenanceController.cleanData();
                                      maintenanceController
                                          .notesControllerData = '';
                                      maintenanceController.descControllerData =
                                          '';
                                      maintenanceController
                                          .locationControllerData = '';
                                      maintenanceController
                                          .machineReadingControllerData = '';

                                      maintenanceController
                                          .descriptionController
                                          .clear();
                                      maintenanceController.quantityController
                                          .clear();
                                      maintenanceController.amountController
                                          .clear();
                                      maintenanceController.descController
                                          .clear();
                                      maintenanceController.notesController
                                          .clear();
                                      maintenanceController.locationController
                                          .clear();
                                      maintenanceController
                                          .machineReadingController
                                          .clear();
                                      maintenanceController.controllers.clear();
                                      maintenanceController
                                          .quotationMaterialDescription
                                          .clear();
                                      maintenanceController.descriptionList
                                          .clear();
                                      maintenanceController.amountList.clear();
                                      maintenanceController.quantityList
                                          .clear();
                                      // maintenanceController.controllers
                                      //     .clear();
                                      // maintenanceController.instructionList
                                      //     .clear();
                                      maintenanceController.maintenanceReason
                                          .clear();
                                      maintenanceController.maintenanceReason
                                          .clear();
                                      maintenanceController
                                          .maintenanceReasonPhoto
                                          .clear();
                                      // maintenanceController
                                      //     .getMaintenanceDetails(
                                      //         jobsDetailsController
                                      //             .filteredAssignVehicle[index]
                                      //             .vehicleId);
                                      await maintenanceController
                                          .getVehicleMaintenance(
                                              true,
                                              jobsDetailsController
                                                  .filteredAssignVehicle[index]
                                                  .vehicleId,
                                              true);
                                      Get.back();
                                      // await maintenanceController
                                      //     .getVehicleMaintenanceList(
                                      //         true,
                                      //         jobsDetailsController
                                      //             .filteredAssignVehicle[index]
                                      //             .vehicleId,
                                      //         true);
                                      if (maintenanceController
                                              .vehicleMaintenanceDetail !=
                                          null) {
                                        maintenanceController.cleanData();
                                        // if (maintenanceController
                                        //         .vehicleMaintenanceDetail!
                                        //         .status ==
                                        //     0) {
                                        if (jobsDetailsController
                                                    .filteredAssignVehicle[
                                                        index]
                                                    .dailyJobSheet ==
                                                0 &&
                                            jobsDetailsController
                                                    .filteredAssignVehicle[
                                                        index]
                                                    .isdraft ==
                                                0) {
                                          ////-------------------loader-------------
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  CustomLoadingPopup());
                                          var DJSController = Get.put(
                                              DailyJobSheetController());
                                          DJSController.cleanData();
                                          DJSController.isDraft = '';
                                          log("--------------------------------1");
                                          await DJSController.getStatusData(
                                              jobsDetailsController
                                                  .filteredAssignVehicle[index]
                                                  .vehicleId);
                                          Get.back();
                                          Get.to(DailyJobSheetView(
                                            jobsDetailsController
                                                .filteredAssignVehicle[index],
                                            dateTime,
                                            jobsDetailsController
                                                .filteredAssignVehicle[index]
                                                .jobId,
                                            '${RemoteServices.baseUrl}${jobsDetailsController.filteredAssignVehicle[index].vehicleImage}',
                                            jobsDetailsController
                                                .jobsList.site_id,
                                            (jobsDetailsController
                                                        .filteredAssignVehicle[
                                                            index]
                                                        .transferstatus ==
                                                    "different"
                                                ? (jobsDetailsController
                                                            .filteredAssignVehicle[
                                                                index]
                                                            .jobId ==
                                                        jobsDetailsController
                                                            .jobsList.id
                                                    ? "Revert"
                                                    : "Accept")
                                                : "Transfer"),
                                          ));
                                        }
                                        if (jobsDetailsController
                                                    .filteredAssignVehicle[
                                                        index]
                                                    .dailyJobSheet ==
                                                1 &&
                                            jobsDetailsController
                                                    .filteredAssignVehicle[
                                                        index]
                                                    .isdraft ==
                                                1) {
                                          //Todo here///
                                          var DJSController = Get.put(
                                              DailyJobSheetController());
                                          DJSController.cleanData();
                                          ////-------------------loader-------------
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  CustomLoadingPopup());
                                          await DJSController.getDraftJobSheet(
                                              jobsDetailsController
                                                  .filteredAssignVehicle[index]
                                                  .vehicleId);
                                          log("--------------------------------2");

                                          Get.back();
                                          Get.to(DailyJobSheetView(
                                            jobsDetailsController
                                                .filteredAssignVehicle[index],
                                            /*jobsDetailsController
                                                .jobDetailsResult[0].dateTime,*/
                                            dateTime,
                                            jobsDetailsController
                                                .filteredAssignVehicle[index]
                                                .jobId,
                                            '${RemoteServices.baseUrl}${jobsDetailsController.filteredAssignVehicle[index].vehicleImage}',
                                            jobsDetailsController
                                                .jobsList.site_id,
                                            (jobsDetailsController
                                                        .filteredAssignVehicle[
                                                            index]
                                                        .transferstatus ==
                                                    "different"
                                                ? (jobsDetailsController
                                                            .filteredAssignVehicle[
                                                                index]
                                                            .jobId ==
                                                        jobsDetailsController
                                                            .jobsList.id
                                                    ? "Revert"
                                                    : "Accept")
                                                : "Transfer"),
                                          ));
                                          await DJSController.getStatusData(
                                              jobsDetailsController
                                                  .filteredAssignVehicle[index]
                                                  .vehicleId);
                                        }
                                        if (jobsDetailsController
                                                    .filteredAssignVehicle[
                                                        index]
                                                    .dailyJobSheet ==
                                                1 &&
                                            jobsDetailsController
                                                    .filteredAssignVehicle[
                                                        index]
                                                    .isdraft ==
                                                0) {
                                          //    Todo here///
                                          var DJSController = Get.put(
                                              DailyJobSheetController());
                                          DJSController.cleanData();
                                          ////-------------------loader-------------
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  CustomLoadingPopup());
                                          await DJSController.getDraftJobSheet(
                                              jobsDetailsController
                                                  .filteredAssignVehicle[index]
                                                  .vehicleId);
                                          log("--------------------------------3");

                                          Get.back();
                                          Get.to(DailyJobSheetView(
                                            jobsDetailsController
                                                .filteredAssignVehicle[index],
                                            /*jobsDetailsController
                                                .jobDetailsResult[0].dateTime,*/
                                            dateTime,
                                            jobsDetailsController
                                                .filteredAssignVehicle[index]
                                                .jobId,
                                            '${RemoteServices.baseUrl}${jobsDetailsController.filteredAssignVehicle[index].vehicleImage}',
                                            jobsDetailsController
                                                .jobsList.site_id,
                                            (jobsDetailsController
                                                        .filteredAssignVehicle[
                                                            index]
                                                        .transferstatus ==
                                                    "different"
                                                ? (jobsDetailsController
                                                            .filteredAssignVehicle[
                                                                index]
                                                            .jobId ==
                                                        jobsDetailsController
                                                            .jobsList.id
                                                    ? "Revert"
                                                    : "Accept")
                                                : "Transfer"),
                                          ));
                                          await DJSController.getStatusData(
                                              jobsDetailsController
                                                  .filteredAssignVehicle[index]
                                                  .vehicleId);
                                        }
                                        //  }
                                        // else {
                                        //   // if (maintenanceController
                                        //   //         .vehicleMaintenanceDetail!
                                        //   //         .status ==
                                        //   //     1) {
                                        //   // Get.to(MaintenanceViewSupervisor(
                                        //   //     jobsDetailsController
                                        //   //             .filteredAssignVehicle[
                                        //   //         index]));
                                        //   // } else {}
                                        // }
                                      } else {
                                        if (jobsDetailsController
                                                    .filteredAssignVehicle[
                                                        index]
                                                    .dailyJobSheet ==
                                                0 &&
                                            jobsDetailsController
                                                    .filteredAssignVehicle[
                                                        index]
                                                    .isdraft ==
                                                0) {
                                          var DJSController = Get.put(
                                              DailyJobSheetController());
                                          DJSController.cleanData();
                                          ////-------------------loader-------------
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  CustomLoadingPopup());
                                          await DJSController.getDraftJobSheet(
                                              jobsDetailsController
                                                  .filteredAssignVehicle[index]
                                                  .vehicleId);
                                          log("--------------------------------4");

                                          Get.back();
                                          Get.to(DailyJobSheetView(
                                            jobsDetailsController
                                                .filteredAssignVehicle[index],
                                            dateTime,
                                            jobsDetailsController
                                                .filteredAssignVehicle[index]
                                                .jobId,
                                            '${RemoteServices.baseUrl}${jobsDetailsController.filteredAssignVehicle[index].vehicleImage}',
                                            jobsDetailsController
                                                .jobsList.site_id,
                                            (jobsDetailsController
                                                        .filteredAssignVehicle[
                                                            index]
                                                        .transferstatus ==
                                                    "different"
                                                ? (jobsDetailsController
                                                            .filteredAssignVehicle[
                                                                index]
                                                            .jobId ==
                                                        jobsDetailsController
                                                            .jobsList.id
                                                    ? "Revert"
                                                    : "Accept")
                                                : "Transfer"),
                                          ));
                                          await DJSController.getStatusData(
                                              jobsDetailsController
                                                  .filteredAssignVehicle[index]
                                                  .vehicleId);
                                        }
                                        if (jobsDetailsController
                                                    .filteredAssignVehicle[
                                                        index]
                                                    .dailyJobSheet ==
                                                1 &&
                                            jobsDetailsController
                                                    .filteredAssignVehicle[
                                                        index]
                                                    .isdraft ==
                                                1) {
                                          //Todo here///
                                          var DJSController = Get.put(
                                              DailyJobSheetController());
                                          DJSController.cleanData();
                                          ////-------------------loader-------------
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  CustomLoadingPopup());
                                          await DJSController.getDraftJobSheet(
                                              jobsDetailsController
                                                  .filteredAssignVehicle[index]
                                                  .vehicleId);
                                          log("--------------------------------5");

                                          Get.back();
                                          Get.to(DailyJobSheetView(
                                            jobsDetailsController
                                                .filteredAssignVehicle[index],
                                            /*jobsDetailsController
                                                .jobDetailsResult[0].dateTime,*/
                                            dateTime,
                                            jobsDetailsController
                                                .filteredAssignVehicle[index]
                                                .jobId,
                                            '${RemoteServices.baseUrl}${jobsDetailsController.filteredAssignVehicle[index].vehicleImage}',
                                            jobsDetailsController
                                                .jobsList.site_id,
                                            (jobsDetailsController
                                                        .filteredAssignVehicle[
                                                            index]
                                                        .transferstatus ==
                                                    "different"
                                                ? (jobsDetailsController
                                                            .filteredAssignVehicle[
                                                                index]
                                                            .jobId ==
                                                        jobsDetailsController
                                                            .jobsList.id
                                                    ? "Revert"
                                                    : "Accept")
                                                : "Transfer"),
                                          ));
                                          await DJSController.getStatusData(
                                              jobsDetailsController
                                                  .filteredAssignVehicle[index]
                                                  .vehicleId);
                                        }
                                        if (jobsDetailsController
                                                    .filteredAssignVehicle[
                                                        index]
                                                    .dailyJobSheet ==
                                                1 &&
                                            jobsDetailsController
                                                    .filteredAssignVehicle[
                                                        index]
                                                    .isdraft ==
                                                0) {
                                          //    Todo here///
                                          var DJSController = Get.put(
                                              DailyJobSheetController());
                                          DJSController.cleanData();
                                          ////-------------------loader-------------
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  CustomLoadingPopup());
                                          await DJSController.getDraftJobSheet(
                                              jobsDetailsController
                                                  .filteredAssignVehicle[index]
                                                  .vehicleId);
                                          log("--------------------------------6");

                                          Get.back();
                                          Get.to(DailyJobSheetView(
                                            jobsDetailsController
                                                .filteredAssignVehicle[index],
                                            /*jobsDetailsController
                                                .jobDetailsResult[0].dateTime,*/
                                            dateTime,
                                            jobsDetailsController
                                                .filteredAssignVehicle[index]
                                                .jobId,
                                            '${RemoteServices.baseUrl}${jobsDetailsController.filteredAssignVehicle[index].vehicleImage}',
                                            jobsDetailsController
                                                .jobsList.site_id,
                                            (jobsDetailsController
                                                        .filteredAssignVehicle[
                                                            index]
                                                        .transferstatus ==
                                                    "different"
                                                ? (jobsDetailsController
                                                            .filteredAssignVehicle[
                                                                index]
                                                            .jobId ==
                                                        jobsDetailsController
                                                            .jobsList.id
                                                    ? "Revert"
                                                    : "Accept")
                                                : "Transfer"),
                                          ));
                                          await DJSController.getStatusData(
                                              jobsDetailsController
                                                  .filteredAssignVehicle[index]
                                                  .vehicleId);
                                        }
                                      }
                                    },
                                    child: Container(
                                      width: 100 * SizeConfig.widthMultiplier,
                                      // color: jobsDetailsController.col == 0
                                      //     ? Colors.white
                                      //     : jobsDetailsController.col == 1
                                      //         ? Colors.red[200]
                                      //         : Colors.green[200],
                                      color: (jobsDetailsController
                                                  .filteredAssignVehicle[index]
                                                  .transferstatus ==
                                              "different"
                                          ? (jobsDetailsController
                                                      .filteredAssignVehicle[
                                                          index]
                                                      .jobId ==
                                                  jobsDetailsController
                                                      .jobsList.id
                                              ? Colors.red[200]
                                              : Colors.green[200])
                                          : Colors.white),
                                      // color: jobsDetailsController
                                      //     .getTransferStatusColor(
                                      //   jobsDetailsController
                                      //       .filteredAssignVehicle[index]
                                      //       .transferstatus,
                                      //   jobsDetailsController
                                      //       .filteredAssignVehicle[index].jobId,
                                      //   jobsDetailsController.jobsList.id,
                                      // ),

                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                height: 10 *
                                                    SizeConfig.heightMultiplier,
                                                width: 15 *
                                                    SizeConfig.widthMultiplier,
                                                child: jobsDetailsController
                                                            .filteredAssignVehicle[
                                                                index]
                                                            .vehicleImage ==
                                                        null
                                                    ? Image.asset(
                                                        'assets/icons/no_image_found.jpg')
                                                    : Image.network(
                                                        '${RemoteServices.baseUrl}${jobsDetailsController.filteredAssignVehicle[index].vehicleImage}'),
                                              ),
                                              SizedBox(
                                                width: 2 *
                                                    SizeConfig.widthMultiplier,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CustTextStart(
                                                      name: jobsDetailsController
                                                          .filteredAssignVehicle[
                                                              index]
                                                          .vehicleNo,
                                                      size: 2,
                                                      colors: colorPrimaryDark,
                                                      fontWeightName:
                                                          FontWeight.w600),
                                                  SizedBox(
                                                      height: 0.5 *
                                                          SizeConfig
                                                              .heightMultiplier),
                                                  CustTextStart(
                                                      name: jobsDetailsController
                                                              .crewNamesList
                                                              .isEmpty
                                                          ? "No Crew Assign"
                                                          : jobsDetailsController
                                                                  .crewNamesList[
                                                              index],
                                                      // "${jobsDetailsController.filteredAssignVehicle[index].crewVehicleAllocation[0].firstName} ${jobsDetailsController.filteredAssignVehicle[index].crewVehicleAllocation[0].lastName}",
                                                      // "${jobsDetailsController.filteredAssignVehicle[index].firstName} ${jobsDetailsController.filteredAssignVehicle[index].lastName}",
                                                      size: 1.8,
                                                      colors: Colors.black87,
                                                      fontWeightName:
                                                          FontWeight.w400),
                                                ],
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              jobsDetailsController.filteredAssignVehicle[index].isdraft == 1 &&
                                                      jobsDetailsController.filteredAssignVehicle[index].dailyJobSheet ==
                                                          1
                                                  ? Row(
                                                      children: [
                                                        jobsDetailsController.filteredAssignVehicle[index].vehStatus == "In Working"
                                                            ? Container()
                                                            : Container(
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        width:
                                                                            2,
                                                                        style: BorderStyle
                                                                            .solid,
                                                                        color:
                                                                            colorPrimary),
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(
                                                                            5))),
                                                                padding: EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        SizeConfig.widthMultiplier *
                                                                            1.5,
                                                                    vertical:
                                                                        SizeConfig.heightMultiplier *
                                                                            0.2),
                                                                child: jobsDetailsController.filteredAssignVehicle[index].vehStatus == "Idle"
                                                                    ? CustTextStart(
                                                                        name: "Idle",
                                                                        size: 1.4,
                                                                        colors: colorPrimary,
                                                                        fontWeightName: FontWeight.w500)
                                                                    : CustTextStart(name: "Maintenance", size: 1.2, colors: colorPrimary, fontWeightName: FontWeight.w500)),
                                                        SizedBox(
                                                          width: 2 *
                                                              SizeConfig
                                                                  .widthMultiplier,
                                                        ),
                                                        Icon(Remix.draft_fill,
                                                            size: 7 *
                                                                SizeConfig
                                                                    .imageSizeMultiplier,
                                                            color:
                                                                colorPrimaryDark),
                                                      ],
                                                    )
                                                  : jobsDetailsController.filteredAssignVehicle[index].vehStatus ==
                                                          "Idle"
                                                      ? Container(
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  width: 2,
                                                                  style: BorderStyle
                                                                      .solid,
                                                                  color:
                                                                      colorPrimary),
                                                              borderRadius:
                                                                  BorderRadius.all(
                                                                      Radius.circular(
                                                                          5))),
                                                          padding: EdgeInsets.symmetric(
                                                              horizontal:
                                                                  SizeConfig.widthMultiplier *
                                                                      1.5,
                                                              vertical:
                                                                  SizeConfig.heightMultiplier *
                                                                      0.2),
                                                          child: CustTextStart(
                                                              name: "Idle",
                                                              size: 1.4,
                                                              colors: colorPrimary,
                                                              fontWeightName: FontWeight.w500))
                                                      : (jobsDetailsController.filteredAssignVehicle[index].vehStatus == "Awaiting Maintenance" ? Container(decoration: BoxDecoration(border: Border.all(width: 2, style: BorderStyle.solid, color: colorPrimary), borderRadius: BorderRadius.all(Radius.circular(5))), padding: EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier * 1.5, vertical: SizeConfig.heightMultiplier * 0.2), child: CustTextStart(name: "Maintenance", size: 1.2, colors: colorPrimary, fontWeightName: FontWeight.w500)) : CustTextStart(name: "", size: 1.2, colors: colorPrimary, fontWeightName: FontWeight.w500)),

                                              // child: jobsDetailsController.filteredAssignVehicle[index].vehStatus ==
                                              //         "Awaiting Maintenance"
                                              //     ? Container(
                                              //         decoration: BoxDecoration(
                                              //             border: Border.all(
                                              //                 width: 2,
                                              //                 style: BorderStyle
                                              //                     .solid,
                                              //                 color:
                                              //                     colorPrimary),
                                              //             borderRadius: BorderRadius.all(
                                              //                 Radius.circular(
                                              //                     5))),
                                              //         padding: EdgeInsets.symmetric(
                                              //             horizontal: SizeConfig.widthMultiplier *
                                              //                 1.5,
                                              //             vertical: SizeConfig.heightMultiplier *
                                              //                 0.2),
                                              //         child: CustTextStart(
                                              //             name: "Main-----------tenance",
                                              //             size: 1.2,
                                              //             colors: colorPrimary,
                                              //             fontWeightName: FontWeight.w500))
                                              //  : Container(),
                                              // ),

                                              SizedBox(
                                                width: 1 *
                                                    SizeConfig.widthMultiplier,
                                              ),
                                              jobsDetailsController
                                                              .filteredAssignVehicle[
                                                                  index]
                                                              .dailyJobSheet ==
                                                          1 &&
                                                      jobsDetailsController
                                                              .filteredAssignVehicle[
                                                                  index]
                                                              .isdraft ==
                                                          0
                                                  ? Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            jobsDetailsController.filteredAssignVehicle[index].vehStatus ==
                                                                    "In Working"
                                                                ? Container()
                                                                : Container(
                                                                    decoration: BoxDecoration(
                                                                        border: Border.all(
                                                                            width:
                                                                                2,
                                                                            style: BorderStyle
                                                                                .solid,
                                                                            color:
                                                                                colorPrimary),
                                                                        borderRadius: BorderRadius.all(Radius.circular(
                                                                            5))),
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal: SizeConfig.widthMultiplier *
                                                                            1.5,
                                                                        vertical: SizeConfig.heightMultiplier *
                                                                            0.2),
                                                                    child: jobsDetailsController.filteredAssignVehicle[index].vehStatus ==
                                                                            "Idle"
                                                                        ? CustTextStart(
                                                                            name: "Idle",
                                                                            size: 1.4,
                                                                            colors: colorPrimary,
                                                                            fontWeightName: FontWeight.w500)
                                                                        : CustTextStart(name: "Maintenance", size: 1.2, colors: colorPrimary, fontWeightName: FontWeight.w500)),
                                                            // SizedBox(
                                                            //   width: 1 *
                                                            //       SizeConfig
                                                            //           .widthMultiplier,
                                                            // ),
                                                            Icon(
                                                                Remix
                                                                    .checkbox_circle_fill,
                                                                size: 7 *
                                                                    SizeConfig
                                                                        .imageSizeMultiplier,
                                                                color:
                                                                    colorPrimaryDark),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: SizeConfig
                                                                  .heightMultiplier *
                                                              0.5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () async {
                                                                var DJSController =
                                                                    Get.put(
                                                                        DailyJobSheetController());
                                                                DJSController
                                                                    .cleanData();

                                                                Get.to(
                                                                    DailyJobSheetView(
                                                                  jobsDetailsController
                                                                          .filteredAssignVehicle[
                                                                      index],
                                                                  dateTime,
                                                                  jobsDetailsController
                                                                      .filteredAssignVehicle[
                                                                          index]
                                                                      .jobId,
                                                                  '${RemoteServices.baseUrl}${jobsDetailsController.filteredAssignVehicle[index].vehicleImage}',
                                                                  jobsDetailsController
                                                                      .jobsList
                                                                      .site_id,
                                                                  (jobsDetailsController
                                                                              .filteredAssignVehicle[
                                                                                  index]
                                                                              .transferstatus ==
                                                                          "different"
                                                                      ? (jobsDetailsController.filteredAssignVehicle[index].jobId ==
                                                                              jobsDetailsController.jobsList.id
                                                                          ? "Revert"
                                                                          : "Accept")
                                                                      : "Transfer"),
                                                                ));
                                                                Get.to(
                                                                    DailyJobSheetView(
                                                                  jobsDetailsController
                                                                          .filteredAssignVehicle[
                                                                      index],
                                                                  dateTime,
                                                                  jobID,
                                                                  '${RemoteServices.baseUrl}${jobsDetailsController.filteredAssignVehicle[index].vehicleImage}',
                                                                  jobsDetailsController
                                                                      .jobsList
                                                                      .site_id,
                                                                  (jobsDetailsController
                                                                              .filteredAssignVehicle[
                                                                                  index]
                                                                              .transferstatus ==
                                                                          "different"
                                                                      ? (jobsDetailsController.filteredAssignVehicle[index].jobId ==
                                                                              jobsDetailsController.jobsList.id
                                                                          ? "Revert"
                                                                          : "Accept")
                                                                      : "Transfer"),
                                                                ));
                                                                await DJSController.getDraftJobSheet(
                                                                    jobsDetailsController
                                                                        .filteredAssignVehicle[
                                                                            index]
                                                                        .vehicleId);
                                                              },
                                                              child: Container(
                                                                  decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                          width:
                                                                              2,
                                                                          style: BorderStyle
                                                                              .solid,
                                                                          color:
                                                                              colorPrimary),
                                                                      borderRadius:
                                                                          BorderRadius.all(Radius.circular(
                                                                              5))),
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          SizeConfig.widthMultiplier *
                                                                              1.5,
                                                                      vertical:
                                                                          SizeConfig.heightMultiplier *
                                                                              0.5),
                                                                  child: CustTextStart(
                                                                      name: "Fill Again",
                                                                      size: 1.4,
                                                                      colors: colorPrimary,
                                                                      fontWeightName: FontWeight.w500)),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )

                                                  // Icon(Remix.arrow_right_s_line,size: 7 * SizeConfig.imageSizeMultiplier,color: colorPrimaryDark)
                                                  :
                                                  // Icon(Remix.checkbox_circle_fill,size: 7 * SizeConfig.imageSizeMultiplier,color: colorPrimaryDark),

                                                  Icon(Remix.arrow_right_s_line,
                                                      size: 7 *
                                                          SizeConfig
                                                              .imageSizeMultiplier,
                                                      color: colorPrimaryDark),
                                              SizedBox(
                                                width: 2 *
                                                    SizeConfig.widthMultiplier,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(child: CustomLoading()),
            ),
          ),
        ],
      ),
    );
  }

  showDetails(title, details) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            width: 42 * SizeConfig.widthMultiplier,
            child: CustTextStart(
                name: title,
                size: 1.6,
                colors: Colors.black87,
                fontWeightName: FontWeight.w600)),
        CustText(
            name: ":  ",
            size: 1.8,
            colors: Colors.black87,
            fontWeightName: FontWeight.w400),
        Container(
            width: 48 * SizeConfig.widthMultiplier,
            child: CustTextStart(
                name: details,
                size: 1.8,
                colors: Colors.black87,
                fontWeightName: FontWeight.w400)),
      ],
    );
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus) {
    currentFocus.unfocus();
  }
}
