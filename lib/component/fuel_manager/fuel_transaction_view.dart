import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:macsys/util/ApiClient.dart';
import 'package:remixicon/remixicon.dart';

import '../../util/SizeConfig.dart';
import '../custom_widget/colorsC.dart';
import '../custom_widget/cust_text.dart';
import '../custom_widget/cust_text_start.dart';
import '../custom_widget/custom_loading_popup.dart';
import 'fuel_controller.dart';

class FuelTransactionView extends StatelessWidget {
  FuelTransactionView({super.key});

  var fuelController = Get.put(FuelController());

  Future<void> _refreshData() async {
    // Add your logic to refill the data here
    await fuelController.getTransaction();
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
          child: Icon(
            Remix.arrow_left_line,
            size: 6 * SizeConfig.imageSizeMultiplier,
            color: Colors.white,
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
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            onRefresh: _refreshData,
            color: colorPrimary,
            child: GetBuilder<FuelController>(
                init: FuelController(),
                builder: (controller) => fuelController.status
                    ? Padding(
                        padding: EdgeInsets.all(2 * SizeConfig.widthMultiplier),
                        child: Column(
                          children: [
                            ApiClient.box.read('skills') == "Supervisors Admin"
                                ? Container(
                                    color: Colors.white70,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              CustText(
                                                  name:
                                                      "Total Purchase Fuel   :     ",
                                                  size: 1.8,
                                                  colors: Colors.black,
                                                  fontWeightName:
                                                      FontWeight.w600),
                                              Container(
                                                width:
                                                    SizeConfig.widthMultiplier *
                                                        35,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: SizeConfig
                                                            .widthMultiplier *
                                                        2.0,
                                                    horizontal: SizeConfig
                                                            .heightMultiplier *
                                                        2),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .all(Radius.circular(1 *
                                                          SizeConfig
                                                              .widthMultiplier)),
                                                  border: Border.all(
                                                      width: 2,
                                                      color: Colors.green),
                                                ),
                                                child: CustText(
                                                    name:
                                                        "${fuelController.TotalPurchaseBalance}",
                                                    size: 1.8,
                                                    colors: Colors.black,
                                                    fontWeightName:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                              height:
                                                  SizeConfig.heightMultiplier *
                                                      1),
                                          Row(
                                            children: [
                                              CustText(
                                                  name:
                                                      "Total Remaining Fuel   :   ",
                                                  size: 1.8,
                                                  colors: Colors.black,
                                                  fontWeightName:
                                                      FontWeight.w600),
                                              Container(
                                                width:
                                                    SizeConfig.widthMultiplier *
                                                        35,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: SizeConfig
                                                            .widthMultiplier *
                                                        2.0,
                                                    horizontal: SizeConfig
                                                            .heightMultiplier *
                                                        2),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .all(Radius.circular(1 *
                                                          SizeConfig
                                                              .widthMultiplier)),
                                                  border: Border.all(
                                                      width: 2,
                                                      color: Colors.green),
                                                ),
                                                child: CustText(
                                                    name:
                                                        "${fuelController.TotalUsedFuel}",
                                                    size: 1.8,
                                                    colors: Colors.black,
                                                    fontWeightName:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                              height:
                                                  SizeConfig.heightMultiplier *
                                                      1),
                                          Row(
                                            children: [
                                              CustText(
                                                  name:
                                                      "Total Remaining Fuel   :   ",
                                                  size: 1.8,
                                                  colors: Colors.black,
                                                  fontWeightName:
                                                      FontWeight.w600),
                                              Container(
                                                width:
                                                    SizeConfig.widthMultiplier *
                                                        35,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: SizeConfig
                                                            .widthMultiplier *
                                                        2.0,
                                                    horizontal: SizeConfig
                                                            .heightMultiplier *
                                                        2),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .all(Radius.circular(1 *
                                                          SizeConfig
                                                              .widthMultiplier)),
                                                  border: Border.all(
                                                      width: 2.0,
                                                      color:
                                                          Colors.red.shade200),
                                                ),
                                                child: CustText(
                                                    name:
                                                        "${fuelController.TotalRemainingFuel}",
                                                    size: 1.8,
                                                    colors: Colors.black,
                                                    fontWeightName:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(),
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: fuelController.purchasePetrol.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        top: 1 * SizeConfig.heightMultiplier,
                                        bottom:
                                            1 * SizeConfig.heightMultiplier),
                                    child: Container(
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
                                              MainAxisAlignment.start,
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
                                                  children: [],
                                                ),
                                                Row(
                                                  children: [
                                                    CustText(
                                                        name:
                                                            // "${jobsController.jobs[index].}",
                                                            "Sr. No ${index + 1}",
                                                        size: 1.8,
                                                        colors: Colors.black87,
                                                        fontWeightName:
                                                            FontWeight.w400),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: 1 *
                                                        SizeConfig
                                                            .heightMultiplier),
                                                Container(
                                                  width: SizeConfig
                                                          .widthMultiplier *
                                                      90,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Remix.filter_2_fill,
                                                            size: 5 *
                                                                SizeConfig
                                                                    .imageSizeMultiplier,
                                                            color:
                                                                colorPrimaryDark,
                                                          ),
                                                          CustText(
                                                              name:
                                                                  // "${jobsController.jobs[index].fromDate}",
                                                                  "Fuel in Litres : ",
                                                              size: 1.8,
                                                              colors: Colors
                                                                  .black87,
                                                              fontWeightName:
                                                                  FontWeight
                                                                      .w400),
                                                          CustText(
                                                              name:
                                                                  // "${jobsController.jobs[index].fromDate}",
                                                                  "${fuelController.purchasePetrol[index].consumption}",
                                                              size: 1.8,
                                                              colors: Colors
                                                                  .black87,
                                                              fontWeightName:
                                                                  FontWeight
                                                                      .w400),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Remix.wallet_3_fill,
                                                            size: 5 *
                                                                SizeConfig
                                                                    .imageSizeMultiplier,
                                                            color:
                                                                colorPrimaryDark,
                                                          ),
                                                          SizedBox(
                                                            width: SizeConfig
                                                                    .widthMultiplier *
                                                                0.5,
                                                          ),
                                                          CustText(
                                                              name:
                                                                  // "${jobsController.jobs[index].fromDate}",
                                                                  "Rate",
                                                              size: 1.8,
                                                              colors: Colors
                                                                  .black87,
                                                              fontWeightName:
                                                                  FontWeight
                                                                      .w400),
                                                          SizedBox(
                                                              width: 0.5 *
                                                                  SizeConfig
                                                                      .heightMultiplier),
                                                          CustText(
                                                              name:
                                                                  // "${jobsController.jobs[index].fromDate}",
                                                                  "${fuelController.purchasePetrol[index].rate}",
                                                              size: 1.8,
                                                              colors: Colors
                                                                  .black87,
                                                              fontWeightName:
                                                                  FontWeight
                                                                      .w400),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: 0.5 *
                                                        SizeConfig
                                                            .heightMultiplier),
                                                Container(
                                                  width: SizeConfig
                                                          .widthMultiplier *
                                                      90,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.yellow
                                                                .withOpacity(
                                                                    0.1),
                                                            borderRadius: BorderRadius.all(
                                                                Radius.circular(1 *
                                                                    SizeConfig
                                                                        .widthMultiplier)),
                                                            border: Border.all(
                                                                width: 0.3 *
                                                                    SizeConfig
                                                                        .widthMultiplier,
                                                                color: Colors
                                                                    .green,
                                                                strokeAlign:
                                                                    BorderSide
                                                                        .strokeAlignCenter)),
                                                        padding: EdgeInsetsDirectional.symmetric(
                                                            vertical: SizeConfig
                                                                    .heightMultiplier *
                                                                0.5,
                                                            horizontal: SizeConfig
                                                                    .widthMultiplier *
                                                                2),
                                                        child: Row(
                                                          children: [
                                                            CustText(
                                                                name:
                                                                    // "${jobsController.jobs[index].fromDate}",
                                                                    "Purchase Amount : ${fuelController.purchasePetrol[index].purchaseAmt}",
                                                                size: 1.6,
                                                                colors: Colors
                                                                    .black87,
                                                                fontWeightName:
                                                                    FontWeight
                                                                        .w600),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: 0.5 *
                                                        SizeConfig
                                                            .heightMultiplier),
                                                Container(
                                                  width: SizeConfig
                                                          .widthMultiplier *
                                                      90,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
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
                                                                  fuelController
                                                                              .purchasePetrol[
                                                                                  index]
                                                                              .purchaseDate ==
                                                                          null
                                                                      ? "Date not found"
                                                                      : "${ApiClient.convertDate(fuelController.purchasePetrol[index].purchaseDate)}",
                                                              size: 1.8,
                                                              colors: Colors
                                                                  .black87,
                                                              fontWeightName:
                                                                  FontWeight
                                                                      .w400),
                                                        ],
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Icon(
                                                              Remix
                                                                  .door_open_fill,
                                                              size: 5 *
                                                                  SizeConfig
                                                                      .imageSizeMultiplier,
                                                              color:
                                                                  colorPrimaryDark),
                                                          SizedBox(
                                                              width: 0.5 *
                                                                  SizeConfig
                                                                      .heightMultiplier),
                                                          CustTextStart(
                                                              name: fuelController.purchasePetrol[index].petroleum ==
                                                                      null
                                                                  ? "Location not found"
                                                                  : "${fuelController.purchasePetrol[index].petroleum!.company}",
                                                              size: 1.6,
                                                              colors: Colors
                                                                  .black87,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              fontWeightName:
                                                                  FontWeight
                                                                      .w400),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: 0.5 *
                                                        SizeConfig
                                                            .heightMultiplier),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                    CustTextStart(
                                                        name: fuelController
                                                                    .purchasePetrol[
                                                                        index]
                                                                    .dieselLocation ==
                                                                null
                                                            ? "Location not found"
                                                            : "${fuelController.purchasePetrol[index].dieselLocation!.address}",
                                                        size: 1.6,
                                                        colors: Colors.black87,
                                                        textAlign:
                                                            TextAlign.start,
                                                        fontWeightName:
                                                            FontWeight.w400),
                                                  ],
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                        width: 3 *
                                                            SizeConfig
                                                                .heightMultiplier),
                                                    CustTextStart(
                                                        name: fuelController
                                                                    .purchasePetrol[
                                                                        index]
                                                                    .dieselLocation ==
                                                                null
                                                            ? "Code not found"
                                                            : "Code: ${fuelController.purchasePetrol[index].dieselLocation!.short}",
                                                        size: 1.6,
                                                        colors: Colors.black87,
                                                        textAlign:
                                                            TextAlign.start,
                                                        fontWeightName:
                                                            FontWeight.w400),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        child: CustomLoadingPopup(),
                      )),
          )
        ],
      ),
    );
  }
}
