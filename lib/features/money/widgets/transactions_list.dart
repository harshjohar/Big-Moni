import 'package:bigbucks/common/screens/loader.dart';
import 'package:bigbucks/features/money/controller/money_controller.dart';
import 'package:bigbucks/features/money/widgets/reciever_card.dart';
import 'package:bigbucks/features/money/widgets/sender_card.dart';
import 'package:bigbucks/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionList extends ConsumerStatefulWidget {
  const TransactionList({
    Key? key,
    required this.userId,
  }) : super(key: key);

  final String userId;

  @override
  ConsumerState<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends ConsumerState<TransactionList> {
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TransactionModel>>(
      stream: ref.read(moneyControllerProvider).getTransactions(widget.userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const Center(child: Text("No Transactions"));
        }
        SchedulerBinding.instance.addPostFrameCallback((_) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        });
        return ListView.builder(
          controller: scrollController,
          shrinkWrap: true,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            TransactionModel cardData = snapshot.data![index];
            if (cardData.senderId == widget.userId) {
              return RecieverCard(
                type: cardData.transactionType,
                amount: cardData.amount,
                description: cardData.description,
                timestamp: cardData.timestamp,
              );
            }
            return SenderCard(
              type: cardData.transactionType,
              amount: cardData.amount,
              description: cardData.description,
              timestamp: cardData.timestamp,
            );
          },
        );
      },
    );
  }
}
