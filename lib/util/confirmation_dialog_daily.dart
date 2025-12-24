import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../component/custom_widget/colorsC.dart';
import '../util/SizeConfig.dart';

class ConfirmationDialogDaily extends StatelessWidget {
  final String msg;
  final String? page;

  ConfirmationDialogDaily(
    this.msg, {
    this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4 * SizeConfig.widthMultiplier)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.0),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 18.0),
            margin: EdgeInsets.only(
                top: 3.5 * SizeConfig.widthMultiplier,
                right: 2 * SizeConfig.widthMultiplier),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                  colors: [colorPrimary, colorPrimary],
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
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 5.2 * SizeConfig.widthMultiplier),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(2.5 * SizeConfig.widthMultiplier),
                    child: Text(
                      msg,
                      style: TextStyle(
                          fontSize: 1.8 * SizeConfig.textMultiplier,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 6 * SizeConfig.widthMultiplier),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          // Navigator.pop(context);
                          Navigator.pop(context, true); // Return true on Yes
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 4 * SizeConfig.widthMultiplier),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(
                                    4 * SizeConfig.widthMultiplier)),
                          ),
                          child: Text(
                            "Yes",
                            style: TextStyle(
                                color: colorPrimary,
                                fontSize: 2 * SizeConfig.textMultiplier),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context,
                              false); // Return false when "No" is clicked
                          // if (onConfirm != null) {
                          //   onConfirm!();
                          // }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 4 * SizeConfig.widthMultiplier),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(
                                    4 * SizeConfig.widthMultiplier)),
                          ),
                          child: Text(
                            "No",
                            style: TextStyle(
                                color: colorPrimary,
                                fontSize: 2 * SizeConfig.textMultiplier),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
