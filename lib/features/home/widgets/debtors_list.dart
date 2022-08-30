import 'package:bigbucks/common/utils/utils.dart';
import 'package:bigbucks/features/home/controller/home_controller.dart';
import 'package:bigbucks/features/home/widgets/list_person.dart';
import 'package:bigbucks/models/transaction_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DebtorsList extends ConsumerStatefulWidget {
  const DebtorsList({Key? key}) : super(key: key);

  @override
  ConsumerState<DebtorsList> createState() => _DebtorsListState();
}

class _DebtorsListState extends ConsumerState<DebtorsList> {
  Future<List<TransactionViewModel>?> getDebtors() async {
    List<TransactionViewModel>? debtors =
        await ref.read(homeControllerProvider).getDebtors();
    return debtors;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getDebtors(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        } else {
          final List<TransactionViewModel>? data =
              snapshot.data as List<TransactionViewModel>?;
          final total = accumulateHomeTransactions(data);
          return SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        total.toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final person = data![index];
                      // ListPerson(user: debtors, money: money, type: type)
                      return ListPerson(
                        user: person.name,
                        money: person.money,
                        type: Type.debt,
                        photoUrl: person.photoUrl,
                        otherUserId: person.otherUserUid,
                      );
                    },
                    itemCount: data?.length,
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
