import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:macsys/component/fuel_manager/fuel_transaction_model.dart';
import 'package:macsys/component/home/home_view.dart';
import 'package:macsys/maintaince/vehicle_maintaince_list_model.dart';
import 'package:macsys/maintaince/vehicle_maintaince_model.dart';

import 'package:macsys/maintaince/vehicle_maintenece_model.dart';

import '../../services/remote_services.dart';
import '../../util/ApiClient.dart';
import '../../util/custom_dialog.dart';
import '../component/fuel_manager/fuel_model.dart';
import '../component/home/home_controller.dart';
import '../util/validator.dart';
import 'vehicle_maintenece_model.dart';

class MaintenanceController extends GetxController {
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
  String selectedType = "Select Type";
  String selectedAssignJob = "Select Person";
  String selectedSupervisor = "Select Supervisor";
  int selectedIndex = 0;
  int selectedIndex2 = 0;
  int selectedIndex3 = 0;
  int selectedIndex4 = 0;
  int selectedIndex5 = 0;
  int selectedIndex6 = 0;

  int selectedIndex7 = 0;

  int selectedTab = 0;
  List<VehicleMaintenence> vehicleMaintenance = [];
  List<MaintenanceQuotation>? filteredVehicleMaintenance = [];
  RxList<XFile> selectedImages = <XFile>[].obs;
  final picker = ImagePicker();

  // String selectedAssignJob = "Select location";
  var transactionLength = 10;

  var msg = "";
  var monitoringImg = "";
  var descController = TextEditingController(), desc = "";
  var reasonTextController = TextEditingController(), reasonText = "";
  var notesController = TextEditingController(), rate = "";
  var locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  var machineReadingController = TextEditingController(), machineReading = "";
  var textFieldValues = [];
  var descriptionList = [];
  var amountList = [];
  var quantityList = [];
  var opinionList = [];
  List<String> arrayVariables = ['value1', 'value2', 'value3'];
  var observationList = [
    'Fuel Tank Level',
    'Engine Oil Level',
    'HYD Oil Level',
    'Coolant Oil Level',
    'Body issue'
  ];
  List<TextEditingController> controllers = [TextEditingController()];
  List<TextEditingController> opinionTextControllers = [
    TextEditingController()
  ];

  textFieldAdd() {
    opinionTextControllers.clear();

    // print(" \n\n\n ${observationList.length} \n\n");
    for (int i = 0; i < observationList.length; i++) {
      opinionTextControllers.add(TextEditingController());
    }
    update();
  }

  changeTab(int index) {
    selectedIndex = index;
    update(); // Notifies the view
  }

  addOpinion() {
    for (int i = 0; i < opinionTextControllers.length; i++) {
      opinionList.add(opinionTextControllers[i].text.toString());
    }
    // print("here is the opinion ${opinionList}");
    update();
  }

  // var observationList;
  final ImagePicker _picker = ImagePicker();
  var selectedDateFlag = true;
  var selectedDate = "";
  var homeController = Get.put(HomeController());

  String textFieldStrings = "";

  //var pumpList = [""];
  void setPumpName(String name) {
    pumpName = name;
    // print("pump name $pumpName");
    // print("object");

    update();
  }

  setDate(String name) {
    selectDate = name;
    update();
  }

  addTestFieldsToList() {
    update();
  }

  /* final picker = ImagePicker();
  var selectedImages = <File>[].obs;*/

  updateSelectedDate(date) {
    if (date == "") {
      selectedDate =
          "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";
      setDate(date);
    } else {
      // print("date::$selectedDate");
      String formatedDate =
          "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";
      selectedDate = date;
      setDate(formatedDate);
    }
    // getComplaintsList(selectedProgressName,selectedDate);

    update();
  }

  List<XFile>? mediaFileList;
  var imageList = 0;

  void filterList(String searchTerm) {
    if (searchTerm.isEmpty) {
      // print("Term $searchTerm");
      filteredVehicleMaintenance = maintenanceVehicleList;
    } else {
      filteredVehicleMaintenance = maintenanceVehicleList!
          .where((vehicle) => vehicle.vehicleDetails!.vehicleNo!
              .toLowerCase()
              .contains(searchTerm.toLowerCase()))
          .toList();
    }
    update();
  }

  pickImages() async {
    try {
      List<XFile>? pickedFileList =
          await _picker.pickMultiImage(// pickMultipleMedia
              //  maxWidth: 90 * SizeConfig.widthMultiplier,
              //  maxHeight: 70 * SizeConfig.heightMultiplier,
              //  imageQuality: 100,
              );
      if (pickedFileList.isNotEmpty) {
        mediaFileList = pickedFileList;
        // meetMemories(context,meetId);
      }
      // print("pickedFileList :${pickedFileList.length}");
      imageList = pickedFileList.length;
      // _mediaFileList = pickedFileList;
    } catch (e) {
      // print("error :$e");
    }
    update();
  }

