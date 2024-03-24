class StoreRegistrationResponse {
  final String packageName;
  final int quantity;
  final String createdAt;
  final String createdBy;

  StoreRegistrationResponse({
    required this.packageName,
    required this.quantity,
    required this.createdAt,
    required this.createdBy,
  });

  factory StoreRegistrationResponse.fromJson(Map<String, dynamic> json) {
    return StoreRegistrationResponse(
      packageName: json['PackageName'],
      quantity: json['Quantity'],
      createdAt: json['CreatedAt'],
      createdBy: json['CreatedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'PackageName': packageName,
      'Quantity': quantity,
      'CreatedAt': createdAt,
      'CreatedBy': createdBy,
    };
    return data;
  }
}
