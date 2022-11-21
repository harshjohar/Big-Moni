import 'package:bigbucks/enums/transaction_enum.dart';

class TransactionModel {
  final String senderId;
  final String recieverId;
  final double amount;
  final String description;
  final TransactionEnum transactionType;
  final DateTime timestamp;

  TransactionModel({
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
      "transactionType": transactionType.type,
      "timestamp": timestamp.toIso8601String(),
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
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
