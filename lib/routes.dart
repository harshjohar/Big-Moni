import 'package:bigbucks/common/error_screen.dart';
import 'package:bigbucks/features/auth/screens/login_screen.dart';
import 'package:bigbucks/features/home/screens/add_debtor.dart';
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
        final args = settings.arguments as UserArguments;
        return UserScreen(user: args.user);
      });
    case (ContactScreen.routeName):
      return MaterialPageRoute(builder: (ctx) => const ContactScreen());
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
