import 'dart:io';

import 'package:bigbucks/models/transaction.dart';
import 'package:bigbucks/models/transaction_view_model.dart';
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

double accumulateTransactions(
    List<TransactionModel>? transactions, String debtorUID) {
  double answer = 0;
  if (transactions == null) return 0;
  for (var transaction in transactions) {
    if (debtorUID == transaction.debtorId) {
      answer += transaction.money;
    } else {
      answer -= transaction.money;
    }
  }
  return answer;
}

double accumulateHomeTransactions(List<TransactionViewModel>? transactions) {
  double answer = 0;
  if (transactions == null) {
    return 0;
  }
  for (var transaction in transactions) {
    answer += double.parse(transaction.money);
  }
  return answer;
}

Future<bool> connectivityChecker() async {
  var connected = false;
  try {
    final result = await InternetAddress.lookup('google.com');
    final result2 = await InternetAddress.lookup('facebook.com');
    final result3 = await InternetAddress.lookup('microsoft.com');
    if ((result.isNotEmpty && result[0].rawAddress.isNotEmpty) ||
        (result2.isNotEmpty && result2[0].rawAddress.isNotEmpty) ||
        (result3.isNotEmpty && result3[0].rawAddress.isNotEmpty)) {
      connected = true;
    } else {
      connected = false;
    }
  } on SocketException catch (_) {
    connected = false;
  }
  return connected;
}
