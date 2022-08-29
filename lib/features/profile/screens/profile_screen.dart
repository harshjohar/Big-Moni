import 'package:bigbucks/colors.dart';
import 'package:bigbucks/features/landing/landing_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static const String routeName = '/profile-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: CustomColors.blackColor,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (ctx) => const LandingScreen(),
              ),
              (route) => false,
            );
            FirebaseAuth.instance.signOut();
          },
          child: const Text("Logout"),
        ),
      ),
    );
  }
}
