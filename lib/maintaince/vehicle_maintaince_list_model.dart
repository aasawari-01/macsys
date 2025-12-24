// To parse this JSON data, do
//
//     final vehicleMaintainceListModel = vehicleMaintainceListModelFromJson(jsonString);

import 'dart:convert';

VehicleMaintainceListModel vehicleMaintainceListModelFromJson(String str) =>
    VehicleMaintainceListModel.fromJson(json.decode(str));

String vehicleMaintainceListModelToJson(VehicleMaintainceListModel data) =>
    json.encode(data.toJson());

class VehicleMaintainceListModel {
  bool? status;
  String? msg;
  List<MaintenanceQuotation>? maintenanceQuotation;
  int? completedMaintenance;

  VehicleMaintainceListModel({
    this.status,
    this.msg,
    this.maintenanceQuotation,
    this.completedMaintenance,
  });

  factory VehicleMaintainceListModel.fromJson(Map<String, dynamic> json) =>
      VehicleMaintainceListModel(
        status: json["status"],
        msg: json["msg"],
        maintenanceQuotation: json["maintenance_quotation"] == null
            ? []
            : List<MaintenanceQuotation>.from(json["maintenance_quotation"]!
                .map((x) => MaintenanceQuotation.fromJson(x))),
        completedMaintenance: json["completed_maintenance"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "maintenance_quotation": maintenanceQuotation == null
            ? []
            : List<dynamic>.from(maintenanceQuotation!.map((x) => x.toJson())),
        "completed_maintenance": completedMaintenance,
      };
}

class MaintenanceQuotation {
  int? id;
  int? profitCenter;
  int? vehicleId;
  int? maintenanceSupervisor;
  int? jobAssign;
  AssignTo? assignTo;

  String? maintenanceType;
  String? notes;
  int? status;
  String? reading;
  String? location;
  String? description;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  VehicleDetails? vehicleDetails;

  MaintenanceQuotation({
    this.id,
    this.profitCenter,
    this.vehicleId,
    this.maintenanceSupervisor,
    this.jobAssign,
    this.assignTo,
    this.maintenanceType,
    this.notes,
    this.status,
    this.reading,
    this.location,
    this.description,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.vehicleDetails,
  });

  factory MaintenanceQuotation.fromJson(Map<String, dynamic> json) =>
      MaintenanceQuotation(
        id: json["id"],
        profitCenter: json["profit_center"],
        vehicleId: json["vehicle_id"],
        maintenanceSupervisor: json["maintenance_supervisor"],
        jobAssign: json["job_assign"],
        assignTo: json["assignto"] == null
            ? null
            : AssignTo.fromJson(json["assignto"]),
        maintenanceType: json["maintenance_type"],
        notes: json["notes"],
        status: json["status"],
        reading: json["reading"],
        location: json["location"],
        description: json["description"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        vehicleDetails: json["vehicle_details"] == null
            ? null
            : VehicleDetails.fromJson(json["vehicle_details"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profit_center": profitCenter,
        "vehicle_id": vehicleId,
        "maintenance_supervisor": maintenanceSupervisor,
        "job_assign": jobAssign,
        "assignto": assignTo?.toJson(),
        "maintenance_type": maintenanceType,
        "notes": notes,
        "status": status,
        "reading": reading,
        "location": location,
        "description": description,
        "deleted_at": deletedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "vehicle_details": vehicleDetails?.toJson(),
      };
}

class AssignTo {
  final int id;
  String? fullName;
  String? crewMobile;

  AssignTo({
    required this.id,
    this.fullName,
    this.crewMobile,
  });

  // Factory constructor to create an instance from a JSON map
  factory AssignTo.fromJson(Map<String, dynamic> json) {
    return AssignTo(
      id: json['id'],
      fullName: json['full_name'] ?? '',
      crewMobile: json['crew_mobile'] ?? '',
    );
  }

  // Convert the instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'crew_mobile': crewMobile,
    };
  }
}

class VehicleDetails {
  int? id;
  String? type;
  String? makeType;
  String? modelName;
  String? vehicleNo;
  String? vehicleTypeName;
  String? status;
  String? vehiclePhoto;
  int? vehicleType;
  int? profitCenter;

  VehicleDetails({
    this.id,
    this.type,
    this.makeType,
    this.modelName,
    this.vehicleNo,
    this.vehicleTypeName,
    this.status,
    this.vehiclePhoto,
    this.vehicleType,
    this.profitCenter,
  });

  factory VehicleDetails.fromJson(Map<String, dynamic> json) => VehicleDetails(
        id: json["id"],
        type: json["type"],
        makeType: json["make_type"],
        modelName: json["model_name"],
        vehicleNo: json["vehicle_no"],
        vehicleTypeName: json["vehicle_type_name"],
        status: json["status"],
        vehiclePhoto: json["vehicle_photo"],
        vehicleType: json["vehicle_type"],
        profitCenter: json["profit_center"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "make_type": makeType,
        "model_name": modelName,
        "vehicle_no": vehicleNo,
        "vehicle_type_name": vehicleTypeName,
        "status": status,
        "vehicle_photo": vehiclePhoto,
        "vehicle_type": vehicleType,
        "profit_center": profitCenter,
      };
}
