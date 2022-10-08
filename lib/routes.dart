import 'package:bigbucks/common/screens/error_screen.dart';
import 'package:bigbucks/features/auth/screens/login_screen.dart';
import 'package:bigbucks/features/auth/screens/otp_screen.dart';
import 'package:bigbucks/features/auth/screens/user_information.dart';
import 'package:bigbucks/features/home/screens/add_debtor.dart';
import 'package:bigbucks/features/home/screens/add_user_transaction.dart';
import 'package:bigbucks/features/home/screens/contacts_screen.dart';
import 'package:bigbucks/features/home/screens/notifications_screen.dart';
import 'package:bigbucks/features/home/screens/user_screen.dart';
import 'package:bigbucks/features/home/widgets/list_person.dart';
import 'package:bigbucks/features/profile/screens/profile_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case (LoginScreen.routeName):
      return MaterialPageRoute(builder: (ctx) => const LoginScreen());
    case (AddScreen.routeName):
      return MaterialPageRoute(builder: (ctx) => const AddScreen());
    case (NotificationScreen.routeName):
      return MaterialPageRoute(builder: (ctx) => const NotificationScreen());
    case (ProfileScreen.routeName):
      return MaterialPageRoute(builder: (ctx) => const ProfileScreen());
    case (UserScreen.routeName):
      return MaterialPageRoute(builder: (ctx) {
        final args = settings.arguments as ListPersonArguments;
        return UserScreen(
          userUid: args.uid,
          userInteraction: args.userInteraction,
        );
      });
    case (ContactScreen.routeName):
      return MaterialPageRoute(builder: (ctx) => const ContactScreen());
    case (OTPScreen.routeName):
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (ctx) => OTPScreen(verificationId: verificationId),
      );
    case (UserInformation.routeName):
      return MaterialPageRoute(builder: (ctx) => const UserInformation());
    case (AddUserTransactions.routeName):
      final userDetails = settings.arguments as Map<String, String>;
      return MaterialPageRoute(
        builder: (ctx) => AddUserTransactions(
          userDetails['phoneNumber']!,
          userDetails['name']!,
        ),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(
            error: 'This page doesn\'t exist',
          ),
        ),
      );
  }
}
