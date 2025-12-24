import 'package:flutter/material.dart';
import '../../util/SizeConfig.dart';
import 'color_loader.dart';
import 'cust_text.dart';

class CustomLoadingPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.all(Radius.circular(4 * SizeConfig.widthMultiplier)),
      ),
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                  child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 2 * SizeConfig.widthMultiplier,
                  ),
                  ColorLoader(),
                  SizedBox(
                    width: 2 * SizeConfig.widthMultiplier,
                  ),
                  CustText(
                      name: "Please wait..",
                      size: 1.8,
                      colors: Colors.black,
                      fontWeightName: FontWeight.w600),
                ],
              ) //
                  ),
              SizedBox(height: 6 * SizeConfig.widthMultiplier),
            ],
          ),
        ],
      ),
    );
  }
}
