import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:macsys/component/job_details/job_details_view.dart';

import '../../services/remote_services.dart';
import '../../util/ApiClient.dart';
import '../../util/custom_dialog.dart';
import '../../util/validator.dart';
import '../job_details/job_details_controller.dart';

int flag = 0;
var currentDate;
int isTransfer = 1;

class DailyJobSheetController extends GetxController {
  var status, msg = "";
  List fuelListController = [];
  var JobDescriptionController = TextEditingController(), jobDescription = "";
  var machineReadingController = TextEditingController(), machineReading = "";
  var fuelAddedController = TextEditingController(), fuelAdded = "";
  var ureaController = TextEditingController(), urea = "";

  var totalH = 0;
  var totalM = 0;
  var monitoringImg = "";
  var times;
  int dateDifference = 0;
  var jobDate = DateTime.now().toString();
  List<TextEditingController> textControllers = [];

  List<String> textFieldValues = [''];
  List<String> fuelDates = [];
  final ImagePicker _picker = ImagePicker();
  int activeIndex = 0;

  @override
  void onInit() {
    super.onInit();

    // cleanData();
    // Initialize the first controller
    textControllers.add(TextEditingController(text: textFieldValues[0]));
    // print("TEXTFIELD:: ${textFieldValues[0]}");
    fuelDates.add(DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            DateTime.now().hour,
            DateTime.now().minute,
            DateTime.now().second)
        .toString());

