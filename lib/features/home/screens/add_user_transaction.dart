import 'package:bigbucks/colors.dart';
import 'package:bigbucks/common/utils/utils.dart';
import 'package:bigbucks/features/home/controller/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddUserTransactions extends ConsumerStatefulWidget {
  final String phoneNumber;
  final String name;
  const AddUserTransactions(this.phoneNumber, this.name, {Key? key}) : super(key: key);
  static const String routeName = '/add-user-transaction';
  @override
  ConsumerState<AddUserTransactions> createState() => _AddUserTransactionsState();
}

class _AddUserTransactionsState extends ConsumerState<AddUserTransactions> {
  final _formKey = GlobalKey<FormState>();

  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double price = 0;
    String description = '';

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Debt for ${widget.name}"),
        backgroundColor: CustomColors.blackColor,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Price',
                      ),
                      onSaved: (newValue) {
                        price = double.parse(newValue!);
                      },
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.parse(value) <= 0) {
                          return 'Please input a valid price';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocusNode,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      onSaved: (newValue) {
                        description = newValue!;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Description is required';
                        }
                        return null;
                      },
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      focusNode: _descriptionFocusNode,
                    ),
                  ],
                ),
              ),
              CupertinoButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    ref.read(homeControllerProvider).addTransactionDebt(
                          context,
                          formatPhoneNumber(widget.phoneNumber),
                          price,
                          description,
                        );
                  }
                },
                color: CustomColors.blackColor,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
