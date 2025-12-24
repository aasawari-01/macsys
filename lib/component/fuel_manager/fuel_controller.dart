import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:macsys/component/fuel_manager/fuel_transaction_model.dart';
import 'package:macsys/component/home/home_view.dart';

import '../../services/remote_services.dart';
import '../../util/ApiClient.dart';
import '../../util/custom_dialog.dart';
import '../custom_widget/colorsC.dart';
import '../home/home_controller.dart';
import 'fuel_model.dart';

class FuelController extends GetxController {
  var pumpName = ""; // Default value, change as needed
  int companyId = 0;
  int locationId = 0;
  var liters = 0;
  var rates = 0.0;
  var fuelBalance = 0.0;
  double fuelTotalBalance = 0.0;
  var purchasePrice = 0.0;
  bool status = true;

  double TotalPurchaseBalance = 0.0;
  double TotalUsedFuel = 0.0;
  double TotalRemainingFuel = 0.0;
  var selectDate = "Pick Date";
  var transactionLength = 10;
  var msg = "";
  var monitoringImg = "";
  var litreController = TextEditingController(), litre = "";
  var rateController = TextEditingController(), rate = "";
  var selectedDateFlag = true;
  var selectedDate = "";
  var homeController = Get.put(HomeController());
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  //var pumpList = [""];
  void setPumpName(String name) {
    pumpName = name;
    print("pump name $pumpName");
    update();
  }

  setDate(String name) {
    selectDate = name;
    update();
  }

  updateSelectedDate(date) {
    if (date == "") {
      selectedDate =
          "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";
      setDate(date);
    } else {
      print("date::$selectedDate");
      String formatedDate =
          "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";
      selectedDate = date;
      setDate(formatedDate);
    }
    // getComplaintsList(selectedProgressName,selectedDate);

    update();
  }

  String selectedName = "Select pump";
  String selectedLocation = "Select location";
  var litreDouble;
  var rateDouble;
  var fuelStatus = "Tanker";

  void updateFuelStatus(String newStatus) {
    fuelStatus = newStatus;
    print("Here is the update : $fuelStatus");
    update();
  }

  setLitreValue(value, flag) {
    if (flag) {
      litreDouble = double.parse(value);
    } else {
      rateDouble = double.parse(value);
    }
    calculateRate(litreDouble, rateDouble);
    update();
  }

  calculateRate(litreDouble, rateDouble) {
    double temp = litreDouble * rateDouble;
    String formattedNumber = temp.toStringAsFixed(2);

    // Convert back to a double if needed
    double result = double.parse(formattedNumber);

    print(result);
    purchasePrice = result;
    print("HERE IS THE PRICE");
    checkValidation();
    update();
  }

  updatePumpName(name) {
    selectedName = name;
    print("Selected Name:$selectedName");
    update();
  }

  updateLocationName(name) {
    selectedLocation = name;
    update();
  }

  updateLoName(nameL) {
    selectedLocation = nameL;
    print("location $selectedLocation");
    update();
  }

  updateRate(index) {
    fuelBalance = double.parse(petroleum[index].balance!);
    print("Fuel Balacnce $fuelBalance");
    update();
  }

  updateFuelBalance(index, isHome) {
    print("Total Fuel Balance $fuelTotalBalance");
    for (int i = 0; i < location.length; i++) {
      print("asdjjjasd:${location[i].purchase}");
    }
    if (location[index].purchase!.isEmpty) {
      print("object");
      fuelTotalBalance = 0;
    } else {
      fuelTotalBalance = double.parse(
          location[index].purchase![0].totalConsumption!.toString());
      print("Total Fuel Balance $fuelTotalBalance");
    }
    update();
  }

  bool warningText = false;

