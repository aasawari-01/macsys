import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:macsys/component/job_details/job_details_model.dart';
import 'package:macsys/component/jobs/job_controller.dart';
import 'package:macsys/main.dart';
import 'package:macsys/maintaince/vehicle_maintaince_list_model.dart';
import 'package:macsys/services/remote_services.dart';
import 'package:macsys/util/assign_supervisor_dialog.dart';
import 'package:remixicon/remixicon.dart';

import '../component/custom_widget/check_internet.dart';
import '../component/custom_widget/colorsC.dart';
import '../component/custom_widget/cust_text.dart';
import '../component/custom_widget/cust_text_start.dart';
import '../component/custom_widget/custom_loading_popup.dart';
import '../component/custom_widget/selectionDialog.dart';
import '../component/custom_widget/textfield_widget.dart';
import '../component/job_details/job_details_controller.dart';
import '../util/ApiClient.dart';
import '../util/SizeConfig.dart';
import '../util/custom_dialog.dart';
import 'dart:io';
import 'maintaince_controller.dart';

class ShowMaintenanceSheet extends StatelessWidget {
  var vehicleDetails;

  ShowMaintenanceSheet(
    vehicleDetails,
  ) {
    print("1232133333333333333333333333");
    print(vehicleDetails);

    this.vehicleDetails = vehicleDetails;
    // this.vehicleDetails = vehicleDetails.vehicleDetails ?? vehicleDetails;
    //   maintenanceController.textFieldAdd();
    //   maintenanceController.addField();
  }

