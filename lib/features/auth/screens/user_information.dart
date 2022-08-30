import 'dart:io';

import 'package:bigbucks/colors.dart';
import 'package:bigbucks/common/utils/utils.dart';
import 'package:bigbucks/features/auth/provider/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserInformation extends ConsumerStatefulWidget {
  static const String routeName = '/user-information';
  const UserInformation({Key? key}) : super(key: key);

  @override
  ConsumerState<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends ConsumerState<UserInformation> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController upiController = TextEditingController();
  File? image;

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

    if (name.isNotEmpty && email.isNotEmpty) {
      ref.read(authControllerProvider).sendDataToFirebase(
            context,
            name,
            email,
            upiID,
            image,
          );
    }
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
                  Column(
                    children: [
                      Container(
                        width: size.width * 0.85,
                        padding: const EdgeInsets.all(20),
                        child: TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your name',
                            label: Text("Name"),
                          ),
                        ),
                      ),
                      Container(
                        width: size.width * 0.85,
                        padding: const EdgeInsets.all(20),
                        child: TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your email',
                            label: Text("Email"),
                          ),
                        ),
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
                    ],
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
