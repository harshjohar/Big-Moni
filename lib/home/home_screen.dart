import 'package:bigbucks/features/money/controller/money_controller.dart';
import 'package:bigbucks/features/money/widgets/InteractionsList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome back bitch!"),
      ),
      body: const InteractionsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(moneyControllerProvider).addTransaction(
                context: context,
                userId: 'Q33too2fAyOai3w6ztyU8CffQst2',
                userName: 'hihi',
                photoUrl: '',
                amount: 1500,
                description: 'peg',
              );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