    // print("fuelDates$fuelDates");
  }

  File? image;
  List<Map<String, dynamic>> workTime = [
    {
      "start_time": "00:00",
      "end_time": "00:00",
      "Work_time": "00:00",
      "start_date": "",
      "end_date": "",
      "s_date": DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 0, 00, 00),
      "e_date": DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 0, 00, 00),
      "sTime": DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 0, 00, 00),
      "eTime": DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 0, 00, 00),
      "break_time": "00:00"
    },
  ];

  void onValueChanged(int index, String value) {
    textFieldValues[index] = value;
  }

  void addField(index, flag) {
    if (flag) {
      textControllers.add(TextEditingController());
      textFieldValues.add('');
      activeIndex = textControllers.length - 1; // Activate the last added field
      fuelDates.add(DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              DateTime.now().hour,
              DateTime.now().minute,
              DateTime.now().second)
          .toString());
      // print("ACTIVEINDEXX$activeIndex");
      // print("Innerindex$index");
      update();
    } else {
      textControllers.removeAt(index);
      textFieldValues.removeAt(index);
      fuelDates.removeAt(index);
      if (index > 0) {
        activeIndex = index - 1;
      } else if (index == 1) {
        activeIndex = index;
      } else {
        activeIndex = 0;
      }
      // print("ACTIVEINDEXX$activeIndex");
      // print("Innerindex$index");

      update();
    } // Trigger a re-build
  }

  @override
  void onClose() {
    // Dispose all controllers to prevent memory leaks
    for (var controller in textControllers) {
      controller.dispose();
    }
    super.onClose();
  }

  addWorkTime(
    index,
    isAdd,
  ) {
    if (isAdd) {
      // print("$index");
      Map<String, dynamic> map = {
        "start_time": "00:00",
        "end_time": "00:00",
        "Work_time": "00:00",
        "s_date": DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 0, 00, 00),
        "e_date": DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 0, 00, 00),
        "sTime": DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 0, 00, 00),
        "eTime": DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 0, 00, 00),
        "break_time": "00:00"
      };

      workTime.add(map);

      workTime[index]['eTime'] = eTime;
      workTime[index]['sTime'] = sTime;
      workTime[index + 1]['sTime'] = workTime[index]['eTime'];
    } else {
      workTime.remove(workTime[index]);
      workTime[index - 1]['sTime'] = workTime[index - 1]['eTime'];
      eTime = workTime[index - 1]['sTime'];

      tt();
    }
    update();
  }

  var sTime = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 00, 00);
  var eTime = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 00, 00);

  updateTime(DateTime newDateTime, flag) {
    // print("\n sTime  for verification ${newDateTime}:$sTime");
    // print("\n eTime  for verification ${newDateTime}:$eTime");

    if (flag) {
      sTime = newDateTime;
    } else {
      eTime = newDateTime;
    }

    update();
  }

  submitTime(index, flag) {
    if (flag) {
      if (workTime[index]['end_time'] != "00:00") {
        workTime[index]['end_time'] = "00:00";
        workTime.last['Work_time'] = "00:00";
        workTime[index]['eTime'] = DateTime(DateTime.now().year,
            DateTime.now().month, DateTime.now().day, 0, 00, 00);
      }

/*     workTime[index]['s_date'] = ApiClient.convertCurrDate(DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              00,
              00,
              00)
          .toString());
      // print("DATE::${workTime[index]['s_date']}");*/

      workTime[index]['start_time'] = ApiClient.convertTime(sTime.toString());
      workTime[index]['sTime'] = sTime;
    } else {
      workTime[index]['end_time'] = ApiClient.convertTime(eTime.toString());
      workTime[index]['eTime'] = eTime;

/*      workTime[index]['e_date'] = ApiClient.convertCurrDate(DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              00,
              00,
              00)
          .toString());*/
    }

    if (workTime[index]['start_time'] != "00:00" &&
        workTime[index]['end_time'] != "00:00") {
      ApiClient.twoDateDifference(sTime, eTime) == 1
          ? dateDifference = 1
          : dateDifference = 0;
      // ApiClient.TimeDifference(workTime[index]['sTime'], workTime[index]['eTime'],dateDifference);
      // print("ST");
      workTime[index]['Work_time'] =
          ApiClient.TimeDifference(sTime, eTime, dateDifference);
      // print("\ndateDifference:::$dateDifference");
      tt();
    } else {
      ApiClient.twoDateDifference(sTime, eTime) == 1
          ? dateDifference = 1
          : dateDifference = 0;
      // print("\ndateDifference:::$dateDifference");
      // ApiClient.TimeDifference(workTime[index]['sTime'], workTime[index]['eTime'],dateDifference);
      workTime[index]['Work_time'] =
          ApiClient.TimeDifference(sTime, eTime, dateDifference);
      workTime[index]['Work_time'] = "00:00";
      tt();
    }

    update();
  }

  tt() {
    int totalMin = 0;
    for (int i = 0; i < workTime.length; i++) {
      final split = workTime[i]['Work_time'].split(':');
      totalMin = totalMin + ((int.parse(split[0])) * 60) + int.parse(split[1]);
    }

    totalH = totalMin ~/ 60;
    totalM = totalMin % 60;
  }

  get_image(ImageSource source) async {
    var img = await ImagePicker()
        .pickImage(source: source, maxHeight: 500, maxWidth: 300); // moto x4
    if (img != null) {
      var cropped = await ImageCropper().cropImage(
        sourcePath: img.path,
        compressQuality: 50,
        /*     aspectRatioPresets: [
          CropAspectRatioPreset.square, // Single ratio for consistency
          CropAspectRatioPreset.ratio16x9,
          CropAspectRatioPreset.ratio4x3,
        ],*/
        // aspectRatio:
        //     const CropAspectRatio(ratioX: 3, ratioY: 3),
        // maxWidth: 300,
        // maxHeight: 400,
        uiSettings: [
          AndroidUiSettings(
            toolbarColor: Colors.blue,
            toolbarTitle: 'Ansh Infra',
            statusBarColor: Colors.blue, // Set the status bar color
            backgroundColor: Colors.white,
            toolbarWidgetColor: Colors.white,
            cropFrameColor: Colors.blue,
            cropGridColor: Colors.grey,
            cropFrameStrokeWidth: 4,
            cropGridRowCount: 3,
            cropGridColumnCount: 3,
            showCropGrid: true,

            lockAspectRatio: false,
          ),
        ],
      );

      if (cropped != null) {
        image = File(cropped.path);
      }
    }

    update();
  }

  bool emptyFuel = false;

  Validation() {
    jobDescription =
        Validator.validateJobDescription(JobDescriptionController.text);
    machineReading =
        Validator.validateReading(machineReadingController.text, "Reading");
    urea = Validator.validateReading(ureaController.text, "Urea");
    if (textFieldValues[0] == "") {
      emptyFuel = true;
    } else {
      emptyFuel = false;
    }
    update();
  }

  bool fuelValidation(index) {
    if (textFieldValues[index] == "") {
      return true;
    } else {
      addField(index, true);
      return false;
    }
  }

  idleValidation() {
    machineReading =
        Validator.validateReading(machineReadingController.text, "Reading");
    fuelAdded = Validator.validateReading(fuelAddedController.text, "Fuel");
    // print("asdasdasd ${fuelAddedController.text}");
    update();
  }

  int draftIndex = 0;
  final currDate = DateTime.now();
  var isDraft;
  Map<String, dynamic> dailyJobSheetReport = {};
  Future getDraftJobSheet(vehicleId) async {
    dailyJobSheetReport.clear();
    isDraft = '';

    try {
      Map map = {
        "vehicle_id": "$vehicleId",
      };
      print("----------------befor respnse getDraftJobSheet-------");
      var getDetails =
          await RemoteServices.postMethodWithToken('api/v1/job-sheet', map);
      // // print("$map");

      printInfo(info: "getDetails :: ${getDetails.body}");
      if (getDetails.statusCode == 200) {
        print("----------------after respnse getDraftJobSheet-------");

        final Map<String, dynamic> jsonResponse = json.decode(getDetails.body);
        final Map<String, dynamic> dailyReport = jsonResponse['daily_report'];

        dailyJobSheetReport = await jsonResponse['daily_report'];
        JobDescriptionController.text =
            dailyReport['job_desc'] == null ? " " : dailyReport['job_desc'];

        isDraft = await dailyReport['is_draft'] ?? "";
        machineReadingController.text =
            dailyReport['reading'] == null ? " " : dailyReport['reading'];
        fuelAddedController.text = dailyReport['fuel_consumption'] == null
            ? " "
            : dailyReport['fuel_consumption'];

        jobDate = dailyReport['job_date'];
        ureaController.text =
            dailyReport['urea'] == null ? " " : dailyReport['urea'];
        vehStatus = dailyReport['status'];
        // // print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@$vehStatus");

        if (dailyReport['monitoring_img'] != null) {
          monitoringImg = dailyReport['monitoring_img'];
        }
        if (dailyReport['fuel_status'].length != 0) {
          textFieldValues.clear();
          textControllers.clear();
          fuelDates.clear();
          for (int i = 0; i < dailyReport['fuel_status'].length; i++) {
            textControllers.add(TextEditingController(
                text: dailyReport['fuel_status'][i]['fuel'].toString()));
            textFieldValues
                .add(dailyReport['fuel_status'][i]['fuel'].toString());
            fuelDates
                .add(dailyReport['fuel_status'][i]['fuel_date'].toString());
          }
        }
        workTime.clear();
        workTime = [
          {
            "start_time": "00:00",
            "end_time": "00:00",
            "Work_time": "00:00",
            "sTime": DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, 0, 00, 00),
            "eTime": DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, 0, 00, 00),
            "break_time": "00:00"
          },
        ];
        //todo HERE IS CLOCK DRAFT LOGIC

        for (int i = 0; i < dailyReport['times'].length; i++) {
          if (i != 0) {
            // // print(
            //     "${dailyReport['times'][i]['work_start_date']} here is the value");
            // // print(
            //     "${dailyReport['times'][i]['work_end_date']} here is the value");
            Map<String, dynamic> map = {
              "start_time": "00:00",
              "end_time": "00:00",
              "Work_time": "00:00",
              "sTime": DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day, 0, 00, 00),
              "eTime": DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day, 0, 00, 00),
              "s_date": DateTime.parse(
                  "${dailyReport['times'][i]['work_start_date']} 00:00:00.000"),
              "e_date": DateTime.parse(
                  "${dailyReport['times'][i]['work_end_date']} 00:00:00.000"),
              "break_time": "00:00"
            };

            workTime.add(map);
          } else {
            if (dailyReport['times'][i]['work_start_date'] != "0000-00-00") {
              // // print("object\n $i");
              workTime[i]["s_date"] = DateTime.parse(
                  "${dailyReport['times'][i]['work_start_date']} 00:00:00.000");
            }
            if (dailyReport['times'][i]['work_end_date'] != "0000-00-00") {
              workTime[i]["e_date"] = DateTime.parse(
                  "${dailyReport['times'][i]['work_end_date']} 00:00:00.000");
            }
          }
          var TodayDate = DateTime.now();
          TodayDate = TodayDate.add(Duration(seconds: 1));
          final sdate = TodayDate.toString().split(' ');
          var curDate = sdate[0];
          curDate = sdate[0];
          currentDate = curDate;
          final startTime = dailyReport['times'][i]['start_time'];
          final endTime = dailyReport['times'][i]['end_time'];

          // // print("JOB DATE::${jobDate}");
          // // print("${curDate}");
          if (startTime != "00:00:00") {
            final startDateTime = DateTime.parse("$curDate $startTime");
            updateTime(startDateTime, true);
            submitTime(i, true);
          }

          if (endTime != "00:00:00") {
            final endDateTime = DateTime.parse("$curDate $endTime");
            // // print("endD::::$endDateTime");
            updateTime(endDateTime, false);
            submitTime(i, false);
          }
        }

        ///IMAGE CODE
        monitoringImg = dailyReport['monitoring_img'] == null
            ? ''
            : dailyReport['monitoring_img'];
        // // print("MONITORING ${monitoringImg}");
      } else {
        throw Exception('Failed to load data from the API');
      }
      // var apiDetails = homeModelFromJson(getDetails.body);
      /*      if(apiDetails.flag == 1){
              status = apiDetails.flag;
              msg = apiDetails.msg;
              allocated = apiDetails.allocated!;
              ongoing = apiDetails.ongoing!;

            }*/
    } catch (e) {
      // print("catch  == $e");
      // print("Here is the error  == $e");
      //   checkUpdate();
    }

    update();
  }

  DateTime sDate = DateTime.now();
  DateTime eDate = DateTime.now();
  var isProcessing = false.obs;

  Future addDailyJobSheet(vehicleId, jobID, context, isDraft, forceAdd) async {
    var isProcessing = false.obs;

    var stime = [];
    var etime = [];
    var sdate = [];
    var edate = [];
    // print("ASDASDASDASD ::$jobID");

/*    for (int i = 0; i < workDay.length; i++) {
      sdate.add(curDate);
      edate.add(curDate);
      // print("start_time DATA SEND :${workTime[i]['start_time']}");
      // print("end_time DATA SEND :${workTime[i]['end_time']}");
    } */

    var TodayDate1 = DateTime.now();
    TodayDate1 = TodayDate1.add(Duration(seconds: 1));
    final currentDate1 = TodayDate1.toString().split(' ');
    var cDate = currentDate1[0];
    for (int i = 0; i < workTime.length; i++) {
      stime.add(workTime[i]['start_time']);
      etime.add(workTime[i]['end_time']);
      if (workTime[i]['start_time'] != "00:00") {
        sdate.add((workTime[i]['s_date']) == null
            ? cDate
            : ApiClient.convertCurrDate(workTime[i]['s_date'].toString()));
      }
      if (workTime[i]['start_time'] == "00:00") {
        sdate.add((workTime[i]['s_date']) == null
            ? cDate
            : ApiClient.convertCurrDate(workTime[i]['s_date'].toString()));
      }

      if (workTime[i]['end_time'] != "00:00") {
        edate.add((workTime[i]['e_date']) == null
            ? cDate
            : ApiClient.convertCurrDate(workTime[i]['e_date'].toString()));
      }

      if (workTime[i]['end_time'] == "00:00") {
        edate.add((workTime[i]['e_date']) == null
            ? cDate
            : ApiClient.convertCurrDate(workTime[i]['e_date'].toString()));
      }

      await Future.delayed(Duration(seconds: 2));

      // edate.add(workTime[i]['end_date']);
      // edate.add((workTime[i]['end_date'])==null ?workTime[i]['e_date']:workTime[i]['end_date']);
      await Future.delayed(Duration(seconds: 1)); // Simulating async task
    }

    Map map = {
      "vehicle_id": "$vehicleId",
      "job_id": "$jobID",
      "no_of_hours": "$totalH",
      "no_of_minutes": "$totalM",
      "job_desc": JobDescriptionController.text,
      "urea": ureaController.text,
      "verified": "1",
      "reading": machineReadingController.text,
      "fuel_added": fuelAddedController.text,
      "reading_in": "Litre",
      "verification_code": "",
      "is_draft": "$isDraft",
      "status": "$vehStatus",
      // "veh_status": "$fuelStatus",
      "table_times_start": stime,
      "table_times_end": etime,
      "table_dates_start": sdate,
      "table_dates_end": edate,
      "job_date": jobDate,
      "kmperltr": "",
      "work_start_date":
          "${sDate!.year.toString().padLeft(4, '0')}-${sDate!.month.toString().padLeft(2, '0')}-${sDate!.day.toString().padLeft(2, '0')}",
      "end_start_date":
          "${eDate!.year.toString().padLeft(4, '0')}-${eDate!.month.toString().padLeft(2, '0')}-${eDate!.day.toString().padLeft(2, '0')}",
    };
    // log('-----------------machineReadingController.text post------------${machineReadingController.text}');
    // log('-----------------readingData.text post------------${readingData}');
    var TodayDate = DateTime.now();
    TodayDate = TodayDate.add(Duration(seconds: 1));
    final Sdate = TodayDate.toString().split(' ');
    var curDate = Sdate[0];
    curDate = Sdate[0];
    currentDate = curDate;
    int? machineReading =
        await int.tryParse(machineReadingController.text.toString());
    int? readingDatafinal = int.tryParse(readingData.toString());
    // print("Machine Reading: $machineReading");
    // print("Reading Data: $readingData");
    // print(" satus ------------ satus : $vehStatus");
    // if (machineReading! >= readingDatafinal!) {
    //   showDialog(
    //       context: context,
    //       builder: (BuildContext context) => CustomDialog(
    //           "Please Enter Reading greater than previous reading "));
    // }
    log('-------- ApiClient.version---------${ApiClient.box.read("version")}');
    var request = new http.MultipartRequest(
        "POST", Uri.parse('${RemoteServices.baseUrl}api/v1/add-job-sheet'));
    // print("request URL here $request");
    request.headers['Authorization'] = 'Bearer ${ApiClient.box.read('token')}';
    // print("TOKEN::${ApiClient.box.read('token')}");
    request.headers['Content-Type'] = 'application/json';
    request.headers['Accept'] = '*/*';
    request.headers['App-Version'] = await ApiClient.box.read("version");
    request.fields['vehicle_id'] = '$vehicleId';
    request.fields['job_id'] = '$jobID';
    request.fields['no_of_hours'] = '$totalH';
    request.fields['no_of_minutes'] = '$totalM';
    request.fields['job_desc'] = JobDescriptionController.text;
    request.fields['urea'] = ureaController.text;
    request.fields['verified'] = '1';
    request.fields['reading'] = machineReadingController.text;
    request.fields['fuel_added'] = fuelAddedController.text;
    request.fields['reading_in'] = 'Litre';
    request.fields['verification_code'] = '';
    request.fields['is_draft'] = '$isDraft';
    request.fields['status'] = '$vehStatus';
    request.fields['purchase_for'] = '$fuelStatus';
    request.fields['table_times_start'] = "${stime}";
    request.fields['table_times_end'] = "${etime}";
    request.fields['table_dates_start'] = "${sdate}";
    request.fields['table_dates_end'] = "${edate}";
    request.fields['job_date'] = jobDate;
    request.fields['force_add'] = forceAdd.toString();

    request.fields['kmperltr'] = '';
    request.fields['fuels'] = "${textFieldValues}";
    request.fields['fuel_dates'] =
        textFieldValues[0] == "" ? "${[]}" : "${fuelDates}";
    request.fields.forEach((key, value) {
      // print("$key: $value");
    });
    /* List<http.MultipartFile> files = [];
    for(int i = 0; i<mediaFileList!.length;i++){//File file in mediaFileList){
      var f = await http.MultipartFile.fromPath('memory_file[]',mediaFileList![i].path);
      files.add(f);
    }
    request.files.addAll(files);*/
    if (image == null) {
      request.fields['monitoring_img'] = '';
    } else {
      request.files.add(
          await http.MultipartFile.fromPath('monitoring_img', image!.path));
    }

    request.send().then(
      (response) {
        http.Response.fromStream(response).then(
          (onValue) async {
            Navigator.pop(context);

            try {
              // print("statusCode : ${onValue.statusCode}");
              // print("body : ${onValue.body}");

              Map decoded = jsonDecode(onValue.body);
              if (decoded['flag'] == 1) {
                status = decoded['flag'];
                msg = decoded['msg'];
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      CustomDialog(decoded['msg']),
                );

                var jobsDetailsController = Get.put(JobsDetailsController());

                await ApiClient.gs.remove('job_$jobID');
                var removedData = await ApiClient.gs.read('job_$jobID');
                // log("job_$jobID from GetStorage after removal: $removedData");

                jobsDetailsController.getJobDetails("$jobID");
                // print("JOBID::$jobID");
              } else {
                status = decoded['flag'];
                msg = decoded['msg'];

                var jobsDetailsController = Get.put(JobsDetailsController());

                await ApiClient.gs.remove('job_$jobID');
                var removedData = await ApiClient.gs.read('job_$jobID');
                // log("job_$jobID from GetStorage after removal: $removedData");

                jobsDetailsController.getJobDetails("$jobID");
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      CustomDialog(decoded['msg']),
                );
                Get.to(() => JobsDetilasView(jobID, 0));
              }
            } catch (e) {}
          },
        );
      },
    );
  }

  cleanData() {
    status = 0;
    emptyFuel = false;
    msg = "";
    JobDescriptionController.clear();
    jobDescription = "";
    machineReadingController.clear();
    machineReading = "";
    fuelAddedController.clear();
    fuelAdded = "";
    ureaController.clear();
    activeIndex = 0;
    fuelStatus = "Tanker";
    monitoringImg = '';
    urea = "";
    jobDate = " ";
    totalH = 0;
    totalM = 0;
    image = null;
    workTime.clear();
    workTime = [
      {
        "start_time": "00:00",
        "end_time": "00:00",
        "Work_time": "00:00",
        "sTime": DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 0, 00, 00),
        "eTime": DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 0, 00, 00),
        "break_time": "00:00"
      },
    ];
    textFieldValues = [''];
    textControllers.clear();
    textControllers.add(TextEditingController());

    update();
  }

  var vehStatus = "Idle";
  var fuelStatus = "Tanker";
  var readingData;
  var readingIn;
  // var statusnew;
  Future getStatusData(vehicleId) async {
    //// print('status Data===================33333333333333333333333');
    try {
      Map map = {
        "vehicle_id": "$vehicleId",
      };
      //   // print("map  == $map");
      var getDetails = await RemoteServices.postMethodWithToken(
          'api/v1/vehicle-details', map);
      //  // print("$map");
      //  printInfo(
      //  info:
      //     "------------------------------------getDetails :: ${getDetails.body}");
      print("----------------befor respnse getStatusData-------");

      allVehicleDetail = getDetails.body;
      if (getDetails.statusCode == 200) {
        print("----------------after respnse getStatusData-------");

        final Map<String, dynamic> jsonResponse = json.decode(getDetails.body);
        final Map<String, dynamic> data = jsonResponse['vehicles'];
        readingData = await data['last_reading'];
        readingIn = await data['reading_in'] ?? "Km";
        var statusData = await data['status'];
        // statusnew = await data['is_draft'];
        // // print('status Data===================$statusData');
        // // print('last reading===================$readingData');
        // // print(' readingIn===================$readingIn');
        // // print(' statusnew===================$statusnew');

        if (statusData == "In Working") {
          updateStatus("In Working");
          vehStatus = "In Working";
        } else if (statusData == "Awaiting Maintenance") {
          updateStatus("Awaiting Maintenance");
          vehStatus = "Awaiting Maintenance";
        } else if (statusData == "Idle") {
          updateStatus("Idle");
          vehStatus = "Idle";
        }
        update();
      } else {
        //  checkUpdate();
      }
    } catch (e) {
      // print("catch  == $e");
      //   checkUpdate();
    }
    update();
  }

  void updateStatus(String newStatus) {
    vehStatus = newStatus;
    // log('uodatestatuss----------$vehStatus');

    update();
  }

  void updateFuelStatus(String newStatus) {
    fuelStatus = newStatus;
    update();
  }

  bool checkEndTime() {
    if (workTime[workTime.length - 1]["end_time"] == "00:00" &&
        DateFormat('yyyy-MM-dd').format(DateTime.now()) != jobDate) {
      // print("${workTime[workTime.length - 1]["end_time"] == "00:00"}");
      // print("Here is the Condition 1");
      // print("Here is the ${DateTime.now()}   job Date :::${jobDate}");
      return true;
    } else if (workTime[workTime.length - 1]["end_time"] == "00:00") {
      // print(
      //  "Here is the DateFormat('yyyy-MM-dd').format(DateTime.now())==jobDate");
      // print("Here is the Condition 2");
      return false;
    } else {
      // print(
      //   "Here is the ${ApiClient.currentDate(DateTime.now().toString())}   job Date :::${jobDate}");
      // print("Here is the Condition 3");
      return true;
    }
  }
}
