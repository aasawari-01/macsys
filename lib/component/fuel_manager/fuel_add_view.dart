import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:macsys/util/fuel_selection_dialog.dart';
import 'package:remixicon/remixicon.dart';
import '../../services/remote_services.dart';
import '../../util/ApiClient.dart';
import '../../util/SizeConfig.dart';
import '../../util/custom_dialog.dart';
import '../custom_widget/check_internet.dart';
import '../custom_widget/colorsC.dart';
import '../custom_widget/cust_text.dart';
import '../custom_widget/cust_text_start.dart';
import '../custom_widget/custom_loading_popup.dart';
import 'fuel_controller.dart';

class FuelView extends StatelessWidget {
  var fuelController = Get.put(FuelController());
  final FocusNode litreFocus = FocusNode();
  final FocusNode rateFocus = FocusNode();

  Future<Null> _selectDate(BuildContext context) async {
    DateTime dd;
    DateTime ldd;
    DateTime? iniDate;

    dd = DateTime(
        DateTime.now().year - 50, DateTime.now().month, DateTime.now().day);
    ldd =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    iniDate = ldd =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: iniDate!,
      initialDatePickerMode: DatePickerMode.day,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      firstDate: dd,
      lastDate: ldd,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: colorPrimary, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: colorPrimary, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      fuelController
          .updateSelectedDate("${picked.year}-${picked.month}-${picked.day}");
      fuelController.setDate("${picked.day}-${picked.month}-${picked.year}");
      print("Selected Date: ${picked.year}-${picked.month}-${picked.day}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrimaryDark,
        leading: GestureDetector(
          onTap: () {
            fuelController.cleanData();
            Navigator.pop(context);
          },
          child: Icon(
            Remix.arrow_left_line,
            size: 6 * SizeConfig.imageSizeMultiplier,
            color: Colors.white,
          ),
        ),
        title: CustText(
            name: "Purchase Fuel Addition ",
            size: 2.2,
            colors: Colors.white,
            fontWeightName: FontWeight.w600),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            GetBuilder<FuelController>(
                init: FuelController(),
                builder: (controller) => fuelController.status
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 1 * SizeConfig.heightMultiplier,
                            horizontal: 3 * SizeConfig.widthMultiplier),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 5.5 * SizeConfig.heightMultiplier,
                              width: 100 * SizeConfig.widthMultiplier,
                              color: colorPrimary,
                              child: Center(
                                child: CustText(
                                    name: "Purchase Information",
                                    size: 1.8,
                                    colors: Colors.white,
                                    fontWeightName: FontWeight.w600),
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.heightMultiplier * 1,
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustText(
                                        name: "Location",
                                        size: 1.8,
                                        colors: Colors.black,
                                        fontWeightName: FontWeight.w600),
                                    CustText(
                                        name: "    :      ",
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
                                        child: Container(
                                          child: GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                  barrierDismissible: true,
                                                  context: context,
                                                  builder: (BuildContext context) =>
                                                      FuelSelectionDialog(
                                                        fuel_list:
                                                        fuelController.location,
                                                        onSelected: (locationid,
                                                            name, index) {
                                                          fuelController
                                                              .locationId =
                                                              locationid;
                                                          print(
                                                              "selected : $locationid  Name::$name");
                                                          fuelController
                                                              .updateLocationName(
                                                              name);
                                                          fuelController.updateFuelBalance(index,true);

                                                        },
                                                        flag: false,
                                                      ));
                                            },
                                            child: CustText(
                                                name:
                                                fuelController.selectedLocation,
                                                size: 1.6,
                                                colors: fuelController
                                                    .selectedLocation ==
                                                    "Select location"
                                                    ? Colors.grey
                                                    : Colors.black,
                                                fontWeightName: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: SizeConfig.heightMultiplier * 1),

                                ApiClient.box.read('skills')=="Supervisors Admin"? Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustText(
                                        name: "Total Fuel added \nas per Location",
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
                                        child:
                                        CustText(
                                            name: "${fuelController.fuelTotalBalance} Ltr",
                                            size: 1.8,
                                            colors: Colors.black,
                                            fontWeightName: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ):Container(),
                                SizedBox(height: SizeConfig.heightMultiplier * 1),
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustText(
                                    name: "Company Name",
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
                                    child: Container(
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              barrierDismissible: true,
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  FuelSelectionDialog(
                                                    fuel_list: fuelController
                                                        .petroleum,
                                                    onSelected:
                                                        (id, name, index) {
                                                      fuelController.companyId =
                                                          id;
                                                      print(
                                                          "selected : $id \n Name::$name");
                                                      fuelController
                                                          .updatePumpName(name);
                                                      fuelController
                                                          .updateRate(index);
                                                    },
                                                    flag: true,
                                                  ));
                                        },
                                        child: CustText(
                                            name: fuelController.selectedName,
                                            size: 1.6,
                                            colors:
                                                fuelController.selectedName ==
                                                        "Select pump"
                                                    ? Colors.grey
                                                    : Colors.black,
                                            fontWeightName: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: SizeConfig.heightMultiplier * 1),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustText(
                                    name: "Current Balance",
                                    size: 1.8,
                                    colors: Colors.black,
                                    fontWeightName: FontWeight.w600),
                                CustText(
                                    name: ":",
                                    size: 1.8,
                                    colors: Colors.black,
                                    fontWeightName: FontWeight.w600),
                                Container(
                                  width: SizeConfig.widthMultiplier * 50,
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                      SizeConfig.widthMultiplier * 2.0,
                                      horizontal:
                                      SizeConfig.heightMultiplier * 2),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: Colors.green),
                                  ),
                                  child: Center(
                                    child:
                                    Text("₹ ${fuelController.fuelBalance}",
                                        style: GoogleFonts.openSans(
                                            textStyle: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize:
                                              2 * SizeConfig.textMultiplier,
                                            ))),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: SizeConfig.heightMultiplier * 1),


                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustText(
                                    name: "Date",
                                    size: 1.8,
                                    colors: Colors.black,
                                    fontWeightName: FontWeight.w600),
                                CustText(
                                    name: "    :      ",
                                    size: 1.8,
                                    colors: Colors.black,
                                    fontWeightName: FontWeight.w600),
                                GestureDetector(
                                    onTap: () {
                                      _selectDate(context);
                                    },
                                    child: Container(
                                      height: 5.5 * SizeConfig.heightMultiplier,
                                      width: 50 * SizeConfig.widthMultiplier,
                                      decoration: BoxDecoration(
                                        color: colorPrimary,
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
                                      // color: colorPrimary,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          CustText(
                                              name: fuelController.selectDate,
                                              size: 1.8,
                                              colors:
                                              fuelController.selectDate ==
                                                  "Pick Date"
                                                  ? Colors.white70
                                                  : Colors.white,
                                              fontWeightName: FontWeight.w600),
                                          SizedBox(
                                            width:
                                            SizeConfig.widthMultiplier * 2,
                                          ),
                                          Icon(
                                            Remix.calendar_2_line,
                                            size: 6 *
                                                SizeConfig.imageSizeMultiplier,
                                            color: fuelController.selectDate ==
                                                "Pick Date"
                                                ? Colors.white70
                                                : Colors.white,
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                            SizedBox(height: SizeConfig.heightMultiplier * 1),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustText(
                                    name: "No of Litre",
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
                                      )),
                                      controller:
                                          fuelController.litreController,
                                      cursorColor: Colors.black,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                          RegExp('[0-9.]+'),
                                        ),
                                      ],
                                      textInputAction: TextInputAction.done,
                                      focusNode: litreFocus,
                                      onChanged: (value) {
                                        print("object $value");
                                        fuelController.setLitreValue(
                                            value, true);
                                      },
                                      onFieldSubmitted: (value) {
                                        litreFocus.unfocus();
                                        fuelController.setLitreValue(
                                            value, true);
                                        // fuelController.calculateRate(value);
                                        //  _calculator();
                                      },
                                      maxLength: 8,
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
                                        hintText: "in Litre",
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
                            SizedBox(height: SizeConfig.heightMultiplier * 1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustText(
                                    name: "Rate per Litre",
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
                                  width: 51 * SizeConfig.widthMultiplier,
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
                                      controller: fuelController.rateController,
                                      cursorColor: Colors.black,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                          RegExp('[0-9.]+'),
                                        ),
                                      ],
                                      textInputAction: TextInputAction.done,
                                      focusNode: rateFocus,
                                      onFieldSubmitted: (value) {
                                        rateFocus.unfocus();
                                        fuelController.setLitreValue(
                                            value, false);
                                        //  _calculator();
                                      },
                                      onChanged: (value) {
                                        print("object $value");
                                        fuelController.setLitreValue(
                                            value, false);
                                      },
                                      maxLength: 7,
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
                                        hintText: "in Rupees",
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
                            SizedBox(height: SizeConfig.heightMultiplier * 1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustText(
                                    name: "Purchasing Price",
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
                                      width: SizeConfig.widthMultiplier * 50,
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              SizeConfig.widthMultiplier * 2.0,
                                          horizontal:
                                              SizeConfig.heightMultiplier * 2),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 2,
                                            color: fuelController.warningText
                                                ? Colors.red
                                                : Colors.black),
                                      ),
                                      child: Center(
                                        child: Text(
                                            "₹ ${fuelController.purchasePrice}",
                                            style: GoogleFonts.openSans(
                                                textStyle: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize:
                                                  2 * SizeConfig.textMultiplier,
                                            ))),
                                      ),
                                    ),
                                    fuelController.warningText
                                        ? CustText(
                                            name: "Not Enough Balance",
                                            size: 1.2,
                                            colors: Colors.red,
                                            fontWeightName: FontWeight.w600)
                                        : Container()
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1 * SizeConfig.heightMultiplier,
                            ),
                            Row(
                              children: [
                                CustTextStart(
                                    name:
                                    "Filled from :          ",
                                    size: 1.8,
                                    colors: Colors.black,
                                    fontWeightName: FontWeight.w600),
                                GestureDetector(
                                  onTap: () {
                                    print("  ${fuelController.fuelStatus}");
                                    fuelController.updateFuelStatus("Tanker");
                                  },
                                  child: Row(
                                    children: [
                                      Radio(
                                        value: "Tanker",
                                        groupValue: fuelController.fuelStatus,
                                        visualDensity: VisualDensity(
                                          vertical: 0,
                                          horizontal: -4,
                                        ),
                                        activeColor: colorPrimary,
                                        focusColor: colorPrimary,
                                        onChanged: (value) {
                                          fuelController.updateFuelStatus("Tanker");
                                          print(
                                              "Here:: ${fuelController.fuelStatus}");
                                        },
                                      ),
                                      CustTextStart(
                                          name: "Fuel Tanker",
                                          size: 1.8,
                                          colors: Colors.black,
                                          fontWeightName: FontWeight.w600),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: SizeConfig.widthMultiplier * 1,
                                ),
                                GestureDetector(
                                  onTap: () {

                                    fuelController.updateFuelStatus("Storage");
                                    print("Here::  ${fuelController.fuelStatus}");
                                  },
                                  child: Row(
                                    children: [
                                      Radio(
                                        value: "Storage",
                                        groupValue: fuelController.fuelStatus,
                                        activeColor: colorPrimary,
                                        focusColor: colorPrimary,
                                        visualDensity: VisualDensity(
                                          vertical: 0,
                                          horizontal: -4,
                                        ),
                                        onChanged: (value) {
                                          fuelController.updateFuelStatus("Storage");
                                          print(
                                              "Here:: ${fuelController.fuelStatus}");
                                        },
                                      ),
                                      CustTextStart(
                                          name: "Storage",
                                          size: 1.8,
                                          colors: Colors.black,
                                          fontWeightName: FontWeight.w600),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: SizeConfig.heightMultiplier * 2,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustText(
                                    name: "Capture Receipt Image",
                                    size: 1.8,
                                    colors: Colors.black,
                                    fontWeightName: FontWeight.w600),
                                CustText(
                                    name: ":",
                                    size: 1.8,
                                    colors: Colors.black,
                                    fontWeightName: FontWeight.w600),
                                GestureDetector(
                                  onTap: () {
                                    fuelController
                                        .get_image(ImageSource.camera);
                                  },
                                  child: Container(
                                    height: 20 * SizeConfig.widthMultiplier,
                                    width: 20 * SizeConfig.widthMultiplier,
                                    child: fuelController.image != null
                                        ? Image.file(
                                            fuelController.image!,
                                            fit: BoxFit.fitHeight,
                                          )
                                        : fuelController.monitoringImg != ""
                                            ? Image.network(
                                                '${RemoteServices.baseUrl + fuelController.monitoringImg}',
                                                fit: BoxFit.cover,
                                              )
                                            : Icon(
                                                Remix.camera_fill,
                                                size: 15 *
                                                    SizeConfig
                                                        .imageSizeMultiplier,
                                                color: Colors.black,
                                              ),
                                  ),
                                ),
                                SizedBox(
                                  width: SizeConfig.widthMultiplier * 2,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: SizeConfig.heightMultiplier * 3,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    fuelController.cleanData();
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
                                    print("${fuelController.selectDate}");
                                    if(fuelController.selectedLocation != "Select location"){
                                    if(fuelController.selectDate!="Pick Date"){
                                    if (fuelController.purchasePrice != 0.0) {
                                      if (fuelController.warningText == false) {
                                        if (fuelController.image != null ||
                                            fuelController.monitoringImg !=
                                                "") {
                                          FocusScope.of(context)
                                              .requestFocus(new FocusNode());
                                          if (await CheckInternet
                                              .checkInternet()) {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        CustomLoadingPopup());
                                            await fuelController.addFuel(
                                                context,
                                                fuelController.companyId,
                                                fuelController.purchasePrice,
                                                fuelController.litreDouble,
                                                fuelController.rateDouble);
                                          } else {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext
                                                        context) =>
                                                    CustomDialog(
                                                        "Please check your internet connection"));
                                          }
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  CustomDialog(
                                                      "Please Upload Image"));
                                        }
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                CustomDialog(
                                                    "Purchasing Price is more than Balance"));
                                      }
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              CustomDialog(
                                                  "Purchase Amount is 00.0"));
                                    }
                                  }else{
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              CustomDialog(
                                                  "Please Select Date !"));
                                    }}
                                    else{
                                    showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                    CustomDialog(
                                    "Please Select Location! "));
                                    }},
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
