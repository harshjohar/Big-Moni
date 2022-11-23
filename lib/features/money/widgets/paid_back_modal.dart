import 'package:bigbucks/common/utils/utils.dart';
import 'package:bigbucks/features/money/controller/money_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaidBackModal extends ConsumerStatefulWidget {
  final String userId;
  final String name;
  final String photoUrl;

  const PaidBackModal({
    Key? key,
    required this.userId,
    required this.name,
    required this.photoUrl,
  }) : super(key: key);

  @override
  ConsumerState<PaidBackModal> createState() => _PaidBackModalState();
}

class _PaidBackModalState extends ConsumerState<PaidBackModal> {
  final TextEditingController amountController = TextEditingController();

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  void _addTransaction() {
    if (amountController.text.trim().isEmpty) {
      showSnackBar(context: context, content: "Amount cannot be empty.");
      return;
    }

    if (double.parse(amountController.text.trim()) < 0) {
      showSnackBar(context: context, content: "Please enter a valid amount.");
      return;
    }
    ref.read(moneyControllerProvider).payBackTransaction(
      context: context,
      userId: widget.userId,
      userName: widget.name,
      photoUrl: widget.photoUrl,
      amount: double.parse(amountController.text.trim()),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Add More Debt to ${widget.name}",
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          TextField(
            controller: amountController,
            decoration: const InputDecoration(
              hintText: "Amount",
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CupertinoButton.filled(
              onPressed: _addTransaction,
              child: const Text("Submit"),
            ),
          ),
        ],
      ),
    );
  }
}
