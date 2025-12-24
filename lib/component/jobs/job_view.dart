import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:macsys/component/fuel_manager/fuel_transaction_view.dart';
import 'package:macsys/component/job_details/job_details_view.dart';
import 'package:remixicon/remixicon.dart';

import '../../util/ApiClient.dart';
import '../../util/SizeConfig.dart';
import '../custom_widget/colorsC.dart';
import '../custom_widget/cust_text.dart';
import '../custom_widget/cust_text_start.dart';
import '../custom_widget/custom_loading_popup.dart';
import '../fuel_manager/fuel_controller.dart';
import '../fuel_manager/fuel_add_view.dart';
import '../job_details/job_details_controller.dart';
import 'job_controller.dart';

class JobsView extends StatelessWidget {
  var jobsController = Get.put(JobsController());

  Future<void> _refreshData() async {
    // Add your logic to refill the data here
    await jobsController.getJobs(jobsController.jobStatus);
    print(
        "HERE:::${jobsController.jobStatus}"); // Replace this with your actual data loading logic
  }

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
            name: "Jobs",
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
          Container(
            height: 100 * SizeConfig.heightMultiplier,
            width: 100 * SizeConfig.widthMultiplier,
            color: Colors.black12.withOpacity(0.2),
          ),
          RefreshIndicator(
            onRefresh: _refreshData,
            color: colorPrimary,
            child: GetBuilder<JobsController>(
                init: JobsController(),
                builder: (controller) => jobsController.status
                    ? Padding(
                        padding: EdgeInsets.all(2 * SizeConfig.widthMultiplier),
                        child: Column(
                          children: [
                            jobsController.isSupervisorAdmin == 1
                                ? Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              print("HERE IS TO ADD FUEL");
                                              var fuelController =
                                                  Get.put(FuelController());
                                              fuelController.cleanData();
                                              fuelController.getFuel();
                                              Get.to(FuelView());
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Remix.add_box_fill,
                                                  size: 5.5 *
                                                      SizeConfig
                                                          .imageSizeMultiplier,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(
                                                  width: SizeConfig
                                                          .widthMultiplier *
                                                      2,
                                                ),
                                                CustTextStart(
                                                    name: "Add Fuel",
                                                    size: 1.8,
                                                    colors: Colors.white,
                                                    fontWeightName:
                                                        FontWeight.w600),
                                              ],
                                            ),
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                        colorPrimary)),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              print("HERE IS TO ADD FUEL");
                                              var fuelController =
                                                  Get.put(FuelController());
                                              fuelController.cleanData();
                                              fuelController.getTransaction();
                                              Get.to(FuelTransactionView());
                                            },
                                            child: Row(
                                              children: [
                                                CustTextStart(
                                                    name:
                                                        "View Transaction History",
                                                    size: 1.8,
                                                    colors: Colors.white,
                                                    fontWeightName:
                                                        FontWeight.w600),
                                              ],
                                            ),
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                        colorPrimary)),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height:
                                            SizeConfig.heightMultiplier * 13,
                                        child: ListView.builder(
                                            physics: BouncingScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            padding: EdgeInsets.zero,
                                            itemCount:
                                                jobsController.vehStatus.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Row(
                                                children: [
                                                  Container(
                                                    width: SizeConfig
                                                            .widthMultiplier *
                                                        23,
                                                    padding: EdgeInsets.all(0.5 *
                                                        SizeConfig
                                                            .heightMultiplier),
                                                    child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          shape: BoxShape
                                                              .rectangle,
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius
                                                              .circular(2 *
                                                                  SizeConfig
                                                                      .widthMultiplier),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              CustTextStart(
                                                                name: jobsController
                                                                            .vehStatus[
                                                                                index]
                                                                            .status ==
                                                                        "Awaiting Maintenance"
                                                                    ? "Maintenance"
                                                                    : jobsController
                                                                        .vehStatus[
                                                                            index]
                                                                        .status,
                                                                colors:
                                                                    colorPrimary,
                                                                size: 1.4,
                                                                fontWeightName:
                                                                    FontWeight
                                                                        .w500,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                              SizedBox(
                                                                height: 1 *
                                                                    SizeConfig
                                                                        .heightMultiplier,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      height: 5 *
                                                                          SizeConfig
                                                                              .heightMultiplier,
                                                                      decoration: BoxDecoration(
                                                                          color: jobsController.colors[
                                                                              index],
                                                                          borderRadius:
                                                                              BorderRadius.circular(7)),
                                                                      child:
                                                                          Center(
                                                                        child: CustTextStart(
                                                                            name:
                                                                                "${jobsController.vehStatus[index].count}",
                                                                            size:
                                                                                1.6,
                                                                            colors:
                                                                                Colors.black,
                                                                            fontWeightName: FontWeight.w600),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        )),
                                                  ),
                                                  SizedBox(
                                                      width: 1.5 *
                                                          SizeConfig
                                                              .widthMultiplier),
                                                ],
                                              );
                                            }),
                                      ),
                                    ],
                                  )
                                : Container(),
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.vertical,
                                itemCount: jobsController.jobs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                      onTap: () async {
                                        print("ASDASDASD");
                                        print(
                                            "JOB ID ${jobsController.jobs[index].id}");
                                        var jobsDetailsController =
                                            Get.put(JobsDetailsController());
                                        // showDialog(
                                        //   context: context,
                                        //   barrierDismissible: false,
                                        //   builder: (BuildContext context) =>
                                        //       CustomLoadingPopup(),

                                        jobsDetailsController.getJobDetails(
                                          "${jobsController.jobs[index].id}",
                                        );
                                        // Get.back();
                                        // jobsDetailsController.getDraftValue();
                                        // Get.to(JobsDetilasView(
                                        //     "${jobsController.jobStatus}", 0));
                                        Get.to(JobsDetilasView(
                                            "${jobsController.jobStatus}", 0));
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top:
                                                1 * SizeConfig.heightMultiplier,
                                            bottom: 1 *
                                                SizeConfig.heightMultiplier),
                                        child: Container(
                                          //  height: 10 * SizeConfig.heightMultiplier,
                                          width:
                                              100 * SizeConfig.widthMultiplier,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                                1 * SizeConfig.widthMultiplier),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                        height: 0.5 *
                                                            SizeConfig
                                                                .heightMultiplier),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Remix
                                                              .calendar_todo_line,
                                                          size: 5 *
                                                              SizeConfig
                                                                  .imageSizeMultiplier,
                                                          color:
                                                              colorPrimaryDark,
                                                        ),
                                                        SizedBox(
                                                            width: 0.5 *
                                                                SizeConfig
                                                                    .heightMultiplier),
                                                        CustText(
                                                            name:
                                                                // "${jobsController.jobs[index].fromDate}",
                                                                "${ApiClient.convertDate(jobsController.jobs[index].fromDate.toString())} ",
                                                            size: 1.8,
                                                            colors:
                                                                Colors.black87,
                                                            fontWeightName:
                                                                FontWeight
                                                                    .w400),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                        height: 0.5 *
                                                            SizeConfig
                                                                .heightMultiplier),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Icon(Remix.map_pin_line,
                                                            size: 5 *
                                                                SizeConfig
                                                                    .imageSizeMultiplier,
                                                            color:
                                                                colorPrimaryDark),
                                                        SizedBox(
                                                            width: 0.5 *
                                                                SizeConfig
                                                                    .heightMultiplier),
                                                        Container(
                                                            width: 75 *
                                                                SizeConfig
                                                                    .widthMultiplier,
                                                            child: CustTextStart(
                                                                name: jobsController
                                                                    .jobs[index]
                                                                    .siteAddress,
                                                                size: 1.8,
                                                                colors: Colors
                                                                    .black87,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                fontWeightName:
                                                                    FontWeight
                                                                        .w400)),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                        height: 0.5 *
                                                            SizeConfig
                                                                .heightMultiplier),
                                                    Row(
                                                      children: [
                                                        Icon(Remix.user_fill,
                                                            size: 5 *
                                                                SizeConfig
                                                                    .imageSizeMultiplier,
                                                            color:
                                                                colorPrimaryDark),
                                                        SizedBox(
                                                            width: 0.5 *
                                                                SizeConfig
                                                                    .heightMultiplier),
                                                        CustText(
                                                            name: jobsController
                                                                .jobs[index]
                                                                .type,
                                                            size: 1.8,
                                                            colors:
                                                                Colors.black87,
                                                            fontWeightName:
                                                                FontWeight
                                                                    .w400),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                        height: 0.5 *
                                                            SizeConfig
                                                                .heightMultiplier),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                            width: 1 *
                                                                SizeConfig
                                                                    .heightMultiplier),
                                                        CustText(
                                                            name: "JOB TYPE",
                                                            /* jobsController
                                                                .jobResult[index]
                                                                .jobSubType,*/
                                                            size: 1.8,
                                                            colors:
                                                                Colors.black87,
                                                            fontWeightName:
                                                                FontWeight
                                                                    .w400),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                        height: 0.5 *
                                                            SizeConfig
                                                                .heightMultiplier),
                                                  ],
                                                ),
                                                Icon(Remix.arrow_right_s_line,
                                                    size: 7 *
                                                        SizeConfig
                                                            .imageSizeMultiplier,
                                                    color: colorPrimaryDark),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ));
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        child: CustomLoadingPopup(),
                      )),
          ),
        ],
      ),
    );
  }
}
