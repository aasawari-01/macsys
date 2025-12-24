import 'dart:convert';

PurchasePetroleum transactionModelFromJson(String str) =>
    PurchasePetroleum.fromJson(json.decode(str));

String transactionModelToJson(PurchasePetroleum data) => json.encode(data.toJson());

class PurchasePetroleum {
  PurchasePetroleum({
    required this.purchaseDiesel,
  });
  late final List<PurchaseDiesel> purchaseDiesel;

  PurchasePetroleum.fromJson(Map<String, dynamic> json){
    purchaseDiesel = List.from(json['purchase_diesel']).map((e)=>PurchaseDiesel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['purchase_diesel'] = purchaseDiesel.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class PurchaseDiesel {
  PurchaseDiesel({
    required this.id,
    required this.company,
    this.rechargeAmt,
    required this.avlBalance,
    this.mode,
    this.txnId,
    required this.purchaseAmt,
    required this.consumption,
    required this.rate,
    required this.rechPurchase,
    this.purchaseInvoice,
    this.location,
    this.purchaseDate,
    required this.transactionDate,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    this.petroleum,
    this.dieselLocation,
  });
  late final int id;
  late final int company;
  late final Null rechargeAmt;
  late final String avlBalance;
  late final Null mode;
  late final Null txnId;
  late final String purchaseAmt;
  late final String consumption;
  late final String rate;
  late final String rechPurchase;
  late final Null purchaseInvoice;
  late final int? location;
  late final String? purchaseDate;
  late final String transactionDate;
  late final Null deletedAt;
  late final String createdAt;
  late final String updatedAt;
  late final Petroleum? petroleum;
  late final DieselLocation? dieselLocation;

  PurchaseDiesel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    company = json['company'];
    rechargeAmt = null;
    avlBalance = json['avl_balance'];
    mode = null;
    txnId = null;
    purchaseAmt = json['purchase_amt'];
    consumption = json['consumption'];
    rate = json['rate'];
    rechPurchase = json['rech_purchase'];
    purchaseInvoice = null;
    location = null;
    purchaseDate = json['purchase_date'];
    transactionDate = json['transaction_date'];
    deletedAt = null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['petroleum'] != null) {
      petroleum = Petroleum.fromJson(json['petroleum']);
    } else {
      petroleum = null; // Assign null if 'diesel_location' is null
    }
    if (json['diesel_location'] != null) {
      dieselLocation = DieselLocation.fromJson(json['diesel_location']);
    } else {
      dieselLocation = null; // Assign null if 'diesel_location' is null
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['company'] = company;
    _data['recharge_amt'] = rechargeAmt;
    _data['avl_balance'] = avlBalance;
    _data['mode'] = mode;
    _data['txnId'] = txnId;
    _data['purchase_amt'] = purchaseAmt;
    _data['consumption'] = consumption;
    _data['rate'] = rate;
    _data['rech_purchase'] = rechPurchase;
    _data['purchase_invoice'] = purchaseInvoice;
    _data['location'] = location;
    _data['purchase_date'] = purchaseDate;
    _data['transaction_date'] = transactionDate;
    _data['deleted_at'] = deletedAt;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['petroleum'] = petroleum;
    _data['diesel_location'] = dieselLocation;
    return _data;
  }
}

class Petroleum {
  Petroleum({
    required this.id,
    required this.company,
    required this.balance,
  });
  late final int id;
  late final String company;
  late final String balance;

  Petroleum.fromJson(Map<String, dynamic> json){
    id = json['id'];
    company = json['company'];
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['company'] = company;
    _data['balance'] = balance;
    return _data;
  }
}

class DieselLocation {
  DieselLocation({
    required this.id,
    required this.address,
    required this.short,
  });
  late final int id;
  late final String address;
  late final String short;

  DieselLocation.fromJson(Map<String, dynamic> json){
    id = json['id'];
    address = json['address'];
    short = json['short'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['address'] = address;
    _data['short'] = short;
    return _data;
  }
}
