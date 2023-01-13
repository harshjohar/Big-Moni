import 'package:bigbucks/features/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff272727),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Track, Organize and keep records \nwith",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xffECE6DB),
              fontSize: 25,
              fontStyle: FontStyle.italic,
            ),
          ),
          Image.asset("assets/images/bigmoni.png"),
          TextButton(
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.routeName);
              },
              child: const Text(
                "Get started!",
                style: TextStyle(fontSize: 18, color: Color(0xffECE6DB)),
              )),
        ],
      ),
    );
  }
}
