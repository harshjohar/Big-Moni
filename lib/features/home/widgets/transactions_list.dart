import 'package:bigbucks/features/home/widgets/transactions.dart';
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

  Future<List<TransactionModel>?> getTransactions() async {
    return ref
        .read(profileRepositoryProvider)
        .getUserSpecificTransactions(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
            child: FutureBuilder(
              future: getTransactions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const CircularProgressIndicator();
                } else {
                  final List<TransactionModel>? data =
                      snapshot.data as List<TransactionModel>?;
                  return ListView.builder(
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
                          transaction.money.toString(),
                          style: const TextStyle(
                            fontSize: 26,
                          ),
                        ),
                        subtitle: Text(
                          formatter.format(timestamp),
                        ),
                        title: Text(transaction.description),
                      );
                    },
                    itemCount: data?.length,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
