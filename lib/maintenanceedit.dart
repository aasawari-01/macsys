import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:macsys/main.dart';
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

class Maintenanceedit extends StatelessWidget {
  Maintenanceedit() {}

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
            name: "Edit Maintenance",
            size: 2.2,
            colors: Colors.white,
            fontWeightName: FontWeight.w600),
      ),
    );
  }
}
