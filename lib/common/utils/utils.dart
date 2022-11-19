import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  return image;
}

String formatPhoneNumber(String phoneNumber) {
  phoneNumber = phoneNumber.replaceAll(" ", "");
  if (phoneNumber[0] == '0') {
    phoneNumber = phoneNumber.substring(1);
  }
  if (phoneNumber.contains("+91") == true) {
    return phoneNumber;
  }
  phoneNumber = "+91$phoneNumber";
  return phoneNumber;
}
