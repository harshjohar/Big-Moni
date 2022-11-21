class Interaction {
  final String name;
  final String photoUrl;
  final String lastTransactionDescription;
  final double balance;
  final DateTime timestamp;
  final String userId;

  Interaction({
    required this.name,
    required this.photoUrl,
    required this.timestamp,
    required this.balance,
    required this.userId,
    required this.lastTransactionDescription,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "photoUrl": photoUrl,
      "lastTransactionDescription": lastTransactionDescription,
      "timestamp": timestamp.toIso8601String(),
      "userId": userId,
      "balance": balance,
    };
  }

  factory Interaction.fromJson(Map<String, dynamic> json) {
    return Interaction(
      name: json["name"],
      photoUrl: json["photoUrl"],
      lastTransactionDescription: json["lastTransactionDescription"],
      timestamp: DateTime.parse(json["timestamp"]),
      userId: json["userId"],
      balance: json['balance'],
    );
  }
//

}
