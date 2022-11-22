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
        title: const Text("Welcome back!"),
      ),
      body: const InteractionsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(moneyControllerProvider).addTransaction(
                context: context,
                userId: 'L6Jw4G8bBBW0CrifhHf98iwuByf1',
                userName: 'Manjit',
                photoUrl: '',
                amount: -1500,
                description: 'peg',
              );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
