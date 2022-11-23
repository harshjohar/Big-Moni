import 'package:bigbucks/common/utils/utils.dart';
import 'package:bigbucks/enums/transaction_enum.dart';
import 'package:bigbucks/models/interaction.dart';
import 'package:bigbucks/models/transaction.dart';
import 'package:bigbucks/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final moneyRepositoryProvider = Provider(
  (ref) => MoneyRepository(
    FirebaseFirestore.instance,
    FirebaseAuth.instance,
    ref,
  ),
);

class MoneyRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  MoneyRepository(this.firestore, this.auth, this.ref);

  void _saveToInteractionSubCollection({
    required String name,
    required String photoUrl,
    required DateTime timestamp,
    required String userId,
    required String description,
    required double amount,
    required UserModel sender,
  }) async {
    Interaction interaction = Interaction(
      name: name,
      photoUrl: photoUrl,
      timestamp: timestamp,
      userId: userId,
      lastTransactionDescription: description,
      balance: amount,
    );
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('interactions')
        .doc(userId)
        .set({
      ...interaction.toJson(),
      'balance': FieldValue.increment(amount),
    }, SetOptions(merge: true));
    Interaction interactionReverse = Interaction(
      name: sender.name,
      photoUrl: sender.photoUrl ?? "",
      timestamp: timestamp,
      balance: amount,
      userId: auth.currentUser!.uid,
      lastTransactionDescription: description,
    );
    await firestore
        .collection('users')
        .doc(userId)
        .collection('interactions')
        .doc(auth.currentUser!.uid)
        .set({
      ...interactionReverse.toJson(),
      'balance': FieldValue.increment(-amount),
    }, SetOptions(merge: true));
  }

  void _saveToTransactionSubCollection({
    required String userId,
    required String description,
    required double amount,
    required TransactionEnum type,
    required String transactionId,
  }) async {
    TransactionModel transaction = TransactionModel(
      senderId: auth.currentUser!.uid,
      recieverId: userId,
      amount: amount,
      description: description,
      transactionType: type,
      timestamp: DateTime.now(),
    );

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('interactions')
        .doc(userId)
        .collection('transactions')
        .doc(transactionId)
        .set(
          transaction.toJson(),
        );

    await firestore
        .collection('users')
        .doc(userId)
        .collection('interactions')
        .doc(auth.currentUser!.uid)
        .collection('transactions')
        .doc(transactionId)
        .set(
          transaction.toJson(),
        );
  }

  Future<void> addTransaction({
    required BuildContext context,
    required String userId,
    required String userName,
    required String photoUrl,
    required double amount,
    required String description,
    required UserModel sender,
  }) async {
    try {
      DateTime timestamp = DateTime.now();
      // UserModel reciever;
      // var userDataMap = await firestore.collection('users').doc(userId).get();
      // reciever = UserModel.fromJson(userDataMap.data()!);
      _saveToInteractionSubCollection(
        name: userName,
        photoUrl: photoUrl,
        timestamp: timestamp,
        userId: userId,
        description: description,
        amount: amount,
        sender: sender,
      );

      var transactionId = const Uuid().v1();

      _saveToTransactionSubCollection(
        userId: userId,
        description: description,
        amount: amount,
        type: TransactionEnum.credit,
        transactionId: transactionId,
      );
      showSnackBar(context: context, content: "Added");
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }

  Future<void> payBackTransaction({
    required BuildContext context,
    required String userId,
    required String userName,
    required String photoUrl,
    required double amount,
    required UserModel sender,
  }) async {
    try {
      DateTime timestamp = DateTime.now();
      // UserModel reciever;
      // var userDataMap = await firestore.collection('users').doc(userId).get();
      // reciever = UserModel.fromJson(userDataMap.data()!);
      _saveToInteractionSubCollection(
        name: userName,
        photoUrl: photoUrl,
        timestamp: timestamp,
        userId: userId,
        description: "Paid Back!",
        amount: -amount,
        sender: sender,
      );

      var transactionId = const Uuid().v1();

      _saveToTransactionSubCollection(
        userId: userId,
        description: "Paid Back!",
        amount: -amount,
        type: TransactionEnum.debit,
        transactionId: transactionId,
      );
      showSnackBar(context: context, content: "Added");
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }

  Stream<List<Interaction>> getInteractions() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('interactions')
        .orderBy(
          'timestamp',
          descending: true,
        )
        .snapshots()
        .asyncMap((event) {
      List<Interaction> interactions = [];
      for (var document in event.docs) {
        Interaction interaction = Interaction.fromJson(document.data());
        interactions.add(interaction);
      }
      return interactions;
    });
  }

  Stream<Interaction> getInteraction(String userId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('interactions')
        .doc(userId)
        .snapshots()
        .asyncMap((event) {
        Interaction interaction = Interaction.fromJson(event.data()!);
      return interaction;
    });
  }

  Stream<List<TransactionModel>> getTransactions(String userId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('interactions')
        .doc(userId)
        .collection('transactions')
        .orderBy('timestamp')
        .snapshots()
        .asyncMap(
      (event) {
        List<TransactionModel> transactions = [];
        for (var document in event.docs) {
          TransactionModel transaction =
              TransactionModel.fromJson(document.data());
          transactions.add(transaction);
        }
        return transactions;
      },
    );
  }
}
