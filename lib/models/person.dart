class Person {
  final String name;
  final String? photoUrl;
  final String phoneNumber;
  final String? upiID;
  final String? email;

  Person({
    required this.name,
    this.photoUrl,
    required this.phoneNumber,
    this.email,
    this.upiID,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'photoUrl': photoUrl,
      "phoneNumber": phoneNumber,
      "upiID": upiID,
      "email": email,
    };
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      photoUrl: map['photoUrl'],
      upiID: map['upiID'],
      email: map['email'],
    );
  }
}
