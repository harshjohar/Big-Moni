import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MoneyRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  MoneyRepository(this.firestore, this.auth, this.ref);

  void _saveToInteractionSubCollection() {
    // TODO
  }

  void _saveToTransactionSubCollection() {
    // TODO
  }

  Future<void> addTransaction({
    required String userId,
    required String userName,
    required double amount,
    required String description,
  }) async {

  }
}
