import 'package:bigbucks/common/screens/loader.dart';
import 'package:bigbucks/features/money/controller/money_controller.dart';
import 'package:bigbucks/features/money/widgets/reciever_card.dart';
import 'package:bigbucks/features/money/widgets/sender_card.dart';
import 'package:bigbucks/models/transaction.dart';
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
      body: StreamBuilder<List<TransactionModel>>(
        stream: ref.read(moneyControllerProvider).getTransactions(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text("No Transactions"));
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              TransactionModel cardData = snapshot.data![index];
              if (cardData.senderId == userId) {
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
