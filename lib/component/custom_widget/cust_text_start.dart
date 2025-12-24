import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../util/SizeConfig.dart';

// ignore: must_be_immutable
class CustTextStart extends StatelessWidget{

  var name,size,colors,textAlign,fontWeightName;

  CustTextStart({
    @required this.name,
    @required this.size,
    @required this.colors,
    @required this.textAlign,
    @required this.fontWeightName,
  });
  @override
  Widget build(BuildContext context) {
    return Text(
        name,
        textAlign: textAlign,
        style: GoogleFonts.notoSans(
        textStyle:TextStyle(
            color: colors,
            fontWeight: fontWeightName,
            fontSize:size * SizeConfig.textMultiplier,
        )));
  }
}

