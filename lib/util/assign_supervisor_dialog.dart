import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:macsys/component/custom_widget/colorsC.dart';
import 'package:macsys/component/custom_widget/custom_loading_popup.dart';
import 'package:macsys/component/jobs/job_controller.dart';
import 'package:macsys/maintaince/maintaince_controller.dart';
import 'package:macsys/maintaince/vehicle_maintenece_model.dart';
import 'package:macsys/util/SizeConfig.dart';
import 'package:macsys/util/custom_dialog.dart';

// ignore: must_be_immutable
class AssignSupervisorDialog extends StatelessWidget {
  AssignSupervisorDialog();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>(); // Form Key

  MaintenanceController maintenanceController = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MaintenanceController>(
      init: MaintenanceController(),
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

  Widget dialogContent(BuildContext context, MaintenanceController controller) {
    return Form(
      key: formKey,
      child: Container(
        margin: EdgeInsets.only(left: 0.0, right: 0.0),
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 18.0),
              margin: EdgeInsets.only(
                top: 3.5 * SizeConfig.widthMultiplier,
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
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(),
                        width: SizeConfig.widthMultiplier * 55,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            dropdownColor:
                                const Color.fromARGB(255, 0, 73, 129),
                            icon: Icon(Icons.arrow_drop_down,
                                color: Colors.white),
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            hint: Text("Select Supervisor",
                                style: TextStyle(color: Colors.white)),

                            // Store only the selected supervisor's ID as a string
                            value: controller.getSelectedSupervisor,

                            items: controller.getMaintenanceSuperList.isNotEmpty
                                ? controller.getMaintenanceSuperList
                                    .map((supervisor) {
                                    return DropdownMenuItem<String>(
                                      alignment: Alignment.center,
                                      value: supervisor.id
                                          .toString(), // Store ID as a string
                                      child: Container(
                                        child: Text(
                                            supervisor.fullName ??
                                                "Unknown Supervisor",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    );
                                  }).toList()
                                : [],

                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                log("Selected Supervisor ID: $newValue");

                                // Store only the ID as a string
                                controller.getSelectedSupervisor = newValue;
                                controller.update();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 6 * SizeConfig.widthMultiplier),
                  GestureDetector(
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
                        "Assign",
                        style: TextStyle(
                          color: colorPrimary,
                          fontSize: 2 * SizeConfig.textMultiplier,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        final MaintenenceSupervisorGet? selectedSupervisor =
                            controller.getMaintenanceSuperList.firstWhereOrNull(
                                (supervisor) =>
                                    supervisor.id.toString() ==
                                    controller.getSelectedSupervisor);

                        if (selectedSupervisor == null) {
                          log("Error: Selected supervisor not found");
                          return;
                        }

                        final supervisorId = selectedSupervisor
                            .id; // Now, we have the correct ID

                        log('-----$supervisorId');
                        log('-----${maintenanceController.maintenanceId}');
                        if (supervisorId != '' &&
                            controller.getSelectedSupervisor != null) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  CustomLoadingPopup());
                          await maintenanceController
                              .assignMaintainceSupervisor(
                                  maintenanceController.maintenanceId,
                                  supervisorId);
                          await maintenanceController.getVehicleMaintenanceList(
                              false, 0, false);
                          controller.getSelectedSupervisor = null;
                        }
                        Get.back();
                      }
                      Navigator.pop(context);
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
                  padding:
                      EdgeInsets.only(top: 1 * SizeConfig.heightMultiplier),
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
      ),
    );
  }
}
