import 'package:bigbucks/enums/transaction_enum.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecieverCard extends StatelessWidget {
  final double amount;
  final String description;
  final DateTime timestamp;
  final TransactionEnum type;

  const RecieverCard({
    Key? key,
    required this.type,
    required this.amount,
    required this.description,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
          minWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.indigo,
          margin: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 5,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type == TransactionEnum.credit
                      ? "Credit added"
                      : "Paid Back!",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Text(
                    '₹${amount >= 0 ? amount.ceil().toString() : (-amount.ceil()).toString()}',
                    style: TextStyle(
                      color: amount < 0 ? Colors.amber : Colors.indigo,
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                    ),
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    DateFormat.yMd().format(timestamp),
                    style: const TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
