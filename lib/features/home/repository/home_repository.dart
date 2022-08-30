import 'package:bigbucks/common/utils/utils.dart';
import 'package:bigbucks/models/transaction.dart';
import 'package:bigbucks/models/transaction_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeRepositoryProvider = Provider(
  (ref) => HomeRespository(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
  ),
);

class HomeRespository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  Map<String, double> currStatusAmongUsers = {};

  List<TransactionViewModel> debtors = [];
  List<TransactionViewModel> creditors = [];
  HomeRespository(this.auth, this.firestore);

  void addTransactionDebt(BuildContext context, String phoneNumber,
      double price, String description) async {
    final uid = auth.currentUser!.uid;
    try {
      final debtorUidDoc = await firestore
          .collection('users')
          .where(
            'phoneNumber',
            isEqualTo: phoneNumber,
          )
          .get();

      if (debtorUidDoc.docs.isNotEmpty) {
        final debtorUid = debtorUidDoc.docs[0].id;

        var transaction = TransactionModel(
          debtorId: debtorUid,
          creditorId: uid,
          description: description,
          money: price,
          timestamp: Timestamp.now(),
        );

        final addedTransaction =
            await firestore.collection("transaction").add(transaction.toMap());

        await firestore.collection("userTransactions").doc(uid).set(
          {
            'transactions': FieldValue.arrayUnion(
              [addedTransaction.id],
            ),
          },
          SetOptions(
            merge: true,
          ),
        );

        await firestore.collection("userTransactions").doc(debtorUid).set(
          {
            'transactions': FieldValue.arrayUnion(
              [addedTransaction.id],
            ),
          },
          SetOptions(
            merge: true,
          ),
        );

        final hashedUID = (uid.compareTo(debtorUid) == -1
            ? uid + debtorUid
            : debtorUid + uid);

        await firestore
            .collection('userMappingTransactions')
            .doc(hashedUID)
            .set(
          {
            'transactions': FieldValue.arrayUnion(
              [addedTransaction.id],
            ),
          },
          SetOptions(
            merge: true,
          ),
        );
      } else {
        showSnackBar(
          context: context,
          content: "Enter a valid phone number.",
        );
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  Future<void> getTransactionsUser() async {
    final userTransactions = await firestore
        .collection('userTransactions')
        .doc(auth.currentUser!.uid)
        .get();

    // all transactions of the logged in user
    List<TransactionModel> transactions = [];

    // creditorId == userId => moni++
    // debtorId == userId => moni--

    if (userTransactions.data() != null) {
      final transactionsIdList = userTransactions.data()!['transactions'];

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

    currStatusAmongUsers = {};
    for (var transaction in transactions) {
      if (transaction.creditorId == auth.currentUser!.uid) {
        if (currStatusAmongUsers.containsKey(transaction.debtorId) &&
            currStatusAmongUsers[transaction.debtorId] != null) {
          double t = currStatusAmongUsers[transaction.debtorId]!;
          t = t - transaction.money;
          currStatusAmongUsers[transaction.debtorId] = t;
        } else {
          currStatusAmongUsers[transaction.debtorId] = -transaction.money;
        }
      } else {
        if (currStatusAmongUsers.containsKey(transaction.creditorId) &&
            currStatusAmongUsers[transaction.creditorId] != null) {
          double t = currStatusAmongUsers[transaction.creditorId]!;
          t = t + transaction.money;
          currStatusAmongUsers[transaction.creditorId] = t;
        } else {
          currStatusAmongUsers[transaction.creditorId] = transaction.money;
        }
      }
    }
  }

  Future<List<TransactionViewModel>?> getDebtors() async {
    debtors = [];
    for (var key in currStatusAmongUsers.keys) {
      // key = otherUserUid, value = balance(money)
      final value = currStatusAmongUsers[key]!;
      if (value < 0) {
        final userDetails =
            (await firestore.collection('users').doc(key).get()).data();
        TransactionViewModel t = TransactionViewModel(
          name: userDetails!['name'],
          money: (-value).toString(),
          photoUrl: userDetails['photoUrl'],
          otherUserUid: key,
        );

        debtors.add(t);
      }
    }
    return debtors;
  }

  Future<List<TransactionViewModel>?> getCreditors() async {
    creditors = [];
    for (var key in currStatusAmongUsers.keys) {
      // key = otherUserUid, value = balance(money)
      final value = currStatusAmongUsers[key]!;
      if (value > 0) {
        final userDetails =
            (await firestore.collection('users').doc(key).get()).data();
        TransactionViewModel t = TransactionViewModel(
          name: userDetails!['name'],
          money: value.toString(),
          photoUrl: userDetails['photoUrl'],
          otherUserUid: key,
        );

        creditors.add(t);
      }
    }
    return creditors;
  }
}
