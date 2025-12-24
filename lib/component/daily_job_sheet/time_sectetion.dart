import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:macsys/maintaince/vehicle_maintaince_list_model.dart';
import 'package:macsys/util/ApiClient.dart';

import '../../util/SizeConfig.dart';
import '../../util/custom_dialog.dart';
import '../custom_widget/colorsC.dart';
import '../custom_widget/cust_text.dart';
import 'daily_job_sheet_controller.dart';

class timeSectetion extends StatelessWidget {
  var time, isstartTime, index;
  List worktime;

  timeSectetion({
    required this.time,
    required this.isstartTime,
    required this.index,
    required this.worktime,
  });

  var DJSController = Get.put(DailyJobSheetController());

  bool dateTimeChanged = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    DateFormat inputformatter = DateFormat("d MMM yyyy");
    DateTime parseDate = inputformatter
        .parse(ApiClient.convertDate(DJSController.currDate.toString()));

    DateFormat outputFormat = DateFormat("yyyy-MM-dd");
    String jobDateNew = outputFormat.format(parseDate);

    String jobDate =
        DJSController.jobDate == " " ? jobDateNew : DJSController.jobDate;
    // var jobDate = DJSController.jobDate == " "
    //     ? ApiClient.convertDate(DJSController.currDate.toString())
    //     : DJSController.jobDate;

    DateTime formattedcurrentDate = DateTime.now();

    DateFormat dateFormat3 = DateFormat("yyyy-MM-dd");
    DateTime currentDate2 = dateFormat3.parse(formattedcurrentDate.toString());
    String currentDate = DateFormat("yyyy-MM-dd").format(currentDate2);

