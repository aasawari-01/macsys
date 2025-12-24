import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:macsys/component/custom_widget/cust_text.dart';
import 'package:macsys/component/custom_widget/cust_text_start.dart';

import '../../maintaince/maintaince_controller.dart';
import '../../util/SizeConfig.dart';

class TextFieldWidget extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController? textEditingController;
  var inputFormatter;
  final bool? readonly;
  final TextInputType? keyboardType;

  var maintenanceController = Get.put(MaintenanceController());
  TextFieldWidget(
      {required this.labelText,
      required this.hintText,
      this.textEditingController,
      this.inputFormatter,
      this.readonly,
      this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
            width: 33 * SizeConfig.widthMultiplier,
            child: CustTextStart(
              name: labelText,
              size: 1.6,
              colors: Colors.black87,
              fontWeightName: FontWeight.w600,
              textAlign: TextAlign.start,
            )),
        Container(
          height: 5.5 * SizeConfig.heightMultiplier,
          width: 60 * SizeConfig.widthMultiplier,
          decoration: BoxDecoration(
            color: Colors.white,
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
            child: TextField(
              keyboardType: inputFormatter,
              textAlign: TextAlign.start,
              maxLines: 5,
              style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 1.6 * SizeConfig.textMultiplier,
              )),
              controller: textEditingController,
              cursorColor: Colors.black,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                // labelText: "Enter Email",
                // isDense: true,
                counterText: "",
                contentPadding: EdgeInsets.only(
                  top: 2 * SizeConfig.widthMultiplier,
                  left: 2 * SizeConfig.widthMultiplier,
                  right: 2 * SizeConfig.widthMultiplier,
                ),
                constraints: BoxConstraints.tightFor(
                    height: 5.5 * SizeConfig.heightMultiplier),
                fillColor: const Color(0xFF689fef),
                /*contentPadding: new EdgeInsets.symmetric(
                                              vertical:
                                              2 * SizeConfig.widthMultiplier,
                                              horizontal:
                                              2 * SizeConfig.widthMultiplier),*/
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(1 * SizeConfig.widthMultiplier),
                  borderSide: const BorderSide(
                    color: Color(0xFF689fef),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(1 * SizeConfig.widthMultiplier),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(1 * SizeConfig.widthMultiplier),
                  borderSide: const BorderSide(
                    color: Color(0xFF689fef),
                    // width: 2.0,
                  ),
                ),
                hintText: hintText,
                hintStyle: GoogleFonts.openSans(
                    textStyle: TextStyle(
                  color: const Color(0xFF888888),
                  fontSize: 1.6 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.w400,
                )),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
