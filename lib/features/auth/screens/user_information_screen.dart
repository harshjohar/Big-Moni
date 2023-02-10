import 'dart:io';

import 'package:bigbucks/colors.dart';
import 'package:bigbucks/common/utils/utils.dart';
import 'package:bigbucks/features/auth/controllers/auth_controller.dart';
import 'package:bigbucks/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  static const String routeName = '/user-information';

  const UserInformationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UserInformationScreen> createState() => _UserInformationState();
}

class _UserInformationState extends ConsumerState<UserInformationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController upiController = TextEditingController();
  File? image;

  // text field state
  final _formKey = GlobalKey<FormState>();
  String nameError = '';
  String emailError = '';

  bool isLoading = false;
  UserModel? userModel;

  void getPerson() async {
    UserModel? p = await ref.read(authControllerProvider).getUserData();
    setState(() {
      userModel = p;
    });
    if (userModel != null) {
      emailController.text = userModel!.email!;
      nameController.text = userModel!.name;
      upiController.text = userModel!.upiID!;
    }
  }

  @override
  void initState() {
    getPerson();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    upiController.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void storeUserData() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String upiID = upiController.text.trim();
    if (_formKey.currentState!.validate()) {
      if (nameError != '' || emailError != '') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in the required fields')),
        );
      } else {
        return null;
      }
    }
    setState(() {
      isLoading = true;
    });

    if (name.isNotEmpty && email.isNotEmpty) {
      ref.read(authControllerProvider).saveUserData(
            context,
            name,
            image,
            email,
            upiID,
          );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Details"),
        backgroundColor: CustomColors.blackColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      image == null
                          ? const CircleAvatar(
                              backgroundImage: NetworkImage(
                                'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
                              ),
                              radius: 64,
                            )
                          : CircleAvatar(
                              backgroundImage: FileImage(
                                image!,
                              ),
                              radius: 64,
                            ),
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(
                            Icons.add_a_photo,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          width: size.width * 0.85,
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                          child: TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              hintText: 'Enter your name',
                              label: Text("Name"),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                setState(() {
                                  nameError = 'Required';
                                });
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                nameError = ''; // Resets the error
                              });
                            },
                          ),
                        ),
                        Text(
                          nameError,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.deepOrange),
                        ),
                        Container(
                          width: size.width * 0.85,
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                          child: TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              hintText: 'Enter your email',
                              label: Text("Email"),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                setState(() {
                                  emailError = 'Required';
                                });
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                emailError = ''; // Resets the error
                              });
                            },
                          ),
                        ),
                        Text(
                          emailError,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.deepOrange),
                        ),
                        Container(
                          width: size.width * 0.85,
                          padding: const EdgeInsets.all(20),
                          child: TextField(
                            controller: upiController,
                            decoration: const InputDecoration(
                              hintText: 'UPI ID',
                              label: Text(
                                "UPI ID (if applicable)",
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          "If you have no UPI ID, then can leave this field empty",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        CupertinoButton(
                          onPressed: storeUserData,
                          child: const Text("Submit"),
                        ),
                        if (isLoading) const CircularProgressIndicator(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
