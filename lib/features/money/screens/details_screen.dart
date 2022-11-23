import 'package:bigbucks/common/screens/loader.dart';
import 'package:bigbucks/features/money/controller/money_controller.dart';
import 'package:bigbucks/features/money/widgets/reciever_card.dart';
import 'package:bigbucks/features/money/widgets/sender_card.dart';
import 'package:bigbucks/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailsScreen extends ConsumerStatefulWidget {
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
  ConsumerState<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends ConsumerState<DetailsScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: StreamBuilder<List<TransactionModel>>(
        stream: ref.read(moneyControllerProvider).getTransactions(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text("No Transactions"));
          }
          SchedulerBinding.instance.addPostFrameCallback((_) {
            scrollController
                .jumpTo(scrollController.position.maxScrollExtent);
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
      ),
    );
  }
}
