import 'package:flutter/material.dart';
import 'package:macsys/component/custom_widget/cust_text_start.dart';
import 'package:remixicon/remixicon.dart';
import '../../util/ApiClient.dart';
import '../../util/SizeConfig.dart';
import '../custom_widget/colorsC.dart';
import '../custom_widget/cust_text.dart';

class ProfileView extends StatelessWidget {
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
            name: "Profile",
            size: 2.2,
            colors: Colors.white,
            fontWeightName: FontWeight.w600),
      ),
      body: Stack(
        children: [
          Container(
            height: 100 * SizeConfig.heightMultiplier,
            width: 100 * SizeConfig.widthMultiplier,
            child: Image.asset(
              'assets/icons/ic_home.png',
              fit: BoxFit.fitHeight,
            ),
          ),
          Container(
            height: 100 * SizeConfig.heightMultiplier,
            width: 100 * SizeConfig.widthMultiplier,
            color: Colors.white.withOpacity(0.8),
            child: Column(
              children: [
                SizedBox(height: 2 * SizeConfig.heightMultiplier),
                cart("Full Name", ApiClient.box.read('superName')),
                SizedBox(height: 1 * SizeConfig.heightMultiplier),
                cart("Mobile No", ApiClient.box.read('superMobile')),
                SizedBox(height: 1 * SizeConfig.heightMultiplier),
                cart("Office Mobile", ApiClient.box.read('crewMobile')),
                SizedBox(height: 1 * SizeConfig.heightMultiplier),
                cart("Email", ApiClient.box.read('superEmail') ?? "Not Available"),
                SizedBox(height: 1 * SizeConfig.heightMultiplier),
                cart("Office Email", ApiClient.box.read('crewEmail')?? "Not Available"),
                SizedBox(height: 1 * SizeConfig.heightMultiplier),
                cart("Skill", ApiClient.box.read('skills')),
              ],
            ),
          ),
        ],
      ),

    );
  }

  cart(title, value) {
    return Container(
      width: 100 * SizeConfig.widthMultiplier,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(1 * SizeConfig.widthMultiplier),
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: 3 * SizeConfig.heightMultiplier,
            bottom: 3 * SizeConfig.heightMultiplier),
        child: Row(
          children: [
            SizedBox(width: 2 * SizeConfig.widthMultiplier),
            Container(
                width: 32 * SizeConfig.widthMultiplier,
                child: CustTextStart(
                    name: title,
                    size: 1.8,
                    colors: Colors.black87,
                    fontWeightName: FontWeight.w600)),
            Container(
                width: 5 * SizeConfig.widthMultiplier,
                child: CustText(
                    name: ":",
                    size: 2.2,
                    colors: Colors.black87,
                    fontWeightName: FontWeight.w600)),
            Container(
                width: 60 * SizeConfig.widthMultiplier,
                child: CustTextStart(
                    name: value,
                    size: 1.8,
                    colors: Colors.black,
                    fontWeightName: FontWeight.w600))
          ],
        ),
      ),
    );
  }
}
