import 'package:bigbucks/features/money/controller/money_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddMoreModal extends ConsumerStatefulWidget {
  final String userId;
  final String name;
  final String photoUrl;

  const AddMoreModal({
    Key? key,
    required this.userId,
    required this.name,
    required this.photoUrl,
  }) : super(key: key);

  @override
  ConsumerState<AddMoreModal> createState() => _AddMoreModalState();
}

class _AddMoreModalState extends ConsumerState<AddMoreModal> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _addTransaction() {
    final isValid = _formKey.currentState?.validate();
    if (!(isValid as bool)) {
      return;
    }

    ref.read(moneyControllerProvider).addTransaction(
          context: context,
          userId: widget.userId,
          userName: widget.name,
          photoUrl: widget.photoUrl,
          amount: double.parse(amountController.text.trim()),
          description: descriptionController.text.trim(),
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.of(context).viewInsets.bottom + 10,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Add More Debt to ${widget.name}",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                controller: amountController,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: false,
                ),
                validator: ((value) {
                  if (value!.trim().isEmpty) {
                    return "Amount cannot be empty";
                  }
                  if (double.tryParse(value.trim()) == null) {
                    return "Please enter a valid amount";
                  }
                  if (double.parse(value.trim()) <= 0) {
                    return "Please enter a valid amount";
                  }
                  if (double.parse(value.trim()) >= 10000) {
                    return "Who are you dealing with? You dont need this app if you got this much money.";
                  }
                  return null;
                }),
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: "Amount",
                ),
              ),
              TextFormField(
                controller: descriptionController,
                onFieldSubmitted: (_) => _addTransaction(),
                decoration: const InputDecoration(
                  hintText: "Description",
                ),
                validator: ((value) {
                  if (value!.trim().isEmpty) {
                    return "Description cannot be empty";
                  }
                  return null;
                }),
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
        ),
      ),
    );
  }
}
