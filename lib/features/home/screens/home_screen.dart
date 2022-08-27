import 'package:bigbucks/features/home/screens/add_debtor.dart';
import 'package:bigbucks/features/home/screens/notifications_screen.dart';
import 'package:bigbucks/features/home/widgets/creditors_list.dart';
import 'package:bigbucks/features/home/widgets/debtors_list.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Big Moni"),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Debtors",
              ),
              Tab(
                text: "Creditors",
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.add,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(AddScreen.routeName);
              },
            ),
          ],
          leading: IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.of(context).pushNamed(NotificationScreen.routeName);
            },
          ),
        ),
        body: TabBarView(
          children: [
            DebtorsList(),
            CreditorsList(),
          ],
        ),
      ),
    );
  }
}
