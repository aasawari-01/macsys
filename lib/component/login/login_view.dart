import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:macsys/component/home/home_view.dart';
import 'package:remixicon/remixicon.dart';

import '../../util/SizeConfig.dart';
import '../../util/custom_dialog.dart';
import '../custom_widget/check_internet.dart';
import '../custom_widget/colorsC.dart';
import '../custom_widget/cust_text.dart';
import '../custom_widget/custom_loading_popup.dart';
import '../home/home_controller.dart';
import 'login_controller.dart';

class LoginView  extends StatelessWidget {

  var loginController = Get.put(LoginController());

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding:  EdgeInsets.only(top: 8 * SizeConfig.heightMultiplier,left: 15*SizeConfig.widthMultiplier),
            child: Image.asset(
              'assets/icons/title.png',
              height: 25 * SizeConfig.heightMultiplier,
              width: 70 * SizeConfig.widthMultiplier,
            ),
          ),
          GetBuilder<LoginController>(
            init: LoginController(),
            builder: (controller) =>  Center(
              child: Padding(
                padding:  EdgeInsets.only(left: 4 * SizeConfig.widthMultiplier,right: 4 * SizeConfig.widthMultiplier),
                child: Container(
                  height: 40 * SizeConfig.heightMultiplier,
                  width: 100 * SizeConfig.widthMultiplier,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: colorPrimary,
                    borderRadius:BorderRadius.circular(3 * SizeConfig.widthMultiplier),
                    border: Border.all(
                        width: 0.2 * SizeConfig.widthMultiplier,
                        color: Colors.white70
                    ),
                  ),
                  child: Padding(
                    padding:  EdgeInsets.all(2 * SizeConfig.widthMultiplier),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Row(
                        children: [
                          CustText(name: "Username",size: 1.6,colors:Colors.white,fontWeightName:FontWeight.w600),
                        ],
                      ),
                      SizedBox(height: 0.5 * SizeConfig.heightMultiplier),
                      Container(
                        // height: 6 * SizeConfig.widthMultiplier,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(
                              2 * SizeConfig.widthMultiplier)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 2 * SizeConfig.widthMultiplier,
                            ),
                          ],
                        ),
                        child: Center(
                          child: TextFormField(

                            textAlign:TextAlign.start ,
                            style: GoogleFonts.openSans(
                                textStyle:TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize:1.6 * SizeConfig.textMultiplier,
                                )),
                            controller: loginController.userNameController,
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            focusNode: _emailFocus,
                            onFieldSubmitted: (term) {
                              _fieldFocusChange(
                                  context, _emailFocus, _passwordFocus);
                            },
                            onTapOutside: (b) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            decoration: InputDecoration(
                              // labelText: "Enter Email",
                              // isDense: true,
                              contentPadding: EdgeInsets.only(top:-0.6 * SizeConfig.widthMultiplier,left: 2 * SizeConfig.widthMultiplier,right: 2 * SizeConfig.widthMultiplier,),
                              constraints: BoxConstraints.tightFor(height: 5.5 * SizeConfig.heightMultiplier),
                              fillColor: const Color(0xFF689fef),
                              /*contentPadding: new EdgeInsets.symmetric(
                                                vertical:
                                                2 * SizeConfig.widthMultiplier,
                                                horizontal:
                                                2 * SizeConfig.widthMultiplier),*/
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    2 * SizeConfig.widthMultiplier),
                                borderSide: const BorderSide(
                                  color: Color(0xFF689fef),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    2 * SizeConfig.widthMultiplier),
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    2 * SizeConfig.widthMultiplier),
                                borderSide: const BorderSide(
                                  color: Color(0xFF689fef),
                                  // width: 2.0,
                                ),
                              ),
                              hintText: "Enter username",
                              hintStyle: GoogleFonts.openSans(
                                  textStyle:TextStyle(
                                    color: const Color(0xFF888888),
                                    fontSize: 1.6 * SizeConfig.textMultiplier,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ),
                          ),
                        ),
                      ),
                        loginController.userEmail !=''?Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            CustText(name: loginController.userEmail,size: 1.6,colors:Colors.red,fontWeightName:FontWeight.w400,),
                          ],
                        ):Container(),
                        SizedBox(height:loginController.userEmail !=''? 2 * SizeConfig.heightMultiplier: 3 * SizeConfig.heightMultiplier),
                        Row(
                          children: [
                            CustText(name: "Password",size: 1.6,colors:Colors.white,fontWeightName:FontWeight.w500),
                          ],
                        ),
                        SizedBox(height: 0.5 * SizeConfig.heightMultiplier),
                        Container(

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(
                                2 * SizeConfig.widthMultiplier)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 1 * SizeConfig.widthMultiplier,
                              ),
                            ],
                          ),
                          child: TextFormField(

                            style: GoogleFonts.openSans(
                                textStyle:TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize:1.6 * SizeConfig.textMultiplier,
                                )),
                            controller: loginController.passwordController,
                            obscureText: loginController.obscureText,
                            enableInteractiveSelection: false,
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.go,
                            focusNode: _passwordFocus,
                            onFieldSubmitted: (value) {
                              _passwordFocus.unfocus();
                              //  _calculator();
                            },
                            onTapOutside: (b) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            decoration: InputDecoration(
                              // labelText: "Enter Email",
                              // isDense: true,
                              fillColor: Color(0xFF689fef),
                              contentPadding: EdgeInsets.only(top:-0.6 * SizeConfig.widthMultiplier,left: 2 * SizeConfig.widthMultiplier,right: 2 * SizeConfig.widthMultiplier,),
                              constraints: BoxConstraints.tightFor(height: 5.5 * SizeConfig.heightMultiplier),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    2 * SizeConfig.widthMultiplier),
                                borderSide: const BorderSide(
                                  color: Color(0xFF689fef),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    2 * SizeConfig.widthMultiplier),
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    2 * SizeConfig.widthMultiplier),
                                borderSide: const BorderSide(
                                  color: Color(0xFF689fef),
                                  // width: 2.0,
                                ),
                              ),

                              hintText: "Enter password",
                              hintStyle: GoogleFonts.openSans(
                                  textStyle:TextStyle(
                                    color: const Color(0xFF888888),
                                    fontSize: 1.6 * SizeConfig.textMultiplier,
                                    fontWeight: FontWeight.w400,
                                  )),
                              suffixIcon:Padding(
                                  padding: EdgeInsets.only(right:  2 * SizeConfig.widthMultiplier),
                                  child: GestureDetector(
                                    onTap: (){
                                      // FocusScope.of(context).requestFocus(new FocusNode());
                                      loginController.UpdateObscure(loginController.obscureText);
                                    },
                                    child: Icon(loginController.obscureText?Remix.eye_line:Remix.eye_off_line,size: 5 * SizeConfig.imageSizeMultiplier,
                                      color: colorPrimary,
                                    ),
                                  )// icon is 48px widget.
                              ),
                            ),

                          ),
                        ),
                        SizedBox(height: 0.5 * SizeConfig.heightMultiplier),
                        loginController.userPassword !=''?Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustText(name: loginController.userPassword,size: 1.6,colors:Colors.red,fontWeightName:FontWeight.w400),
                          ],
                        ):Container(),

                        SizedBox(height: 4 * SizeConfig.heightMultiplier),
                        GestureDetector(
                          onTap: () async {
                            FocusScope.of(context).requestFocus(new FocusNode());
                            loginController.Validation();
                            if(loginController.userEmail == '' && loginController.userPassword == ''){
                              if(await CheckInternet.checkInternet()) {
                                showDialog(context: context, builder: (BuildContext context) => CustomLoadingPopup());
                                final result = await loginController.login();
                                 Navigator.pop(context);
                                if(loginController.status == true){
                                  var homeController = Get.put(HomeController());
                                  homeController.getJobs();
                                  Get.offAll(HomeView());
                                }else{
                                  // print("loginController.msg ${loginController.msg}");
                                  showDialog(context: context, builder: (BuildContext context) => CustomDialog(loginController.msg));
                                }
                                }else{
                                showDialog(context: context, builder: (BuildContext context) => CustomDialog("Please check your internet connection"));
                              }
                            }

                          },
                          child: Container(
                             height: 5 * SizeConfig.heightMultiplier,
                            width: 100 * SizeConfig.widthMultiplier,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(
                                  2 * SizeConfig.widthMultiplier)),
                            ),child: Center(child: CustText(name: "Login",size: 1.6,colors:Colors.black,fontWeightName:FontWeight.w600)),),
                        )
                    ],),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
