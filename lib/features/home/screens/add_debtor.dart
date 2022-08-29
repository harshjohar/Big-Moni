import 'package:bigbucks/colors.dart';
import 'package:bigbucks/features/home/controller/home_controller.dart';
import 'package:bigbucks/features/home/screens/contacts_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddScreen extends ConsumerStatefulWidget {
  const AddScreen({Key? key}) : super(key: key);
  static const String routeName = '/add-screen';
  @override
  ConsumerState<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends ConsumerState<AddScreen> {
  final _formKey = GlobalKey<FormState>();

  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _phoneNumberFocusNode = FocusNode();

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String phoneNumber = '';
    double price = 0;
    String description = '';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Debt"),
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
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: TextFormField(
                            onSaved: (newValue) {
                              phoneNumber = newValue!;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a contact';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: "Phone Number",
                            ),
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_priceFocusNode);
                            },
                            focusNode: _phoneNumberFocusNode,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(ContactScreen.routeName);
                          },
                          icon: const Icon(
                            Icons.contacts,
                            color: CustomColors.blackColor,
                          ),
                        ),
                      ],
                    ),
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
                          phoneNumber,
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
