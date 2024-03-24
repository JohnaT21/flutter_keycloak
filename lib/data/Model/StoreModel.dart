class StoreModel {
  late String message;

  StoreModel({required this.message});

  // Factory method to create a StoreModel object from a JSON map
  factory StoreModel.fromJson(Map<String, dynamic> json) {
    String message = json['message'] ?? '';
    return StoreModel(
      message: message,
    );
  }

  // Method to convert a StoreModel object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
