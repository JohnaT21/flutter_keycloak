class StoreRegistrationModel {
  final String packageName;
  final int quantity;

  StoreRegistrationModel({
    required this.packageName,
    required this.quantity,
  });

  factory StoreRegistrationModel.fromJson(Map<String, dynamic> json) {
    return StoreRegistrationModel(
      packageName: json['PackageName'],
      quantity: json['Quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'PackageName': packageName,
      'Quantity': quantity,
    };
    return data;
  }
}
