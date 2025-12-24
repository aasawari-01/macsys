import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../services/remote_services.dart';
import '../../util/ApiClient.dart';
import '../../util/validator.dart';
import 'login_model.dart';

var loginStatus = false;

class LoginController extends GetxController {
  String userEmail = '';
  String userPassword = '';

  var userNameController = TextEditingController();
  var passwordController = TextEditingController();
  var status, token, msg = "";

  bool obscureText = true;

  void UpdateObscure(pass) {
    if (pass) {
      obscureText = false;
    } else {
      obscureText = true;
    }
    update();
  }

  String version = '';
  getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var remoteServices = RemoteServices();
    version = await packageInfo.version;
    // print("version::${version}");
    await ApiClient.box.write("version", version);
    update();
  }

  Future login() async {
    await getVersion();

    try {
      Map map = {
        "username": userNameController.text,
        "password": passwordController.text,
        "app_type": "supervisor",
      };
      print("map  == $map");
      var getDetails = await RemoteServices.postMethod('api/v1/login', map);
      Map decoded = jsonDecode(getDetails.body);
      if (getDetails.statusCode == 200) {
        print("HERE!!");
        print("HERE !!!!!${decoded['msg']}");
        msg = decoded['msg'];
        var apiDetails = loginModelFromJson(getDetails.body);
        print("HERE!!");
        print("HERE LOUTT");
        print("MESGG${apiDetails.msg}");
        msg = apiDetails.msg!;
        if (apiDetails.status == true) {
          print("HERE INN");
          String superName = "${apiDetails.profile!.firstName}" +
              " ${apiDetails.profile!.lastName}";
          ApiClient.box.write('login', true);
          ApiClient.box.write('token', apiDetails.token);
          ApiClient.box.write('superName', superName);
          ApiClient.box.write('superEmail', apiDetails.profile?.personalEmail);
          ApiClient.box
              .write('superMobile', apiDetails.profile?.personalMobile);
          ApiClient.box.write('crewMobile', apiDetails.profile?.officeMobile);
          ApiClient.box.write('crewEmail', apiDetails.profile?.officeEmail);
          ApiClient.box.write('skills', apiDetails.profile?.skills);
          print("status${apiDetails.status}");
          print("MESGG${apiDetails.msg}");
          print("Token${apiDetails.token}");
          loginStatus = apiDetails.status!;
          status = apiDetails.status;
          msg = apiDetails.msg!;
        } else {
          // print("else  == ");
          print("else out");
          print("MESGG${apiDetails.msg}");
          msg = apiDetails.msg!;
          checkUpdate();
        }
      } else {
        print("HERE:::");
        checkUpdate();
      }
    } catch (e) {
      print("this::: $e");

      checkUpdate();
    }

    update();
  }

  checkUpdate() {
    status = 0;
    print("msg ::  ");
    update();
  }

  Validation() {
    userEmail = Validator.validateName(userNameController.text);
    userPassword = Validator.validatePassword(passwordController.text);
    update();
  }

  cleanData() {
    userNameController.text = '';
    passwordController.text = '';
    update();
  }
}
