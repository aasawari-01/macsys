import 'dart:convert';

VehicleMaintenanceModel vehicleMaintenanceModelFromJson(String str) =>
    VehicleMaintenanceModel.fromJson(json.decode(str));

String vehicleMaintenanceToJson(VehicleMaintenanceModel data) =>
    json.encode(data.toJson());

class VehicleMaintenanceModel {
  final bool? status;
  final String? msg;
  final List<VehicleMaintenence>? vehicleMaintenence;
  final int? completedMaintenance;

  VehicleMaintenanceModel({
    this.status,
    this.msg,
    this.vehicleMaintenence,
    this.completedMaintenance,
  });

  VehicleMaintenanceModel.fromJson(Map<String, dynamic> json)
      : status = json['status'] as bool?,
        msg = json['msg'] as String?,
        vehicleMaintenence = (json['vehicle_maintenence'] as List?)
            ?.map((dynamic e) =>
                VehicleMaintenence.fromJson(e as Map<String, dynamic>))
            .toList(),
        completedMaintenance = json['completed_maintenance'] as int?;

  Map<String, dynamic> toJson() => {
        'status': status,
        'msg': msg,
        'vehicle_maintenence':
            vehicleMaintenence?.map((e) => e.toJson()).toList(),
        'completed_maintenance': completedMaintenance
      };
}

class VehicleMaintenence {
  final int? id;
  final int? profitCenter;
  final int? vehicleId;
  final int? maintenanceSupervisor;
  final int? jobAssign;
  final String? maintenanceType;
  final dynamic notes;
  final int? status;
  final dynamic reading;
  final dynamic location;
  final dynamic description;
  final dynamic deletedAt;
  final String? createdAt;
  final String? updatedAt;
  final VehicleDetails? vehicleDetails;
  final List<MaintenanceDetails>? maintenanceDetails;
  final JobsAssign? jobsAssign;
  final List<MaterialDescription>? materialDescription;
  final List<Observation>? observation;
  final List<dynamic>? instruction;
  final List<MaintenancePhoto>? maintenancePhoto;

  VehicleMaintenence({
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
    this.materialDescription,
    this.observation,
    this.instruction,
    this.maintenancePhoto,
  });

  VehicleMaintenence.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        profitCenter = json['profit_center'] as int?,
        vehicleId = json['vehicle_id'] as int?,
        maintenanceSupervisor = json['maintenance_supervisor'] as int?,
        jobAssign = json['job_assign'] as int?,
        maintenanceType = json['maintenance_type'] as String?,
        notes = json['notes'],
        status = json['status'] as int?,
        reading = json['reading'],
        location = json['location'],
        description = json['description'],
        deletedAt = json['deleted_at'],
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        vehicleDetails =
            (json['vehicle_details'] as Map<String, dynamic>?) != null
                ? VehicleDetails.fromJson(
                    json['vehicle_details'] as Map<String, dynamic>)
                : null,
        maintenanceDetails = (json['maintenance_details'] as List?)
            ?.map((dynamic e) =>
                MaintenanceDetails.fromJson(e as Map<String, dynamic>))
            .toList(),
        jobsAssign = (json['jobs_assign'] as Map<String, dynamic>?) != null
            ? JobsAssign.fromJson(json['jobs_assign'] as Map<String, dynamic>)
            : null,
        materialDescription = (json['material_description'] as List?)
            ?.map((dynamic e) =>
                MaterialDescription.fromJson(e as Map<String, dynamic>))
            .toList(),
        observation = (json['observation'] as List?)
            ?.map(
                (dynamic e) => Observation.fromJson(e as Map<String, dynamic>))
            .toList(),
        instruction = json['instruction'] as List?,
        maintenancePhoto = (json['maintenance_photo'] as List?)
            ?.map((dynamic e) =>
                MaintenancePhoto.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'id': id,
        'profit_center': profitCenter,
        'vehicle_id': vehicleId,
        'maintenance_supervisor': maintenanceSupervisor,
        'job_assign': jobAssign,
        'maintenance_type': maintenanceType,
        'notes': notes,
        'status': status,
        'reading': reading,
        'location': location,
        'description': description,
        'deleted_at': deletedAt,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'vehicle_details': vehicleDetails?.toJson(),
        'maintenance_details':
            maintenanceDetails?.map((e) => e.toJson()).toList(),
        'jobs_assign': jobsAssign?.toJson(),
        'material_description':
            materialDescription?.map((e) => e.toJson()).toList(),
        'observation': observation?.map((e) => e.toJson()).toList(),
        'instruction': instruction,
        'maintenance_photo': maintenancePhoto?.map((e) => e.toJson()).toList()
      };
}

class VehicleDetails {
  final int? id;
  final String? type;
  final String? makeType;
  final String? modelName;
  final String? vehicleNo;
  final String? vehicleTypeName;
  final String? status;
  final String? vehiclePhoto;
  final int? vehicleType;
  final int? profitCenter;

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

  VehicleDetails.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        type = json['type'] as String?,
        makeType = json['make_type'] as String?,
        modelName = json['model_name'] as String?,
        vehicleNo = json['vehicle_no'] as String?,
        vehicleTypeName = json['vehicle_type_name'] as String?,
        status = json['status'] as String?,
        vehiclePhoto = json['vehicle_photo'] as String?,
        vehicleType = json['vehicle_type'] as int?,
        profitCenter = json['profit_center'] as int?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'make_type': makeType,
        'model_name': modelName,
        'vehicle_no': vehicleNo,
        'vehicle_type_name': vehicleTypeName,
        'status': status,
        'vehicle_photo': vehiclePhoto,
        'vehicle_type': vehicleType,
        'profit_center': profitCenter
      };
}

