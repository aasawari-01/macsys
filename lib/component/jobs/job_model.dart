import 'dart:convert';

JobModel jobsModelFromJson(String str) => JobModel.fromJson(json.decode(str));

String jobsModelToJson(JobModel data) => json.encode(data.toJson());

class JobModel {
  bool status;
  String msg;
  List<Job> jobs;
  int isSupervisorAdmin;
  List<VehicleStatus>? vehicleStatuses;

  JobModel({
    required this.status,
    required this.msg,
    required this.jobs,
    required this.isSupervisorAdmin,
    this.vehicleStatuses,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) => JobModel(
        status: json["status"],
        msg: json["msg"],
        jobs: List<Job>.from(json["jobs"].map((x) => Job.fromJson(x))),
        isSupervisorAdmin: json['isSupervisorAdmin'],
        vehicleStatuses: json['vehicle_statuses'] != null
            ? List<VehicleStatus>.from(
                json['vehicle_statuses'].map((x) => VehicleStatus.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "jobs": List<dynamic>.from(jobs.map((x) => x.toJson())),
        "isSupervisorAdmin": isSupervisorAdmin,
        "vehicle_statuses": vehicleStatuses?.map((x) => x.toJson()).toList(),
      };
}

class VehicleStatus {
  String? status;
  int? count;

  VehicleStatus({
    this.status,
    this.count,
  });

  factory VehicleStatus.fromJson(Map<String, dynamic> json) => VehicleStatus(
        status: json["status"] ?? "",
        count: json["count"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "count": count,
      };
}

class Job {
  int id;
  int customer;
  String type;
  String fromDate;
  String toDate;
  int jobType;
  int supervisor;
  String siteAddress;
  String notes;
  dynamic problem;
  dynamic deletedAt;
  String createdAt;
  String updatedAt;
  SupervisorDetail supervisorDetail;
  List<AssignVehicle> assignVehicle;
  String status;

  Job({
    required this.id,
    required this.customer,
    required this.type,
    required this.fromDate,
    required this.toDate,
    required this.jobType,
    required this.supervisor,
    required this.siteAddress,
    required this.notes,
    required this.problem,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.supervisorDetail,
    required this.assignVehicle,
    required this.status,
  });

  factory Job.fromJson(Map<String, dynamic> json) => Job(
        id: json["id"],
        customer: json["customer"],
        type: json["type"],
        fromDate: json["from_date"],
        toDate: json["to_date"],
        jobType: json["job_type"],
        supervisor: json["supervisor"],
        siteAddress: json["site_address"],
        notes: json["notes"],
        problem: json["problem"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        supervisorDetail: SupervisorDetail.fromJson(json["supervisor_detail"]),
        assignVehicle: List<AssignVehicle>.from(
            json["assign_vehicle"].map((x) => AssignVehicle.fromJson(x))),
        status: json["status"],
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
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "supervisor_detail": supervisorDetail.toJson(),
        "assign_vehicle":
            List<dynamic>.from(assignVehicle.map((x) => x.toJson())),
        "status": status,
      };
}

class AssignVehicle {
  int id;
  int jobId;
  int vehicleId;
  String vehicleNo;
  int vehicleType;
  List<CrewVehicleAllocation> crewVehicleAllocation;

  AssignVehicle({
    required this.id,
    required this.jobId,
    required this.vehicleId,
    required this.vehicleNo,
    required this.vehicleType,
    required this.crewVehicleAllocation,
  });

  factory AssignVehicle.fromJson(Map<String, dynamic> json) => AssignVehicle(
        id: json["id"],
        jobId: json["job_id"],
        vehicleId: json["vehicle_id"],
        vehicleNo: json["vehicle_no"],
        vehicleType: json["vehicle_type"],
        crewVehicleAllocation: List<CrewVehicleAllocation>.from(
            json["crew_vehicle_allocation"]
                .map((x) => CrewVehicleAllocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "job_id": jobId,
        "vehicle_id": vehicleId,
        "vehicle_no": vehicleNo,
        "vehicle_type": vehicleType,
        "crew_vehicle_allocation":
            List<dynamic>.from(crewVehicleAllocation.map((x) => x.toJson())),
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

class SupervisorDetail {
  int id;
  String firstName;
  String lastName;
  String personalMobile;
  String? personalEmail;
  String? crewEmail;
  String crewMobile;
  String skills;

  SupervisorDetail({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.personalMobile,
    this.personalEmail,
    this.crewEmail,
    required this.crewMobile,
    required this.skills,
  });

  factory SupervisorDetail.fromJson(Map<String, dynamic> json) =>
      SupervisorDetail(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        personalMobile: json["personal_mobile"],
        personalEmail: json["personal_email"] ?? "",
        crewMobile: json["crew_email"] ?? "",
        crewEmail: json["crew_mobile"],
        skills: json["skills"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "personal_mobile": personalMobile,
        "personal_email": personalEmail,
        "crew_email": crewEmail,
        "crew_mobile": crewMobile,
        "skills": skills,
      };
}
