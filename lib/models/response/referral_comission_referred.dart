import 'dart:convert';

class ReferralCommissionByReferredResponse {
  final String status;
  final List<DataComissionReferred> data;

  ReferralCommissionByReferredResponse({
    required this.status,
    required this.data,
  });

  factory ReferralCommissionByReferredResponse.fromRawJson(String str) =>
      ReferralCommissionByReferredResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReferralCommissionByReferredResponse.fromJson(
          Map<String, dynamic> json) =>
      ReferralCommissionByReferredResponse(
        status: json['status'],
        data: List<DataComissionReferred>.from(json['data'].map((x) => DataComissionReferred.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DataComissionReferred {
  final DateTime createDate;
  final String amount;

  DataComissionReferred({
    required this.createDate,
    required this.amount,
  });

  factory DataComissionReferred.fromRawJson(String str) => DataComissionReferred.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataComissionReferred.fromJson(Map<String, dynamic> json) => DataComissionReferred(
        createDate: DateTime.parse(json['createDate']),
        amount: json['amount'],
      );

  Map<String, dynamic> toJson() => {
        'createDate': createDate.toIso8601String(),
        'amount': amount,
      };
}