class MaintenanceDetails {
  final int? id;
  final int? maintenanceId;
  final int? vendorId;
  final String? maintenanceDate;
  final String? invoiceAmt;
  final dynamic invoiceFile;
  final dynamic deletedAt;
  final String? createdAt;
  final String? updatedAt;

  MaintenanceDetails({
    this.id,
    this.maintenanceId,
    this.vendorId,
    this.maintenanceDate,
    this.invoiceAmt,
    this.invoiceFile,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  MaintenanceDetails.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        maintenanceId = json['maintenance_id'] as int?,
        vendorId = json['vendor_id'] as int?,
        maintenanceDate = json['maintenance_date'] as String?,
        invoiceAmt = json['invoice_amt'] as String?,
        invoiceFile = json['invoice_file'],
        deletedAt = json['deleted_at'],
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'maintenance_id': maintenanceId,
        'vendor_id': vendorId,
        'maintenance_date': maintenanceDate,
        'invoice_amt': invoiceAmt,
        'invoice_file': invoiceFile,
        'deleted_at': deletedAt,
        'created_at': createdAt,
        'updated_at': updatedAt
      };
}

class JobsAssign {
  final int? id;
  final int? profitCenter;
  final int? jobId;
  final int? vehicleId;
  final dynamic deletedAt;
  final String? createdAt;
  final String? updatedAt;
  final String? siteAddress;
  final String? firstName;
  final String? lastName;
  final String? crewMobile;

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

  JobsAssign.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        profitCenter = json['profit_center'] as int?,
        jobId = json['job_id'] as int?,
        vehicleId = json['vehicle_id'] as int?,
        deletedAt = json['deleted_at'],
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        siteAddress = json['site_address'] as String?,
        firstName = json['first_name'] as String?,
        lastName = json['last_name'] as String?,
        crewMobile = json['crew_mobile'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'profit_center': profitCenter,
        'job_id': jobId,
        'vehicle_id': vehicleId,
        'deleted_at': deletedAt,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'site_address': siteAddress,
        'first_name': firstName,
        'last_name': lastName,
        'crew_mobile': crewMobile
      };
}

class MaterialDescription {
  final int? id;
  final int? maintenanceId;
  final String? materialDescription;
  final int? quantity;
  final String? amount;
  final dynamic deletedAt;
  final String? createdAt;
  final String? updatedAt;

  MaterialDescription({
    this.id,
    this.maintenanceId,
    this.materialDescription,
    this.quantity,
    this.amount,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  MaterialDescription.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        maintenanceId = json['maintenance_id'] as int?,
        materialDescription = json['material_description'] as String?,
        quantity = json['quantity'] as int?,
        amount = json['amount'] as String?,
        deletedAt = json['deleted_at'],
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'maintenance_id': maintenanceId,
        'material_description': materialDescription,
        'quantity': quantity,
        'amount': amount,
        'deleted_at': deletedAt,
        'created_at': createdAt,
        'updated_at': updatedAt
      };
}

class Observation {
  final int? id;
  final int? maintenanceId;
  final String? observation;
  final dynamic openion;
  final dynamic deletedAt;
  final String? createdAt;
  final String? updatedAt;

  Observation({
    this.id,
    this.maintenanceId,
    this.observation,
    this.openion,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  Observation.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        maintenanceId = json['maintenance_id'] as int?,
        observation = json['observation'] as String?,
        openion = json['openion'],
        deletedAt = json['deleted_at'],
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'maintenance_id': maintenanceId,
        'observation': observation,
        'openion': openion,
        'deleted_at': deletedAt,
        'created_at': createdAt,
        'updated_at': updatedAt
      };
}

class MaintenancePhoto {
  final int? id;
  final int? maintenanceId;
  final String? activityPhoto;
  final dynamic deletedAt;
  final String? createdAt;
  final String? updatedAt;

  MaintenancePhoto({
    this.id,
    this.maintenanceId,
    this.activityPhoto,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  MaintenancePhoto.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        maintenanceId = json['maintenance_id'] as int?,
        activityPhoto = json['activity_photo'] as String?,
        deletedAt = json['deleted_at'],
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'maintenance_id': maintenanceId,
        'activity_photo': activityPhoto,
        'deleted_at': deletedAt,
        'created_at': createdAt,
        'updated_at': updatedAt
      };
}

// To parse this JSON data, do
//
//     final getMaintenenceSupervisor = getMaintenenceSupervisorFromJson(jsonString);

GetMaintenenceSupervisor getMaintenenceSupervisorFromJson(String str) =>
    GetMaintenenceSupervisor.fromJson(json.decode(str));

String getMaintenenceSupervisorToJson(GetMaintenenceSupervisor data) =>
    json.encode(data.toJson());

class GetMaintenenceSupervisor {
  List<MaintenenceSupervisorGet> data;

  GetMaintenenceSupervisor({
    required this.data,
  });

  factory GetMaintenenceSupervisor.fromJson(Map<String, dynamic> json) =>
      GetMaintenenceSupervisor(
        data: List<MaintenenceSupervisorGet>.from(
            json["data"].map((x) => MaintenenceSupervisorGet.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class MaintenenceSupervisorGet {
  int id;
  String? fullName;

  MaintenenceSupervisorGet({
    required this.id,
    this.fullName,
  });

  factory MaintenenceSupervisorGet.fromJson(Map<String, dynamic> json) =>
      MaintenenceSupervisorGet(
        id: json["id"],
        fullName: json["full_name"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
      };
  @override
  String toString() {
    return 'ID: $id,fullName:$fullName';
  }
}
