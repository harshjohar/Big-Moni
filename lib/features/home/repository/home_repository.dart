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
          debitorId: debtorUid,
          creditorId: uid,
          description: description,
          money: price,
          timestamp: FieldValue.serverTimestamp(),
        );

        final addedTransaction =
            await firestore.collection("transaction").add(transaction.toMap());

        final hashedId =
            (uid.compareTo(debtorUid) < -1 ? uid + debtorUid : debtorUid + uid);
        await firestore.collection("creditDebitMapping").doc(hashedId).set(
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

  Future<List<TransactionViewModel>?> getDebtors() async {
    final transactions = await firestore.collection('transactions').get();
    // TODO
    List<TransactionViewModel>? creditors = [];
    return creditors;
  }

  Future<List<TransactionViewModel>?> getCreditors() async {
    final transactions = await firestore.collection('transactions').get();
    // TODO
    List<TransactionViewModel>? debtors = [];
    return debtors;
  }
}
