import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:macsys/component/custom_widget/colorsC.dart';
import 'package:macsys/maintaince/add_maintenanceshett_pandm.dart';
import 'package:macsys/maintaince/show_maintenancesheet_pandm.dart';

import 'add_maintaince_vehicle.dart';
import 'maintaince_controller.dart';
import 'show_maintance_sheet_view.dart';

// ignore: must_be_immutable
class MaintenanceViewpandm extends StatefulWidget {
  var mainQ;
  MaintenanceViewpandm(this.mainQ);

  @override
  _MaintenanceViewpandmState createState() => _MaintenanceViewpandmState();
}

class _MaintenanceViewpandmState extends State<MaintenanceViewpandm>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final controller = Get.put(MaintenanceController());
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        controller.changeTab(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorPrimary,
      child: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Material(
                color: colorPrimary, // Optional for styling
                child: TabBar(
                  unselectedLabelColor: Colors.white,
                  controller: _tabController,
                  tabs: [
                    Tab(text: 'Quotation'),
                    Tab(text: 'Maintenance Progress'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    ShowMaintenanceSheetpandm(widget.mainQ.id),
                    AddMainternaceSheetpandm(widget.mainQ.id),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
