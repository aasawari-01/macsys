import 'package:flutter/material.dart';
import '../component/custom_widget/colorsC.dart';
import '../component/custom_widget/cust_text.dart';
import '../util/SizeConfig.dart';

class ConfirmationDialog extends StatelessWidget {
  var title, msg;
  final Function(bool) onSelected;

  ConfirmationDialog({
    @required this.title,
    @required this.msg,
    required this.onSelected,
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
      margin: EdgeInsets.only(left: 0.0, right: 0.0),
      child: Container(
        padding: EdgeInsets.only(
          top: 18.0,
        ),
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
            borderRadius: BorderRadius.circular(4 * SizeConfig.widthMultiplier),
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
            title != ""
                ? Center(
                    child: Padding(
                    padding: EdgeInsets.all(1 * SizeConfig.widthMultiplier),
                    child: CustText(
                        name: title,
                        size: 2.2,
                        colors: Colors.white,
                        fontWeightName: FontWeight.w600),
                  ) //
                    )
                : Container(),
            title != "" ? Divider() : Container(),
            Center(
                child: Padding(
              padding: EdgeInsets.all(2.5 * SizeConfig.widthMultiplier),
              child: CustText(
                  name: msg,
                  size: 1.8,
                  colors: Colors.white,
                  fontWeightName: FontWeight.w400),
            ) //
                ),
            SizedBox(height: 3 * SizeConfig.heightMultiplier),
            InkWell(
              child: Container(
                padding: EdgeInsets.only(
                    top: 1 * SizeConfig.heightMultiplier,
                    bottom: 1 * SizeConfig.heightMultiplier),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft:
                          Radius.circular(4 * SizeConfig.widthMultiplier),
                      bottomRight:
                          Radius.circular(4 * SizeConfig.widthMultiplier)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        onSelected(false);
                        Navigator.pop(context);
                      },
                      child: CustText(
                          name: "Cancel",
                          size: 2,
                          colors: Colors.blue,
                          fontWeightName: FontWeight.w600),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onSelected(true);
                      },
                      child: CustText(
                          name: "Yes",
                          size: 2,
                          colors: Colors.blue,
                          fontWeightName: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
