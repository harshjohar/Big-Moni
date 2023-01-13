import 'package:bigbucks/common/screens/error_screen.dart';
import 'package:bigbucks/common/screens/loader.dart';
import 'package:bigbucks/features/auth/controllers/auth_controller.dart';
import 'package:bigbucks/features/landing/landing_screen.dart';
import 'package:bigbucks/firebase_options.dart';
import 'package:bigbucks/home/home_screen.dart';
import 'package:bigbucks/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: BigBucks(),
    ),
  );
}

class BigBucks extends ConsumerStatefulWidget {
  const BigBucks({Key? key}) : super(key: key);

  @override
  ConsumerState<BigBucks> createState() => _BigBucksState();
}

class _BigBucksState extends ConsumerState<BigBucks> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Big Moni',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.indigo,
        ).copyWith(
          secondary: Colors.amber,
        ),
      ),
      home: ref.watch(userProvider).when(data: (user) {
        if (user == null) return const LandingScreen();
        return const HomeScreen();
      }, error: (error, trace) {
        return ErrorScreen(
          error: error.toString(),
        );
      }, loading: () {
        return const Loader();
      }),
      onGenerateRoute: (settings) => generateRoute(settings),
    );
  }
}