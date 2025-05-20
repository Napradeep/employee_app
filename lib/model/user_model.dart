class UserModel {
  String id;
  String name;
  String contact;
  String monbileno;
  String password;
  String userType;
  String? deviceToken;

  UserModel({
    required this.id,
    required this.name,
    required this.contact,
    required this.monbileno,
    required this.password,
    required this.userType,
    this.deviceToken,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
      'mobileno': monbileno,
      'password': password,
      'userType': userType,
      'deviceToken': deviceToken,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      id: documentId,
      name: data['name'] ?? '',
      contact: data['contact'] ?? '',
      monbileno: data['mobileno'] ?? '',
      password: data['password'] ?? '',
      userType: data['userType'] ?? '',
      deviceToken: data['deviceToken'],
    );
  }
}
