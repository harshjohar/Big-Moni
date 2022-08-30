import 'package:bigbucks/models/person.dart';
import 'package:bigbucks/models/transaction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileRepositoryProvider = Provider(
  (ref) => ProfileRepository(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
  ),
);

class ProfileRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  ProfileRepository(this.auth, this.firestore);

  Future<Person?> getLoggedInUserDetails() async {
    final personDetails =
        await firestore.collection('users').doc(auth.currentUser!.uid).get();

    return Person.fromMap(personDetails.data()!);
  }

  Future<Person?> getUserDetails(String uid) async {
    final userDetails = await firestore.collection('users').doc(uid).get();
    return Person.fromMap(userDetails.data()!);
  }

  Future<List<TransactionModel>?> getUserSpecificTransactions(
      String uid) async {
    final hashedUID = (auth.currentUser!.uid.compareTo(uid) == -1
        ? auth.currentUser!.uid + uid
        : uid + auth.currentUser!.uid);

    final transactionsIdDoc = (await firestore
            .collection('userMappingTransactions')
            .doc(hashedUID)
            .get())
        .data();

    final transactionIdList = transactionsIdDoc!['transactions'];
    print(transactionIdList);
    List<TransactionModel> transactions = [];
    for (var transactionId in transactionIdList) {
      final transaction = await firestore
          .collection("transaction")
          .doc(transactionId as String)
          .get();
      final transactionData = transaction.data();
      transactions.add(
        TransactionModel.fromMap(
          transactionData!,
        ),
      );
    }

    return transactions;
  }
}
