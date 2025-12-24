import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:macsys/component/custom_widget/colorsC.dart';
import '../../util/SizeConfig.dart';
import '../component/custom_widget/cust_text.dart';

class FuelSelectionDialog extends StatelessWidget {
  var fuel_list;
  bool flag;

  final Function(int, String, int) onSelected;

  FuelSelectionDialog({
    required this.fuel_list,
    required this.onSelected,
    required this.flag,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: 20 * SizeConfig.heightMultiplier,
          bottom: flag?30 * SizeConfig.heightMultiplier:35 * SizeConfig.heightMultiplier),
      child: Dialog(
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(5 * SizeConfig.widthMultiplier)),
        elevation: 2.0,
        backgroundColor: colorPrimary,
        child: dialogContent(context),
      ),
    );
  }

  Widget dialogContent(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: fuel_list.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
            onTap: () {
              if (flag) {
                onSelected(
                    fuel_list[index].id, fuel_list[index].company, index);
                Get.back();
              } else {
                print("HERE IS CLICK");
                onSelected(
                    fuel_list[index].id, fuel_list[index].short, index);
                Get.back();
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.widthMultiplier * 2.0),
              child: Column(
                children: [
                  CustText(
                      name: flag
                          ? ""
                          : fuel_list[index].short,
                      size: 1.8,
                      colors: Colors.white,
                      fontWeightName: FontWeight.w600),
                  CustText(
                      name: flag
                          ? "${fuel_list[index].company}"
                          : fuel_list[index].address,
                      size: flag?1.8:1.4 ,
                      colors: Colors.white,
                      fontWeightName: FontWeight.w600),

                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.widthMultiplier * 1.0),
                    child: Divider(
                        color: Colors.white,
                        indent: 40,
                        endIndent: 40,
                        height: 1),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
