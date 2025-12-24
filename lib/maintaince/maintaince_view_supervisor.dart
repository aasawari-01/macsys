import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:macsys/component/custom_widget/textfield_widget.dart';
import 'package:macsys/component/job_details/job_details_controller.dart';
import 'package:macsys/component/job_details/job_details_view.dart';
import 'package:macsys/util/confirmation_dialog.dart';
import 'package:macsys/util/fuel_selection_dialog.dart';
import 'package:remixicon/remixicon.dart';
import '../../services/remote_services.dart';
import '../../util/ApiClient.dart';
import '../../util/SizeConfig.dart';
import '../../util/custom_dialog.dart';
import '../component/custom_widget/check_internet.dart';
import '../component/custom_widget/colorsC.dart';
import '../component/custom_widget/cust_text.dart';
import '../component/custom_widget/cust_text_start.dart';
import '../component/custom_widget/custom_loading_popup.dart';
import '../component/custom_widget/selectionDialog.dart';
import '../component/daily_job_sheet/daily_job_sheet_controller.dart';
import '../component/jobs/job_controller.dart';
import 'maintaince_controller.dart';
import 'ongoing_maintaince_view.dart';

class MaintenanceView extends StatefulWidget {
  final String VehicleName;
  final int vehicleID;
  var details, jobId;

  MaintenanceView(
      {required this.VehicleName,
      required this.vehicleID,
      this.details,
      required this.jobId});
  @override
  State<MaintenanceView> createState() => _MaintenanceViewState();
}

class _MaintenanceViewState extends State<MaintenanceView> {
  @override
  void initState() {
    super.initState();

    // print('Before called *********************** ');
    // print(
    //     ' maintenanceController.notesControllerData ${maintenanceController.notesControllerData}');
    // print(
    //     '  maintenanceController.descControllerData ${maintenanceController.descControllerData}');
    // print(
    //     ' maintenanceController.locationControllerData ${maintenanceController.locationControllerData}');
    // print(
    //     'maintenanceController.machineReadingControllerData ${maintenanceController.machineReadingControllerData}');

    // print('afet called *********************** ');
    // print(
    //     ' maintenanceController.notesControllerData ${maintenanceController.notesControllerData}');
    // print(
    //     '  maintenanceController.descControllerData ${maintenanceController.descControllerData}');
    // print(
    //     ' maintenanceController.locationControllerData ${maintenanceController.locationControllerData}');
    // print(
    //     'maintenanceController.machineReadingControllerData ${maintenanceController.machineReadingControllerData}');
    maintenanceController.descriptionController.clear();
    maintenanceController.quantityController.clear();
    maintenanceController.amountController.clear();
    maintenanceController.descController.clear();
    maintenanceController.notesController.clear();
    maintenanceController.locationController.clear();
    maintenanceController.machineReadingController.clear();

    maintenanceController.descController.text =
        maintenanceController.descControllerData ?? '';
    maintenanceController.notesController.text =
        maintenanceController.notesControllerData ?? '';

    maintenanceController.locationController.text =
        maintenanceController.locationControllerData ?? '';
    maintenanceController.machineReadingController.text =
        maintenanceController.machineReadingControllerData ?? "";
    maintenanceController.controllers.clear();
    maintenanceController.instructionList.clear();

    for (var item in maintenanceController.maintenanceReason) {
      log("maintenanceController.maintenanceReason ------------${maintenanceController.maintenanceReason.length} as String");

      if (maintenanceController.maintenanceReason.isNotEmpty) {
        maintenanceController.instructionList.add(item['reason']);
        maintenanceController.controllers.add(
          TextEditingController(text: item['reason']),
        );
      }
    }
    // if (maintenanceController.instructionList.isEmpty) {
    //   maintenanceController.addField();
    // }

    // log("instructionList ------------${maintenanceController.instructionList.length} as String");
    // log("instructionList-----------${maintenanceController.instructionList} as String");
    // for (var item in maintenanceController.quotationMaterialDescription) {
    //   if (maintenanceController.quotationMaterialDescription.isNotEmpty) {
    //     maintenanceController.descriptionController.text =
    //         item['material_description'].toString();
    //     maintenanceController.quantityController.text =
    //         item['quantity'].toString();
    //     maintenanceController.amountController.text = item['amount'].toString();
    //   }
    // }

    for (var item in maintenanceController.quotationMaterialDescription) {
      if (maintenanceController.quotationMaterialDescription.isNotEmpty) {
        maintenanceController.quantityList.add(item['quantity']);
        maintenanceController.amountList.add(item['amount']);
        maintenanceController.descriptionList.add(item['material_description']);
      }
      // maintenanceController.descriptionController.text =
      //     item['material_description'];
    }
    // print("++++++++++: ${maintenanceController.materialDescription.length}");

    // log(maintenanceController.descriptionList.length.toString());
    // log(maintenanceController.amountList.length.toString());
    // log(maintenanceController.quantityList.length.toString());
    maintenanceController.controllers.add(TextEditingController());
  }

  var maintenanceController = Get.put(MaintenanceController());
  var jobsController = Get.put(JobsController());

