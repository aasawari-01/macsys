import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:macsys/component/custom_widget/colorsC.dart';
import '../../util/SizeConfig.dart';
import 'cust_text.dart';

class SelectionDialog extends StatelessWidget {
  var list;
  int flag;
  final String? selectedValue; // Default value

  final Function(String, int) onSelected;

  SelectionDialog({
    required this.list,
    required this.onSelected,
    required this.flag,
    this.selectedValue, // Default value
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: 20 * SizeConfig.heightMultiplier,
          bottom: flag == 0
              ? 30 * SizeConfig.heightMultiplier
              : 35 * SizeConfig.heightMultiplier),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          bool isSelected =
              selectedValue == list[index]; // Check if it's the selected item

          return GestureDetector(
              onTap: () {
                if (flag == 0) {
                  onSelected(list[index], index);
                  Get.back();
                } else if (flag == 1) {
                  print("HERE IS CLICK");
                  onSelected(list[index], index);
                  Get.back();
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.widthMultiplier * 2.0),
                child: Column(
                  children: [
                    CustText(
                        name: flag == 0 ? "${list[index]}" : list[index],
                        size: 1.8,
                        colors: Colors.white,
                        fontWeightName: FontWeight.w600),
                    /* CustText(
                        name: flag==1
                            ? "${list[index]}"
                            : list[index],
                        size: flag==1?1.8:1.4 ,
                        colors: Colors.white,
                        fontWeightName: FontWeight.w600),*/

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
      ),
    );
  }
}
