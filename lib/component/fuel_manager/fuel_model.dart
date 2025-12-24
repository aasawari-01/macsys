import 'dart:convert';

PetroleumResponse fuelModelFromJson(String str) =>
    PetroleumResponse.fromJson(json.decode(str));

String fuelModelToJson(PetroleumResponse data) => json.encode(data.toJson());

class PetroleumCompany {
  int? id;
  String? company;
  String? balance;
  String? consumption;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  PetroleumCompany({
    this.id,
    this.company,
    this.balance,
    this.consumption,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory PetroleumCompany.fromJson(Map<String, dynamic> json) =>
      PetroleumCompany(
        id: json["id"] ?? 0,
        company: json["company"] ?? "",
        balance: json["balance"] ?? "",
        consumption: json["consumption"] ?? "",
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company": company,
        "balance": balance,
        "consumption": consumption,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class PetroleumResponse {
  List<PetroleumCompany> petroleum;
  List<Location> location;
  num? totalPurchaseFuel;
  num? totalUsedFuel;

  PetroleumResponse({
    required this.petroleum,
    required this.location,
    this.totalPurchaseFuel,
    this.totalUsedFuel,
  });
  factory PetroleumResponse.fromJson(Map<String, dynamic> json) =>
      PetroleumResponse(
        petroleum: List<PetroleumCompany>.from(
            json["petroleum"].map((x) => PetroleumCompany.fromJson(x))),
        location: List<Location>.from(
            json["location"].map((x) => Location.fromJson(x))),
        totalPurchaseFuel: json["total_purchase_fuel"],
        totalUsedFuel: json["total_used_fuel"],
      );

  Map<String, dynamic> toJson() => {
        "petroleum": List<dynamic>.from(petroleum.map((x) => x.toJson())),
        "location": List<dynamic>.from(location.map((x) => x.toJson())),
      };
}

class Location {
  int? id;
  String? address;
  String? short;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  List<Purchase>? purchase;

  Location({
    this.id,
    this.address,
    this.short,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.purchase,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json["id"] ?? 0,
        address: json["address"] ?? "",
        short: json["short"] ?? "",
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        purchase: (json["purchase"] != null)
            ? List<Purchase>.from(
                json["purchase"].map((x) => Purchase.fromJson(x)))
            : null,

      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address": address,
        "short": short,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "purchase": (purchase != null)
            ? List<dynamic>.from(purchase!.map((x) => x.toJson()))
            : null,
      };
}

class Purchase {
  int? id;
  int? location;
  String? consumption;
  num? totalConsumption;

  Purchase({
    this.id,
    this.location,
    this.consumption,
    this.totalConsumption,
  });

  factory Purchase.fromJson(Map<String, dynamic> json) => Purchase(
        id: json["id"] ?? 0,
        location: json["location"] ?? 0,
        consumption: json["consumption"],
        totalConsumption: json["total_consumption"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "location": location,
        "consumption": consumption,
        "total_consumption": totalConsumption,
      };
}
