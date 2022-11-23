import 'package:bigbucks/features/money/controller/money_controller.dart';
import 'package:bigbucks/features/money/widgets/add_more_modal.dart';
import 'package:bigbucks/features/money/widgets/paid_back_modal.dart';
import 'package:bigbucks/features/money/widgets/transactions_list.dart';
import 'package:bigbucks/models/interaction.dart';
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
        centerTitle: false,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.amber,
              backgroundImage: NetworkImage(
                photoUrl.isNotEmpty
                    ? photoUrl
                    : "https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png",
              ),
              radius: 20,
            ),
            const SizedBox(
              width: 10,
            ),
            FittedBox(
              clipBehavior: Clip.hardEdge,
              fit: BoxFit.fitWidth,
              child: Text(
                name,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        actions: [
          StreamBuilder<Interaction>(
              stream: ref.read(moneyControllerProvider).getInteraction(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Align(
                    alignment: Alignment.center,
                    child: Container(),
                  );
                }
                if (snapshot.data == null) {
                  return Container();
                }
                final balance = snapshot.data!.balance;
                return Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: balance >= 0
                          ? Text(
                              balance.ceil().toString(),
                              style: TextStyle(
                                color:
                                    balance > 0 ? Colors.green : Colors.indigo,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            )
                          : Text(
                              (-balance).ceil().toString(),
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                    ));
              }),
        ],
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
