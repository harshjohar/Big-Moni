import 'package:bigbucks/features/money/widgets/add_more_modal.dart';
import 'package:bigbucks/features/money/widgets/paid_back_modal.dart';
import 'package:bigbucks/features/money/widgets/transactions_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailsScreen extends ConsumerWidget {
  static const String routeName = '/details-screen';
  final String userId;
  final String name;
  final String photoUrl;

  const DetailsScreen({
    required this.userId,
    required this.name,
    required this.photoUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: TransactionList(
                userId: userId,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CupertinoButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (ctx) {
                          return AddMoreModal(
                            userId: userId,
                            name: name,
                            photoUrl: photoUrl,
                          );
                        });
                  },
                  child: const Text(
                    "Add More",
                  ),
                ),
                Container(
                  width: 1,
                  color: Colors.indigo,
                  height: 20,
                ),
                CupertinoButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (ctx) {
                          return PaidBackModal(
                            userId: userId,
                            name: name,
                            photoUrl: photoUrl,
                          );
                        });
                  },
                  child: const Text(
                    "Paid Back",
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
