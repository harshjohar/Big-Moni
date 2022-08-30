import 'package:bigbucks/features/home/widgets/transactions.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({Key? key}) : super(key: key);
  final double total = 890;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
          const TransactionItem(),
        ],
      ),
    );
  }
}
