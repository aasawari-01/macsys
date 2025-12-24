import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:macsys/component/custom_widget/colorsC.dart';
import 'package:macsys/component/custom_widget/cust_text.dart';
import 'package:macsys/component/custom_widget/custom_loading_popup.dart';
import 'package:macsys/component/daily_job_sheet/dropdown_siteaddress_controller.dart';
import 'package:macsys/component/daily_job_sheet/dropdown_siteaddress_model.dart';
import 'package:macsys/component/home/home_controller.dart';
import 'package:macsys/component/job_details/job_details_view.dart';
import 'package:macsys/component/jobs/job_controller.dart';
import 'package:macsys/maintaince/maintaince_controller.dart';
import 'package:macsys/util/ApiClient.dart';
import 'package:macsys/util/SizeConfig.dart';
import 'package:macsys/util/custom_dialog.dart';

import '../component/job_details/job_details_controller.dart';
import '../component/jobs/job_view.dart';

class CustomDialogDropdown extends StatelessWidget {
  final String msg;
  var vehicleDetails;
  var siteid;
  var btnStatus;
  var jobId;

  CustomDialogDropdown(
      this.msg, this.vehicleDetails, this.siteid, this.btnStatus, this.jobId);
  final MaintenanceController maintenanceController =
      Get.put(MaintenanceController());
  final JobsController jobsController = Get.put(JobsController());
  var jobsDetailsController = Get.put(JobsDetailsController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SiteAddressController>(
      init: SiteAddressController(),
      builder: (controller) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4 * SizeConfig.widthMultiplier),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: dialogContent(context, controller),
        );
      },
    );
  }

  Widget dialogContent(BuildContext context, SiteAddressController controller) {
    return Container(
      margin: EdgeInsets.only(left: 0.0, right: 0.0),
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              top: 0.8 * SizeConfig.widthMultiplier,
              right: 2 * SizeConfig.widthMultiplier,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: [const Color.fromARGB(255, 0, 73, 129), colorPrimary],
                tileMode: TileMode.repeated,
              ),
              shape: BoxShape.rectangle,
              borderRadius:
                  BorderRadius.circular(4 * SizeConfig.widthMultiplier),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 0.0,
                  offset: Offset(0.0, 0.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 10 * SizeConfig.widthMultiplier),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 4 * SizeConfig.widthMultiplier),
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    }
                    return Center(
                      child: DropdownButton<SiteAddresses>(
                        isExpanded: false,
                        underline: SizedBox(),
                        value: controller.selectedSiteAddress.value,
                        hint: controller.isLoading.value ||
                                controller.selectedSiteAddress.value == null
                            ? CustText(
                                name: "Select an option", // Hint text
                                size: 28,
                                colors: Colors.white,
                                fontWeightName: FontWeight.w600,
                              )
                            : null,
                        dropdownColor: const Color.fromARGB(255, 0, 73, 129),
                        icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                        style: TextStyle(
                          fontSize: 2 * SizeConfig.textMultiplier,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                        items: controller.siteAddresses.map((site) {
                          return DropdownMenuItem<SiteAddresses>(
                            value: site,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(site.short ??
                                  "Unknown"), // Use the "short" property of SiteAddresses
                            ),
                          );
                        }).toList(),
                        onChanged: (SiteAddresses? newValue) {
                          controller.selectedSiteAddress.value = newValue;
                        },
                      ),
                    );
                  }),
                ),
                SizedBox(height: 6 * SizeConfig.widthMultiplier),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 4 * SizeConfig.widthMultiplier,
                      bottom: 4 * SizeConfig.widthMultiplier,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft:
                            Radius.circular(4 * SizeConfig.widthMultiplier),
                        bottomRight:
                            Radius.circular(4 * SizeConfig.widthMultiplier),
                      ),
                    ),
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        color: colorPrimary,
                        fontSize: 2 * SizeConfig.textMultiplier,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: () async {
                    if (controller.selectedSiteAddress.value != null) {
                      final selectedId =
                          controller.selectedSiteAddress.value!.id;
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              CustomLoadingPopup());
                      if (selectedId != null) {
                        await maintenanceController.transferVehicle(
                            selectedId, [vehicleDetails.vehicleId]);
                      }
                      await ApiClient.gs.remove('job_$jobId');
                      var removedData = await ApiClient.gs.read('job_$jobId');
                      log("job_$jobId from GetStorage after removal: $removedData");
                      jobsDetailsController.getJobDetails(
                        "${jobId}",
                      );

                      log(selectedId.toString());
                      log(vehicleDetails.vehicleId.toString());
                      log(siteid.toString());

                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);

                      //  Get.back();
                      await Get.off(
                          JobsDetilasView("${jobsController.jobStatus}", 0));
                      await showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              CustomDialog(maintenanceController.msgTransfer));
                    } else {
                      print("No site address selected!");
                    }
                  },
                ),
              ],
            ),
          ),
          Positioned(
            right: 3.0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: EdgeInsets.only(top: 1 * SizeConfig.heightMultiplier),
                child: Align(
                  alignment: Alignment.topRight,
                  child: CircleAvatar(
                    radius: 3.5 * SizeConfig.widthMultiplier,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.close, color: Colors.blue),
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
