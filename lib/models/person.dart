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
}
