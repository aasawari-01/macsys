import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:macsys/component/custom_widget/colorsC.dart';

import 'add_maintaince_vehicle.dart';
import 'maintaince_controller.dart';
import 'show_maintance_sheet_view.dart';

class MaintenanceViewSupervisor extends StatefulWidget {
  var vehicleDetails;

  MaintenanceViewSupervisor(this.vehicleDetails);

  @override
  _MaintenanceViewSupervisorState createState() =>
      _MaintenanceViewSupervisorState();
}

class _MaintenanceViewSupervisorState extends State<MaintenanceViewSupervisor>
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
                    ShowMaintenanceSheet(widget.vehicleDetails),
                    AddMaintenanceSheet(widget.vehicleDetails),
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