  var maintenanceController = Get.put(MaintenanceController());
  @override
  Widget build(BuildContext context) {
    print(vehicleDetails.toString());
    // print(
    // '--------------------------Status Check: ${vehicleDetails.status != 1}');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrimaryDark,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Remix.arrow_left_line,
              size: 6 * SizeConfig.imageSizeMultiplier,
              color: Colors.white,
            )),
        title: CustText(
            name: "Quotation Details",
            size: 2.2,
            colors: Colors.white,
            fontWeightName: FontWeight.w600),
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
          SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Container(
              // height: 100 * SizeConfig.heightMultiplier,
              width: 100 * SizeConfig.widthMultiplier,
              color: Colors.white.withOpacity(0.9),
              child: GetBuilder<MaintenanceController>(
                init: MaintenanceController(),
                builder: (controller) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      /*  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: 90 * SizeConfig.widthMultiplier,
                              child: CustTextStart(
                                  name:
                                      "Before start work read/ understand job details carefully",
                                  size: 1.8,
                                  colors: colorPrimary,
                                  fontWeightName: FontWeight.w600)),
                        ],
                      ),*/
                      /*    SizedBox(height: 1 * SizeConfig.heightMultiplier),
                      showDetails("Job Date",
                          jobsDetailsController.jobsList!=null?"${ApiClient.convertDate(jobsDetailsController.jobsList.fromDate.toString())}":""),
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
                          "${ApiClient.convertDate(jobsDetailsController.jobsList.createdAt.toString())}"),*/

                      Container(
                          //   height: 40 * SizeConfig.heightMultiplier,
                          width: 100 * SizeConfig.widthMultiplier,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.all(Radius.circular(
                                  1 * SizeConfig.widthMultiplier)),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {},
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 2 *
                                                  SizeConfig.widthMultiplier,
                                            ),
                                            CustTextStart(
                                                name: "Vehicle No:",
                                                size: 1.8,
                                                colors: Colors.black,
                                                fontWeightName:
                                                    FontWeight.w600),
                                          ],
                                        ),
                                        SizedBox(
                                          height:
                                              1 * SizeConfig.heightMultiplier,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 2 *
                                                  SizeConfig.widthMultiplier,
                                            ),
                                            CustTextStart(
                                                name:
                                                    "${vehicleDetails.vehicleNo}",
                                                size: 2,
                                                colors: colorPrimaryDark,
                                                fontWeightName:
                                                    FontWeight.w600),
                                          ],
                                        ),
                                        SizedBox(
                                          height:
                                              1 * SizeConfig.heightMultiplier,
                                        ),
                                        // Row(
                                        //   children: [
                                        //     SizedBox(
                                        //       width: 2 *
                                        //           SizeConfig.widthMultiplier,
                                        //     ),
                                        //     CustTextStart(
                                        //         name: "Model Name:",
                                        //         size: 1.8,
                                        //         colors: Colors.black,
                                        //         fontWeightName:
                                        //             FontWeight.w600),
                                        //   ],
                                        // ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 2 *
                                                  SizeConfig.widthMultiplier,
                                            ),
                                            // CustTextStart(
                                            //     name:
                                            //         "${"vehicleDetails!.modeName"}",
                                            //     size: 2,
                                            //     colors: colorPrimaryDark,
                                            //     fontWeightName:
                                            //         FontWeight.w600),
                                          ],
                                        ),
                                        SizedBox(
                                          height:
                                              1 * SizeConfig.heightMultiplier,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 2 *
                                                  SizeConfig.widthMultiplier,
                                            ),
                                            CustTextStart(
                                                name: "Type",
                                                size: 1.8,
                                                colors: Colors.black,
                                                fontWeightName:
                                                    FontWeight.w600),
                                            SizedBox(
                                              width: 2 *
                                                  SizeConfig.widthMultiplier,
                                            ),
                                            SizedBox(
                                              width:
                                                  SizeConfig.widthMultiplier *
                                                      28,
                                              child: CustTextStart(
                                                name: maintenanceController
                                                        .vehicleMaintenanceDetail
                                                        ?.vehicleDetails
                                                        ?.vehicleTypeName ??
                                                    '-',
                                                size: 1.8,
                                                colors: Colors.black38,
                                                fontWeightName: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height:
                                              1 * SizeConfig.heightMultiplier,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 2 *
                                                  SizeConfig.widthMultiplier,
                                            ),
                                            CustTextStart(
                                                name: "Assign To",
                                                size: 1.8,
                                                colors: Colors.black,
                                                fontWeightName:
                                                    FontWeight.w600),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 2 *
                                                  SizeConfig.widthMultiplier,
                                            ),
                                            SizedBox(
                                              width:
                                                  SizeConfig.widthMultiplier *
                                                      36,
                                              child: CustTextStart(
                                                name: maintenanceController
                                                        .vehicleMaintenanceDetail
                                                        ?.assignTo
                                                        ?.fullName ??
                                                    '-',
                                                size: 1.8,
                                                colors: Colors.black38,
                                                fontWeightName: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height:
                                              1 * SizeConfig.heightMultiplier,
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
                                      child: Image.network(
                                          "${RemoteServices.baseUrl + vehicleDetails!.vehiclePhoto.toString()}"),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 0.4 * SizeConfig.heightMultiplier,
                                ),
                                SizedBox(
                                    height: 1.5 * SizeConfig.heightMultiplier),
                              ])),
                      Container(
                          height: 5.5 * SizeConfig.heightMultiplier,
                          width: 100 * SizeConfig.widthMultiplier,
                          color: colorPrimary,
                          child: Center(
                              child: CustText(
                                  name: "Maintenance Type",
                                  size: 1.8,
                                  colors: Colors.white,
                                  fontWeightName: FontWeight.w600))),
                      SizedBox(height: 1 * SizeConfig.heightMultiplier),
                      Container(
                        height: 5.5 * SizeConfig.heightMultiplier,
                        width: 100 * SizeConfig.widthMultiplier,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                              Radius.circular(1 * SizeConfig.widthMultiplier)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 2 * SizeConfig.widthMultiplier,
                            ),
                          ],
                        ),
                        child: Center(
                          child: CustText(
                              name: maintenanceController
                                      .vehicleMaintenanceDetail
                                      ?.maintenanceType ??
                                  "Not selected",
                              size: 1.6,
                              colors: Colors.black,
                              fontWeightName: FontWeight.w600),
                        ),
                      ),
                      maintenanceController.selectedType == "Others"
                          ? Column(
                              children: [
                                SizedBox(
                                    height: 1 * SizeConfig.heightMultiplier),
                                TextFieldWidget(
                                  labelText: "Reason",
                                  textEditingController: maintenanceController
                                      .reasonTextController,
                                  hintText: "Enter Reason",
                                ),
                                SizedBox(
                                    height: 1 * SizeConfig.heightMultiplier),
                              ],
                            )
                          : Container(),
                      SizedBox(height: 1 * SizeConfig.heightMultiplier),
