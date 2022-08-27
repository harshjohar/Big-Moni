import 'package:bigbucks/features/home/screens/home_screen.dart';
import 'package:bigbucks/features/landing/landing_screen.dart';
import 'package:bigbucks/firebase_options.dart';
import 'package:bigbucks/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Big Moni',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo)
              .copyWith(secondary: Colors.amber)),
      home: const HomeScreen(),
      onGenerateRoute: (settings) => generateRoute(settings),
    );
  }
}