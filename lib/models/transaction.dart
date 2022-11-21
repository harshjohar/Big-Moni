import 'package:bigbucks/enums/transaction_enum.dart';

class Transaction {
  final String senderId;
  final String recieverId;
  final double amount;
  final String description;
  final TransactionEnum transactionType;
  final DateTime timestamp;

  Transaction({
    required this.senderId,
    required this.recieverId,
    required this.amount,
    required this.description,
    required this.transactionType,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      "senderId": senderId,
      "recieverId": recieverId,
      "amount": amount,
      "description": description,
      "transactionType": transactionType,
      "timestamp": timestamp.toIso8601String(),
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      senderId: json["senderId"],
      recieverId: json["recieverId"],
      amount: double.parse(json["amount"]),
      description: json["description"],
      transactionType: (json["transactionType"] as String).toEnum(),
      timestamp: DateTime.parse(json["timestamp"]),
    );
  }
//

}