  Future addFuel(context, id, purchaseAmount, litre, rate) async {
    var request = new http.MultipartRequest("POST",
        Uri.parse('${RemoteServices.baseUrl}api/v1/diesel-daily-purchase'));
    print("request URL here $request");
    request.headers['Authorization'] = 'Bearer ${ApiClient.box.read('token')}';
    print("TOKEN::${ApiClient.box.read('token')}");
    request.headers['Content-Type'] = 'application/json';
    request.headers['Accept'] = '*/*';
    request.fields['company'] = "${id.toString()}";
    request.fields['purchase_amt'] = '${purchasePrice.toString()}';
    request.fields['consumption'] = '${litre.toString()}';
    request.fields['rate'] = "${rate.toString()}";
    request.fields['purchase_for'] = '$fuelStatus';
    request.fields['location'] = "$locationId";
    request.fields['purchase_date'] = "$selectedDate";
    request.fields.forEach((key, value) {
      print("$key: $value");
    });
    if (image == null) {
      request.fields['invoice'] = '';
    } else {
      request.files.add(
          await http.MultipartFile.fromPath('monitoring_img', image!.path));
    }
    request.send().then(
      (response) {
        http.Response.fromStream(response).then(
          (onValue) {
            Navigator.pop(context);
            try {
              print("statusCode : ${onValue.statusCode}");
              print("body : ${onValue.body}");

              Map decoded = jsonDecode(onValue.body);
              if (decoded['status'] == true) {
                status = decoded['status'];
                msg = decoded['msg'];
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        CustomDialog(decoded['msg']));
                print("Comapny ID::${decoded['msg']} id:::$companyId");
                Get.to(HomeView());
              } else {
                status = decoded['flag'];
                msg = decoded['msg'];
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        CustomDialog(decoded['msg']));
              }
              // get your response here...
            } catch (e) {
              // handle exeption(e);
            }
          },
        );
      },
    );
  }

  File? image;

  get_image(ImageSource source) async {
    var img = await ImagePicker()
        .pickImage(source: source, maxHeight: 592, maxWidth: 360); // moto x4
    // var image = await ImagePicker.pickImage( imageQuality: 90, source: ImageSource.camera, );
    if (img != null) {
      var cropped = await ImageCropper().cropImage(
          sourcePath: img.path,
          compressQuality: 50,
          // aspectRatioPresets: [
          //   CropAspectRatioPreset.original,
          //   CropAspectRatioPreset.square,
          //   //  CropAspectRatioPreset.ratio3x2,
          //   // CropAspectRatioPreset.original,
          //   CropAspectRatioPreset.ratio4x3,
          //   /*   CropAspectRatioPreset.ratio5x3,
          //   CropAspectRatioPreset.ratio5x4,
          //   CropAspectRatioPreset.ratio7x5,*/
          //   CropAspectRatioPreset.ratio16x9
          // ],
          uiSettings: [
            AndroidUiSettings(
              toolbarColor: colorPrimary,
              toolbarTitle: "Ansh Infra",
              statusBarColor: colorPrimary,
              backgroundColor: Colors.white,
            )
          ]);

      // final bytes = (await img.readAsBytes()).lengthInBytes;
      image = File(cropped!.path);
    }

    // print(" print == ::: $image");
    update();
  }

  checkValidation() {
    if (purchasePrice > fuelBalance) {
      print("purchasePrice greater Price");
      print("warning the price is greater");
      warningText = true;
    } else {
      print("purchasePrice Smaller Price");
      print("Valid  purchasePrice Smaller Price");
      warningText = false;
    }

    update();
  }

  List<PetroleumCompany> petroleum = [];
  List<Location> location = [];
  List<PurchaseDiesel> purchasePetrol = [];

  Future getTransaction() async {
    getFuel();
    try {
      var getDetails =
          await RemoteServices.fetchGetData('api/v1/diesel-daily-purchase');
      print("${getDetails.body}");
      if (getDetails.statusCode == 200) {
        print("HERE !!");
        var apiDetails = transactionModelFromJson(getDetails.body);
        print("HERE !!");
        purchasePetrol = apiDetails.purchaseDiesel;
      } else {
        // checkUpdate();
        print("Exception");
      }
    } catch (e) {
      print("catch  == $e");
      //   checkUpdate();
    }

    update();
  }

  Future getFuel() async {
    try {
      //    pumpList.clear();
      var getDetails = await RemoteServices.fetchGetData('api/v1/petroleum');
      print("ASD${getDetails.statusCode})");
      if (getDetails.statusCode == 200) {
        print("Issue Here");
        var apiDetails = fuelModelFromJson(getDetails.body);
        print("Issue Here");
        petroleum = apiDetails.petroleum;
        location = apiDetails.location;
        TotalUsedFuel =
            double.parse(apiDetails.totalUsedFuel!.toStringAsFixed(2));
        TotalPurchaseBalance =
            double.parse(apiDetails.totalPurchaseFuel!.toStringAsFixed(2));
        var temp1 = TotalPurchaseBalance - TotalUsedFuel;
        var temp = temp1.toStringAsFixed(2);
        print("TotalUsedFuel=$TotalUsedFuel");
        print("TotalPurchaseBalance=$TotalPurchaseBalance");
        print("Remaining Fuel=$temp1");
        print("Remaining Fuel=$temp");
        TotalRemainingFuel = double.parse(temp);
        // var TBalance=apiDetails.totalPurchaseFuel;
        // homeController.updateTotalBalance(double.parse(TBalance.toString()));
        // print("HERE IS THE ${apiDetails.totalUsedFuel}");
        /* print("asdasdasd ${getDetails.body}");
        print("Asdjkahjsdh ${apiDetails.petroleum[0].id}");
        Set<String> uniqueCompanies = Set();

        for (int i = 0; i < apiDetails.petroleum.length; i++) {
          uniqueCompanies.add(apiDetails.petroleum[i].company.toString());
        }

        // Add unique values back to pumpList
        pumpList.addAll(uniqueCompanies.toList());*/
      } else {
        print("HERE:::");
      }
    } catch (e) {
      print("this:is the ::$e.");
    }

    update();
  }

  cleanData() {
    fuelBalance = 00.0;
    purchasePrice = 00.0;
    petroleum.clear();
    selectedName = "Select pump";
    selectedLocation = "Select location";
    fuelStatus = "Fuel Tanker";
    litreController.clear();
    rateController.clear();
    rateDouble = 0;
    litreDouble = 0;
    warningText = false;
    monitoringImg = '';
    image = null;
    selectedDate = "";
    selectDate = "Pick Date";
    fuelTotalBalance = 0.0;
    update();
  }
}
