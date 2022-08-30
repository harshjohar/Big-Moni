import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String debtorId;
  final String creditorId;
  final double money;
  final String description;
  final Timestamp timestamp;

  TransactionModel({
    required this.debtorId,
    required this.creditorId,
    required this.description,
    required this.money,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'debtorId': debtorId,
      'creditorId': creditorId,
      'description': description,
      'money': money,
      'timestamp': timestamp,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      debtorId: map['debtorId'],
      creditorId: map['creditorId'],
      description: map['description'],
      money: map['money'],
      timestamp: map['timestamp'],
    );
  }
}
