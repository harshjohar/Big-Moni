import 'package:bigbucks/features/money/widgets/interactions_list.dart';
import 'package:bigbucks/features/select_contacts/screens/select_contact_screen.dart';
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
          Navigator.of(context).pushNamed(SelectContactScreen.routeName);
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
