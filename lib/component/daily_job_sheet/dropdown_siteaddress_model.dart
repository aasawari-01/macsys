class SiteAddresses {
  int? id;
  int? profitCenter;
  String? address;
  String? short;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  SiteAddresses({
    this.id,
    this.profitCenter,
    this.address,
    this.short,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  // Create a SiteAddresses instance from JSON
  factory SiteAddresses.fromJson(Map<String, dynamic> json) {
    return SiteAddresses(
      id: json['id'],
      profitCenter: json['profit_center'],
      address: json['address'],
      short: json['short'],
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  // Convert SiteAddresses instance to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['profit_center'] = this.profitCenter;
    data['address'] = this.address;
    data['short'] = this.short;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class SiteAddressResponse {
  final List<SiteAddresses> siteAddresses;

  SiteAddressResponse({required this.siteAddresses});

  // Create a SiteAddressResponse from JSON
  factory SiteAddressResponse.fromJson(Map<String, dynamic> json) {
    return SiteAddressResponse(
      siteAddresses: (json['site_addresses'] as List)
          .map((item) => SiteAddresses.fromJson(item))
          .toList(),
    );
  }

  // Convert SiteAddressResponse to JSON
  Map<String, dynamic> toJson() {
    return {
      'site_addresses': siteAddresses.map((item) => item.toJson()).toList(),
    };
  }
}
