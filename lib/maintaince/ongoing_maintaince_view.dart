import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:macsys/component/custom_widget/custom_loading_popup.dart';
import 'package:macsys/main.dart';
import 'package:macsys/maintaince/maintainance_view.dart';
import 'package:macsys/maintaince/maintainance_view_pandm.dart';
import 'package:macsys/maintaince/maintaince_view_supervisor.dart';
import 'package:macsys/services/remote_services.dart';
import 'package:macsys/util/ApiClient.dart';
import 'package:remixicon/remixicon.dart';
import '../../util/CustomLoading.dart';
import '../../util/SizeConfig.dart';
import '../component/custom_widget/colorsC.dart';
import '../component/custom_widget/cust_text.dart';
import '../component/custom_widget/cust_text_start.dart';
import 'show_maintance_sheet_view.dart';
import 'maintaince_controller.dart';

class MaintenanceVehicleView extends StatelessWidget {
  DateTime dateTime = DateTime.now();

  final FocusNode searchReadingFocus = FocusNode();
  var maintenanceController = Get.put(MaintenanceController());

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
            )),
        title: CustText(
            name: "Vehicle Maintenance List",
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
            color: Colors.white.withOpacity(0.9),
            child: GetBuilder<MaintenanceController>(
              init: MaintenanceController(),
              builder: (controller) => maintenanceController.status == true
                  ? SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.all(2 * SizeConfig.widthMultiplier),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 1 * SizeConfig.heightMultiplier),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: TextFormField(
                                  onChanged: (term) {
                                    maintenanceController.filterList(term);
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
                              //physics: ,
                              primary: false,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              // physics: AlwaysScrollableScrollPhysics(),
                              itemCount: maintenanceController
                                  .filteredVehicleMaintenance!.length,
                              itemBuilder: (BuildContext context, int index) {
                                print(
                                    "${maintenanceController.filteredVehicleMaintenance!.length}");
                                return RefreshIndicator(
                                  onRefresh: () {
                                    print("here ios the indigator ");
                                    return maintenanceController
                                        .getMaintenanceDetails(0);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 0.5 * SizeConfig.heightMultiplier,
                                        bottom:
                                            0.5 * SizeConfig.heightMultiplier),
                                    child: GestureDetector(
                                      onTap: () async {
                                        // showDialog(
                                        //     context: context,
                                        //     builder: (BuildContext context) =>
                                        //         CustomLoadingPopup());
                                        await maintenanceController
                                            .getVehicleMaintenance(
                                                true,
                                                maintenanceController
                                                    .filteredVehicleMaintenance![
                                                        index]
                                                    .id,
                                                false);
                                        maintenanceController.getMaintenanceDetails(
                                            maintenanceController
                                                    .filteredVehicleMaintenance![
                                                index]);
                                        await maintenanceController
                                            .getVehicleMaintenanceList(
                                                true,
                                                maintenanceController
                                                    .filteredVehicleMaintenance![
                                                        index]
                                                    .id,
                                                false);
                                        // Get.back();
                                        print("Index:$index");
                                        print(
                                            "Index22${maintenanceController.filteredVehicleMaintenance![index]}");
                                        maintenanceController.selectedIndex = 0;
                                        maintenanceController.selectedIndex2 =
                                            0;

                                        if (ApiClient.role) {
                                          maintenanceController
                                                      .filteredVehicleMaintenance![
                                                          index]
                                                      .status ==
                                                  1
                                              ? Get.to(MaintenanceViewpandm(
                                                  maintenanceController
                                                          .filteredVehicleMaintenance![
                                                      index],
                                                ))
                                              : Get.to(ShowMaintenanceSheet(
                                                  maintenanceController
                                                      .filteredVehicleMaintenance![
                                                          index]
                                                      .vehicleDetails));
                                          print("Index:$index");
                                        } else {
                                          print(
                                              "wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww");
                                          if (maintenanceController
                                                  .vehicleMaintenanceDetail !=
                                              null) {
                                            // maintenanceController.cleanData();
                                            //  if (decoded['status'] == 1) {
                                            //   // Navigate to Approve page
                                            //   print("Navigating to Approve page...");
                                            // } else if (decoded['status'] == 0) {
                                            //   // Navigate to Details page
                                            //   print("Navigating to Details page...");
                                            // }
                                            print(
                                                "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
                                            print(
                                                '${maintenanceController.vehicleMaintenanceDetail!.status}');
                                            if (maintenanceController
                                                    .vehicleMaintenanceDetail!
                                                    .status ==
                                                1) {
                                              print(
                                                  "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv");

                                              await Get.to(
                                                  MaintenanceViewSupervisor(
                                                      maintenanceController
                                                          .filteredVehicleMaintenance![
                                                              index]
                                                          .vehicleDetails));
                                            } else {
                                              Get.to(MaintenanceView(
                                                VehicleName: maintenanceController
                                                        .filteredVehicleMaintenance![
                                                            index]
                                                        .vehicleDetails
                                                        ?.vehicleNo ??
                                                    '',
                                                vehicleID: maintenanceController
                                                        .filteredVehicleMaintenance![
                                                            index]
                                                        .vehicleDetails
                                                        ?.id ??
                                                    0,
                                                jobId: 0,
                                              ));
                                            }
                                            // Get.to(ShowMaintenanceSheet(vehicleDetails.id));
                                          } else {
                                            print(
                                                "eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
                                            // maintenanceController
                                            //     .textFieldAdd();
                                            // maintenanceController.addField();
                                            Get.to(MaintenanceView(
                                              VehicleName: maintenanceController
                                                      .filteredVehicleMaintenance![
                                                          index]
                                                      .vehicleDetails
                                                      ?.vehicleNo ??
                                                  '',
                                              vehicleID: maintenanceController
                                                      .filteredVehicleMaintenance![
                                                          index]
                                                      .vehicleDetails
                                                      ?.id ??
                                                  0,
                                              details: maintenanceController
                                                  .filteredVehicleMaintenance![
                                                      index]
                                                  .vehicleDetails,
                                              jobId: 0,
                                            ));
                                          }
                                        }
                                      },
                                      child: Container(
                                        width: 100 * SizeConfig.widthMultiplier,
                                        color: Colors.white,
                                        height:
                                            10 * SizeConfig.heightMultiplier,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  height: 10 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                  width: 15 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                  child: (maintenanceController
                                                                  .filteredVehicleMaintenance![
                                                                      index]
                                                                  .vehicleDetails
                                                                  ?.vehiclePhoto ??
                                                              "")
                                                          .isNotEmpty
                                                      ? Image.network(
                                                          "${RemoteServices.baseUrl + maintenanceController.filteredVehicleMaintenance![index].vehicleDetails!.vehiclePhoto!}",
                                                          errorBuilder: (context,
                                                                  error,
                                                                  stackTrace) =>
                                                              Icon(Icons
                                                                  .image_not_supported),
                                                        )
                                                      : Image.network(
                                                          "https://anshinfra.macsysonline.com/public/asset_photo/noimage.png",
                                                          errorBuilder: (context,
                                                                  error,
                                                                  stackTrace) =>
                                                              Icon(Icons
                                                                  .image_not_supported),
                                                        ),
                                                ),
                                                SizedBox(
                                                  width: 2 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    CustTextStart(
                                                        name:
                                                            "${maintenanceController.filteredVehicleMaintenance![index].vehicleDetails!.vehicleNo}",
                                                        size: 2,
                                                        colors:
                                                            colorPrimaryDark,
                                                        fontWeightName:
                                                            FontWeight.w600),
                                                    SizedBox(
                                                        height: 0.5 *
                                                            SizeConfig
                                                                .heightMultiplier),
                                                    CustTextStart(
                                                        name:
                                                            "${maintenanceController.filteredVehicleMaintenance![index].vehicleDetails!.modelName}",
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
                                            maintenanceController.filteredVehicleMaintenance![index].status == 1
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 2,
                                                            style: BorderStyle
                                                                .solid,
                                                            color:
                                                                Colors.green),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5))),
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: SizeConfig
                                                                .widthMultiplier *
                                                            1.5,
                                                        vertical:
                                                            SizeConfig.heightMultiplier *
                                                                0.2),
                                                    child: CustTextStart(
                                                        name: "Approved",
                                                        size: 1.2,
                                                        colors: colorPrimary,
                                                        fontWeightName: FontWeight.w500))
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
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

  _fieldFocusChange(BuildContext context, FocusNode currentFocus) {
    currentFocus.unfocus();
  }
}
