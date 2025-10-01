class UserModel {
  final int? age;
  final String? fullName;
  final String? gender;
  final String email;
  final String? phoneNumber;
  final String userId;
  final String? userType;

  UserModel({
    this.age,
    this.fullName,
    this.gender,
    required this.email,
    this.phoneNumber,
    required this.userId,
    this.userType,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      age: data['age'] ?? 0,
      fullName: data['fullName'] ?? "",
      email: data['email'] ?? "",
      gender: data['gender'] ?? "",
      phoneNumber: data['phoneNumber'] ?? "",
      userId: data['userId'] ?? "",
      userType: data['userType'] ?? '',
    );
  }
}
