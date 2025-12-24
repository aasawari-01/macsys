
import 'dart:convert';

FilledJobDetailsModel filledJobDetailsModelFromJson(String str) => FilledJobDetailsModel.fromJson(json.decode(str));

String filledJobDetailsModelToJson(FilledJobDetailsModel data) => json.encode(data.toJson());

class FilledJobDetailsModel {
  int flag;
  String msg;
  List<DailyJob> dailyJob;

  FilledJobDetailsModel({
    required this.flag,
    required this.msg,
    required this.dailyJob,
  });

  factory FilledJobDetailsModel.fromJson(Map<String, dynamic> json) => FilledJobDetailsModel(
    flag: json["flag"],
    msg: json["msg"],
    dailyJob: List<DailyJob>.from(json["daily_job"].map((x) => DailyJob.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "flag": flag,
    "msg": msg,
    "daily_job": List<dynamic>.from(dailyJob.map((x) => x.toJson())),
  };
}

class DailyJob {
  String id;
  String crewId;
  String machineId;
  String jobId;
  String noOfHours;
  String noOfMinutes;
  String reading;
  String? kmperltr;
  String? hrperltr;
  String? fuelConsumption;
  String? urea;
  String? readingIn;
  DateTime? jobDate;
  String ?jobDesc;
  String? other;
  String ?totalRunning;
  dynamic supervisorSign;
  dynamic crewSign;
  dynamic monitoringImg;
  DateTime? createdDate;
  String ?createdBy;
  String ?isVerified;
  String ?isActive;

  DailyJob({
    required this.id,
    required this.crewId,
    required this.machineId,
    required this.jobId,
    required this.noOfHours,
    required this.noOfMinutes,
    required this.reading,
    this.kmperltr,
    this.hrperltr,
    this.fuelConsumption,
    this.urea,
    this.readingIn,
    this.jobDate,
    this.jobDesc,
    this.other,
    this.totalRunning,
    this.supervisorSign,
    this.crewSign,
    this.monitoringImg,
    this.createdDate,
    this.createdBy,
    this.isVerified,
    this.isActive,
  });

  factory DailyJob.fromJson(Map<String, dynamic> json) => DailyJob(
    id: json["id"],
    crewId: json["crew_id"],
    machineId: json["machine_id"],
    jobId: json["job_id"],
    noOfHours: json["no_of_hours"],
    noOfMinutes: json["no_of_minutes"],
    reading: json["reading"],
    kmperltr: json["kmperltr"],
    hrperltr: json["hrperltr"],
    fuelConsumption: json["fuel_consumption"],
    urea: json["urea"],
    readingIn: json["reading_in"],
    jobDate: DateTime.parse(json["job_date"]),
    jobDesc: json["job_desc"],
    other: json["other"],
    totalRunning: json["total_running"],
    supervisorSign: json["supervisor_sign"],
    crewSign: json["crew_sign"],
    monitoringImg: json["monitoring_img"],
    createdDate: DateTime.parse(json["created_date"]),
    createdBy: json["created_by"],
    isVerified: json["is_verified"],
    isActive: json["is_active"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "crew_id": crewId,
    "machine_id": machineId,
    "job_id": jobId,
    "no_of_hours": noOfHours,
    "no_of_minutes": noOfMinutes,
    "reading": reading,
    "kmperltr": kmperltr,
    "hrperltr": hrperltr,
    "fuel_consumption": fuelConsumption,
    "urea": urea,
    "reading_in": readingIn,
    "job_date": "${jobDate!.year.toString().padLeft(4, '0')}-${jobDate!.month.toString().padLeft(2, '0')}-${jobDate!.day.toString().padLeft(2, '0')}",
    "job_desc": jobDesc,
    "other": other,
    "total_running": totalRunning,
    "supervisor_sign": supervisorSign,
    "crew_sign": crewSign,
    "monitoring_img": monitoringImg,
    "created_date": createdDate!.toIso8601String(),
    "created_by": createdBy,
    "is_verified": isVerified,
    "is_active": isActive,
  };
}
