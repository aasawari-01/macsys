import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../util/SizeConfig.dart';

class CustText extends StatelessWidget {

  var name,size,colors,fontWeightName;

  CustText({
    @required this.name,
    @required this.size,
    @required this.colors,
    @required this.fontWeightName,
  });
  @override
  Widget build(BuildContext context) {
    return Text(name,
        textAlign: TextAlign.center,
        style: GoogleFonts.openSans(
        textStyle:TextStyle(
            color: colors,
            fontWeight: fontWeightName,
            fontSize:size * SizeConfig.textMultiplier,
        )));
  }
}
/*

TextStyle(
color: colors,
fontFamily: "NotoSans",
fontWeight: fontWeightName,
fontSize:
size * SizeConfig.textMultiplier)*/
