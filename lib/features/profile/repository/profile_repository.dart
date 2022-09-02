import 'package:bigbucks/models/person.dart';
import 'package:bigbucks/models/transaction.dart';
import 'package:bigbucks/models/transaction_view_model.dart';
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

  Stream<List<TransactionModel>?> getUserSpecificTransactions(String uid) {
    final hashedUID = (auth.currentUser!.uid.compareTo(uid) == -1
        ? auth.currentUser!.uid + uid
        : uid + auth.currentUser!.uid);

    return firestore
        .collection('userMappingTransactions')
        .doc(hashedUID)
        .snapshots()
        .asyncMap((transactionsIdDoc) async {
      final transactionIdList = transactionsIdDoc['transactions'];
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

      transactions.sort((b, a) {
        return (a.timestamp.compareTo(b.timestamp));
      });

      return transactions;
    });
  }

  Future<List<TransactionViewModel>?> getUserTransactions() async {
    final userTransactionsIds = await firestore
        .collection('userTransactions')
        .doc(auth.currentUser!.uid)
        .get();

    // all transactions of the logged in user
    List<TransactionModel> transactions = [];

    if (userTransactionsIds.data() != null) {
      final transactionsIdList = userTransactionsIds.data()!['transactions'];

      for (var transactionId in transactionsIdList) {
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
    }
    transactions.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    List<TransactionViewModel> userTransactions = [];

    for (var transaction in transactions) {
      if (transaction.debtorId == auth.currentUser!.uid) {
        final user = await firestore
            .collection('users')
            .doc(transaction.creditorId)
            .get();

        userTransactions.add(
          TransactionViewModel(
            name: user.data()!['name'],
            money: (-transaction.money).toString(),
            photoUrl: user.data()!['photoUrl'],
            otherUserUid: transaction.description,
          ),
        );
      } else {
        final user =
            await firestore.collection('users').doc(transaction.debtorId).get();
        userTransactions.add(
          TransactionViewModel(
            name: user.data()!['name'],
            money: transaction.money.toString(),
            photoUrl: user.data()!['photoUrl'],
            otherUserUid: transaction.description,
          ),
        );
      }
    }
    return userTransactions;
  }
}