/*                      Container(
                          height: 5.5 * SizeConfig.heightMultiplier,
                          width: 100 * SizeConfig.widthMultiplier,
                          color: colorPrimary,
                          child: Center(
                              child: CustText(
                                  name: "Observation",
                                  size: 1.8,
                                  colors: Colors.white,
                                  fontWeightName: FontWeight.w600))),
                      ListView.builder(
                        itemCount:
                            maintenanceController.opinionTextControllers.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            contentPadding: EdgeInsets.all(0),
                            title: Column(
                              children: [
                                TextFieldWidget(
                                  labelText: maintenanceController
                                      .observationList[index],
                                  textEditingController: maintenanceController
                                      .opinionTextControllers[index],
                                  hintText:
                                      "Enter ${maintenanceController.observationList[index]}",
                                ),
                              ],
                            ),
                          );
                        },
                      ),*/
                      SizedBox(height: 1 * SizeConfig.heightMultiplier),
                      Container(
                          height: 5.5 * SizeConfig.heightMultiplier,
                          width: 100 * SizeConfig.widthMultiplier,
                          color: colorPrimary,
                          child: Center(
                              child: CustText(
                                  name: "Reasons for maintenance",
                                  size: 1.8,
                                  colors: Colors.white,
                                  fontWeightName: FontWeight.w600))),
                      ListView.builder(
                        itemCount: maintenanceController
                            .vehicleMaintenanceDetail
                            ?.maintenanceReason
                            ?.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            contentPadding: EdgeInsets.all(0),
                            title: Container(
                              height: 5.5 * SizeConfig.heightMultiplier,
                              width: 100 * SizeConfig.widthMultiplier,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(
                                    1 * SizeConfig.widthMultiplier)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 2 * SizeConfig.widthMultiplier,
                                  ),
                                ],
                              ),
                              child: Container(
                                height: 5.5 * SizeConfig.heightMultiplier,
                                width: 100 * SizeConfig.widthMultiplier,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          1 * SizeConfig.widthMultiplier)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius:
                                          2 * SizeConfig.widthMultiplier,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: CustText(
                                      name: maintenanceController
                                              .vehicleMaintenanceDetail
                                              ?.maintenanceReason?[index]
                                              .reason ??
                                          "",
                                      size: 1.6,
                                      colors: Colors.black,
                                      fontWeightName: FontWeight.w600),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 1 * SizeConfig.heightMultiplier),
                      Container(
                          height: 5.5 * SizeConfig.heightMultiplier,
                          width: 100 * SizeConfig.widthMultiplier,
                          color: colorPrimary,
                          child: Center(
                              child: CustText(
                                  name: "Photos While Performing Activity",
                                  size: 1.8,
                                  colors: Colors.white,
                                  fontWeightName: FontWeight.w600))),
                      SizedBox(
                        height: 1 * SizeConfig.heightMultiplier,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 1.5 * SizeConfig.heightMultiplier),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 2 * SizeConfig.widthMultiplier,
                                ),
                                CustTextStart(
                                    name: "Upload Images:",
                                    size: 1.8,
                                    colors: Colors.black,
                                    fontWeightName: FontWeight.w400),
                                SizedBox(
                                  width: 8 * SizeConfig.widthMultiplier,
                                ),
                                maintenanceController.vehicleMaintenanceDetail
                                            ?.maintenanceReasonPhoto?.length ==
                                        0
                                    ? Container()
                                    : GestureDetector(
                                        onTap: () {
                                          print("Heelo");
                                          showDialog(
                                              context: context,
                                              builder:
                                                  (BuildContext context) =>
                                                      Dialog(
                                                        child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              shape: BoxShape
                                                                  .rectangle,
                                                              borderRadius: BorderRadius
                                                                  .circular(3 *
                                                                      SizeConfig
                                                                          .widthMultiplier),
                                                            ),
                                                            child:
                                                                StatefulBuilder(
                                                              builder: (BuildContext
                                                                      context,
                                                                  StateSetter
                                                                      setState) {
                                                                return Container(
                                                                  width: double
                                                                      .infinity,
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.all(1 *
                                                                        SizeConfig
                                                                            .widthMultiplier),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        Align(
                                                                          alignment:
                                                                              Alignment.bottomRight,
                                                                          child:
                                                                              GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              height: 12.5 * SizeConfig.widthMultiplier,
                                                                              width: 10 * SizeConfig.widthMultiplier,
                                                                              child: Icon(Remix.close_circle_line, size: 7 * SizeConfig.imageSizeMultiplier, color: colorPrimary),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        InteractiveViewer(
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                40 * SizeConfig.heightMultiplier,
                                                                            width:
                                                                                80 * SizeConfig.widthMultiplier,
                                                                            padding:
                                                                                EdgeInsets.all(
                                                                              1 * SizeConfig.heightMultiplier,
                                                                            ),
                                                                            margin:
                                                                                EdgeInsets.all(
                                                                              1 * SizeConfig.heightMultiplier,
                                                                            ),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              shape: BoxShape.rectangle,
                                                                              borderRadius: BorderRadius.circular(3 * SizeConfig.widthMultiplier),
                                                                              /* image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(
                                                  '${RemoteServices
                                                      .baseUrlIMG}${photoList[selectedIndex]}')
                                          )*/
                                                                            ),
                                                                            child:
                                                                                Image.network(RemoteServices.baseUrl + maintenanceController.vehicleMaintenanceDetail!.maintenanceReasonPhoto![maintenanceController.selectedIndex3].reasonPhoto!, fit: BoxFit.contain),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                1 * SizeConfig.heightMultiplier),
                                                                        Container(
                                                                          height:
                                                                              8 * SizeConfig.heightMultiplier,
                                                                          width:
                                                                              100 * SizeConfig.widthMultiplier,
                                                                          color:
                                                                              Colors.white,
                                                                          child: new ListView
                                                                              .builder(
                                                                              scrollDirection: Axis.horizontal,
                                                                              padding: EdgeInsets.zero,
                                                                              shrinkWrap: true,
                                                                              physics: ScrollPhysics(),
                                                                              itemCount: maintenanceController.vehicleMaintenanceDetail!.maintenanceReasonPhoto!.length,
                                                                              itemBuilder: (BuildContext context, int index) {
                                                                                return Container(
                                                                                    child: GestureDetector(
                                                                                        onTap: () {
                                                                                          setState(() {
                                                                                            maintenanceController.selectedIndex3 = index;
                                                                                          });

                                                                                          print('Here is selectedIndex3 ${maintenanceController.selectedIndex3}');
                                                                                          print('Here is index ${index}');
                                                                                        },
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.all(2),
                                                                                          child: Container(
                                                                                            height: 8 * SizeConfig.heightMultiplier,
                                                                                            width: 18 * SizeConfig.widthMultiplier,
                                                                                            decoration: BoxDecoration(shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(3 * SizeConfig.widthMultiplier), border: Border.all(color: colorPrimaryDark, width: 1)),
                                                                                            child: Image.network(
                                                                                              RemoteServices.baseUrl + maintenanceController.vehicleMaintenanceDetail!.maintenanceReasonPhoto![index].reasonPhoto!,
                                                                                              fit: BoxFit.contain,
                                                                                            ),
                                                                                          ),
                                                                                        )));
                                                                              }),
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                1 * SizeConfig.heightMultiplier)
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            )),
                                                      ));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey,
                                                  width: 1,
                                                  style: BorderStyle.solid)),
                                          height:
                                              13 * SizeConfig.heightMultiplier,
                                          width:
                                              25 * SizeConfig.widthMultiplier,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 2.0 *
                                                  SizeConfig.widthMultiplier,
                                              vertical: 1.0 *
                                                  SizeConfig.heightMultiplier,
                                            ),
                                            child: Image.network(
                                              RemoteServices.baseUrl +
                                                  maintenanceController
                                                      .vehicleMaintenanceDetail!
                                                      .maintenanceReasonPhoto![
                                                          0]
                                                      .reasonPhoto!,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                /*      GestureDetector(
                                  onTap: () {
                                    maintenanceController.pickImages();
                                  },
                                  child: maintenanceController.imageList == 0
                                      ? Container(
                                          height:
                                              15 * SizeConfig.widthMultiplier,
                                          width:
                                              15 * SizeConfig.widthMultiplier,
                                          child: Icon(
                                            Remix.gallery_fill,
                                            size: 15 *
                                                SizeConfig.imageSizeMultiplier,
                                            color: Colors.black,
                                          ),
                                        )
                                      : Container(),
                                ),*/
                                SizedBox(
                                  width: 2.5 * SizeConfig.widthMultiplier,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    maintenanceController.pickImages();
                                    maintenanceController.selectedIndex3 = 0;
                                  },
                                  child: maintenanceController.imageList != 0
                                      ? Row(
                                          children: [
                                            Icon(Remix.restart_fill,
                                                size: 4 *
                                                    SizeConfig
                                                        .imageSizeMultiplier,
                                                color: colorPrimary),
                                            SizedBox(
                                              width: 1 *
                                                  SizeConfig.widthMultiplier,
                                            ),
                                            CustText(
                                                name: "Retake",
                                                size: 1.7,
                                                colors: Colors.black,
                                                fontWeightName:
                                                    FontWeight.w600),
                                          ],
                                        )
                                      : Container(),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              height: 5.5 * SizeConfig.heightMultiplier,
                              width: 100 * SizeConfig.widthMultiplier,
                              color: colorPrimary,
                              child: Center(
                                  child: CustText(
                                      name: "Material Expectation",
                                      size: 1.8,
                                      colors: Colors.white,
                                      fontWeightName: FontWeight.w600))),
                        ],
                      ),
                      Container(
                        child: Column(
                          children: [
                            maintenanceController.vehicleMaintenanceDetail!
                                    .quotationMaterial!.isNotEmpty
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      CustText(
                                          name: "Material Dec.",
                                          size: 1.8,
                                          colors: Colors.black,
                                          fontWeightName: FontWeight.w600),
                                      SizedBox(
                                        width: 1,
                                      ),
                                      CustText(
                                          name: "Quantity",
                                          size: 1.8,
                                          colors: Colors.black,
                                          fontWeightName: FontWeight.w600),
                                      SizedBox(width: 2),
                                      CustText(
                                          name: "Amount",
                                          size: 1.8,
                                          colors: Colors.black,
                                          fontWeightName: FontWeight.w600),
                                      SizedBox(
                                        width: 1,
                                      ),
                                      // SizedBox(width: 10,),
                                    ],
                                  )
                                : Container(),
                            ListView.builder(
                              itemCount: maintenanceController
                                  .vehicleMaintenanceDetail!
                                  .quotationMaterial!
                                  .length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var data = maintenanceController
                                    .vehicleMaintenanceDetail!
                                    .quotationMaterial![index];
                                return Column(
                                  children: [
                                    Table(
                                      children: [
                                        TableRow(children: [
                                          Row(
                                            children: [
                                              CustTextStart(
                                                  name: '${index + 1}.',
                                                  size: 1.8,
                                                  colors: Colors.black,
                                                  fontWeightName:
                                                      FontWeight.w400),
                                              Expanded(
                                                  child: CustTextStart(
                                                      name:
                                                          '${data.materialDescription}',
                                                      size: 1.8,
                                                      colors: Colors.black,
                                                      textAlign:
                                                          TextAlign.center,
                                                      fontWeightName:
                                                          FontWeight.w400)),
                                            ],
                                          ),
                                          CustTextStart(
                                              name: '${data.quantity}',
                                              size: 1.8,
                                              colors: Colors.black,
                                              textAlign: TextAlign.center,
                                              fontWeightName: FontWeight.w400),
                                          CustTextStart(
                                              name: '${data.amount}',
                                              size: 1.8,
                                              colors: Colors.black,
                                              textAlign: TextAlign.center,
                                              fontWeightName: FontWeight.w400),
                                        ])
                                      ],
                                    ),
                                    Divider(
                                      height: 10,
                                      color: Colors.grey,
                                    )
                                  ],
                                );
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: 7 * SizeConfig.widthMultiplier),
                                  child: CustText(
                                    name:
                                        "${maintenanceController.totalAmountMaintenance}",
                                    size: 1.8,
                                    fontWeightName: FontWeight.w600,
                                    colors: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1 * SizeConfig.heightMultiplier),
/*                            Container(
                              height: 6.0 * SizeConfig.heightMultiplier,
                              width: 100 * SizeConfig.widthMultiplier,
                              child: TextFieldWidget(
                                textEditingController:
                                    maintenanceController.descriptionController,
                                hintText: "Enter Description",
                                labelText: "Description",
                              ),
                            ),
                            Container(
                              height: 6.0 * SizeConfig.heightMultiplier,
                              width: 100 * SizeConfig.widthMultiplier,
                              child: TextFieldWidget(
                                textEditingController:
                                    maintenanceController.quantityController,
                                hintText: "Enter Quantity ",
                                labelText: "Quantity ",
                                inputFormatter: TextInputType.numberWithOptions(
                                    decimal: true),
                              ),
                            ),
                            Container(
                              height: 6.0 * SizeConfig.heightMultiplier,
                              width: 100 * SizeConfig.widthMultiplier,
                              child: TextFieldWidget(
                                textEditingController:
                                    maintenanceController.amountController,
                                hintText: "Enter Amount ",
                                labelText: "Amount",
                                inputFormatter: TextInputType.numberWithOptions(
                                    decimal: true),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: 1.5 * SizeConfig.heightMultiplier),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  maintenanceController.controllers.length != 1
                                      ? GestureDetector(
                                          onTap: () {
                                            maintenanceController.removeField();
                                          },
                                          child: Container(
                                            child: Row(
                                              children: [
                                                CustText(
                                                    name: "Remove",
                                                    size: 1.8,
                                                    colors: Colors.black,
                                                    fontWeightName:
                                                        FontWeight.w500),
                                                Icon(
                                                  Remix
                                                      .checkbox_indeterminate_fill,
                                                  size: 25,
                                                  color: colorPrimary,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  SizedBox(
                                    width: 3 * SizeConfig.widthMultiplier,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      print(
                                          "LEngth = ${maintenanceController.dataList.length}");

                                      print(
                                          "object${vehicleDetails.status}  ${vehicleDetails.id}");

                                      for (int i = 0;
                                          i <
                                              maintenanceController
                                                  .dataList.length;
                                          i++) {
                                        print(
                                            "object ${maintenanceController.dataList[i]}");
                                      }
                                      maintenanceController.addNewEntry();
                                    },
                                    child: Container(
                                      child: Row(
                                        children: [
                                          CustText(
                                              name: "Add",
                                              size: 1.8,
                                              colors: Colors.black,
                                              fontWeightName: FontWeight.w500),
                                          Icon(
                                            Remix.add_box_fill,
                                            size: 25,
                                            color: colorPrimary,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),*/
                          ],
                        ),
                      ),
                      ApiClient.box.read('skills') != "P&M"
                          ? Container()
                          : maintenanceController.maintenanceSupervisor != 0
                              ? GestureDetector(
                                  onTap: () async {
                                    log('--------------${maintenanceController.maintenanceSupervisor}');
                                    // maintenanceController.addMaintenanceReport(
                                    //     vehicleDetails.id, context);
                                    // maintenanceController.addReport(
                                    //     vehicleDetails.id, context);
                                    // print("object");
                                    if (await CheckInternet.checkInternet()) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              CustomLoadingPopup());
                                      await maintenanceController
                                          .approveMaintaince(
                                              maintenanceController
                                                      .vehicleMaintenanceDetail
                                                      ?.id ??
                                                  0);
                                      await maintenanceController
                                          .getVehicleMaintenanceList(
                                              false, 0, false);
                                      Get.back();
                                      Get.back();
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              CustomDialog(
                                                  "Please check your internet connection"));
                                    }
                                    // Get.back();
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
                                              strokeAlign: BorderSide
                                                  .strokeAlignCenter)),
                                      child: Center(
                                          child: CustText(
                                              name: "Approve",
                                              size: 1.8,
                                              colors: Colors.black,
                                              fontWeightName:
                                                  FontWeight.w600))),
                                )
                              : GestureDetector(
                                  onTap: () async {
                                    // maintenanceController.addMaintenanceReport(
                                    //     vehicleDetails.id, context);
                                    // maintenanceController.addReport(
                                    //     vehicleDetails.id, context);
                                    // print("object");

                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            CustomLoadingPopup());
                                    await maintenanceController
                                        .getMaintainceSupervisor();
                                    Get.back();
                                    if (await CheckInternet.checkInternet()) {
                                      await showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AssignSupervisorDialog(),
                                      );
                                      Get.back();

                                      print("check call");
                                      if (maintenanceController.msgData !=
                                          null) {
                                        await showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                CustomDialog(
                                                    maintenanceController
                                                        .msgData));
                                        maintenanceController.msgData = '';
                                        Get.back();
                                        // Get.back();
                                      } else {
                                        //  Get.back();
                                      }

                                      //  Get.back();

                                      //  Get.back();
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              CustomDialog(
                                                  "Please check your internet connection"));
                                    }
                                    // Get.back();
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
                                              strokeAlign: BorderSide
                                                  .strokeAlignCenter)),
                                      child: Center(
                                          child: CustText(
                                              name: "Assign",
                                              size: 1.8,
                                              colors: Colors.black,
                                              fontWeightName:
                                                  FontWeight.w600))),
                                ),
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 5,
                      ),
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
}
