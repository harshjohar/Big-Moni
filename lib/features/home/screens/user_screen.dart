import 'package:bigbucks/colors.dart';
import 'package:bigbucks/common/screens/loader.dart';
import 'package:bigbucks/features/home/widgets/transactions_list.dart';
import 'package:bigbucks/features/profile/repository/profile_repository.dart';
import 'package:bigbucks/models/person.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserScreen extends ConsumerStatefulWidget {
  final String userUid;
  const UserScreen({Key? key, required this.userUid}) : super(key: key);

  static const String routeName = '/user-screen';

  @override
  ConsumerState<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends ConsumerState<UserScreen> {
  Future<Person?> getUserInfo(String userUid) async {
    return ref.read(profileRepositoryProvider).getUserDetails(userUid);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserInfo(widget.userUid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        Person userDetails = snapshot.data as Person;
        return Scaffold(
          appBar: AppBar(
            title: Text(userDetails.name),
            backgroundColor: CustomColors.blackColor,
          ),
          body: SingleChildScrollView(
            child: Padding(
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
                                height: 150,
                                width: 150,
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
                          ElevatedButton(
                            onPressed: () {
                              // TODO
                            },
                            child: const Text("Poke"),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "RECENT TRANSACTIONS",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  TransactionList(uid: widget.userUid),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
