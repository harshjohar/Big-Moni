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
      } else {
        showSnackBar(
          context: context,
          content: "Enter a valid phone number.",
        );
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }

    Navigator.of(context).pop();
  }

  Future<void> getTransactionsUser() async {
    final userTransactions = await firestore
        .collection('userTransactions')
        .doc(auth.currentUser!.uid)
        .get();

    List<TransactionModel> transactions = [];

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
  }

  Future<List<TransactionViewModel>?> getDebtors() async {
    TransactionViewModel t = TransactionViewModel(
      name: "Jolie",
      money: "304",
      photoUrl:
          "https://deadline.com/wp-content/uploads/2022/03/Angelina-Jolie-photo-Netflix-Alexei-Hay-e1646407877581.jpeg",
      otherUserUid: "lol",
    );
    List<TransactionViewModel>? debtors = [t];
    // TODO
    return debtors;
  }

  Future<List<TransactionViewModel>?> getCreditors() async {
    TransactionViewModel t = TransactionViewModel(
      name: "Rachel",
      money: "304",
      photoUrl:
          "https://media1.popsugar-assets.com/files/thumbor/ptdgPx5tCvvD9kUsU7pQFMUkBIA/207x134:1865x1792/fit-in/2048xorig/filters:format_auto-!!-:strip_icc-!!-/2019/09/09/028/n/1922398/066318895d76e2ef0c31d8.46065434_/i/Jennifer-Aniston.jpg",
      otherUserUid: "lol",
    );
    // TODO
    List<TransactionViewModel>? creditors = [t];
    return creditors;
  }
}
