import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String debitorId;
  final String creditorId;
  final double money;
  final String description;
  final FieldValue timestamp;

  TransactionModel({
    required this.debitorId,
    required this.creditorId,
    required this.description,
    required this.money,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'debitorId': debitorId,
      'creditorId': creditorId,
      'description': description,
      'money': money,
      'timestamp': timestamp,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      debitorId: map['debitorId'],
      creditorId: map['creditorId'],
      description: map['description'],
      money: map['money'],
      timestamp: map['timestamp'],
    );
  }
}
