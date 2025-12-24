import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class Profile {
  int id;
  String rememberToken;
  String firstName;
  String lastName;
  String personalMobile;
  String? personalEmail;
  String officeMobile;
  String? officeEmail;
  String skills;

  Profile({
    required this.id,
    required this.rememberToken,
    required this.firstName,
    required this.lastName,
    required this.personalMobile,
    required this.personalEmail,
    required this.officeMobile,
    required this.officeEmail,
    required this.skills,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"],
        rememberToken: json["remember_token"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        personalMobile: json["personal_mobile"],
        personalEmail: json["personal_email"],
        officeMobile: json["office_mobile"],
        officeEmail: json["office_email"],
        skills: json["skills"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "remember_token": rememberToken,
        "first_name": firstName,
        "last_name": lastName,
        "personal_mobile": personalMobile,
        "personal_email": personalEmail,
        "office_mobile": officeMobile,
        "office_email": officeEmail,
        "skills": skills,
      };
}

class LoginModel {
  bool? status;
  String? msg;
  String? token;
  Profile? profile;

  LoginModel({
    this.status,
    this.msg,
    this.token,
    this.profile,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        status: json["status"],
        msg: json["msg"],
        token: json["token"],
        profile: json.containsKey("profile")
            ? Profile.fromJson(json["profile"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "token": token,
        "profile": profile?.toJson(),
      };
}
