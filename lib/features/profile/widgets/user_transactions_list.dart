import 'package:bigbucks/common/utils/utils.dart';
import 'package:bigbucks/features/profile/repository/profile_repository.dart';
import 'package:bigbucks/features/profile/widgets/list_person.dart';
import 'package:bigbucks/models/transaction_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserTransactionList extends ConsumerStatefulWidget {
  const UserTransactionList({Key? key}) : super(key: key);

  @override
  ConsumerState<UserTransactionList> createState() =>
      _UserTransactionListState();
}

class _UserTransactionListState extends ConsumerState<UserTransactionList> {
  Future<List<TransactionViewModel>?> getTransactions() {
    return ref.read(profileRepositoryProvider).getUserTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getTransactions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        } else {
          final List<TransactionViewModel>? data =
              snapshot.data as List<TransactionViewModel>?;
          final total = accumulateProfileTransactions(data);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Net balance",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      total.ceil().abs().toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: (total > 0 ? Colors.green : Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                "RECENT TRANSACTIONS",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(
                height: 400,
                child: ListView.builder(
                  // physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final transaction = data![index];
                    return ListPerson(
                      user: transaction.name,
                      money: double.parse(transaction.money) > 0
                          ? transaction.money
                          : transaction.money.substring(1),
                      type: double.parse(transaction.money) > 0
                          ? Type.credit
                          : Type.debt,
                      photoUrl: transaction.photoUrl,
                      otherUserId: transaction.otherUserUid,
                    );
                  },
                  itemCount: data?.length,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
