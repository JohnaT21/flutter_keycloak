class StoreReturn {
  List<Data> data;

  StoreReturn({
    required this.data,
  });

  factory StoreReturn.fromJson(Map<String, dynamic> json) {
    return StoreReturn(
      data: List<Data>.from(json['data'].map((x) => Data.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
  }
}

class Data {
  int id;
  String packageName;
  int quantity;
  DateTime createdAt;
  String createdBy;

  Data({
    required this.id,
    required this.packageName,
    required this.quantity,
    required this.createdAt,
    required this.createdBy,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['Id'],
      packageName: json['PackageName'],
      quantity: json['Quantity'],
      createdAt: DateTime.parse(json['CreatedAt']),
      createdBy: json['CreatedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'PackageName': packageName,
      'Quantity': quantity,
      'CreatedAt': createdAt.toIso8601String(),
      'CreatedBy': createdBy,
    };
  }
}
