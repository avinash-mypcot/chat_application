class ProfileModel {
  final String name;
  final String email;
  final String mobile;

  // Constructor
  ProfileModel({
    required this.name,
    required this.email,
    required this.mobile,
  });

  // Factory method to create a ProfileModel from a Map (e.g., Firestore data)
  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      mobile: map['mobile'] ?? '',
    );
  }

  // Method to convert a ProfileModel instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'mobile': mobile,
    };
  }
}
