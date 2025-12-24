import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:macsys/component/custom_widget/custom_loading_popup.dart';
import 'package:macsys/component/job_details/job_details_controller.dart';
import 'package:macsys/component/job_details/job_details_view.dart';
import 'package:macsys/component/jobs/job_controller.dart';
import 'package:macsys/component/jobs/job_view.dart';
import 'package:macsys/maintaince/maintaince_controller.dart';
import 'package:macsys/util/ApiClient.dart';
import 'package:macsys/util/custom_dialog.dart';
import '../component/custom_widget/colorsC.dart';
import '../component/custom_widget/cust_text.dart';
import '../util/SizeConfig.dart';

class ConfirmationCardDialog extends StatelessWidget {
  var title, msg, transfer, siteid, vehicleDetails, btnStatus, jobId;
  var jobsDetailsController = Get.put(JobsDetailsController());
  ConfirmationCardDialog({
    @required this.msg,
    this.transfer,
    this.siteid,
    this.vehicleDetails,
    this.btnStatus,
    required this.onSelected,
    required this.jobId,
  });

  var onSelected;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4 * SizeConfig.widthMultiplier)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 0.0, right: 0.0),
      child: Container(
        padding: EdgeInsets.only(
          top: 18.0,
        ),
        margin: EdgeInsets.only(
            top: 0.7 * SizeConfig.widthMultiplier,
            right: 2 * SizeConfig.widthMultiplier),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [colorPrimary, colorPrimary],
              tileMode: TileMode.repeated,
            ),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(4 * SizeConfig.widthMultiplier),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black26,
                blurRadius: 0.0,
                offset: Offset(0.0, 0.0),
              ),
            ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
                child: Padding(
              padding: EdgeInsets.all(2.5 * SizeConfig.widthMultiplier),
              child: CustText(
                  name: msg,
                  size: 1.8,
                  colors: Colors.white,
                  fontWeightName: FontWeight.w400),
            ) //
                ),
            SizedBox(height: 3 * SizeConfig.heightMultiplier),
            InkWell(
              child: Container(
                padding: EdgeInsets.only(
                    top: 1 * SizeConfig.heightMultiplier,
                    bottom: 1 * SizeConfig.heightMultiplier),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft:
                          Radius.circular(4 * SizeConfig.widthMultiplier),
                      bottomRight:
                          Radius.circular(4 * SizeConfig.widthMultiplier)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        onSelected(false);
                        Navigator.pop(context);
                      },
                      child: CustText(
                          name: "Cancel",
                          size: 2,
                          colors: Colors.blue,
                          fontWeightName: FontWeight.w600),
                    ),
                    TextButton(
                      onPressed: () async {
                        await onSelected(true);
                        // showDialog(
                        //     context: context,
                        //     builder: (BuildContext context) =>
                        //         CustomLoadingPopup());

                        await ApiClient.gs.remove('job_$jobId');
                        var removedData = await ApiClient.gs.read('job_$jobId');
                        log("job_$jobId from GetStorage after removal: $removedData");

                        jobsDetailsController.getJobDetails(
                          "${jobId}",
                        );
                        log("******************Accepted job");
                        log("***************${jobId}");

                        Navigator.pop(context);

                        Get.back();
                        final JobsController jobsController =
                            Get.put(JobsController());

                        await Get.off(
                            JobsDetilasView("${jobsController.jobStatus}", 0));
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            final MaintenanceController maintenanceController =
                                Get.put(MaintenanceController());
                            return CustomDialog(maintenanceController
                                .msgTransfer); // Ensure msgTransfer is not null
                          },
                        );
                      },
                      child: CustText(
                          name: "Yes",
                          size: 2,
                          colors: Colors.blue,
                          fontWeightName: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