  final FocusNode descFocus = FocusNode();
  final FocusNode noteFocus = FocusNode();
  final FocusNode reasonFocus = FocusNode();
  final FocusNode machineReadingFocus = FocusNode();
  final FocusNode locationFocus = FocusNode();
  var DJSController = Get.put(DailyJobSheetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrimaryDark,
        leading: GestureDetector(
          onTap: () {
            maintenanceController.cleanData();
            Get.back();
          },
          child: Icon(
            Remix.arrow_left_line,
            size: 6 * SizeConfig.imageSizeMultiplier,
            color: Colors.white,
          ),
        ),
        title: CustText(
            name: "Vehicle Maintenance Quotation",
            size: 2.2,
            colors: Colors.white,
            fontWeightName: FontWeight.w600),
      ),
      body: SingleChildScrollView(
        // physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            GetBuilder<MaintenanceController>(
                init: MaintenanceController(),
                builder: (controller) => maintenanceController.status
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 1 * SizeConfig.heightMultiplier,
                            horizontal: 3 * SizeConfig.widthMultiplier),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 5.5 * SizeConfig.heightMultiplier,
                              width: 100 * SizeConfig.widthMultiplier,
                              color: colorPrimary,
                              child: Center(
                                child: CustText(
                                    name: "Vehicle Details",
                                    size: 1.8,
                                    colors: Colors.white,
                                    fontWeightName: FontWeight.w600),
                              ),
                            ),
                            SizedBox(height: 1.5 * SizeConfig.heightMultiplier),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustText(
                                        name: "Vehicle Name",
                                        size: 1.8,
                                        colors: Colors.black,
                                        fontWeightName: FontWeight.w600),
                                    CustText(
                                        name: ":",
                                        size: 1.8,
                                        colors: Colors.black,
                                        fontWeightName: FontWeight.w600),
                                    Container(
                                      height: 5.5 * SizeConfig.heightMultiplier,
                                      width: 50 * SizeConfig.widthMultiplier,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(1 *
                                                SizeConfig.widthMultiplier)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius:
                                                2 * SizeConfig.widthMultiplier,
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Container(
                                          child: CustText(
                                              name: "${widget.VehicleName}",
                                              size: 1.8,
                                              colors: Colors.black,
                                              fontWeightName: FontWeight.w700),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    height: 1.5 * SizeConfig.heightMultiplier),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustText(
                                        name: "Maintenance Type",
                                        size: 1.8,
                                        colors: Colors.black,
                                        fontWeightName: FontWeight.w600),
                                    CustText(
                                        name: ":",
                                        size: 1.8,
                                        colors: Colors.black,
                                        fontWeightName: FontWeight.w600),
                                    Column(
                                      children: [
                                        Container(
                                          height:
                                              5.5 * SizeConfig.heightMultiplier,
                                          width:
                                              50 * SizeConfig.widthMultiplier,
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
                                            child: Container(
                                              child: GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                      barrierDismissible: true,
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          SelectionDialog(
                                                            selectedValue:
                                                                maintenanceController
                                                                    .selectedTypedata,
                                                            list: maintenanceController
                                                                .maintenanceType,
                                                            onSelected:
                                                                (type, index) {
                                                              /*  maintenanceController
                                                            .locationId =
                                                            locationid;*/
                                                              maintenanceController
                                                                      .selectedTypedata =
                                                                  type;
                                                              print(
                                                                  "Index $index, $type");
                                                              maintenanceController
                                                                  .updateType(
                                                                      type);
                                                              // maintenanceController.updateFuelBalance(index,true);
                                                            },
                                                            flag: 0,
                                                          ));
                                                },
                                                child: CustText(
                                                    name: maintenanceController
                                                                .selectedTypedata !=
                                                            null
                                                        ? maintenanceController
                                                            .selectedTypedata
                                                        : maintenanceController
                                                            .selectedType,
                                                    size: 1.6,
                                                    colors: maintenanceController
                                                                .selectedType ==
                                                            "Select Type"
                                                        ? Colors.black
                                                        : Colors.black,
                                                    fontWeightName:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                maintenanceController.selectedType == "Others"
                                    ? Column(
                                        children: [
                                          SizedBox(
                                              height: 1 *
                                                  SizeConfig.heightMultiplier),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CustText(
                                                  name: "Reason",
                                                  size: 1.8,
                                                  colors: Colors.black,
                                                  fontWeightName:
                                                      FontWeight.w600),
                                              CustText(
                                                  name: ":",
                                                  size: 1.8,
                                                  colors: Colors.black,
                                                  fontWeightName:
                                                      FontWeight.w600),
                                              Container(
                                                height: 5.5 *
                                                    SizeConfig.heightMultiplier,
                                                width: 50 *
                                                    SizeConfig.widthMultiplier,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius
                                                      .all(Radius.circular(1 *
                                                          SizeConfig
                                                              .widthMultiplier)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      blurRadius: 2 *
                                                          SizeConfig
                                                              .widthMultiplier,
                                                    ),
                                                  ],
                                                ),
                                                child: Center(
                                                  child: TextFormField(
                                                    textAlign: TextAlign.start,
                                                    style: GoogleFonts.openSans(
                                                        textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 1.6 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                    )),
                                                    controller:
                                                        maintenanceController
                                                            .reasonTextController,
                                                    cursorColor: Colors.black,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    focusNode: reasonFocus,
                                                    onChanged: (value) {
                                                      print("object $value");
                                                    },
                                                    onFieldSubmitted: (value) {
                                                      reasonFocus.unfocus();
                                                      // maintenanceController.calculateRate(value);
                                                      //  _calculator();
                                                    },
                                                    maxLines: 4,
                                                    decoration: InputDecoration(
                                                      // labelText: "Enter Email",
                                                      // isDense: true,
                                                      counterText: "",
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                        top: 2 *
                                                            SizeConfig
                                                                .heightMultiplier,
                                                        left: 2 *
                                                            SizeConfig
                                                                .widthMultiplier,
                                                        right: 2 *
                                                            SizeConfig
                                                                .widthMultiplier,
                                                      ),
                                                      constraints: BoxConstraints
                                                          .tightFor(
                                                              height: 7 *
                                                                  SizeConfig
                                                                      .heightMultiplier),
                                                      fillColor: const Color(
                                                          0xFF689fef),
                                                      /*contentPadding: new EdgeInsets.symmetric(
                                                          vertical:
                                                          2 * SizeConfig.widthMultiplier,
                                                          horizontal:
                                                          2 * SizeConfig.widthMultiplier),*/
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(2 *
                                                                SizeConfig
                                                                    .widthMultiplier),
                                                        borderSide:
                                                            const BorderSide(
                                                          color:
                                                              Color(0xFF689fef),
                                                        ),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(2 *
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
                                                        borderRadius: BorderRadius
                                                            .circular(2 *
                                                                SizeConfig
                                                                    .widthMultiplier),
                                                        borderSide:
                                                            const BorderSide(
                                                          color:
                                                              Color(0xFF689fef),
                                                          // width: 2.0,
                                                        ),
                                                      ),
                                                      hintText: "Enter Reason",
                                                      hintStyle:
                                                          GoogleFonts.openSans(
                                                              textStyle:
                                                                  TextStyle(
                                                        color: const Color(
                                                            0xFF888888),
                                                        fontSize: 1.6 *
                                                            SizeConfig
                                                                .textMultiplier,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      )),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                              height: 1 *
                                                  SizeConfig.heightMultiplier),
                                        ],
                                      )
                                    : Container(),
                                SizedBox(
                                    height: 1.5 * SizeConfig.heightMultiplier),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustTextStart(
                                    name: "Location",
                                    size: 1.8,
                                    colors: Colors.black,
                                    fontWeightName: FontWeight.w600),
                                CustTextStart(
                                    name: ":",
                                    size: 1.8,
                                    colors: Colors.black,
                                    fontWeightName: FontWeight.w600),
                                Container(
                                  height: 5.5 * SizeConfig.heightMultiplier,
                                  width: 50 * SizeConfig.widthMultiplier,
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
                                    child: TextFormField(
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.openSans(
                                          textStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize:
                                            1.6 * SizeConfig.textMultiplier,
                                      )),
                                      controller: maintenanceController
                                          .locationController,
                                      cursorColor: Colors.black,
                                      textInputAction: TextInputAction.next,
                                      focusNode: locationFocus,
                                      onChanged: (value) {
                                        print("object $value");
                                      },
                                      onFieldSubmitted: (value) {
                                        noteFocus.unfocus();
                                        // maintenanceController.calculateRate(value);
                                        //  _calculator();
                                      },
                                      maxLines: 4,
                                      decoration: InputDecoration(
                                        // labelText: "Enter Email",
                                        // isDense: true,
                                        counterText: "",
                                        contentPadding: EdgeInsets.only(
                                          top: 2 * SizeConfig.heightMultiplier,
                                          left: 2 * SizeConfig.widthMultiplier,
                                          right: 2 * SizeConfig.widthMultiplier,
                                        ),
                                        constraints: BoxConstraints.tightFor(
                                            height: 7 *
                                                SizeConfig.heightMultiplier),
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
                                            color: Colors.transparent,
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
                                        hintText: "Enter Location",
                                        hintStyle: GoogleFonts.openSans(
                                            textStyle: TextStyle(
                                          color: const Color(0xFF888888),
                                          fontSize:
                                              1.6 * SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.w400,
                                        )),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.5 * SizeConfig.heightMultiplier),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustText(
                                    name: "Reading",
                                    size: 1.8,
                                    colors: Colors.black,
                                    fontWeightName: FontWeight.w600),
                                CustText(
                                    name: ":",
                                    size: 1.8,
                                    colors: Colors.black,
                                    fontWeightName: FontWeight.w600),
                                Container(
                                  height: 5.5 * SizeConfig.heightMultiplier,
                                  width: 50 * SizeConfig.widthMultiplier,
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
                                    child: TextFormField(
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize:
                                              1.6 * SizeConfig.textMultiplier,
                                        ),
                                      ),
                                      controller: maintenanceController
                                          .machineReadingController,
                                      cursorColor: Colors.black,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                      inputFormatters: <TextInputFormatter>[
                                        // FilteringTextInputFormatter.digitsOnly
                                        FilteringTextInputFormatter.allow(
                                            RegExp('[0-9.]+'))
                                      ],
                                      textInputAction: TextInputAction.next,
                                      focusNode: machineReadingFocus,
                                      onFieldSubmitted: (term) {
                                        machineReadingFocus.unfocus();
                                      },
                                      maxLength: 9,
                                      decoration: InputDecoration(
                                        // labelText: "Enter Email",
                                        // isDense: true,
                                        counterText: "",
                                        contentPadding: EdgeInsets.only(
                                          top:
                                              -0.5 * SizeConfig.widthMultiplier,
                                          left: 2 * SizeConfig.widthMultiplier,
                                          right: 2 * SizeConfig.widthMultiplier,
                                        ),
                                        constraints: BoxConstraints.tightFor(
                                            height: 7 *
                                                SizeConfig.heightMultiplier),
                                        fillColor: const Color(0xFF689fef),
                                        /*contentPadding: new EdgeInsets.symmetric(
                                              vertical:
                                              2 * SizeConfig.widthMultiplier,
                                              horizontal:
                                              2 * SizeConfig.widthMultiplier),*/
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              1 * SizeConfig.widthMultiplier),
                                          borderSide: const BorderSide(
                                            color: Color(0xFF689fef),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              1 * SizeConfig.widthMultiplier),
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              1 * SizeConfig.widthMultiplier),
                                          borderSide: const BorderSide(
                                            color: Color(0xFF689fef),
                                            // width: 2.0,
                                          ),
                                        ),
                                        hintText: "Machine Reading",
                                        hintStyle: GoogleFonts.openSans(
                                            textStyle: TextStyle(
                                          color: const Color(0xFF888888),
                                          fontSize:
                                              1.6 * SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.w400,
                                        )),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 28 * SizeConfig.widthMultiplier,
                                ),
                                maintenanceController.machineReading != ''
                                    ? CustText(
                                        name: maintenanceController
                                            .machineReading,
                                        size: 1.6,
                                        colors: Colors.red,
                                        fontWeightName: FontWeight.w400)
                                    : Container(),
                              ],
                            ),
                            SizedBox(
                              height: 1 * SizeConfig.heightMultiplier,
                            ),
                            SizedBox(height: SizeConfig.heightMultiplier * 2),
                            SizedBox(height: 1 * SizeConfig.heightMultiplier),
                            Container(
                                height: 5.5 * SizeConfig.heightMultiplier,
                                width: 100 * SizeConfig.widthMultiplier,
                                color: colorPrimary,
                                child: Center(
                                    child: CustText(
                                        name: "Reason/Issues",
                                        size: 1.8,
                                        colors: Colors.white,
                                        fontWeightName: FontWeight.w600))),
                            ListView.builder(
                              itemCount:
                                  maintenanceController.controllers.length,
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
                                    child: TextFormField(
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize:
                                              1.6 * SizeConfig.textMultiplier,
                                        ),
                                      ),
                                      controller: maintenanceController
                                          .controllers[index],
                                      cursorColor: Colors.black,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (value) {},
                                      decoration: InputDecoration(
                                        // labelText: "Enter Email",
                                        // isDense: true,
                                        counterText: "",
                                        contentPadding: EdgeInsets.only(
                                          top:
                                              -0.5 * SizeConfig.widthMultiplier,
                                          left: 2 * SizeConfig.widthMultiplier,
                                          right: 2 * SizeConfig.widthMultiplier,
                                        ),

                                        constraints: BoxConstraints.tightFor(
                                            height: 5.5 *
                                                SizeConfig.heightMultiplier),
                                        fillColor: const Color(0xFF689fef),
                                        /*contentPadding: new EdgeInsets.symmetric(
                                            vertical:
                                            2 * SizeConfig.widthMultiplier,
                                            horizontal:
                                            2 * SizeConfig.widthMultiplier),*/
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              1 * SizeConfig.widthMultiplier),
                                          borderSide: const BorderSide(
                                            color: Color(0xFF689fef),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              1 * SizeConfig.widthMultiplier),
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              1 * SizeConfig.widthMultiplier),
                                          borderSide: const BorderSide(
                                            color: Color(0xFF689fef),
                                            // width: 2.0,
                                          ),
                                        ),
                                        hintText: "Enter Reason/Issues",
                                        hintStyle: GoogleFonts.openSans(
                                            textStyle: TextStyle(
                                          color: const Color(0xFF888888),
                                          fontSize:
                                              1.6 * SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.w400,
                                        )),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            maintenanceController
                                                .removeDataAtInstructionreason(
                                                    index);
                                          },
                                          icon: Icon(Icons.remove_circle,
                                              color: colorPrimary),
                                          iconSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
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
                                            // maintenanceController
                                            //     .removeInstructionreason();
                                          },
                                          child: Container(
                                              // child: Row(
                                              //   children: [
                                              //     CustText(
                                              //         name: "Remove",
                                              //         size: 1.8,
                                              //         colors: Colors.black,
                                              //         fontWeightName:
                                              //             FontWeight.w500),
                                              //     Icon(
                                              //       Remix
                                              //           .checkbox_indeterminate_fill,
                                              //       size: 25,
                                              //       color: colorPrimary,
                                              //     ),
                                              //   ],
                                              // ),
                                              ),
                                        )
                                      : Container(),
                                  SizedBox(
                                    width: 3 * SizeConfig.widthMultiplier,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      log('--------controllers----------------------${maintenanceController.controllers.length}');
                                      if (maintenanceController
                                              .controllers.length ==
                                          0) {
                                        log('--------controllers----------------------${maintenanceController.controllers.length}');
                                        maintenanceController.addField();
                                      }

                                      maintenanceController
                                                  .controllers.isNotEmpty &&
                                              maintenanceController
                                                      .controllers.last.text ==
                                                  "" &&
                                              maintenanceController
                                                      .controllers.length !=
                                                  1
                                          ? showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  CustomDialog(
                                                      "Please Enter Instruction"))
                                          : Container;
                                      maintenanceController.submitDataReason();

                                      // if (maintenanceController
                                      //         .controllers.length ==
                                      //     0) {
                                      //   maintenanceController.addField();
                                      // }

                                      // maintenanceController
                                      //             .controllers.last.text ==
                                      //         ""
                                      //     ?
                                      //      showDialog(
                                      //         context: context,
                                      //         builder: (BuildContext context) =>
                                      //             CustomDialog(
                                      //                 "Please Enter Instruction"))
                                      //     : Container;
                                      // maintenanceController.submitDataReason();
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
                            ),
                            SizedBox(height: 1 * SizeConfig.heightMultiplier),
                            Container(
                                height: 5.5 * SizeConfig.heightMultiplier,
                                width: 100 * SizeConfig.widthMultiplier,
                                color: colorPrimary,
                                child: Center(
                                    child: CustText(
                                        name:
                                            "Photos While Performing Activity",
                                        size: 1.8,
                                        colors: Colors.white,
                                        fontWeightName: FontWeight.w600))),
                            SizedBox(
                              height: 1 * SizeConfig.heightMultiplier,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
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
                                    maintenanceController.maintenanceReasonPhoto
                                                .length ==
                                            0
                                        ? Container()
                                        : GestureDetector(
                                            onTap: () {
                                              //Navigator.pop(context);

                                              print("Heelo");
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          Dialog(
                                                            child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  shape: BoxShape
                                                                      .rectangle,
                                                                  borderRadius:
                                                                      BorderRadius.circular(3 *
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
                                                                        padding:
                                                                            EdgeInsets.all(1 *
                                                                                SizeConfig.widthMultiplier),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Align(
                                                                              alignment: Alignment.bottomRight,
                                                                              child: GestureDetector(
                                                                                onTap: () {
                                                                                  Navigator.of(context).pop();
                                                                                },
                                                                                child: Container(
                                                                                  height: 12.5 * SizeConfig.widthMultiplier,
                                                                                  width: 10 * SizeConfig.widthMultiplier,
                                                                                  child: Icon(Remix.close_circle_line, size: 7 * SizeConfig.imageSizeMultiplier, color: colorPrimary),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            InteractiveViewer(
                                                                              child: Column(
                                                                                children: [
                                                                                  Container(
                                                                                    height: 40 * SizeConfig.heightMultiplier,
                                                                                    width: 80 * SizeConfig.widthMultiplier,
                                                                                    padding: EdgeInsets.only(
                                                                                      top: 1 * SizeConfig.heightMultiplier,
                                                                                      left: 1 * SizeConfig.heightMultiplier,
                                                                                      right: 1 * SizeConfig.heightMultiplier,
                                                                                    ),
                                                                                    margin: EdgeInsets.all(
                                                                                      1 * SizeConfig.heightMultiplier,
                                                                                    ),
                                                                                    decoration: BoxDecoration(
                                                                                      shape: BoxShape.rectangle,
                                                                                      borderRadius: BorderRadius.circular(3 * SizeConfig.widthMultiplier),
                                                                                      /* image: DecorationImage(
                                                                                                                                              fit: BoxFit.fill,
                                                                                                                                              image: NetworkImage(
                                                                                                                                                  '${RemoteServices
                                                                                                                                                      .baseUrlIMG}${photoList[selectedIndex]}')
                                                                                                                                          )*/
                                                                                    ),
                                                                                    child: Image.network(
                                                                                      RemoteServices.baseUrl + maintenanceController.maintenanceReasonPhoto![maintenanceController.selectedIndex6]['reason_photo'].toString(),
                                                                                      fit: BoxFit.contain,
                                                                                    ),
                                                                                  ),
                                                                                  GestureDetector(
                                                                                    onTap: () async {
                                                                                      // await maintenanceController.removeMaintenanceimg(maintenanceController.maintenancePhoto[maintenanceController.selectedIndex4]['id']);
                                                                                      // maintenanceController.maintenancePhoto.removeAt(maintenanceController.selectedIndex4);
                                                                                      // print(maintenanceController.selectedIndex4);
                                                                                      // maintenanceController.selectedIndex4 = 0;
                                                                                      // // Navigator.of(context).pop();
                                                                                      // if (maintenanceController.maintenancePhoto.length == 0) {
                                                                                      //   Navigator.of(context).pop();
                                                                                      // }
                                                                                      showDialog(
                                                                                          barrierDismissible: false,
                                                                                          context: context,
                                                                                          builder: (BuildContext context) => ConfirmationDialog(
                                                                                                title: "Delete",
                                                                                                msg: "Are you sure you want to delete? ",
                                                                                                onSelected: (flag) async {
                                                                                                  await maintenanceController.removeQuotationMaintenanceimg(maintenanceController.maintenanceReasonPhoto[maintenanceController.selectedIndex6]['id']);
                                                                                                  maintenanceController.maintenanceReasonPhoto.removeAt(maintenanceController.selectedIndex6);
                                                                                                  print(maintenanceController.selectedIndex6);
                                                                                                  maintenanceController.selectedIndex6 = 0;
                                                                                                  setState(() {
                                                                                                    maintenanceController.selectedIndex6 = 0;
                                                                                                  });
                                                                                                  // Navigator.of(context).pop();
                                                                                                  Navigator.pop(context);
                                                                                                },
                                                                                              ));

                                                                                      //Navigator.pop(context);
                                                                                    },
                                                                                    child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                      Text(
                                                                                        "Remove",
                                                                                        style: TextStyle(color: Colors.black),
                                                                                      ),
                                                                                      Icon(
                                                                                        Remix.checkbox_indeterminate_fill,
                                                                                        size: 25,
                                                                                        color: colorPrimary,
                                                                                      ),
                                                                                    ]),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 3 * SizeConfig.heightMultiplier),
                                                                            Container(
                                                                              height: 8 * SizeConfig.heightMultiplier,
                                                                              width: 100 * SizeConfig.widthMultiplier,
                                                                              color: Colors.white,
                                                                              child: new ListView.builder(
                                                                                  scrollDirection: Axis.horizontal,
                                                                                  padding: EdgeInsets.zero,
                                                                                  shrinkWrap: true,
                                                                                  physics: ScrollPhysics(),
                                                                                  itemCount: maintenanceController.maintenanceReasonPhoto.length ?? 0,
                                                                                  itemBuilder: (BuildContext context, int index) {
                                                                                    return Container(
                                                                                        child: GestureDetector(
                                                                                            onTap: () {
                                                                                              setState(() {
                                                                                                maintenanceController.selectedIndex6 = index;
                                                                                              });
                                                                                              print('Here is selectedIndex6 ${maintenanceController.selectedIndex6}');
                                                                                              print('Here is index ${index}');
                                                                                            },
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(2),
                                                                                              child: Container(
                                                                                                height: 8 * SizeConfig.heightMultiplier,
                                                                                                width: 18 * SizeConfig.widthMultiplier,
                                                                                                decoration: BoxDecoration(
                                                                                                  shape: BoxShape.rectangle,
                                                                                                  borderRadius: BorderRadius.circular(3 * SizeConfig.widthMultiplier),
                                                                                                ),
                                                                                                child: Image.network(
                                                                                                  RemoteServices.baseUrl + maintenanceController.maintenanceReasonPhoto[index]['reason_photo'].toString(),
                                                                                                  fit: BoxFit.contain,
                                                                                                ),
                                                                                              ),
                                                                                            )));
                                                                                  }),
                                                                            ),
                                                                            SizedBox(height: 1 * SizeConfig.heightMultiplier)
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
                                                      style:
                                                          BorderStyle.solid)),
                                              height: 13 *
                                                  SizeConfig.heightMultiplier,
                                              width: 25 *
                                                  SizeConfig.widthMultiplier,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 2.0 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                  vertical: 1.0 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                ),
                                                child: Image.network(
                                                  RemoteServices.baseUrl +
                                                      maintenanceController
                                                          .maintenanceReasonPhoto![
                                                              0]['reason_photo']
                                                          .toString(),
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          ),
                                    SizedBox(
                                      width: 2.5 * SizeConfig.widthMultiplier,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: SizeConfig.heightMultiplier * 3,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          1.5 * SizeConfig.heightMultiplier),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 2 * SizeConfig.widthMultiplier,
                                      ),
                                      CustTextStart(
                                          name: "Choose Images:",
                                          size: 1.8,
                                          colors: Colors.black,
                                          fontWeightName: FontWeight.w400),
                                      SizedBox(
                                        width: 8 * SizeConfig.widthMultiplier,
                                      ),
                                      maintenanceController.imageList == 0
                                          ? Container()
                                          : GestureDetector(
                                              onTap: () {
                                                print("Heelo");
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext
                                                                context) =>
                                                            Dialog(
                                                              child: Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    shape: BoxShape
                                                                        .rectangle,
                                                                    borderRadius:
                                                                        BorderRadius.circular(3 *
                                                                            SizeConfig.widthMultiplier),
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
                                                                          padding:
                                                                              EdgeInsets.all(1 * SizeConfig.widthMultiplier),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              Align(
                                                                                alignment: Alignment.bottomRight,
                                                                                child: GestureDetector(
                                                                                  onTap: () {
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                  child: Container(
                                                                                    height: 12.5 * SizeConfig.widthMultiplier,
                                                                                    width: 10 * SizeConfig.widthMultiplier,
                                                                                    child: Icon(Remix.close_circle_line, size: 7 * SizeConfig.imageSizeMultiplier, color: colorPrimary),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              InteractiveViewer(
                                                                                child: Container(
                                                                                  height: 40 * SizeConfig.heightMultiplier,
                                                                                  width: 80 * SizeConfig.widthMultiplier,
                                                                                  padding: EdgeInsets.all(
                                                                                    1 * SizeConfig.heightMultiplier,
                                                                                  ),
                                                                                  margin: EdgeInsets.all(
                                                                                    1 * SizeConfig.heightMultiplier,
                                                                                  ),
                                                                                  decoration: BoxDecoration(
                                                                                    shape: BoxShape.rectangle,
                                                                                    borderRadius: BorderRadius.circular(3 * SizeConfig.widthMultiplier),
                                                                                    /* image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(
                                                  '${RemoteServices
                                                      .baseUrlIMG}${photoList[selectedIndex]}')
                                          )*/
                                                                                  ),
                                                                                  child: Image.file(
                                                                                    File(maintenanceController.mediaFileList![maintenanceController.selectedIndex7].path),
                                                                                    fit: BoxFit.contain,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              SizedBox(height: 1 * SizeConfig.heightMultiplier),
                                                                              Container(
                                                                                height: 8 * SizeConfig.heightMultiplier,
                                                                                width: 100 * SizeConfig.widthMultiplier,
                                                                                color: Colors.white,
                                                                                child: new ListView.builder(
                                                                                    scrollDirection: Axis.horizontal,
                                                                                    padding: EdgeInsets.zero,
                                                                                    shrinkWrap: true,
                                                                                    physics: ScrollPhysics(),
                                                                                    itemCount: maintenanceController.mediaFileList!.length,
                                                                                    itemBuilder: (BuildContext context, int index) {
                                                                                      return Container(
                                                                                          child: GestureDetector(
                                                                                              onTap: () {
                                                                                                setState(() {
                                                                                                  maintenanceController.selectedIndex7 = index;
                                                                                                });
                                                                                                print('Here is selectedIndex7 ${maintenanceController.selectedIndex7}');
                                                                                                print('Here is index ${index}');
                                                                                              },
                                                                                              child: Padding(
                                                                                                padding: const EdgeInsets.all(2),
                                                                                                child: Container(
                                                                                                  height: 8 * SizeConfig.heightMultiplier,
                                                                                                  width: 18 * SizeConfig.widthMultiplier,
                                                                                                  decoration: BoxDecoration(
                                                                                                    shape: BoxShape.rectangle,
                                                                                                    borderRadius: BorderRadius.circular(3 * SizeConfig.widthMultiplier),
                                                                                                  ),
                                                                                                  child: Image.file(
                                                                                                    File(maintenanceController.mediaFileList![index].path),
                                                                                                    fit: BoxFit.contain,
                                                                                                  ),
                                                                                                ),
                                                                                              )));
                                                                                    }),
                                                                              ),
                                                                              SizedBox(height: 1 * SizeConfig.heightMultiplier)
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
                                                        style:
                                                            BorderStyle.solid)),
                                                height: 13 *
                                                    SizeConfig.heightMultiplier,
                                                width: 25 *
                                                    SizeConfig.widthMultiplier,
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 2.0 *
                                                        SizeConfig
                                                            .widthMultiplier,
                                                    vertical: 1.0 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                  ),
                                                  child: Image.file(
                                                    File(maintenanceController
                                                        .mediaFileList![0]
                                                        .path),
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                            ),
                                      GestureDetector(
                                        onTap: () {
                                          maintenanceController.pickImages();
                                        },
                                        child: maintenanceController
                                                    .imageList ==
                                                0
                                            ? Container(
                                                height: 15 *
                                                    SizeConfig.widthMultiplier,
                                                width: 15 *
                                                    SizeConfig.widthMultiplier,
                                                child: Icon(
                                                  Remix.gallery_fill,
                                                  size: 15 *
                                                      SizeConfig
                                                          .imageSizeMultiplier,
                                                  color: Colors.black,
                                                ),
                                              )
                                            : Container(),
                                      ),
                                      SizedBox(
                                        width: 2.5 * SizeConfig.widthMultiplier,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          maintenanceController.pickImages();
                                          maintenanceController.selectedIndex7 =
                                              0;
                                        },
                                        child:
                                            maintenanceController.imageList != 0
                                                ? Row(
                                                    children: [
                                                      Icon(Remix.restart_fill,
                                                          size: 4 *
                                                              SizeConfig
                                                                  .imageSizeMultiplier,
                                                          color: colorPrimary),
                                                      SizedBox(
                                                        width: 1 *
                                                            SizeConfig
                                                                .widthMultiplier,
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
                                  maintenanceController
                                          .quotationMaterialDescription
                                          .isNotEmpty
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            CustText(
                                                name: "Material Dec.",
                                                size: 1.8,
                                                colors: Colors.black,
                                                fontWeightName:
                                                    FontWeight.w600),
                                            SizedBox(
                                              width: 1,
                                            ),
                                            CustText(
                                                name: "Quantity",
                                                size: 1.8,
                                                colors: Colors.black,
                                                fontWeightName:
                                                    FontWeight.w600),
                                            SizedBox(width: 2),
                                            CustText(
                                                name: "Amount",
                                                size: 1.8,
                                                colors: Colors.black,
                                                fontWeightName:
                                                    FontWeight.w600),
                                            SizedBox(
                                              width: 1,
                                            ),
                                            // SizedBox(width: 10,),
                                          ],
                                        )
                                      : Container(),
                                  ListView.builder(
                                    itemCount: maintenanceController
                                        .quotationMaterialDescription.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      var data = maintenanceController
                                          .quotationMaterialDescription[index];
                                      return Column(
                                        children: [
                                          Table(
                                            defaultVerticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle, // Align content vertically
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
                                                                '${data['material_description']}',
                                                            size: 1.8,
                                                            colors:
                                                                Colors.black,
                                                            textAlign: TextAlign
                                                                .center,
                                                            fontWeightName:
                                                                FontWeight
                                                                    .w400)),
                                                  ],
                                                ),
                                                CustTextStart(
                                                    name: '${data['quantity']}',
                                                    size: 1.8,
                                                    colors: Colors.black,
                                                    textAlign: TextAlign.center,
                                                    fontWeightName:
                                                        FontWeight.w400),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: SizeConfig
                                                              .widthMultiplier *
                                                          17,
                                                      child: CustTextStart(
                                                          name:
                                                              '${data['amount']}',
                                                          size: 1.8,
                                                          colors: Colors.black,
                                                          textAlign:
                                                              TextAlign.center,
                                                          fontWeightName:
                                                              FontWeight.w400),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        maintenanceController
                                                            .removeDataAtQuotation(
                                                                index);
                                                        // maintenanceController
                                                        //     .descriptionList
                                                        //     .removeAt(index);
                                                        // maintenanceController
                                                        //     .quantityList
                                                        //     .removeAt(index);
                                                        // maintenanceController
                                                        //     .amountList
                                                        //     .removeAt(index);
                                                      },
                                                      icon: Icon(
                                                          Icons.remove_circle,
                                                          color: colorPrimary),
                                                      iconSize: 20,
                                                      tooltip:
                                                          "Remove this material",
                                                    ),
                                                  ],
                                                ),
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
                                  SizedBox(
                                      height: 1 * SizeConfig.heightMultiplier),
                                  Container(
                                    height: 6.0 * SizeConfig.heightMultiplier,
                                    width: 100 * SizeConfig.widthMultiplier,
                                    child: TextFieldWidget(
                                      textEditingController:
                                          maintenanceController
                                              .descriptionController,
                                      hintText: "Enter Description",
                                      labelText: "Description",
                                    ),
                                  ),
                                  Container(
                                    height: 6.0 * SizeConfig.heightMultiplier,
                                    width: 100 * SizeConfig.widthMultiplier,
                                    child: TextFieldWidget(
                                      textEditingController:
                                          maintenanceController
                                              .quantityController,
                                      hintText: "Enter Quantity ",
                                      labelText: "Quantity ",
                                      inputFormatter:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                    ),
                                  ),
                                  Container(
                                    height: 6.0 * SizeConfig.heightMultiplier,
                                    width: 100 * SizeConfig.widthMultiplier,
                                    child: TextFieldWidget(
                                      textEditingController:
                                          maintenanceController
                                              .amountController,
                                      hintText: "Enter Amount ",
                                      labelText: "Amount",
                                      inputFormatter:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        bottom:
                                            1.5 * SizeConfig.heightMultiplier),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        maintenanceController
                                                    .controllers.length !=
                                                1
                                            ? GestureDetector(
                                                onTap: () {
                                                  // maintenanceController
                                                  //     .removeFieldQuotationdescription();
                                                },
                                                child: Container(
                                                    //   child: Row(
                                                    //     children: [
                                                    //       CustText(
                                                    //           name: "Remove",
                                                    //           size: 1.8,
                                                    //           colors: Colors.black,
                                                    //           fontWeightName:
                                                    //               FontWeight.w500),
                                                    //       Icon(
                                                    //         Remix
                                                    //             .checkbox_indeterminate_fill,
                                                    //         size: 25,
                                                    //         color: colorPrimary,
                                                    //       ),
                                                    //     ],
                                                    //   ),
                                                    ),
                                              )
                                            : Container(),
                                        SizedBox(
                                          width: 3 * SizeConfig.widthMultiplier,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            print(
                                                "LEngth = ${maintenanceController.quotationMaterialDescription.length}");

                                            for (int i = 0;
                                                i <
                                                    maintenanceController
                                                        .quotationMaterialDescription
                                                        .length;
                                                i++) {
                                              print(
                                                  "object ${maintenanceController.quotationMaterialDescription[i]}");
                                            }
                                            maintenanceController
                                                .addNewEntry3();
                                            ();
                                          },
                                          child: Container(
                                            child: Row(
                                              children: [
                                                CustText(
                                                    name: "Add",
                                                    size: 1.8,
                                                    colors: Colors.black,
                                                    fontWeightName:
                                                        FontWeight.w500),
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
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 100 * SizeConfig.widthMultiplier,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustTextStart(
                                      name: "Description",
                                      size: 1.8,
                                      colors: Colors.black,
                                      fontWeightName: FontWeight.w600),
                                  SizedBox(
                                      height: 1 * SizeConfig.heightMultiplier),
                                  Container(
                                    height: 10 * SizeConfig.heightMultiplier,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              2 * SizeConfig.widthMultiplier)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius:
                                              2 * SizeConfig.widthMultiplier,
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
                                          fontSize:
                                              1.6 * SizeConfig.textMultiplier,
                                        )),
                                        controller: maintenanceController
                                            .descController,
                                        cursorColor: Colors.black,
                                        textInputAction: TextInputAction.next,
                                        focusNode: descFocus,
                                        onChanged: (value) {
                                          print("object $value");
                                        },
                                        onFieldSubmitted: (value) {
                                          descFocus.unfocus();
                                          // maintenanceController.calculateRate(value);
                                          //  _calculator();
                                        },
                                        maxLines: 7,
                                        decoration: InputDecoration(
                                          // labelText: "Enter Email",
                                          // isDense: true,
                                          counterText: "",
                                          contentPadding: EdgeInsets.only(
                                            top: 2 * SizeConfig.widthMultiplier,
                                            left:
                                                2 * SizeConfig.widthMultiplier,
                                            right:
                                                2 * SizeConfig.widthMultiplier,
                                          ),
                                          constraints: BoxConstraints.tightFor(
                                              height: 10 *
                                                  SizeConfig.heightMultiplier),
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
                                              color: Colors.transparent,
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
                                          hintText: "Enter Description Here",
                                          hintStyle: GoogleFonts.openSans(
                                              textStyle: TextStyle(
                                            color: const Color(0xFF888888),
                                            fontSize:
                                                1.8 * SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.w400,
                                          )),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            maintenanceController.desc != ""
                                ? CustTextStart(
                                    textAlign: TextAlign.start,
                                    name: maintenanceController.desc,
                                    size: 1.6,
                                    colors: Colors.red,
                                    fontWeightName: FontWeight.w400)
                                : Container(),
                            SizedBox(height: SizeConfig.heightMultiplier * 1),
                            Container(
                              width: 100 * SizeConfig.widthMultiplier,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustTextStart(
                                      name: "Notes",
                                      size: 1.8,
                                      colors: Colors.black,
                                      fontWeightName: FontWeight.w600),
                                  SizedBox(
                                      height: 1 * SizeConfig.heightMultiplier),
                                  Container(
                                    height: 7 * SizeConfig.heightMultiplier,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              2 * SizeConfig.widthMultiplier)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius:
                                              2 * SizeConfig.widthMultiplier,
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
                                          fontSize:
                                              1.6 * SizeConfig.textMultiplier,
                                        )),
                                        controller: maintenanceController
                                            .notesController,
                                        cursorColor: Colors.black,
                                        textInputAction: TextInputAction.next,
                                        focusNode: noteFocus,
                                        onChanged: (value) {
                                          print("object $value");
                                        },
                                        onFieldSubmitted: (value) {
                                          noteFocus.unfocus();
                                          // maintenanceController.calculateRate(value);
                                          //  _calculator();
                                        },
                                        maxLines: 7,
                                        decoration: InputDecoration(
                                          // labelText: "Enter Email",
                                          // isDense: true,
                                          counterText: "",
                                          contentPadding: EdgeInsets.only(
                                            top: 2 * SizeConfig.widthMultiplier,
                                            left:
                                                2 * SizeConfig.widthMultiplier,
                                            right:
                                                2 * SizeConfig.widthMultiplier,
                                          ),
                                          constraints: BoxConstraints.tightFor(
                                              height: 7 *
                                                  SizeConfig.heightMultiplier),
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
                                              color: Colors.transparent,
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
                                          hintText: "Enter Notes Here",
                                          hintStyle: GoogleFonts.openSans(
                                              textStyle: TextStyle(
                                            color: const Color(0xFF888888),
                                            fontSize:
                                                1.6 * SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.w400,
                                          )),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.heightMultiplier * 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    maintenanceController.cleanData();
                                    Get.back();
                                  },
                                  child: Container(
                                      height: 5 * SizeConfig.heightMultiplier,
                                      width: 35 * SizeConfig.widthMultiplier,
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.9),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(2 *
                                                  SizeConfig.widthMultiplier)),
                                          border: Border.all(
                                              width: 0.18 *
                                                  SizeConfig.widthMultiplier,
                                              color: Colors.black,
                                              strokeAlign: BorderSide
                                                  .strokeAlignCenter)),
                                      child: Center(
                                          child: CustText(
                                              name: "Cancel",
                                              size: 1.8,
                                              colors: Colors.black,
                                              fontWeightName:
                                                  FontWeight.w600))),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    maintenanceController.checkValidation();
                                    // maintenanceController
                                    //     .checkReadingValidation(DJSController
                                    //         .machineReadingController.text
                                    //         .toString());
                                    if (maintenanceController.selectedType !=
                                        "Select Type") {
                                      print(
                                          "Here is desc== ${maintenanceController.desc}");
                                      if (maintenanceController.warningText ==
                                          true) {
                                        FocusScope.of(context)
                                            .requestFocus(new FocusNode());
                                        if (await CheckInternet
                                            .checkInternet()) {
                                          // showDialog(
                                          //     context: context,
                                          //     builder: (BuildContext context) =>
                                          //         CustomLoadingPopup());
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  CustomLoadingPopup());
                                          maintenanceController
                                              .submitDataReason();
                                          maintenanceController.addNewEntry3();
                                          await maintenanceController
                                              .addMaintenanceSheet(
                                                  widget.vehicleID,
                                                  widget.jobId,
                                                  context,
                                                  false);
                                          // Print values before clearing

// Clear all values
                                          maintenanceController
                                              .notesControllerData = '';
                                          maintenanceController
                                              .descControllerData = '';
                                          maintenanceController
                                              .locationControllerData = '';
                                          maintenanceController
                                              .machineReadingControllerData = '';

                                          maintenanceController
                                              .descriptionController
                                              .clear();
                                          maintenanceController
                                              .quantityController
                                              .clear();
                                          maintenanceController.amountController
                                              .clear();
                                          maintenanceController.descController
                                              .clear();
                                          maintenanceController.notesController
                                              .clear();
                                          maintenanceController
                                              .locationController
                                              .clear();
                                          maintenanceController
                                              .machineReadingController
                                              .clear();
                                          maintenanceController.controllers
                                              .clear();
                                          maintenanceController
                                              .quotationMaterialDescription
                                              .clear();
                                          maintenanceController.descriptionList
                                              .clear();
                                          maintenanceController.amountList
                                              .clear();
                                          maintenanceController.quantityList
                                              .clear();
                                          // maintenanceController.controllers
                                          //     .clear();
                                          // maintenanceController.instructionList
                                          //     .clear();
                                          maintenanceController
                                              .maintenanceReason
                                              .clear();
                                          maintenanceController
                                              .maintenanceReasonPhoto
                                              .clear();
// Print values after clearing

                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          //    Navigator.pop(context);

                                          await showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  CustomDialog(
                                                      "Quotation added successfully",
                                                      page: 'maintenance'));
                                          //Get.back();

                                          // ApiClient.roleisMSupervisor
                                          //     ? await Get.to(
                                          //         MaintenanceVehicleView())
                                          //     : await Get.off(JobsDetilasView(
                                          //         "${jobsController.jobStatus}",
                                          //         0));
                                          // await jobsController.getJobs(
                                          //     jobsController.jobStatus);
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  CustomDialog(
                                                      "Please check your internet connection"));
                                        }
                                      } else {}
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              CustomDialog(
                                                  "Please select maintenance type !"));
                                    }
                                  },
                                  child: Container(
                                      height: 5 * SizeConfig.heightMultiplier,
                                      width: 35 * SizeConfig.widthMultiplier,
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.9),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(2 *
                                                  SizeConfig.widthMultiplier)),
                                          border: Border.all(
                                              width: 0.18 *
                                                  SizeConfig.widthMultiplier,
                                              color: Colors.black,
                                              strokeAlign: BorderSide
                                                  .strokeAlignCenter)),
                                      child: Center(
                                          child: CustText(
                                              name: "Submit",
                                              size: 1.8,
                                              colors: Colors.black,
                                              fontWeightName:
                                                  FontWeight.w600))),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 100,
                            )
                          ],
                        ),
                      )
                    : Container(
                        child: CustomLoadingPopup(),
                      )),
          ],
        ),
      ),
    );
  }
}
