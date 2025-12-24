import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:macsys/component/job_details/job_details_controller.dart';
import 'package:remixicon/remixicon.dart';

import '../../services/remote_services.dart';
import '../../util/ApiClient.dart';
import '../../util/CustomLoading.dart';
import '../../util/SizeConfig.dart';
import '../custom_widget/colorsC.dart';
import '../custom_widget/cust_text.dart';
import '../custom_widget/cust_text_start.dart';
import '../daily_job_sheet/daily_job_sheet_controller.dart';

class FilledJobsDetilasView  extends StatelessWidget {

  var truckPlantUnitNo,vehicleImage;
  FilledJobsDetilasView(truckPlantUnitNo,vehicleImage){
    this.truckPlantUnitNo = truckPlantUnitNo;
    this.vehicleImage = vehicleImage;
  }
  var jobsDetailsController = Get.put(JobsDetailsController());
  var DJSController =
  Get.put(DailyJobSheetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrimaryDark,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
            child: Icon(Remix.arrow_left_line,size: 6 * SizeConfig.imageSizeMultiplier,color: Colors.white,)),
        title:  CustText(name: "$truckPlantUnitNo Filled Details",size: 2.2,colors:Colors.white,fontWeightName:FontWeight.w600),
      ),
      body: Stack(
        children: [
          Container(
            height: 100 * SizeConfig.heightMultiplier,
            width: 100 * SizeConfig.widthMultiplier,
            child: Image.asset(
              'assets/icons/ic_home.png',fit: BoxFit.fitHeight,
            ),
          ),
          Container(
            height: 100 * SizeConfig.heightMultiplier,
            width: 100 * SizeConfig.widthMultiplier,
            color: Colors.white.withOpacity(0.9),
            child: GetBuilder<JobsDetailsController>(
              init: JobsDetailsController(),
              builder: (controller) => /* jobsDetailsController.fStatus == 1 ?*/SingleChildScrollView(
                child: Padding(
                  padding:  EdgeInsets.all(2 * SizeConfig.widthMultiplier),
                  child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 1 * SizeConfig.heightMultiplier),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: 90 * SizeConfig.widthMultiplier,
                              child: CustTextStart(name: "Today's you have already filled jon details",size: 2,colors:colorPrimary,fontWeightName:FontWeight.w600)),


                        ],),
                      SizedBox(height: 1 * SizeConfig.heightMultiplier),
                      Center(
                        child: Container(
                          height: 25 * SizeConfig.heightMultiplier,
                          width: 60 * SizeConfig.widthMultiplier,
                          // color: Colors.red,
                          child: vehicleImage==null?Image.asset('assets/icons/no_image_found.jpg'):Image.network(vehicleImage),
                        ),
                      ),

                      DJSController.vehStatus == "In Working"?Container():
                      Center(
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width:
                                    2,
                                    style: BorderStyle
                                        .solid,
                                    color:
                                    colorPrimary),
                                borderRadius:
                                BorderRadius.all(Radius.circular(
                                    5))),
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                SizeConfig.widthMultiplier *
                                    2.2,
                                vertical: SizeConfig.heightMultiplier *
                                    0.2),
                            child:DJSController.vehStatus == "Idle"?CustTextStart(
                                name: "Machine is Idle",
                                size: 2.0,
                                colors: colorPrimary,
                                fontWeightName: FontWeight.w500):CustTextStart(
                                name: "Machine is Under Maintenance",
                                size: 1.7,
                                colors: colorPrimary,
                                fontWeightName: FontWeight.w500)),
                      ),

                      SizedBox(
                        width: 2 *
                            SizeConfig
                                .widthMultiplier,
                      ),
                      SizedBox(height: 1 * SizeConfig.heightMultiplier),
                      showDetails("Vehicle No:","${jobsDetailsController.VehicleNo}"),
                      SizedBox(height: 1 * SizeConfig.heightMultiplier),

                      // showDetails("Job Time and Date","${ApiClient.convertTime(jobsDetailsController.dailyJob[0].createdDate.toString())}   ${ApiClient.convertDate(jobsDetailsController.dailyJob[0].createdDate.toString())}"),
                      // SizedBox(height: 1 * SizeConfig.heightMultiplier),
                      showDetails("No. of Hours","${jobsDetailsController.noHours} Hours"),
                      SizedBox(height: 1 * SizeConfig.heightMultiplier),
                      showDetails("No. of Minutes","${jobsDetailsController.noMin} Minutes"),
                      SizedBox(height: 1 * SizeConfig.heightMultiplier),
                      showDetails("Reading","${jobsDetailsController.reading}"),
                      // SizedBox(height: 1 * SizeConfig.heightMultiplier),
                      // showDetails("Fuel Consumption","${jobsDetailsController.dailyJob[0].fuelConsumption}"),
                      SizedBox(height: 1 * SizeConfig.heightMultiplier),
                      showDetails("Urea","${jobsDetailsController.urea}"),

                      SizedBox(height: 1 * SizeConfig.heightMultiplier),
                      showDetails("Reading In","${jobsDetailsController.readingIn}"),

                      SizedBox(height: 1 * SizeConfig.heightMultiplier),
                      Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: 42 * SizeConfig.widthMultiplier,
                              child: CustTextStart(name: "Reading Image",size: 1.6,colors:Colors.black87,fontWeightName:FontWeight.w600)),
                          CustText(name: ":  ",size: 1.8,colors:Colors.black87,fontWeightName:FontWeight.w400),
                          jobsDetailsController.imageLink != null?Container(
                            height: 10 * SizeConfig.widthMultiplier,
                            width: 10 * SizeConfig.widthMultiplier,
                            // color: Colors.red,
                            // child: Image.network("${jobsDetailsController.dailyJob[0].monitoringImg}"),
                            child: Image.network("${RemoteServices.baseUrl + jobsDetailsController.imageLink}"),
                          ):CustTextStart(name: "Not Uploaded",size: 1.6,colors:Colors.black87,fontWeightName:FontWeight.w600),
                        ],),

                      SizedBox(height: 1 * SizeConfig.heightMultiplier),
                      // showDetails("Site Address","${jobsDetailsController.jobDetailsResult[0].siteAddress}"),

                      SizedBox(height: 1 * SizeConfig.heightMultiplier),
                      showDetails("Job Description","${jobsDetailsController.jobDesc}"),

                    ],
                  ),
                ),
              )
                 /* :Container(child: CustomLoading()),*/
            ),
          ),

        ],
      ),
    );
  }
  showDetails(title,details){
    return Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            width: 42 * SizeConfig.widthMultiplier,
            child: CustTextStart(name: title,size: 1.6,colors:Colors.black87,fontWeightName:FontWeight.w600)),
        CustText(name: ":  ",size: 1.8,colors:Colors.black87,fontWeightName:FontWeight.w400),
        Container(width: 48 * SizeConfig.widthMultiplier,
            child: CustTextStart(name: details,size: 1.8,colors:Colors.black87,fontWeightName:FontWeight.w400)),
      ],);
  }

}