    var maxEndTime = jobDate == currentDate
        ? DateTime.now()
        : DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            23,
            59,
          );
    // var maxEndTime;
    DateTime? minDateParsed;
    // var minDateParsed;

    if (worktime.isNotEmpty && worktime.last.containsKey("start_time")) {
      var minEndTime = worktime[worktime.length - 1]["start_time"];
      DateFormat dateFormat =
          DateFormat("h:mm a"); // 12-hour time format with AM/PM
      if (minEndTime != "00:00") {
        minDateParsed = dateFormat.parse(minEndTime);
        print("not equal-*************$worktime");
        if (worktime.isNotEmpty && worktime.last.containsKey("s_date")) {
          var initialstartDate =
              worktime[worktime.length - 1]['s_date'].toString();
          DateFormat dateFormat3 = DateFormat("yyyy-MM-dd");
          DateTime formattedDate = dateFormat3.parse(initialstartDate);
          String startDate = dateFormat3.format(formattedDate);
          print("conatans date-*************");
          if (currentDate != startDate) {
            minDateParsed = dateFormat.parse(minEndTime);
          } else {
            minDateParsed = time;
          }
        } else {
          print("Not conatans date-*************");

          minDateParsed = time;
          // }
        }
      } else {
        minDateParsed = time;
      }
      print("worktime-*************$worktime");
      print("minEndTime-*************$minEndTime");
      print("minDateParsed-*************$minDateParsed");
      print("time-*************$time");

      // var initialstartDate25 = "2025-01-17 05:24:00.000";
      // // Use a DateFormat that matches the input string
      // DateFormat dateFormat25 = DateFormat("yyyy-MM-dd HH:mm:ss.SSS");
      // // Parse the string into a DateTime object
      // minDateParsed = dateFormat25.parse(initialstartDate25);
    } else {
      minDateParsed = time;
      print("timesnow-*************$time");
    }

    if (worktime.isNotEmpty && worktime.last.containsKey('s_date')) {
      var initialstartDate2 =
          worktime[worktime.length - 1]['e_date'].toString();
      DateFormat dateFormat2 = DateFormat("yyyy-MM-dd");
      DateTime formattedDate2 = dateFormat2.parse(initialstartDate2);
      String lastEndDate = dateFormat2.format(formattedDate2);

      var initialstartDate = worktime[worktime.length - 1]['s_date'].toString();
      DateFormat dateFormat3 = DateFormat("yyyy-MM-dd");
      DateTime formattedDate = dateFormat3.parse(initialstartDate);
      String startDate = dateFormat3.format(formattedDate);

      time = lastEndDate != currentDate ? minDateParsed : DateTime.now();

      log("##############################");
      log("lastEndDate$lastEndDate");
      log("currentDate$currentDate");
      log("minDateParsed$minDateParsed");
      log("##############################");
      log("start$startDate");
      log("jobdate$jobDate");
      log("currentDate$currentDate");
      log("time$time");

      // if (startDate == currentDate) {
      //   time = DateTime.now();
      maxEndTime = (jobDate != currentDate && jobDate != startDate)
          ? DateTime.now()
          : maxEndTime;
    } else {
      time = DateTime.now();
    }

    return GetBuilder<DailyJobSheetController>(
      init: DailyJobSheetController(),
      builder: (controller) => Container(
        color: colorPrimary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 1 * SizeConfig.heightMultiplier,
            ),
            CustText(
                name: "TODAY'S WORKING HOURS",
                size: 1.8,
                colors: Colors.white,
                fontWeightName: FontWeight.w600),
            SizedBox(
              height: 1 * SizeConfig.heightMultiplier,
            ),
            Container(
              height: 25 * SizeConfig.heightMultiplier,
              child: CupertinoTheme(
                  data: CupertinoThemeData(
                    brightness: CupertinoTheme.of(context).brightness,
                    primaryColor: Colors.white,
                    primaryContrastingColor: Colors.white,
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: GoogleFonts.notoSans(
                          textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        fontSize: 2 * SizeConfig.textMultiplier,
                      )),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    minimumDate: minDateParsed,
                    // minimumDate: DateTime.now().subtract(Duration(days: 1)),
                    initialDateTime: time,

                    // initialDateTime:  DJSController.jobType == "day"?DateTime.now():time,
                    // minimumDate:DJSController.jobType == "day"?time :getYesterday(),
                    backgroundColor: colorPrimary,
                    maximumDate: maxEndTime,

                    // maximumDate: DateTime.now().subtract(Duration(days: 1)),
                    onDateTimeChanged: (DateTime newDateTime) {
                      DJSController.updateTime(newDateTime, isstartTime);
                      print("^6666666666666666666");
                      print(newDateTime);
                      print(isstartTime);

                      dateTimeChanged = true;

                      // meetUpController.updateTemp(newDateTime);
                    },
                  )),
            ),
            SizedBox(
              height: 2 * SizeConfig.heightMultiplier,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    print("*************************");
                    //  print(DJSController.dailyJSheetReport);
                    // print(worktime);
                    // print(worktime[index]['start_time']);
                    // print("Formatted last end date: $formattedDate");
                    // print(currentDate);
                    // print(jobDate);
                    // print(jobDateNew);
                    print(minDateParsed);

                    Navigator.pop(context);
                  },
                  child: Container(
                      height: 5 * SizeConfig.heightMultiplier,
                      width: 35 * SizeConfig.widthMultiplier,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.all(
                              Radius.circular(2 * SizeConfig.widthMultiplier)),
                          border: Border.all(
                              width: 0.0 * SizeConfig.widthMultiplier,
                              color: Colors.grey,
                              strokeAlign: BorderSide.strokeAlignCenter)),
                      child: Center(
                          child: CustText(
                              name: "Cancel",
                              size: 1.8,
                              colors: Colors.black,
                              fontWeightName: FontWeight.w600))),
                ),
                SizedBox(width: 2 * SizeConfig.widthMultiplier),
                GestureDetector(
                  onTap: () {
                    if (!dateTimeChanged) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              CustomDialog("Please Change Time "));
                      print("$time");

                      // DJSController.updateTime(selectedTime, isstartTime);
                      // DJSController.submitTime(index, isstartTime);
                    } else {
                      DJSController.submitTime(index, isstartTime);
                      DJSController.tt();
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                      height: 5 * SizeConfig.heightMultiplier,
                      width: 35 * SizeConfig.widthMultiplier,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.all(
                              Radius.circular(2 * SizeConfig.widthMultiplier)),
                          border: Border.all(
                              width: 0.0 * SizeConfig.widthMultiplier,
                              color: Colors.grey,
                              strokeAlign: BorderSide.strokeAlignCenter)),
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
              height: 1 * SizeConfig.heightMultiplier,
            ),
          ],
        ),
      ),
    );
  }
}
