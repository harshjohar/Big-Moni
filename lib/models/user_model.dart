class UserModel {
  final String name;
  final String? photoUrl;
  final String phoneNumber;
  final String? upiID;
  final String? email;

  UserModel({
    required this.name,
    this.photoUrl,
    required this.phoneNumber,
    this.email,
    this.upiID,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "photoUrl": photoUrl,
      "phoneNumber": phoneNumber,
      "upiID": upiID,
      "email": email,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json["name"] ?? "",
      photoUrl: json["photoUrl"] ?? "",
      phoneNumber: json["phoneNumber"] ?? "",
      upiID: json["upiID"] ?? "",
      email: json["email"] ?? "",
    );
  }
//

}
