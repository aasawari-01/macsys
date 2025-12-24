import 'dart:convert';

JobDetailsModel jobDetailsModelFromJson(String str) =>
    JobDetailsModel.fromJson(json.decode(str));

String jobDetailsModelToJson(JobDetailsModel data) =>
    json.encode(data.toJson());

class JobDetailsModel {
  bool status;
  String msg;
  Jobs jobs;

  JobDetailsModel({
    required this.status,
    required this.msg,
    required this.jobs,
  });

  factory JobDetailsModel.fromJson(Map<String, dynamic> json) =>
      JobDetailsModel(
        status: json["status"],
        msg: json["msg"],
        jobs: Jobs.fromJson(json["jobs"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "jobs": jobs.toJson(),
      };
}

class Jobs {
  int? site_id;
  int id;
  int customer;
  String type;
  String? fromDate;
  String? toDate;
  int? jobType;
  int? supervisor;
  String siteAddress;
  String notes;
  dynamic? problem;
  String status;
  dynamic? deletedAt;
  String? createdAt;
  String? updatedAt;
  String? customerName;
  SupervisorDetail? supervisorDetail;
  List<AssignVehicle> assignVehicle;

  Jobs({
    this.site_id,
    required this.id,
    required this.customer,
    required this.type,
    this.fromDate,
    this.toDate,
    this.jobType,
    this.supervisor,
    required this.siteAddress,
    required this.notes,
    this.problem,
    required this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.customerName,
    this.supervisorDetail,
    required this.assignVehicle,
  });

  factory Jobs.fromJson(Map<String, dynamic> json) => Jobs(
        site_id: json["site_id"],
        id: json["id"],
        customer: json["customer"],
        type: json["type"],
        fromDate: json["from_date"] ?? "2023-10-01",
        toDate: json["to_date"] ?? "",
        jobType: json["job_type"] ?? "",
        supervisor: json["supervisor"] ?? "",
        siteAddress: json["site_address"],
        notes: json["notes"],
        problem: json["problem"] ?? "",
        status: json["status"],
        deletedAt: json["deleted_at"] ?? "",
        createdAt: json["created_at"] ?? "",
        updatedAt: json["updated_at"] ?? "",
        customerName: json["customer_name"] ?? "",
        supervisorDetail:
            SupervisorDetail.fromJson(json["supervisor_detail"] ?? []),
        assignVehicle: List<AssignVehicle>.from(
            json["assign_vehicle"].map((x) => AssignVehicle.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer": customer,
        "type": type,
        "from_date": fromDate,
        "to_date": toDate,
        "job_type": jobType,
        "supervisor": supervisor,
        "site_address": siteAddress,
        "notes": notes,
        "problem": problem,
        "status": status,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "customer_name": customerName,
        "supervisor_detail": supervisorDetail!.toJson(),
        "assign_vehicle":
            List<dynamic>.from(assignVehicle.map((x) => x.toJson())),
      };
}

class SupervisorDetail {
  int id;
  String firstName;
  String lastName;
  String personalMobile;
  String personalEmail;

  SupervisorDetail({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.personalMobile,
    required this.personalEmail,
  });

  factory SupervisorDetail.fromJson(Map<String, dynamic> json) =>
      SupervisorDetail(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        personalMobile: json["personal_mobile"],
        personalEmail: json["personal_email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "personal_mobile": personalMobile,
        "personal_email": personalEmail,
      };
}

class AssignVehicle {
  int id;
  int jobId;
  int vehicleId;
  String? vehicleNo;
  String? vehStatus;
  int? vehicleType;
  String? vehicleImage;
  List<CrewVehicleAllocation>? crewVehicleAllocation;
  int dailyJobSheet;
  int isdraft;
  String transferstatus;
  String? vehicleTypeName;

  AssignVehicle({
    required this.id,
    required this.jobId,
    required this.vehicleId,
    required this.vehicleNo,
    required this.vehStatus,
    required this.vehicleType,
    this.vehicleImage,
    required this.crewVehicleAllocation,
    required this.dailyJobSheet,
    required this.isdraft,
    required this.transferstatus,
    this.vehicleTypeName,
  });

  factory AssignVehicle.fromJson(Map<String, dynamic> json) => AssignVehicle(
        id: json["id"],
        jobId: json["job_id"],
        vehicleId: json["vehicle_id"],
        vehicleNo: json["vehicle_no"],
        vehStatus: json["status"],
        vehicleType: json["vehicle_type"],
        vehicleImage: json["vehicle_photo"] ?? '',
        dailyJobSheet: json["daily_job_sheet"],
        isdraft: json["is_draft"],
        transferstatus: json["transfer_status"],
        crewVehicleAllocation: List<CrewVehicleAllocation>.from(
            json["crew_vehicle_allocation"]
                .map((x) => CrewVehicleAllocation.fromJson(x))),
        vehicleTypeName: json["vehicle_type_name"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "job_id": jobId,
        "vehicle_id": vehicleId,
        "vehicle_no": vehicleNo,
        "vehicle_type": vehicleType,
        "vehicle_photo": vehicleImage,
        "daily_job_sheet": dailyJobSheet,
        "is_draft": isdraft,
        "status": vehStatus,
        "transferstatus": transferstatus,
        "crew_vehicle_allocation": List<dynamic>.from(
            crewVehicleAllocation?.map((x) => x.toJson()) ?? []),
        "vehicle_type_name": vehicleTypeName,
      };
}

class CrewVehicleAllocation {
  int id;
  int vehicleId;
  int crewId;
  String firstName;
  String lastName;

  CrewVehicleAllocation({
    required this.id,
    required this.vehicleId,
    required this.crewId,
    required this.firstName,
    required this.lastName,
  });

  factory CrewVehicleAllocation.fromJson(Map<String, dynamic> json) =>
      CrewVehicleAllocation(
        id: json["id"],
        vehicleId: json["vehicle_id"],
        crewId: json["crew_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vehicle_id": vehicleId,
        "crew_id": crewId,
        "first_name": firstName,
        "last_name": lastName,
      };
}
