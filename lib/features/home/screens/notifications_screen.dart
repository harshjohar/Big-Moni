import 'package:bigbucks/colors.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);
  static const String routeName = "/notification-screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: CustomColors.blackColor,
      ),
      body: const Center(child: Text("Feature coming soon, Stay tuned.")),
    );
  }
}
