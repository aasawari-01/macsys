import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:macsys/component/custom_widget/custom_loading_popup.dart';
import 'package:macsys/services/remote_services.dart';
import 'package:macsys/util/confirmation_dialog.dart';
import 'package:remixicon/remixicon.dart';

import '../component/custom_widget/colorsC.dart';
import '../component/custom_widget/cust_text.dart';
import '../component/custom_widget/cust_text_start.dart';
import '../component/custom_widget/textfield_widget.dart';
import '../util/SizeConfig.dart';
import '../util/custom_dialog.dart';
import 'dart:io';
import 'maintaince_controller.dart';

// ignore: must_be_immutable
class AddMaintenanceSheet extends StatefulWidget {
  var vehicleDetails;

  var maintenanceController = Get.put(MaintenanceController());
  AddMaintenanceSheet(vehicleDetails) {
    this.vehicleDetails = vehicleDetails;
    // maintenanceController.textFieldAdd();
    // maintenanceController.addField();
  }
  @override
  State<AddMaintenanceSheet> createState() => AddMaintenanceSheetState();
}

class AddMaintenanceSheetState extends State<AddMaintenanceSheet> {
  var maintenanceController = Get.put(MaintenanceController());
  @override
  void initState() {
    super.initState();
    if (maintenanceController.observationListdata.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration(seconds: 1), () {
          maintenanceController.textFieldAdd();
          //  maintenanceController.addField();
        });
      });
    }

    print("********above function}");
    maintenanceController.opinionTextControllers.clear();

    maintenanceController.controllers.clear();
    maintenanceController.instructionList.clear();

    maintenanceController.quantityList.clear();
    maintenanceController.amountList.clear();
    maintenanceController.descriptionList.clear();
    //  maintenanceController.maintenanceReason.clear();

    print(
        "Adding opinion: ${maintenanceController.opinionTextControllers.length}");
    print("obs opinion: ${maintenanceController.observationListdata.length}");
    print("controller opinion: ${maintenanceController.controllers.length}");
    print(
        "insstructionList opinion: ${maintenanceController.instructionList.length}");
    print(
        "+++++descriptionList: ${maintenanceController.descriptionList.length}");
    print("++++++++++amountList: ${maintenanceController.amountList.length}");
    print(
        "++++++++++quantityList: ${maintenanceController.quantityList.length}");

    for (var item in maintenanceController.observationListdata) {
      log('${item}---------------------------------');
      log('Adding opinion: ${item['openion'].toString()}'); // Verify the value

      maintenanceController.opinionTextControllers.add(
        TextEditingController(text: item['openion'].toString()),
      );
    }

    for (var item in maintenanceController.operatingInstruction) {
      log('${item}-------------instruction--------------------');

      maintenanceController.instructionList.add(item['instruction']);
      maintenanceController.controllers.add(
        TextEditingController(text: item['instruction']),
      );
    }
    if (maintenanceController.instructionList.length == 0) {
      maintenanceController.controllers.add(TextEditingController());
    }

    print(
        "++++++++++instructionList: ${maintenanceController.instructionList.length}");
    print(
        "++++++++++instructionList: ${maintenanceController.instructionList}");
    print(
        "++++++++++instructionList: ${maintenanceController.controllers.length}");

    // for (var item in maintenanceController.operatingInstruction) {
    //   maintenanceController.controllers.add(
    //     TextEditingController(text: item['instruction']),
    //   );
    // }

    for (var item in maintenanceController.materialDescription) {
      maintenanceController.quantityList.add(item['quantity']);
      maintenanceController.amountList.add(item['amount']);
      maintenanceController.descriptionList.add(item['material_description']);

      // maintenanceController.descriptionController.text =
      //     item['material_description'];
    }
    print("++++++++++: ${maintenanceController.materialDescription.length}");

    log(maintenanceController.descriptionList.length.toString());
    log(maintenanceController.amountList.length.toString());
    log(maintenanceController.quantityList.length.toString());
    // for (var item in maintenanceController.materialDescription) {
    //   maintenanceController.quantityController.text =
    //       item['quantity'].toString();
    // }

    // for (var item in maintenanceController.materialDescription) {
    //   maintenanceController.amountController.text = item['amount'].toString();
    // }
    //  for (var item in maintenanceController.maintenancePhoto) {
    //   maintenanceController.amountController.text = item['amount'].toString();
    // }

    print(
        "Initialized ----------------55555555555555controllers: ${maintenanceController.opinionTextControllers}");
  }

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
            name: "Fill Maintenance Details",
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
            // child: maintenanceController.vehicleMaintenanceDetail?.status == 0
            //     ? Container(
            //         height: 83 * SizeConfig.heightMultiplier,
            //         width: 100 * SizeConfig.widthMultiplier,
            //         color: Colors.white38,
            //         child: Center(
            //             child: CustText(
            //                 name: "Approval Waiting",
            //                 size: 2.2,
            //                 colors: Colors.black,
            //                 fontWeightName: FontWeight.w600)))
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
                          color: maintenanceController.selectedType !=
                                  "Select Type"
                              ? Colors.green.shade100
                              : Colors.white,
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
                          child: Container(
                            child: GestureDetector(
                              onTap: () {
                                // showDialog(
                                //     barrierDismissible: true,
                                //     context: context,
                                //     builder: (BuildContext context) =>
                                //         SelectionDialog(
                                //           list: maintenanceController
                                //               .maintenanceType,
                                //           onSelected: (type, index) {
                                //             /*  maintenanceController
                                //                       .locationId =
                                //                       locationid;*/
                                //             print("Index $index, $type");
                                //             maintenanceController
                                //                 .updateType(type);
                                //             // maintenanceController.updateFuelBalance(index,true);
                                //           },
                                //           flag: 0,
                                //         ));
                              },
                              child: CustText(
                                  name: maintenanceController
                                              .vehicleMaintenanceDetail !=
                                          null
                                      ? maintenanceController
                                              .vehicleMaintenancedata[
                                          'maintenance_type']
                                      : "",
                                  size: 1.6,
                                  colors: maintenanceController.selectedType ==
                                          "Select Type"
                                      ? Colors.black
                                      : Colors.black,
                                  fontWeightName: FontWeight.w600),
                            ),
                          ),
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
                      Container(
                          height: 5.5 * SizeConfig.heightMultiplier,
                          width: 100 * SizeConfig.widthMultiplier,
                          color: colorPrimary,
                          child: Center(
                              child: CustText(
                                  name: "Observation",
                                  size: 1.8,
                                  colors: Colors.white,
                                  fontWeightName: FontWeight.w600))),
                      // ListView.builder(
                      //   itemCount:
                      //       maintenanceController.opinionTextControllers.length,
                      //   physics: NeverScrollableScrollPhysics(),
                      //   shrinkWrap: true,
                      //   itemBuilder: (BuildContext context, int index) {
                      //     // maintenanceController.opinionTextControllers
                      //     //     .add(maintenanceController
                      //     //         .observationListdata[index]['openion']);
                      //     // if (index >=
                      //     //     maintenanceController
                      //     //         .opinionTextControllers.length) {
                      //     //   maintenanceController.opinionTextControllers
                      //     //       .add(
                      //     //     TextEditingController(
                      //     //       text: maintenanceController
                      //     //               .observationListdata[index]
                      //     //           ['openion'],
                      //     //     ),
                      //     //   );
                      //     // }
                      //     return ListTile(
                      //       contentPadding: EdgeInsets.all(0),
                      //       title: Column(
                      //         children: [
                      //           TextFieldWidget(
                      //             labelText: maintenanceController
                      //                 .observationList[index],
                      //             textEditingController: maintenanceController
                      //                 .opinionTextControllers[index],

                      //             hintText: maintenanceController
                      //                     .opinionTextControllers[index]
                      //                     .text
                      //                     .isEmpty
                      //                 ? "Enter ${maintenanceController.opinionTextControllers[index].text}" // Placeholder if empty
                      //                 : maintenanceController
                      //                     .opinionTextControllers[index]
                      //                     .text, // No hint text if there's data,
                      //           ),
                      //         ],
                      //       ),
                      //     );
                      //   },
                      // ),

                      ListView.builder(
                        itemCount:
                            maintenanceController.opinionTextControllers.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          // Fetch the observation and opinion data
                          String observation =
                              maintenanceController.observationList[index];
                          String opinion = maintenanceController
                                  .opinionTextControllers[index].text.isEmpty
                              ? "Enter Opinion" // Placeholder if empty
                              : maintenanceController
                                  .opinionTextControllers[index]
                                  .text; // Display opinion value

                          return ListTile(
                            contentPadding: EdgeInsets.all(0),
                            title: Column(
                              children: [
                                TextFieldWidget(
                                  labelText:
                                      observation, // Label for the observation
                                  textEditingController: maintenanceController
                                      .opinionTextControllers[index],
                                  hintText:
                                      opinion, // Display either placeholder or actual opinion text
                                ),
                              ],
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
                                  name: "Repair/Operating Instruction",
                                  size: 1.8,
                                  colors: Colors.white,
                                  fontWeightName: FontWeight.w600))),
                      ListView.builder(
                        itemCount: maintenanceController.controllers.length,
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
                              child: TextFormField(
                                textAlign: TextAlign.start,
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 1.6 * SizeConfig.textMultiplier,
                                  ),
                                ),
                                controller:
                                    maintenanceController.controllers[index],
                                cursorColor: Colors.black,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (value) {},
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  // labelText: "Enter Email",
                                  // isDense: true,
                                  counterText: "",
                                  contentPadding: EdgeInsets.only(
                                    top: -0.5 * SizeConfig.widthMultiplier,
                                    left: 2 * SizeConfig.widthMultiplier,
                                    right: 2 * SizeConfig.widthMultiplier,
                                  ),

                                  constraints: BoxConstraints.tightFor(
                                      height:
                                          5.5 * SizeConfig.heightMultiplier),
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
                                  hintText: "Enter Operations / Instruction",
                                  hintStyle: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                    color: const Color(0xFF888888),
                                    fontSize: 1.6 * SizeConfig.textMultiplier,
                                    fontWeight: FontWeight.w400,
                                  )),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      maintenanceController
                                          .removeDataAtInstruction(index);
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
                                      // maintenanceController.removeInstruction();
                                    },
                                    child: Container(
                                      child: Row(
                                        children: [
                                          // CustText(
                                          //     name: "Remove",
                                          //     size: 1.8,
                                          //     colors: Colors.black,
                                          //     fontWeightName: FontWeight.w500),
                                          // Icon(
                                          //   Remix.checkbox_indeterminate_fill,
                                          //   size: 25,
                                          //   color: colorPrimary,
                                          // ),
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
                                if (maintenanceController.controllers.length ==
                                    0) {
                                  maintenanceController.addField();
                                }
                                maintenanceController.controllers.last.text ==
                                        ""
                                    ? showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            CustomDialog(
                                                "Please Enter Instruction"))
                                    : Container(
                                        height: 20,
                                        width: 20,
                                        color: Colors.yellow,
                                      );
                                // if (maintenanceController
                                //         .controllers.length ==
                                //     0) {
                                //   maintenanceController.addField();
                                // }
                                maintenanceController.submitData();
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
                            child: Column(
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
                                      fontWeightName: FontWeight.w400,
                                      textAlign: null,
                                    ),
                                    SizedBox(
                                      width: 8 * SizeConfig.widthMultiplier,
                                    ),
                                    maintenanceController
                                                .maintenancePhoto.length ==
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
                                                                                      RemoteServices.baseUrl + maintenanceController.maintenancePhoto[maintenanceController.selectedIndex4]['activity_photo'].toString(),
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
                                                                                                  await maintenanceController.removeMaintenanceimg(maintenanceController.maintenancePhoto[maintenanceController.selectedIndex4]['id']);
                                                                                                  maintenanceController.maintenancePhoto.removeAt(maintenanceController.selectedIndex4);
                                                                                                  print(maintenanceController.selectedIndex4);
                                                                                                  maintenanceController.selectedIndex4 = 0;
                                                                                                  setState(() {
                                                                                                    maintenanceController.selectedIndex4 = 0;
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
                                                                                  itemCount: maintenanceController.maintenancePhoto.length ?? 0,
                                                                                  itemBuilder: (BuildContext context, int index) {
                                                                                    return Container(
                                                                                        child: GestureDetector(
                                                                                            onTap: () {
                                                                                              setState(() {
                                                                                                maintenanceController.selectedIndex4 = index;
                                                                                              });
                                                                                              print('Here is selectedIndex4 ${maintenanceController.selectedIndex4}');
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
                                                                                                  RemoteServices.baseUrl + maintenanceController.maintenancePhoto[index]['activity_photo'].toString(),
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
                                                          .maintenancePhoto[0]
                                                              ['activity_photo']
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
                                Row(
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
                                                                                    child: GestureDetector(
                                                                                      child: Image.file(
                                                                                        File(maintenanceController.mediaFileList![maintenanceController.selectedIndex5].path),
                                                                                        fit: BoxFit.contain,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
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
                                                                                                maintenanceController.selectedIndex5 = index;
                                                                                              });
                                                                                              print('Here is selectedIndex5 ${maintenanceController.selectedIndex5}');
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
                                                      .mediaFileList![0].path),
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          ),
                                    GestureDetector(
                                      onTap: () {
                                        maintenanceController.pickImages();
                                      },
                                      child: maintenanceController.imageList ==
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
                                      width: SizeConfig.widthMultiplier * 2,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        maintenanceController.pickImages();
                                        maintenanceController.selectedIndex4 =
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
                              ],
                            ),
                          ),
                          Container(
                              height: 5.5 * SizeConfig.heightMultiplier,
                              width: 100 * SizeConfig.widthMultiplier,
                              color: colorPrimary,
                              child: Center(
                                  child: CustText(
                                      name: "Material Required",
                                      size: 1.8,
                                      colors: Colors.white,
                                      fontWeightName: FontWeight.w600))),
                        ],
                      ),
                      Container(
                        child: Column(
                          children: [
                            maintenanceController.materialDescription.isNotEmpty
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
                                  .materialDescription.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var data = maintenanceController
                                    .materialDescription[index];
                                // maintenanceController.addNewEntry();

                                print(
                                    "materialcontroller length:${maintenanceController.materialDescription.length}");
                                print(
                                    "datalist length:${maintenanceController.dataList.length}");
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
                                                      colors: Colors.black,
                                                      textAlign:
                                                          TextAlign.center,
                                                      fontWeightName:
                                                          FontWeight.w400)),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              CustTextStart(
                                                  name: '${data['quantity']}',
                                                  size: 1.8,
                                                  colors: Colors.black,
                                                  textAlign: TextAlign.center,
                                                  fontWeightName:
                                                      FontWeight.w400),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width:
                                                    SizeConfig.widthMultiplier *
                                                        17,
                                                child: CustTextStart(
                                                    name: '${data['amount']}',
                                                    size: 1.8,
                                                    colors: Colors.black,
                                                    textAlign: TextAlign.center,
                                                    fontWeightName:
                                                        FontWeight.w400),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  maintenanceController
                                                      .removeDataAt(index);
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
                                                icon: Icon(Icons.remove_circle,
                                                    color: colorPrimary),
                                                iconSize: 20,
                                                tooltip: "Remove this material",
                                              ),
                                            ],
                                          ),
                                        ]),
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
                            SizedBox(height: 1 * SizeConfig.heightMultiplier),
                            Container(
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
                                  maintenanceController.dataList.length != 1
                                      ? GestureDetector(
                                          onTap: () {
                                            // maintenanceController
                                            //     .removeFielddescription();

                                            // maintenanceController
                                            //     .removeFielddescription();
                                            // maintenanceController
                                            //     .removeData2();
                                          },
                                          child: Container(
                                            child: Row(
                                              children: [
                                                // CustText(
                                                //     name: "Remove",
                                                //     size: 1.8,
                                                //     colors: Colors.black,
                                                //     fontWeightName:
                                                //         FontWeight.w500),
                                                // Icon(
                                                //   Remix
                                                //       .checkbox_indeterminate_fill,
                                                //   size: 25,
                                                //   color: colorPrimary,
                                                // ),
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
                                      /*          print(
                                          "LEngth = ${maintenanceController.dataList.length}");

                                      print(
                                          "object${vehicleDetails.status}  ${vehicleDetails.id}");*/

                                      for (int i = 0;
                                          i <
                                              maintenanceController
                                                  .dataList.length;
                                          i++) {
                                        print(
                                            "object ${maintenanceController.dataList[i]}");
                                      }
                                      maintenanceController.addNewEntry2();
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
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          // maintenanceController.addMaintenanceReport(
                          //     vehicleDetails.id, context);
                          // maintenanceController.addReport(
                          //     vehicleDetails.id, context);
                          print("object ${maintenanceController.opinionList}");
                          /* if (maintenanceController.opinionList.isNotEmpty) {*/
                          if (true) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    CustomLoadingPopup());
                            maintenanceController.submitData();
                            maintenanceController.addNewEntry2();

                            await maintenanceController.addMaintenanceReport(
                                maintenanceController
                                        .vehicleMaintenanceDetail?.id ??
                                    0,
                                context,
                                true);
                            print("********above function}");
                            print(
                                "Adding opinion: ${maintenanceController.opinionTextControllers.length}");
                            print(
                                "obs opinion: ${maintenanceController.observationListdata.length}");
                            print(
                                "controller opinion: ${maintenanceController.controllers.length}");
                            print(
                                "insstructionList opinion: ${maintenanceController.instructionList.length}");
                            print(
                                "+++++descriptionList: ${maintenanceController.descriptionList.length}");
                            print(
                                "++++++++++amountList: ${maintenanceController.amountList.length}");
                            print(
                                "++++++++++quantityList: ${maintenanceController.quantityList.length}");
                            maintenanceController.opinionTextControllers
                                .clear();
                            maintenanceController.controllers.clear();
                            maintenanceController.instructionList.clear();

                            maintenanceController.quantityList.clear();
                            maintenanceController.amountList.clear();
                            maintenanceController.descriptionList.clear();
                            print(
                                "Adding opinion: ${maintenanceController.opinionTextControllers.length}");
                            print(
                                "obs opinion: ${maintenanceController.observationListdata.length}");
                            print(
                                "controller opinion: ${maintenanceController.controllers.length}");
                            print(
                                "insstructionList opinion: ${maintenanceController.instructionList.length}");
                            print(
                                "+++++descriptionList: ${maintenanceController.descriptionList.length}");
                            print(
                                "++++++++++amountList: ${maintenanceController.amountList.length}");
                            print(
                                "++++++++++quantityList: ${maintenanceController.quantityList.length}");
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) => CustomDialog(
                                    "Maintenance details added successfully",
                                    page: 'maintenance'));
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    CustomDialog("Fill Material Details! "));
                          }
                          /*              } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    CustomDialog("Fill Instructions !"));
                          }*/
                        },
                        child: Container(
                            height: 5.5 * SizeConfig.heightMultiplier,
                            width: 35 * SizeConfig.widthMultiplier,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.all(Radius.circular(
                                    2 * SizeConfig.widthMultiplier)),
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
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 5,
                      )
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
