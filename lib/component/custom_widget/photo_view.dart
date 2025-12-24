import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

import '../../services/remote_services.dart';
import '../../util/SizeConfig.dart';
import '../daily_job_sheet/daily_job_sheet_controller.dart';
import 'colorsC.dart';
import 'cust_text_start.dart';

class PhotoView extends StatelessWidget {
  var photoLink;
  bool flag;

  PhotoView({
    required this.photoLink,
    required this.flag,
  });

  var DJSController = Get.put(DailyJobSheetController());

  @override
  Widget build(BuildContext context) {
    print("photoLink  :: $photoLink");
    return Dialog(
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(3 * SizeConfig.widthMultiplier),
        ),
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(1 * SizeConfig.widthMultiplier),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 12.5 * SizeConfig.widthMultiplier,
                          width: 10 * SizeConfig.widthMultiplier,
                          child: Icon(Remix.close_circle_line,
                              size: 7 * SizeConfig.imageSizeMultiplier,
                              color: colorPrimary),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // print("BASEEE ${RemoteServices.baseUrlIMG}${photoLink[selectedIndex]}");
                      },
                      child: InteractiveViewer(
                        child: Container(
                            height: 40 * SizeConfig.heightMultiplier,
                            width: 80 * SizeConfig.widthMultiplier,
                            padding: EdgeInsets.all(
                              1 * SizeConfig.heightMultiplier,
                            ),
                            margin: EdgeInsets.all(
                              1 * SizeConfig.heightMultiplier,
                            ),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(
                                    3 * SizeConfig.widthMultiplier),
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                        '${RemoteServices.baseUrl}${photoLink}'))),
                            child: flag
                                ? Image.file(
                                    DJSController.image!,
                                    fit: BoxFit.fitHeight,
                                  )
                                : DJSController.monitoringImg != ""
                                    ? Image.network(
                                        '${RemoteServices.baseUrl + DJSController.monitoringImg}',
                                        fit: BoxFit.cover,
                                      )
                                    : Container()),
                      ),
                    ),
                    SizedBox(height: 1 * SizeConfig.heightMultiplier),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
