import 'package:bigbucks/colors.dart';
import 'package:bigbucks/common/screens/loader.dart';
import 'package:bigbucks/features/home/widgets/transactions_list.dart';
import 'package:bigbucks/features/landing/landing_screen.dart';
import 'package:bigbucks/features/profile/repository/profile_repository.dart';
import 'package:bigbucks/features/profile/widgets/user_transactions_list.dart';
import 'package:bigbucks/models/person.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static const String routeName = '/profile-screen';

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Future<Person?> getUserDetails() async {
    return ref.read(profileRepositoryProvider).getLoggedInUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          Person userDetails = snapshot.data as Person;
          return Scaffold(
            appBar: AppBar(
              title: Text(userDetails.name),
              backgroundColor: CustomColors.blackColor,
              actions: [
                IconButton(
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
                    icon: const Icon(Icons.power_settings_new))
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15.0,
                horizontal: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(9999),
                        child: userDetails.photoUrl != null
                            ? Image.network(
                                userDetails.photoUrl!,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "assets/images/user.png",
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                              ),
                      ),
                      Column(
                        children: [
                          Text(userDetails.phoneNumber),
                          userDetails.upiID != null
                              ? Text(userDetails.upiID!)
                              : const Text("No UPI Id"),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: UserTransactionList(),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
