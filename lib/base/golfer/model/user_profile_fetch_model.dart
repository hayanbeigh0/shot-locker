class UserProfileFetchModel {
  String id;
  String photo;
  String firstName;
  String lastName;
  String phone;
  final String email;
  String dob;
  String gender;

  UserProfileFetchModel({
    required this.id,
    required this.photo,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.dob,
    required this.gender,
  });

  factory UserProfileFetchModel.fromMap(Map<String, dynamic> map) {
    return UserProfileFetchModel(
      id: map['id'].toString(),
      photo: map['photo'] ?? '',
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      dob: map['dob'] ?? '',
      gender: map['gender'] ?? '',
    );
  }
  factory UserProfileFetchModel.fromJson(dynamic source) =>
      UserProfileFetchModel.fromMap(source);

  Map<String, dynamic> toMap() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'dob': dob,
      'gender': gender,
      'phone': phone,
    };
  }
}
