import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:macsys/main.dart';
import 'package:macsys/services/remote_services.dart';
import 'package:remixicon/remixicon.dart';

import '../component/custom_widget/colorsC.dart';
import '../component/custom_widget/cust_text.dart';
import '../component/custom_widget/cust_text_start.dart';
import '../component/custom_widget/selectionDialog.dart';
import '../component/custom_widget/textfield_widget.dart';
import '../component/job_details/job_details_controller.dart';
import '../util/ApiClient.dart';
import '../util/SizeConfig.dart';
import '../util/custom_dialog.dart';
import 'dart:io';
import 'maintaince_controller.dart';

class AddMainternaceSheetpandm extends StatefulWidget {
  var vehicleDetails;

  AddMainternaceSheetpandm(id);

  AddMaintenanceSheetpandm(vehicleDetails) {
    this.vehicleDetails = vehicleDetails;
/*    maintenanceController.textFieldAdd();
    maintenanceController.addField();*/
  }

  @override
  State<AddMainternaceSheetpandm> createState() =>
      AddMainternaceSheetpandmState();
}

class AddMainternaceSheetpandmState extends State<AddMainternaceSheetpandm> {
  var maintenanceController = Get.put(MaintenanceController());
  var jobsDetailsController = Get.put(JobsDetailsController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      maintenanceController.textFieldAdd();
      maintenanceController.addField();
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Here ${maintenanceController.observationList}:::\n");
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
            name: "Maintenance Progress",
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
            child: maintenanceController.vehicleMaintenanceDetail?.status == 0
                ? Container(
                    height: 83 * SizeConfig.heightMultiplier,
                    width: 100 * SizeConfig.widthMultiplier,
                    color: Colors.white38,
                    child: Center(
                        child: CustText(
                            name: "Approval Waiting",
                            size: 2.2,
                            colors: Colors.black,
                            fontWeightName: FontWeight.w600)))
                : Container(
                    // height: 100 * SizeConfig.heightMultiplier,
                    width: 100 * SizeConfig.widthMultiplier,
                    color: Colors.white.withOpacity(0.9),
                    child: GetBuilder<MaintenanceController>(
                        init: MaintenanceController(),
                        builder: (controller) {
                          //   maintenanceController.textFieldAdd();
                          // maintenanceController.addField();
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Container(
                                    height: 5.5 * SizeConfig.heightMultiplier,
                                    width: 100 * SizeConfig.widthMultiplier,
                                    color: colorPrimary,
                                    child: Center(
                                        child: CustText(
                                            name: "Reason for breakdown",
                                            size: 1.8,
                                            colors: Colors.white,
                                            fontWeightName: FontWeight.w600))),
                                SizedBox(
                                    height: 1 * SizeConfig.heightMultiplier),
                                Container(
                                  height: 5.5 * SizeConfig.heightMultiplier,
                                  width: 100 * SizeConfig.widthMultiplier,
                                  decoration: BoxDecoration(
                                    color: maintenanceController.selectedType !=
                                            "Select Type"
                                        ? Colors.black12
                                        : Colors.white,
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
                                                            .vehicleMaintenancedata[
                                                        'maintenance_type'] !=
                                                    null
                                                ? maintenanceController
                                                        .vehicleMaintenancedata[
                                                    'maintenance_type']
                                                : "Select Type",
                                            size: 1.6,
                                            colors: maintenanceController
                                                        .selectedType ==
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
                                              height: 1 *
                                                  SizeConfig.heightMultiplier),
                                          TextFieldWidget(
                                            labelText: "Reason",
                                            textEditingController:
                                                maintenanceController
                                                    .reasonTextController,
                                            hintText: "Enter Reason",
                                          ),
                                          SizedBox(
                                              height: 1 *
                                                  SizeConfig.heightMultiplier),
                                        ],
                                      )
                                    : Container(),
                                SizedBox(
                                    height: 1 * SizeConfig.heightMultiplier),
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
                                ListView.builder(
                                  itemCount: maintenanceController
                                              .observationListdata.length >
                                          0
                                      ? maintenanceController
                                          .observationListdata.length
                                      : 0,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return
                                        // contentPadding: EdgeInsets.all(0),
                                        // title: Column(
                                        //   children: [
                                        //     // TextFieldWidget(
                                        //     //   labelText: maintenanceController
                                        //     //       .observationList[index],
                                        //     //   textEditingController:
                                        //     //       maintenanceController
                                        //     //               .opinionTextControllers[
                                        //     //           index],
                                        //     //   hintText:
                                        //     //       "Enter ${maintenanceController.observationList[index]}",
                                        //     // ),
                                        //   ],
                                        // ),
                                        Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      height: 5.5 * SizeConfig.heightMultiplier,
                                      width: 100 * SizeConfig.widthMultiplier,
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
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width:
                                                  SizeConfig.widthMultiplier *
                                                      40,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${maintenanceController.observationListdata[index]['observation']}",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 1.6 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 50,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "${maintenanceController.observationListdata[index]['openion']}",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 1.6 *
                                                        SizeConfig
                                                            .textMultiplier,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ]),
                                    );
                                  },
                                ),
                                SizedBox(
                                    height: 1 * SizeConfig.heightMultiplier),
                                Container(
                                    height: 5.5 * SizeConfig.heightMultiplier,
                                    width: 100 * SizeConfig.widthMultiplier,
                                    color: colorPrimary,
                                    child: Center(
                                        child: CustText(
                                            name:
                                                "Repair/Operating Instruction",
                                            size: 1.8,
                                            colors: Colors.white,
                                            fontWeightName: FontWeight.w600))),
                                ListView.builder(
                                  itemCount: maintenanceController
                                              .operatingInstruction.length >
                                          0
                                      ? maintenanceController
                                          .operatingInstruction.length
                                      : 0,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      height: 5.5 * SizeConfig.heightMultiplier,
                                      width: 100 * SizeConfig.widthMultiplier,
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
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${maintenanceController.operatingInstruction[index]['instruction']}",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 1.6 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 50,
                                            ),
                                          ]),
                                    );
                                  },
                                ),
                                SizedBox(
                                    height: 1 * SizeConfig.heightMultiplier),
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
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 1.5 *
                                              SizeConfig.heightMultiplier),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 15 *
                                                    SizeConfig.widthMultiplier,
                                              ),
                                              CustTextStart(
                                                  name: "Upload Images:",
                                                  size: 1.8,
                                                  colors: Colors.black,
                                                  fontWeightName:
                                                      FontWeight.w400),
                                              SizedBox(
                                                width: 5 *
                                                    SizeConfig.widthMultiplier,
                                              ),
                                              Column(
                                                children: [
                                                  //**************************************** */

                                                  maintenanceController
                                                              .maintenancePhoto
                                                              .length !=
                                                          0
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            print("Heelo");
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                            context) =>
                                                                        Dialog(
                                                                          child: Container(
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.white,
                                                                                shape: BoxShape.rectangle,
                                                                                borderRadius: BorderRadius.circular(3 * SizeConfig.widthMultiplier),
                                                                              ),
                                                                              child: StatefulBuilder(
                                                                                builder: (BuildContext context, StateSetter setState) {
                                                                                  return Container(
                                                                                    width: double.infinity,
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.all(1 * SizeConfig.widthMultiplier),
                                                                                      child: Column(
                                                                                        mainAxisSize: MainAxisSize.min,
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
                                                                                              child: maintenanceController.maintenancePhoto.length != 0 ? Image.network(RemoteServices.baseUrl + maintenanceController.maintenancePhoto[maintenanceController.selectedIndex2]['activity_photo']) : Image.network(""),
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
                                                                                                itemCount: maintenanceController.maintenancePhoto.length,
                                                                                                itemBuilder: (BuildContext context, int index) {
                                                                                                  return Container(
                                                                                                      child: GestureDetector(
                                                                                                          onTap: () {
                                                                                                            setState(() {
                                                                                                              maintenanceController.selectedIndex2 = index;
                                                                                                            });

                                                                                                            print('Here is selectedIndex ${maintenanceController.selectedIndex2}');
                                                                                                            print('Here is index ${index}');
                                                                                                          },
                                                                                                          child: Padding(
                                                                                                            padding: const EdgeInsets.all(2),
                                                                                                            child: Container(
                                                                                                              height: 8 * SizeConfig.heightMultiplier,
                                                                                                              width: 18 * SizeConfig.widthMultiplier,
                                                                                                              decoration: BoxDecoration(shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(3 * SizeConfig.widthMultiplier), border: Border.all(color: colorPrimaryDark, width: 1)),
                                                                                                              child: Image.network(
                                                                                                                RemoteServices.baseUrl + maintenanceController.maintenancePhoto[index]['activity_photo'].toString(),
                                                                                                                fit: BoxFit.contain,
                                                                                                              ),
                                                                                                            ),
                                                                                                          )));
                                                                                                }),
                                                                                          ),
                                                                                          SizedBox(height: 1 * SizeConfig.heightMultiplier),
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
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1,
                                                                    style: BorderStyle
                                                                        .solid)),
                                                            height: 13 *
                                                                SizeConfig
                                                                    .heightMultiplier,
                                                            width: 25 *
                                                                SizeConfig
                                                                    .widthMultiplier,
                                                            child: Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                  horizontal: 2.0 *
                                                                      SizeConfig
                                                                          .widthMultiplier,
                                                                  vertical: 1.0 *
                                                                      SizeConfig
                                                                          .heightMultiplier,
                                                                ),
                                                                child: maintenanceController
                                                                            .maintenancePhoto
                                                                            .length >
                                                                        0
                                                                    ? Image
                                                                        .network(
                                                                        RemoteServices.baseUrl +
                                                                            maintenanceController.maintenancePhoto[0]['activity_photo'].toString(),
                                                                        fit: BoxFit
                                                                            .contain,
                                                                      )
                                                                    : Image
                                                                        .network(
                                                                            "")),
                                                          ),
                                                        )
                                                      : Container()
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                        height:
                                            5.5 * SizeConfig.heightMultiplier,
                                        width: 100 * SizeConfig.widthMultiplier,
                                        color: colorPrimary,
                                        child: Center(
                                            child: CustText(
                                                name: "Material Required",
                                                size: 1.8,
                                                colors: Colors.white,
                                                fontWeightName:
                                                    FontWeight.w600))),
                                  ],
                                ),
                                Container(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height:
                                            SizeConfig.heightMultiplier * 0.5,
                                      ),
                                      maintenanceController
                                              .materialDescription.isNotEmpty
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
                                            .materialDescription.length,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          //var data =;
                                          return Column(
                                            children: [
                                              Table(
                                                children: [
                                                  TableRow(children: [
                                                    Row(
                                                      children: [
                                                        CustTextStart(
                                                            name:
                                                                '${index + 1}.',
                                                            size: 1.8,
                                                            colors:
                                                                Colors.black,
                                                            fontWeightName:
                                                                FontWeight
                                                                    .w400),
                                                        Expanded(
                                                            child: CustTextStart(
                                                                name:
                                                                    '${maintenanceController.materialDescription[index]['material_description']}',
                                                                size: 1.8,
                                                                colors: Colors
                                                                    .black,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                fontWeightName:
                                                                    FontWeight
                                                                        .w400)),
                                                      ],
                                                    ),
                                                    CustTextStart(
                                                        name:
                                                            '${maintenanceController.materialDescription[index]['quantity']}',
                                                        size: 1.8,
                                                        colors: Colors.black,
                                                        textAlign:
                                                            TextAlign.center,
                                                        fontWeightName:
                                                            FontWeight.w400),
                                                    CustTextStart(
                                                        name:
                                                            '${maintenanceController.materialDescription[index]['amount']}',
                                                        size: 1.8,
                                                        colors: Colors.black,
                                                        textAlign:
                                                            TextAlign.center,
                                                        fontWeightName:
                                                            FontWeight.w400),
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
                                      //       SizedBox(
                                      //           height:
                                      //               1 * SizeConfig.heightMultiplier),
                                      //       Container(
                                      //         height:
                                      //             6.0 * SizeConfig.heightMultiplier,
                                      //         width: 100 * SizeConfig.widthMultiplier,
                                      //         child: TextFieldWidget(
                                      //           textEditingController:
                                      //               maintenanceController
                                      //                   .descriptionController,
                                      //           hintText: "Enter Description",
                                      //           labelText: "Description",
                                      //         ),
                                      //       ),
                                      //       Container(
                                      //         height:
                                      //             6.0 * SizeConfig.heightMultiplier,
                                      //         width: 100 * SizeConfig.widthMultiplier,
                                      //         child: TextFieldWidget(
                                      //           textEditingController:
                                      //               maintenanceController
                                      //                   .quantityController,
                                      //           hintText: "Enter Quantity ",
                                      //           labelText: "Quantity ",
                                      //           inputFormatter:
                                      //               TextInputType.numberWithOptions(
                                      //                   decimal: true),
                                      //         ),
                                      //       ),
                                      //       Container(
                                      //         height:
                                      //             6.0 * SizeConfig.heightMultiplier,
                                      //         width: 100 * SizeConfig.widthMultiplier,
                                      //         child: TextFieldWidget(
                                      //           textEditingController:
                                      //               maintenanceController
                                      //                   .amountController,
                                      //           hintText: "Enter Amount ",
                                      //           labelText: "Amount",
                                      //           inputFormatter:
                                      //               TextInputType.numberWithOptions(
                                      //                   decimal: true),
                                      //         ),
                                      //       ),
                                      SizedBox(
                                        height:
                                            SizeConfig.heightMultiplier * 10,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
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
  // ListView.builder(
                                //   itemCount: maintenanceController
                                //               .observationListdata.length >=
                                //           0
                                //       ? maintenanceController
                                //           .observationListdata.length
                                //       : maintenanceController
                                //           .observationList.length,
                                //   physics: NeverScrollableScrollPhysics(),
                                //   shrinkWrap: true,
                                //   itemBuilder:
                                //       (BuildContext context, int index) {
                                //     return ListTile(
                                //       contentPadding: EdgeInsets.all(0),
                                //       title: Container(
                                //         height:
                                //             5.5 * SizeConfig.heightMultiplier,
                                //         width: 100 * SizeConfig.widthMultiplier,
                                //         decoration: BoxDecoration(
                                //           color: Colors.white,
                                //           borderRadius: BorderRadius.all(
                                //               Radius.circular(1 *
                                //                   SizeConfig.widthMultiplier)),
                                //           boxShadow: [
                                //             BoxShadow(
                                //               color: Colors.black12,
                                //               blurRadius: 2 *
                                //                   SizeConfig.widthMultiplier,
                                //             ),
                                //           ],
                                //         ),
                                //         child: Container(
                                //           height:
                                //               5.5 * SizeConfig.heightMultiplier,
                                //           width:
                                //               100 * SizeConfig.widthMultiplier,
                                //           decoration: BoxDecoration(
                                //             color: Colors.white,
                                //             borderRadius: BorderRadius.all(
                                //                 Radius.circular(1 *
                                //                     SizeConfig
                                //                         .widthMultiplier)),
                                //             boxShadow: [
                                //               BoxShadow(
                                //                 color: Colors.black12,
                                //                 blurRadius: 2 *
                                //                     SizeConfig.widthMultiplier,
                                //               ),
                                //             ],
                                //           ),
                                //           child: Center(
                                //             child: Row(
                                //               children: [
                                //                 CustText(
                                //                     name: maintenanceController
                                //                             .observationListdata[
                                //                         index]['observation'],
                                //                     size: 1.6,
                                //                     colors: Colors.black,
                                //                     fontWeightName:
                                //                         FontWeight.w600),
                                //                 CustText(
                                //                     name: maintenanceController
                                //                             .observationListdata[
                                //                         index]['observation'],
                                //                     size: 1.6,
                                //                     colors: Colors.black,
                                //                     fontWeightName:
                                //                         FontWeight.w600),
                                //               ],
                                //             ),
                                //           ),
                                //         ),
                                //       ),
                                //     );
                                //   },
                                // ),