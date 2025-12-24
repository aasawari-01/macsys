import 'package:flutter/material.dart';
import '../component/custom_widget/color_loader.dart';
import '../util/SizeConfig.dart';

class CustomLoading extends StatelessWidget {

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
      margin: EdgeInsets.only(left: 0.0,right: 0.0),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: 18.0,
            ),
            margin: EdgeInsets.only(top: 3.5 * SizeConfig.widthMultiplier,right: 2 * SizeConfig.widthMultiplier),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 5.2 * SizeConfig.widthMultiplier,
                ),
                Center(
                    child: Row(children: <Widget>[
                      SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                      ColorLoader(),
                      SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                      Text("Please wait..",style: TextStyle(
                          color: Colors.black,
                          fontSize:
                          2 * SizeConfig.textMultiplier))
                    ],)//
                ),
                SizedBox(height: 6 * SizeConfig.widthMultiplier),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

