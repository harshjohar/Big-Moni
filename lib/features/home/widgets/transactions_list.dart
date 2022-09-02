import 'package:bigbucks/common/utils/utils.dart';
import 'package:bigbucks/features/profile/repository/profile_repository.dart';
import 'package:bigbucks/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TransactionList extends ConsumerStatefulWidget {
  final String uid;
  const TransactionList({Key? key, required this.uid}) : super(key: key);

  @override
  ConsumerState<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends ConsumerState<TransactionList> {
  final double total = 890;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ref
          .read(profileRepositoryProvider)
          .getUserSpecificTransactions(widget.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          final List<TransactionModel>? data =
              snapshot.data as List<TransactionModel>?;
          final total = accumulateTransactions(data, widget.uid);
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
                Flexible(
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final transaction = data![index];
                      final timestamp =
                          transaction.timestamp.toDate().toLocal();
                      DateFormat formatter =
                          DateFormat.yMMMMd('en_US').add_jm();
                      return ListTile(
                        leading: Text(
                          transaction.money.ceil().toString(),
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: (widget.uid == transaction.debtorId)
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                        subtitle: Text(
                          formatter.format(timestamp),
                        ),
                        title: Text(transaction.description),
                      );
                    },
                    itemCount: data?.length,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
