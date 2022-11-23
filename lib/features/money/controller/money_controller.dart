import 'package:bigbucks/features/auth/controllers/auth_controller.dart';
import 'package:bigbucks/features/money/repository/money_repository.dart';
import 'package:bigbucks/models/interaction.dart';
import 'package:bigbucks/models/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final moneyControllerProvider = Provider((ref) {
  final moneyRepository = ref.read(moneyRepositoryProvider);
  return MoneyController(ref, moneyRepository);
});

class MoneyController {
  final ProviderRef ref;
  final MoneyRepository moneyRepository;

  MoneyController(this.ref, this.moneyRepository);

  void addTransaction({
    required BuildContext context,
    required String userId,
    required String userName,
    required String photoUrl,
    required double amount,
    required String description,
  }) {
    ref.read(userProvider).whenData((user) {
      moneyRepository.addTransaction(
        context: context,
        userId: userId,
        userName: userName,
        photoUrl: photoUrl,
        amount: amount,
        description: description,
        sender: user!,
      );
    });
  }

  void payBackTransaction({
    required BuildContext context,
    required String userId,
    required String userName,
    required String photoUrl,
    required double amount,
  }) {
    ref.read(userProvider).whenData((user) {
      moneyRepository.payBackTransaction(
        context: context,
        userId: userId,
        userName: userName,
        photoUrl: photoUrl,
        amount: amount,
        sender: user!,
      );
    });
  }

  Stream<List<Interaction>> getInteractions() {
    return moneyRepository.getInteractions();
  }

  Stream<List<TransactionModel>> getTransactions(String userId) {
    return moneyRepository.getTransactions(userId);
  }
}
