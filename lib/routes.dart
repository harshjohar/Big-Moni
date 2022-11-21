import 'package:bigbucks/common/screens/error_screen.dart';
import 'package:bigbucks/features/auth/screens/login_screen.dart';
import 'package:bigbucks/features/auth/screens/otp_screen.dart';
import 'package:bigbucks/features/auth/screens/user_information_screen.dart';
import 'package:bigbucks/features/select_contacts/screens/select_contact_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (ctx) => const LoginScreen());
    case (OTPScreen.routeName):
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (ctx) => OTPScreen(verificationId: verificationId),
      );
    case (UserInformationScreen.routeName):
      return MaterialPageRoute(builder: (ctx) => const UserInformationScreen());
    case (SelectContactScreen.routeName):
      return MaterialPageRoute(builder: (ctx) => const SelectContactScreen());
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(
            error: 'This page does not exist',
          ),
        ),
      );
  }
}
