import 'package:bigbucks/features/home/repository/home_repository.dart';
import 'package:bigbucks/models/transaction_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeControllerProvider = Provider((ref) {
  final homeRepository = ref.watch(homeRepositoryProvider);
  return HomeController(homeRepository, ref);
});

class HomeController {
  final HomeRespository homeRespository;
  final ProviderRef ref;

  HomeController(this.homeRespository, this.ref);

  void addTransactionDebt(BuildContext context, String phoneNumber,
      double price, String description) {
    homeRespository.addTransactionDebt(
      context,
      phoneNumber,
      price,
      description,
    );
  }

  Future<void> paidBack(BuildContext context, String uid, double price) {
    return homeRespository.paidBack(context, uid, price);
  }

  Future<List<TransactionViewModel>?> getCreditors() async {
    List<TransactionViewModel>? creditors =
        await homeRespository.getCreditors();
    return creditors;
  }

  Future<List<TransactionViewModel>?> getDebtors() async {
    List<TransactionViewModel>? debtors = await homeRespository.getDebtors();
    return debtors;
  }

  Future<void> getUserTransactions() async {
    return await homeRespository.getTransactionsUser();
  }
}
