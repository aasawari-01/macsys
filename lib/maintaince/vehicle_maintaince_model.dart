// To parse this JSON data, do
//
//     final vehicleMaintainceListModel = vehicleMaintainceListModelFromJson(jsonString);

import 'dart:convert';

VehicleMaintainceListModel vehicleMaintainceModelFromJson(String str) =>
    VehicleMaintainceListModel.fromJson(json.decode(str));

String vehicleMaintainceModelToJson(VehicleMaintainceListModel data) =>
    json.encode(data.toJson());

class VehicleMaintainceListModel {
  bool? status;
  String? msg;
  MaintenanceVehicle? maintenanceQuotation;
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
            ? null
            : MaintenanceVehicle.fromJson(json["maintenance_quotation"]),
        completedMaintenance: json["completed_maintenance"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "maintenance_quotation": maintenanceQuotation?.toJson(),
        "completed_maintenance": completedMaintenance,
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

class MaintenanceVehicle {
  int? id;
  int? profitCenter;
  int? vehicleId;
  int? maintenanceSupervisor;
  int? jobAssign;
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
  List<dynamic>? maintenanceDetails;
  JobsAssign? jobsAssign;
  List<QuotationMaterial>? quotationMaterial;
  List<MaintenanceReason>? maintenanceReason;
  List<MaintenanceReason>? maintenanceReasonPhoto;
  AssignTo? assignTo;

  MaintenanceVehicle({
    this.id,
    this.profitCenter,
    this.vehicleId,
    this.maintenanceSupervisor,
    this.jobAssign,
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
    this.maintenanceDetails,
    this.jobsAssign,
    this.quotationMaterial,
    this.maintenanceReason,
    this.maintenanceReasonPhoto,
    this.assignTo,
  });

  factory MaintenanceVehicle.fromJson(Map<String, dynamic> json) =>
      MaintenanceVehicle(
        id: json["id"],
        profitCenter: json["profit_center"],
        vehicleId: json["vehicle_id"],
        maintenanceSupervisor: json["maintenance_supervisor"],
        jobAssign: json["job_assign"],
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
        maintenanceDetails: json["maintenance_details"] == null
            ? []
            : List<dynamic>.from(json["maintenance_details"]!.map((x) => x)),
        jobsAssign: json["jobs_assign"] == null
            ? null
            : JobsAssign.fromJson(json["jobs_assign"]),
        quotationMaterial: json["quotation_material"] == null
            ? []
            : List<QuotationMaterial>.from(json["quotation_material"]!
                .map((x) => QuotationMaterial.fromJson(x))),
        maintenanceReason: json["maintenance_reason"] == null
            ? []
            : List<MaintenanceReason>.from(json["maintenance_reason"]!
                .map((x) => MaintenanceReason.fromJson(x))),
        maintenanceReasonPhoto: json["maintenance_reason_photo"] == null
            ? []
            : List<MaintenanceReason>.from(json["maintenance_reason_photo"]!
                .map((x) => MaintenanceReason.fromJson(x))),
        assignTo: json["assignto"] == null
            ? null
            : AssignTo.fromJson(json["assignto"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profit_center": profitCenter,
        "vehicle_id": vehicleId,
        "maintenance_supervisor": maintenanceSupervisor,
        "job_assign": jobAssign,
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
        "maintenance_details": maintenanceDetails == null
            ? []
            : List<dynamic>.from(maintenanceDetails!.map((x) => x)),
        "jobs_assign": jobsAssign?.toJson(),
        "quotation_material": quotationMaterial == null
            ? []
            : List<dynamic>.from(quotationMaterial!.map((x) => x.toJson())),
        "maintenance_reason": maintenanceReason == null
            ? []
            : List<dynamic>.from(maintenanceReason!.map((x) => x.toJson())),
        "maintenance_reason_photo": maintenanceReasonPhoto == null
            ? []
            : List<dynamic>.from(
                maintenanceReasonPhoto!.map((x) => x.toJson())),
        "assignto": assignTo?.toJson(),
      };
}

class JobsAssign {
  int? id;
  int? profitCenter;
  int? jobId;
  int? vehicleId;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? siteAddress;
  String? firstName;
  String? lastName;
  String? crewMobile;

  JobsAssign({
    this.id,
    this.profitCenter,
    this.jobId,
    this.vehicleId,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.siteAddress,
    this.firstName,
    this.lastName,
    this.crewMobile,
  });

  factory JobsAssign.fromJson(Map<String, dynamic> json) => JobsAssign(
        id: json["id"],
        profitCenter: json["profit_center"],
        jobId: json["job_id"],
        vehicleId: json["vehicle_id"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        siteAddress: json["site_address"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        crewMobile: json["crew_mobile"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profit_center": profitCenter,
        "job_id": jobId,
        "vehicle_id": vehicleId,
        "deleted_at": deletedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "site_address": siteAddress,
        "first_name": firstName,
        "last_name": lastName,
        "crew_mobile": crewMobile,
      };
}

class MaintenanceReason {
  int? id;
  int? maintenanceId;
  String? reason;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? reasonPhoto;

  MaintenanceReason({
    this.id,
    this.maintenanceId,
    this.reason,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.reasonPhoto,
  });

  factory MaintenanceReason.fromJson(Map<String, dynamic> json) =>
      MaintenanceReason(
        id: json["id"],
        maintenanceId: json["maintenance_id"],
        reason: json["reason"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        reasonPhoto: json["reason_photo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "maintenance_id": maintenanceId,
        "reason": reason,
        "deleted_at": deletedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "reason_photo": reasonPhoto,
      };
}

class QuotationMaterial {
  int? id;
  int? maintenanceId;
  String? materialDescription;
  int? quantity;
  String? amount;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  QuotationMaterial({
    this.id,
    this.maintenanceId,
    this.materialDescription,
    this.quantity,
    this.amount,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory QuotationMaterial.fromJson(Map<String, dynamic> json) =>
      QuotationMaterial(
        id: json["id"],
        maintenanceId: json["maintenance_id"],
        materialDescription: json["material_description"],
        quantity: json["quantity"],
        amount: json["amount"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "maintenance_id": maintenanceId,
        "material_description": materialDescription,
        "quantity": quantity,
        "amount": amount,
        "deleted_at": deletedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
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