  Future<void> pickImage() async {
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImages.add(pickedFile);
    }
  }

  var litreDouble;
  var rateDouble;
  List instructionList = [];

  addField() {
    // fields.add('');
    controllers.add(TextEditingController());

    // print("Here addField");
    update();
  }

  removefeild() {
    controllers.removeLast();
    update();
  }

  void removeField() {
    if (controllers.length > 1) {
      instructionList.removeLast();
      //  operatingInstruction.removeLast();
      controllers.removeLast();
      maintenanceReason.removeLast();
    }
    // print("Here removeField");
    update();
  }

  void removeFielddescription() {
    // if (controllers.length > 1) {
    //dataList.removeLast();
    materialDescription.removeLast();
    descriptionList.removeLast();
    amountList.removeLast();
    quantityList.removeLast();
    // }
    // print("Here removeField");
    update();
  }

  void removeFieldQuotationdescription() {
    // if (controllers.length > 1) {
    //dataList.removeLast();
    quotationMaterialDescription.removeLast();
    descriptionList.removeLast();
    amountList.removeLast();
    quantityList.removeLast();
    // }
    // print("Here removeField");
    update();
  }

  void removeInstruction() {
    // if (controllers.length > 1) {
    //dataList.removeLast();
    // print("Here removeinstructionList");
    controllers.removeLast();

    instructionList.removeLast();
    operatingInstruction.removeLast();
    // print("after removeinstructionList");

    // }
    // print("Here removeField");
    update();
  }

  void removeInstructionreason() {
    // if (controllers.length > 1) {
    //dataList.removeLast();
    // // print("Here removeinstructionList");
    // log("#############################");
    // log('instruction length${instructionList.length}');
    // log('instruction obj${instructionList}');

    // log('controller length${controllers.length}');
    // log('maintenanceReason length${maintenanceReason.length}');
    controllers.removeLast();
    instructionList.removeLast();
    maintenanceReason.removeLast();
    // log('instruction obj${instructionList}');

    // // print("after removeinstructionList");
    // log("#############################");
    // log('instruction length${instructionList.length}');
    // log('controller length${controllers.length}');
    // log('maintenanceReason length${maintenanceReason.length}');
    // // }
    // print("Here removeField");
    update();
  }

  void submitData() {
    // You can process the data here
    if (controllers.last.text != "") {
      instructionList.add(controllers.last.text);
      operatingInstruction.add(controllers.last.text);
      // print("instructionList  $instructionList");
      // print("instructionList  ${instructionList.length}");

      addField();
    }
    update();
  }

  void submitDataReason() {
    // You can process the data here
    if (controllers.last.text != "") {
      instructionList.add(controllers.last.text);
      maintenanceReason.add(controllers.last.text);
      // print("instructionList  $instructionList");
      // print("instructionList  ${instructionList.length}");
      // print("maintenace reasonlist  ${instructionList.length}");

      addField();
    }
    update();
  }

  calculateRate(litreDouble, rateDouble) {
    double temp = litreDouble * rateDouble;
    String formattedNumber = temp.toStringAsFixed(2);

    // Convert back to a double if needed
    double result = double.parse(formattedNumber);

    // print(result);
    purchasePrice = result;
    // print("HERE IS THE PRICE");
    update();
  }

  void addTextFieldValue() {
    // print(textFieldValues);
    // print(textFieldValues);
    update();
  }

  updateType(name) {
    selectedType = name;
    // print("Selected Name:$selectedType");
    update();
  }

  updatePersonName(name) {
    selectedAssignJob = name;
    update();
  }

  updateMaintenanceSupervisor(name) {
    selectedAssignJob = name;
    update();
  }

  updateRate(index) {
    fuelBalance = double.parse(petroleum[index].balance!);
    // print("Fuel Balacnce $fuelBalance");
    update();
  }

  updateFuelBalance(index, isHome) {
    // print("Total Fuel Balance $fuelTotalBalance");
    for (int i = 0; i < location.length; i++) {
      // print("asdjjjasd:${location[i].purchase}");
    }
    if (location[index].purchase!.isEmpty) {
      // print("object");
      fuelTotalBalance = 0;
    } else {
      fuelTotalBalance = double.parse(
          location[index].purchase![0].totalConsumption!.toString());
      // print("Total Fuel Balance $fuelTotalBalance");
    }
    update();
  }

  bool warningText = false;
  var dataList = [];

  addData(description, int quantity, double amount) {
    // dataList.add({
    //   'material_description': description,
    //   'quantity': quantity,
    //   'amount': amount,
    // });
    materialDescription.add({
      'material_description': description,
      'quantity': quantity,
      'amount': amount,
    });
    descriptionList.add("${description}");
    amountList.add('${amount}');
    quantityList.add('${quantity}');
    if (descriptionList.isNotEmpty) {
      // print("here ${descriptionList}");
      // print("${amountList}");
      // print("${quantityList}");
    }

    update();
  }

  addData2(description, int quantity, double amount) {
    dataList.add({
      'material_description': description,
      'quantity': quantity,
      'amount': amount,
    });
    materialDescription.add({
      'material_description': description,
      'quantity': quantity,
      'amount': amount,
    });

    log(descriptionList.length.toString());
    log(amountList.length.toString());
    log(quantityList.length.toString());
    descriptionList.add("${description}");
    amountList.add('${amount}');
    quantityList.add('${quantity}');
    if (descriptionList.isNotEmpty) {
      // print("here ${descriptionList}");
      // print("${amountList}");
      // print("${quantityList}");
    }

    update();
  }

  addData3(description, int quantity, double amount) {
    // dataList.add({
    //   'material_description': description,
    //   'quantity': quantity,
    //   'amount': amount,
    // });
    quotationMaterialDescription.add({
      'material_description': description,
      'quantity': quantity,
      'amount': amount,
    });

    log(descriptionList.length.toString());
    log(amountList.length.toString());
    log(quantityList.length.toString());
    descriptionList.add("${description}");
    amountList.add('${amount}');
    quantityList.add('${quantity}');
    if (descriptionList.isNotEmpty) {
      // print("here ${descriptionList}");
      // print("${amountList}");
      // print("${quantityList}");
    }

    update();
  }

  removeDataAt(int index) {
    if (index >= 0 && index < materialDescription.length) {
      log("#############################$index");
      // dataList.removeLast();
      log(descriptionList.length.toString());
      log(amountList.length.toString());
      log(quantityList.length.toString());
      descriptionList.removeAt(index);
      amountList.removeAt(index);
      quantityList.removeAt(index);
      materialDescription.removeAt(index);

      // Debugging output
      // print("Removed item at index: $index");
      // print("Updated materialDescription: $materialDescription");
      // print("Updated descripotionlist: $descriptionList");
      // print("Updated amount: $amountList");
      // print("Updated quality: $quantityList");

      update(); // Refresh UI
    } else {
      // print("Invalid index: $index. No item removed.");
    }
  }

  removeDataAtQuotation(int index) {
    if (index >= 0 && index < quotationMaterialDescription.length) {
      log("#############################$index");
      // dataList.removeLast();
      log(descriptionList.length.toString());
      log(amountList.length.toString());
      log(quantityList.length.toString());
      descriptionList.removeAt(index);
      amountList.removeAt(index);
      quantityList.removeAt(index);
      quotationMaterialDescription.removeAt(index);

      // Debugging output
      // print("Removed item at index: $index");
      // print("Updated materialDescription: $quotationMaterialDescription");
      // print("Updated descripotionlist: $descriptionList");
      // print("Updated amount: $amountList");
      // print("Updated quality: $quantityList");

      update(); // Refresh UI
    } else {
      // print("Invalid index: $index. No item removed.");
    }
  }

  removeDataAtInstruction(int index) {
    if (index >= 0 && index < instructionList.length) {
      log("#############################$index");

      // log(instructionList.length.toString());
      controllers.removeAt(index);

      instructionList.removeAt(index);
      operatingInstruction.removeAt(index);
      // print("Removed item at index: $index");
      // print("Updated instructionList: $instructionList");
      // print("Updated operatingInstruction: $operatingInstruction");

      update();
    } else {
      // print("Invalid index: $index. No item removed.");
    }
  }

  removeDataAtInstructionreason(int index) {
    if (index >= 0 && index < instructionList.length) {
      log("#############################$index");
      log('instruction length${instructionList.length}');
      log('controller length${controllers.length}');
      log('maintenanceReason length${maintenanceReason.length}');
      // log(instructionList.length.toString());
      controllers.removeAt(index);

      instructionList.removeAt(index);
      maintenanceReason.removeAt(index);
      // print("Removed item at index: $index");
      log("#############################$index");
      log('instruction length${instructionList.length}');
      log('controller length${controllers.length}');
      log('maintenanceReason length${maintenanceReason.length}');

      update();
    } else {
      // print("Invalid index: $index. No item removed.");
    }
  }

  addNewEntry() {
    final description = "${descriptionController.text}";
    final quantity = int.tryParse(quantityController.text) ?? 0;
    final amount = double.tryParse(amountController.text) ?? 0.0;
    // print("Quantity :: $quantity");
    // print("Amount :: $amount");
    // print("descrppp  :: $description");
    if (description.isNotEmpty && quantity >= 0 && amount >= 0.0) {
      addData2(description, quantity, amount);
      descriptionController.clear();
      quantityController.clear();
      amountController.clear();
    } else {
      // Show error message or handle invalid input
      // print("Quantity :: $quantity");
      // print("Amount :: $amount");
      // print("descrppp  :: $description");
    }
    update();
  }

  addNewEntry2() {
    final description = "${descriptionController.text}";
    final quantity = int.tryParse(quantityController.text) ?? 0;
    final amount = double.tryParse(amountController.text) ?? 0.0;
    // print("Quantity :: $quantity");
    // print("Amount :: $amount");
    // print("descrppp  :: $description");
    if (description.isNotEmpty && quantity >= 0 && amount >= 0.0) {
      addData2(description, quantity, amount);
      descriptionController.clear();
      quantityController.clear();
      amountController.clear();
    } else {
      // Show error message or handle invalid input
      // print("Quantity :: $quantity");
      // print("Amount :: $amount");
      // print("descrppp  :: $description");
    }
    update();
  }

  addNewEntry3() {
    final description = "${descriptionController.text}";
    final quantity = int.tryParse(quantityController.text) ?? 0;
    final amount = double.tryParse(amountController.text) ?? 0.0;
    // print("Quantity :: $quantity");
    // print("Amount :: $amount");
    // print("descrppp  :: $description");
    if (description.isNotEmpty && quantity >= 0 && amount >= 0.0) {
      addData3(description, quantity, amount);
      descriptionController.clear();
      quantityController.clear();
      amountController.clear();
    } else {
      // Show error message or handle invalid input
      // print("Quantity :: $quantity");
      // print("Amount :: $amount");
      // print("descrppp  :: $description");
    }
    update();
  }

  void removeFielddescription2() {
    // if (controllers.length > 1) {
    //dataList.removeLast();
    // materialDescription.removeLast();

    int index = 0; // Index of the element to remove
    descriptionList.removeAt(index);
    amountList.removeAt(index);
    quantityList.removeAt(index);

    // dataList.removeLast();
    // dataList.remove(value);
    // }
    // print("Here removeField");
    update();
  }

  void addOperatingInstruction() {
    controllers.add(TextEditingController());
    operatingInstruction.add(TextEditingController());
    update(); // Call this to rebuild the UI if you're using a reactive state management library like GetX.
  }

  void removeOperatingInstruction() {
    if (operatingInstruction.isNotEmpty) {
      controllers.removeLast();
      operatingInstruction.removeLast();
      update(); // Call this to rebuild the UI.
    }
  }

  Future addFuel(context, id, purchaseAmount, litre, rate) async {
    var request = new http.MultipartRequest("POST",
        Uri.parse('${RemoteServices.baseUrl}api/v1/diesel-daily-purchase'));
    // print("request URL here $request");
    request.headers['Authorization'] = 'Bearer ${ApiClient.box.read('token')}';
    // print("TOKEN::${ApiClient.box.read('token')}");
    request.headers['Content-Type'] = 'application/json';
    request.headers['Accept'] = '*/*';
    request.fields['company'] = "${id.toString()}";
    request.fields['purchase_amt'] = '${purchasePrice.toString()}';
    request.fields['consumption'] = '${litre.toString()}';
    request.fields['rate'] = "${rate.toString()}";
    request.fields['location'] = "$locationId";
    request.fields['purchase_date'] = "$selectedDate";

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
              // print("statusCode : ${onValue.statusCode}");
              // print("body : ${onValue.body}");

              Map decoded = jsonDecode(onValue.body);
              if (decoded['status'] == true) {
                status = decoded['status'];
                msg = decoded['msg'];
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        CustomDialog(decoded['msg']));
                // print("Comapny ID::${decoded['msg']} id:::$companyId");
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

  checkReadingValidation(readingValidation) {
    machineReading =
        Validator.validateReading(readingValidation.toString(), "Reading");
    if (readingValidation == '') {
      // print("Here is the issue");
    } else {
      // print(" \n Else Here is the issue");
      machineReading = "";
    }
  }

  checkValidation() {
    desc = Validator.validateJobDescription(descController.text);
    if (desc == "Enter valid job description") {
      // print("Enter valid job description\n");
      // print("Enter valid job description\n");
      warningText = false;
    } else if (desc == "Enter job description") {
      // print("Enter valid job description\n");
      // print("Enter valid job description\n");
      warningText = false;
    } else if (desc == "") {
      warningText = true;
    }
    update();
  }

  List<PetroleumCompany> petroleum = [];
  List<Location> location = [];
  List<PurchaseDiesel> purchasePetrol = [];
  List maintenanceType = [];

  Future addMaintenanceSheet(vehicleId, jobID, context, isApproved) async {
    await addOpinion();
    Map map = {
      "vehicle_id": "$vehicleId",
      "job_id": "$jobID",
      'maintenance_type': selectedType == "others"
          ? reasonTextController.text.toString()
          : selectedType,
      'maintenance_notes': notesController.text.toString(),
      'maintenacne_desc': descController.text.toString(),
      'maintenance_reading': machineReadingController.text.toString(),
      'maintenance_location': locationController.text.toString(),
      // "openion": opinionList,
      "quantity": quantityList,
      "amount": amountList,
      "material_description": descriptionList,
      "maintenance_reason": instructionList,
      // request.fields['status'] = '$vehStatus';
      "status": "Awaiting Maintenance",
      "is_draft": 1,
      // "instruction": instructionList,
    };
    var getDetails =
        await RemoteServices.postMethodWithToken('api/v1/quotation-add', map);

    print("map :: ${jsonDecode(getDetails.body)}");
    if (getDetails.statusCode == 200) {
      print("here is the data uploaded successzfullu");
      final Map<String, dynamic> jsonResponse = json.decode(getDetails.body);
      // noHours=dailyReport["no_of_hours"]

      //

      // print(
      //    "here is the maintenance_id:: :: ${jsonResponse["maintenance_id"]}");
      await addImageReport(jsonResponse["maintenance_id"], context, isApproved);
      // print("here is the addImageReport:: ::");
    }
    // var request = new http.MultipartRequest(
    //     "POST", Uri.parse('${RemoteServices.baseUrl}api/v1/quotation-add'));
    // // print("request URL here $request");
    // request.headers['Authorization'] = 'Bearer ${ApiClient.box.read('token')}';
    // // print("TOKEN::${ApiClient.box.read('token')}");
    // request.headers['Content-Type'] = 'application/json';
    // request.headers['Accept'] = '*/*';
    //
    // map.forEach((key, value) {
    //   request.fields[key] = value;
    // });
    //
    // request.fields.forEach((key, value) {
    //   // print("$key: $value");
    // });
    // List<http.MultipartFile> files = [];
    // for (int i = 0; i < mediaFileList!.length; i++) {
    //   var f = await http.MultipartFile.fromPath(
    //       'reason_photo', mediaFileList![i].path);
    //   files.add(f);
    // }
    // request.files.addAll(files);
    // request.send().then(
    //   (response) {
    //     http.Response.fromStream(response).then(
    //       (onValue) {
    //         Navigator.pop(context);
    //         try {
    //           // print("statusCode : ${onValue.statusCode}");
    //           // print("body : ${onValue.body}");
    //
    //           Map decoded = jsonDecode(onValue.body);
    //           if (decoded['flag'] == 1) {
    //             msg = decoded['msg'];
    //             // Navigator.pop(context);
    //             showDialog(
    //                 context: context,
    //                 builder: (BuildContext context) =>
    //                     CustomDialog(decoded['msg']));
    //             Get.back();
    //             var jobsDetailsController = Get.put(JobsDetailsController());
    //             jobsDetailsController.getJobDetails("$jobID}");
    //             Get.to(JobsDetilasView(jobID));
    //             // print("JOBID::$jobID");
    //           } else {
    //             status = decoded['flag'];
    //             msg = decoded['msg'];
    //             showDialog(
    //                 context: context,
    //                 builder: (BuildContext context) =>
    //                     CustomDialog(decoded['msg']));
    //             Get.back();
    //             var jobsDetailsController = Get.put(JobsDetailsController());
    //             jobsDetailsController.getJobDetails("$jobID}");
    //
    //             Get.off(JobsDetilasView(jobID));
    //           }
    //           // get your response here...`
    //         } catch (e) {
    //           // handle exeption(e);
    //           // print(e);
    //         }
    //       },
    //     );
    //   },
    // );
  }

  // var statusNew;
  Future getMaintenanceDetails(vehicleId) async {
    status = false;
    try {
      // // print("HERE IS THE VALUE");
      Map map = {
        "vehicle_id": vehicleId,
      };
      // // print("map  == $map");
      var getDetails =
          await RemoteServices.postMethodWithToken('api/v1/job-sheet', map);
      // // print("${getDetails.body}");
      if (getDetails.statusCode == 200) {
        status = true;
        final Map<String, dynamic> jsonResponse =
            await json.decode(getDetails.body);
        maintenanceType = await jsonResponse['maintenance_type'];
        // var supervisor = await jsonResponse['daily_report'];
        // statusNew = await supervisor['is_draft'];
        // log('--------------------------isDraft :$statusNew');
        // // print("object::${dailyReport['maintenance_type']}");
        // maintenanceType = dailyReport['maintenance_type'];
        // // print("LENGTH :: ${maintenanceType.length}");
      } else {
        // checkUpdate();
        // // print("Exception");
      }
    } catch (e) {
      // print("catch  == $e");
      //   checkUpdate();
    }

    update();
  }

  Map<int, bool> transferStatuses = {};
  var msgTransfer = '';
  Future<void> transferVehicle(int siteId, List vehiclesId,
      {int isTransfer = 0}) async {
    msgTransfer = '';
    try {
      print("Sending transfer request with data:");
      Map<String, dynamic> requestData = {
        "site_id": siteId,
        "vehicles": vehiclesId,
        "transfer": isTransfer,
      };
      print("Request Data: $requestData");

      final response = await RemoteServices.postMethodWithToken(
        'api/v1/transfer',
        requestData,
      );
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var responseBody = await jsonDecode(response.body);
        log('if---------------');

        for (int vehicleId in vehiclesId) {
          //    transferStatuses[vehicleId] = true;
          toggleTransferStatus(vehicleId);
        }
        status = true;
        log('if---msg--$msg----------');

        if (responseBody['msg'] != null) {
          msgTransfer = await responseBody['msg'];
          log('if---in if statement --$msg----------');
        }
        log('if---await--$msg----------');

        print("Transfer successful!");
      } else {
        log('else---------------');
        for (int vehicleId in vehiclesId) {
          //transferStatuses[vehicleId] =
          // false;
          toggleTransferStatus(vehicleId);
        }

        print(
            "Error: Failed to transfer vehicles. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      for (int vehicleId in vehiclesId) {
        // transferStatuses[vehicleId] = false;
        toggleTransferStatus(vehicleId);
      }
      print("Error occurred during transfer: $e");
    }

    update();
  }

  void toggleTransferStatus(int vehicleId) {
    if (transferStatuses.containsKey(vehicleId)) {
      transferStatuses[vehicleId] = !transferStatuses[vehicleId]!;
    } else {
      transferStatuses[vehicleId] = true;
    }
    update(); // Notify listeners about changes
  }

  Future getFuel() async {
    try {
      //    pumpList.clear();
      var getDetails = await RemoteServices.fetchGetData('api/v1/petroleum');
      // print("ASD${getDetails.statusCode})");
      if (getDetails.statusCode == 200) {
        // print("Issue Here");
        var apiDetails = fuelModelFromJson(getDetails.body);
        // print("Issue Here");
        petroleum = apiDetails.petroleum;
        location = apiDetails.location;

        TotalUsedFuel =
            double.parse(apiDetails.totalUsedFuel!.toStringAsFixed(2));
        TotalPurchaseBalance =
            double.parse(apiDetails.totalPurchaseFuel!.toStringAsFixed(2));
        var temp1 = TotalPurchaseBalance - TotalUsedFuel;
        var temp = temp1.toStringAsFixed(2);
        // print("TotalUsedFuel=$TotalUsedFuel");
        // print("TotalPurchaseBalance=$TotalPurchaseBalance");
        // print("Remaining Fuel=$temp1");
        // print("Remaining Fuel=$temp");
        TotalRemainingFuel = double.parse(temp);
        // var TBalance=apiDetails.totalPurchaseFuel;
        // homeController.updateTotalBalance(double.parse(TBalance.toString()));
        // // print("HERE IS THE ${apiDetails.totalUsedFuel}");
        /* // print("asdasdasd ${getDetails.body}");
        // print("Asdjkahjsdh ${apiDetails.petroleum[0].id}");
        Set<String> uniqueCompanies = Set();

        for (int i = 0; i < apiDetails.petroleum.length; i++) {
          uniqueCompanies.add(apiDetails.petroleum[i].company.toString());
        }

        // Add unique values back to pumpList
        pumpList.addAll(uniqueCompanies.toList());*/
      } else {
        // print("HERE:::");
      }
    } catch (e) {
      // print("this:is the ::$e.");
    }

    update();
  }

  List<Map<dynamic, dynamic>> previousDataList =
      []; // To store all submitted data

  Future addMaintenanceReport(int maintenanceId, context, isApproved) async {
    await addOpinion();
    try {
      Map map = {
        "maintenance_id": maintenanceId,
        "openion": opinionList,
        "quantity": quantityList,
        "amount": amountList,
        "material_description": descriptionList,
        "observation": observationList,
        "instruction": instructionList,
        "images": "0",
      };
      // print("map :: ${jsonEncode(map)}");
      // print("token :: ${ApiClient.box.read('token')}");
      var getDetails = await RemoteServices.postMethodWithToken(
          'api/v1/maintenance-details', map);

      // print("map :: ${jsonDecode(getDetails.body)}");
      if (getDetails.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(getDetails.body);
        previousDataList.add(map);
        // print("map adding");

        // print(previousDataList.length);
        // print("HERE REPORT::$jsonResponse");
        var message = "";
        message = jsonResponse['msg'];
        // print("Here is the resopnse:: $message");

        await addImageReport(maintenanceId, context, isApproved);
        // addReport(maintenanceId,context);

        // final Map<String, dynamic> jsonResponse = json.decode(getDetails.body);
        // final Map<String, dynamic> dailyReport = jsonResponse['msg'];
        // // print("$dailyReport");
      } else {
        // print("Errror Here");
      }
    } catch (e) {
      // print("Here ius the exception $e");
    }
    update();
  }

  Future removeMaintenanceimg(int index) async {
    try {
      Map map = {
        "maintenance_image_id": index,
      };

      var getDetails = await RemoteServices.postMethodWithToken(
          'api/v1/remove-maintenance-image', map);
      // print("in api");
      // print("map :: ${jsonDecode(getDetails.body)}");
      if (getDetails.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(getDetails.body);

        // print("HERE REPORT::$jsonResponse");
        var message = "";
        message = jsonResponse['msg'];
        // print("Here is the resopnse:: $message");
      } else {
        // print("Errror Here");
      }
    } catch (e) {
      // print("Here ius the exception $e");
    }
    update();
  }

  Future removeQuotationMaintenanceimg(int index) async {
    log("Delte img ------------------------------------------");
    try {
      Map map = {
        "quotation_image_id": index,
      };

      var getDetails = await RemoteServices.postMethodWithToken(
          'api/v1/remove-quotation-image', map);
      // print("in api");
      // print("map :: ${jsonDecode(getDetails.body)}");
      if (getDetails.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(getDetails.body);

        // print("HERE REPORT::$jsonResponse");
        var message = "";
        message = jsonResponse['msg'];
        // print("Here is the resopnse:: $message");
      } else {
        // print("Errror Here");
      }
    } catch (e) {
      // print("Here ius the exception $e");
    }
    update();
  }

  Future addImageReport(maintenanceId, context, isApproved) async {
    try {
      var request;
      if (isApproved) {
        request = new http.MultipartRequest("POST",
            Uri.parse('${RemoteServices.baseUrl}api/v1/maintenance-details'));
      } else {
        request = new http.MultipartRequest(
            "POST", Uri.parse('${RemoteServices.baseUrl}api/v1/quotation-add'));
      }

      // print("request URL here $request");
      request.headers['Authorization'] =
          'Bearer ${ApiClient.box.read('token')}';
      // print("TOKEN::${ApiClient.box.read('token')}");
      request.fields['images'] = "1";
      request.headers['Content-Type'] = 'application/json';
      request.headers['Authorization'] =
          'Bearer ${ApiClient.box.read('token')}';
      request.headers['Accept'] = '*/*';

      request.fields['maintenance_id'] = "$maintenanceId";
      // request.fields['vehicle_id'] = "$vehicleId";
      // request.fields['images'] = "1";
      List<http.MultipartFile> files = [];
      // print("LENGTH ::${mediaFileList!.length}");
      for (int i = 0; i < mediaFileList!.length; i++) {
        //File file in mediaFileList){

        if (isApproved) {
          var f = await http.MultipartFile.fromPath(
              'maintenance_photo[]', mediaFileList![i].path);
          files.add(f);
          // print("HERE :::${mediaFileList![i].path}");
        } else {
          var f = await http.MultipartFile.fromPath(
              'reason_photo[]', mediaFileList![i].path);
          files.add(f);
          // print("HERE :::${mediaFileList![i].path}");
        }
      }
      // print("${files}");
      request.files.addAll(files);
      request.send().then((response) {
        http.Response.fromStream(response).then((onValue) {
          Navigator.pop(context);
          Navigator.pop(context);
          try {
            // print("statusCode : ${onValue.statusCode}");
            // print("body : ${onValue.body}");
            Map decoded = jsonDecode(onValue.body);
            if (decoded['status']) {
              status = decoded['status'];
              msg = decoded['msg'];
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      CustomDialog("Maintenance details added successfully"));
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
            // handle exeption
            // print("${e}");
          }
        });
      });
    } catch (e) {
      // print("Exception Here :$e");
    }
    update();
  }

  List<MaintenanceQuotation>? maintenanceVehicleList = [];
  var vehicleMaintenancedata;
  List observationListdata = [];
  List operatingInstruction =
      []; // use instructionList instead of operatingInstruction
  List materialDescription = [];
  List maintenancePhoto = [];

  Future getVehicleMaintenance(bool flag, id, bool isSupervisor) async {
    try {
      //    pumpList.clear();
      Map map;
      if (isSupervisor) {
        map = {"vehicle_id": id};
      } else {
        map = {"maintenance_id": id};
      }
      if (flag) {
        // // print("Abcd");
        var getDetails =
            await RemoteServices.postMethodWithToken('api/v1/maintenance', map);
        Map decoded = jsonDecode(getDetails.body);
        if (getDetails.statusCode == 200) {
          // // print("@@@@@@@@@@@aaaaaa");
          log("${getDetails.body}");

          vehicleMaintenancedata = decoded['vehicle_maintenence'];
          observationListdata =
              await vehicleMaintenancedata['observation'] ?? [];
          operatingInstruction = await vehicleMaintenancedata['instruction'];
          // instructionList = await vehicleMaintenancedata['instruction'];
          materialDescription =
              await vehicleMaintenancedata['material_description'] ?? [];
          maintenancePhoto =
              await vehicleMaintenancedata['maintenance_photo'] ?? [];

          // // print("Maintenance ID: ${vehicleMaintenancedata['id']}");
          // // print("Vehicle ID: ${vehicleMaintenancedata['vehicle_id']}");
          // // print(
          //     "Maintenance Type: ${vehicleMaintenancedata['material_description']}");
          // // print("Description: ${vehicleMaintenancedata['description']}");
          // // print(
          //     "Maintenance photo: ${vehicleMaintenancedata['maintenance_photo']}");

          // // // print(
          // //     "Observation: ${vehicleMaintenancedata['observation'][0]['observation']}");
          // // print(observationListdata.length);
          // // print("Obs lengt *********h+ ${observationListdata.length}");
          // // print(
          //     "operatingins lengt *********h+ ${operatingInstruction.length}");
          // // print("operatingins lengt *********h+ ${operatingInstruction}");
          // // print("instruction lengt *********h+ ${instructionList.length}");

          // // print("material lengt *********h+ ${materialDescription.length}");
          // // print("Maintenance photo: ${maintenancePhoto.length}");
          // // // print(
          // //     "material desc *********h+                       ${materialDescription[0]['material_description']}");

          // // print("${getDetails.body}");
        }
      } else {
        // // print("HEREEEEE");
        Map map = {"maintenance_id": id};
        var getDetails =
            await RemoteServices.postMethodWithToken('api/v1/maintenance', map);
        // // print("ASD ${getDetails.statusCode})");
        if (getDetails.statusCode == 200) {
          Map decoded = jsonDecode(getDetails.body);

          vehicleMaintenancedata = decoded['vehicle_maintenence'];
          observationListdata =
              await vehicleMaintenancedata['observation'] ?? [];
          operatingInstruction =
              await vehicleMaintenancedata['instruction'] ?? [];
          materialDescription =
              await vehicleMaintenancedata['material_description'] ?? [];
          maintenancePhoto =
              await vehicleMaintenancedata['maintenance_photo'] ?? [];
          // // print("Obs lengt *********h+ ${observationListdata.length}");

          // // print("Maintenance ID: ${vehicleMaintenancedata['id']}");
          // // print("Vehicle ID: ${vehicleMaintenancedata['vehicle_id']}");
          // // print(
          //     "Maintenance Type: ${vehicleMaintenancedata['maintenance_type']}");
          // // print("Description: ${vehicleMaintenancedata['description']}");

          // // print("${getDetails.body}");

          // printInfo(info: "object \n\n ${getDetails.body}");
          var apiDetails = vehicleMaintenanceModelFromJson(getDetails.body);
          // // print("Succesfully Called");

          // // print(
          // "Here as per vehicle ${apiDetails.vehicleMaintenence![0].vehicleDetails!.vehicleNo}");
          vehicleMaintenance = apiDetails.vehicleMaintenence!;
          // filteredVehicleMaintenance = vehicleMaintenance;
          //// print("Succesfully Called");
        } else {
          // // print("HERE:::");
        }
      }
    } catch (e) {
      // print("this:is the ::$e.");
    }

    update();
  }

  var selectedTypedata,
      notesControllerData,
      descControllerData,
      machineReadingControllerData,
      locationControllerData,
      maintenanceId;

  var maintenanceSupervisor = 0;

  List quotationMaterialDescription = [];
  List maintenanceReason = [];
  List maintenanceReasonPhoto = [];
  var totalAmountMaintenance;
  List<VehicleMaintenence> vehicleMaintenanceDetails = [];
  MaintenanceVehicle? vehicleMaintenanceDetail;
  static bool statusData1 = false;
  static bool statusData2 = false;
  var vehicleDetailsData;
  var statusApprove;
  Future getVehicleMaintenanceList(bool flag, id, bool isSupervisor) async {
    try {
      print("IFFFFFFFF");

      Map map;
      if (isSupervisor) {
        map = {"vehicle_id": id};
      } else {
        map = {"maintenance_id": id};
      }
      print("8888888888SingleObjjj888888888888$map");

      if (flag) {
        print("8888888888SingleObjjj888888888888");
        var getDetails = await RemoteServices.postMethodWithToken(
            'api/v1/get-maintenance-quotation', map);

        if (getDetails.statusCode == 200) {
          var apiDetails = vehicleMaintainceModelFromJson(getDetails.body);
          // print("Succesfully Called");
          vehicleDetailsData =
              await apiDetails.maintenanceQuotation!.vehicleDetails!;
          // print(apiDetails.maintenanceQuotation!.vehicleDetails!.vehicleNo);

          Map<String, dynamic> decoded = jsonDecode(getDetails.body);

          Map<String, dynamic> addData = await decoded['maintenance_quotation'];
          log("---------------vehicleDetailsData  -----data----------------${vehicleDetailsData}");
          selectedTypedata = await addData["maintenance_type"];
          maintenanceSupervisor = await addData['maintenance_supervisor'] ?? 0;
          maintenanceId = addData['id'];
          log('---------------aaaaaaaaaaaaaaaaaa----------------${maintenanceSupervisor}');
          updateType(selectedTypedata);
          notesControllerData = await addData["notes"];
          descControllerData = await addData["description"];
          machineReadingControllerData = await addData["reading"];
          locationControllerData = await addData["location"];
          quotationMaterialDescription = await addData['quotation_material'];
          maintenanceReason = await addData['maintenance_reason'];
          maintenanceReasonPhoto = await addData['maintenance_reason_photo'];
          statusApprove = await addData['status'];
          print("Maintenance Type: $selectedTypedata");
          print("Notes: $notesControllerData");
          print("Description: $descControllerData");
          print("Machine Reading: $machineReadingControllerData");
          print("Location: $locationControllerData");
          print("quotationMaterialDescription: $quotationMaterialDescription");
          print("maintenanceReason: $maintenanceReason");
          log("statsuss: $statusApprove");

          if (decoded['status'] == 1) {
            // print("Navigating to Approve page...");
            statusData1 = false;
          } else if (decoded['status'] == 0) {
            statusData1 = true;
          }

          vehicleMaintenanceDetail = await apiDetails.maintenanceQuotation;

          if (apiDetails.maintenanceQuotation != null) {
            // print(
            //  "Here as per vehicle ${apiDetails.maintenanceQuotation!.maintenanceReason}");
            // vehicleMaintenance = apiDetails.vehicleMaintenence!;
            // filteredVehicleMaintenance = vehicleMaintenance;
            // print("Succesfully Called");

            totalAmountMaintenance = getTotalAmountMaintenance(
                vehicleMaintenanceDetail!.quotationMaterial!);
            // print("here is the total Amount ${totalAmountMaintenance}");
          } else {
            vehicleMaintenanceDetail = null;
          }
        } else {
          vehicleMaintenanceDetail = null;
        }
      } else {
        print("22222222Listttttttttttt2222222222");
        Map map = {"maintenance_id": 0};
        var getDetails = await RemoteServices.postMethodWithToken(
            'api/v1/get-maintenance-quotation', map);
        // print("ASD ${getDetails.statusCode})");

        if (getDetails.statusCode == 200) {
          printInfo(info: "object \n\n ${getDetails.body}");
          var apiDetails = vehicleMaintainceListModelFromJson(getDetails.body);

          Map<String, dynamic> decoded = await jsonDecode(getDetails.body);

          // print("Succesfully Called");
          if (decoded['status'] == 1) {
            // print("Navigating to Approve page...");
            statusData2 = false;
          } else if (decoded['status'] == 0) {
            statusData2 = true;
          }

          if (apiDetails.maintenanceQuotation!.isNotEmpty) {
            maintenanceVehicleList = apiDetails.maintenanceQuotation;
            filteredVehicleMaintenance = apiDetails.maintenanceQuotation;
            // print(
            // "Here mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm::${maintenanceSupervisor}");
            // print(
            //   "Here vehicle No::${apiDetails.maintenanceQuotation![0].vehicleDetails!.vehicleNo}");
            // print("Here vehicle No::${maintenanceVehicleList!.length}");
          }
          // print("Succesfully Called");
        } else {
          // print("HERE:::");
        }
      }
    } catch (e) {
      vehicleMaintenanceDetail = null;
      // print("this:is the ::$e.");
    }

    update();
  }

  getTotalAmountMaintenance(List<QuotationMaterial> list) {
    double totalAmount = 00.0;
    for (int i = 0; i < list.length; i++) {
      totalAmount = totalAmount + double.parse(list![i].amount!);
    }
    return totalAmount;
  }

  cleanData() {
    fuelBalance = 00.0;
    purchasePrice = 00.0;
    petroleum.clear();
    desc = "";
    selectedType = "Select Type";
    selectedAssignJob = "Select Person";
    selectedType = "Select Type";
    selectedAssignJob = "Select location";
    litreDouble = 0;
    warningText = false;
    monitoringImg = '';
    image = null;
    selectedDate = "";
    selectDate = "Pick Date";
    fuelTotalBalance = 0.0;
    maintenanceType.clear();
    locationController.clear();
    textFieldValues.clear();
    descriptionController.clear();
    quantityController.clear();
    reasonTextController.clear();
    amountController.clear();
    descController.clear();
    notesController.clear();
    rateDouble = 0;
    dataList.clear();
    opinionList.clear();
    opinionTextControllers.clear();
    controllers.clear();
    imageList = 0;
    update();
  }

  Future approveMaintaince(maintenanceId) async {
    Map map = {"maintenance_id": maintenanceId};
    var getDetails = await RemoteServices.fetchGetData(
        'api/v1/approve-maintenance?maintenance_id=${maintenanceId}');

    // print("map :: ${jsonDecode(getDetails.body)}");
    if (getDetails.statusCode == 200) {
      // print("here is the approved maintaince id");
    }
    update();
  }

  List<MaintenenceSupervisorGet> getMaintenanceSuperList = [];

  var getSelectedSupervisor;

  Future getMaintainceSupervisor() async {
    Map map = {};
    var getDetails =
        await RemoteServices.fetchGetData('api/v1/get-maintenancesupervisor');

    if (getDetails.statusCode == 200) {
      Map<String, dynamic> decoded = jsonDecode(getDetails.body);
      // print("Fetched Maintenance Supervisors: $decoded");

      getMaintenanceSuperList = (decoded['data'] as List)
          .map((item) => MaintenenceSupervisorGet.fromJson(item))
          .toList();

      // print("Fetched Maintenance Supervisors: $getMaintenanceSuperList");
    } else {
      // print("Error: ${getDetails.statusCode}");
    }
    update();
  }

  var msgData;
  Future assignMaintainceSupervisor(
    maintenanceId,
    supervisorId,
  ) async {
    try {
      // print("HERE IS THE VALUE");
      Map map = {
        "maintenance_id": maintenanceId,
        "supervisor_id": supervisorId
      };

      print("map  == $map");
      var getDetails = await RemoteServices.postMethodWithToken(
          'api/v1/assign-maintenancesupervisor', map);
      print("${getDetails.body}");
      if (getDetails.statusCode == 200) {
        status = true;
        final Map<String, dynamic> jsonResponse =
            await json.decode(getDetails.body);

        var response = await jsonResponse['status'];
        if (response) {
          msgData = await jsonResponse['msg'];
          log('-------------------$msgData');
        }
      } else {
        // checkUpdate();
        // print("Exception");
      }
    } catch (e) {
      // print("catch  == $e");
      //   checkUpdate();
    }

    update();
  }

  bool skills = false;

  @override
  void onInit() {
    super.onInit();
    controllers.add(TextEditingController());

    getVehicleMaintenanceList(false, 0, false);
  }
}
