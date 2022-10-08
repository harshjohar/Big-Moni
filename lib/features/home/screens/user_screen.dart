import 'package:bigbucks/colors.dart';
import 'package:bigbucks/common/screens/loader.dart';
import 'package:bigbucks/features/home/controller/home_controller.dart';
import 'package:bigbucks/features/home/screens/add_user_transaction.dart';
import 'package:bigbucks/features/home/widgets/transactions_list.dart';
import 'package:bigbucks/features/profile/repository/profile_repository.dart';
import 'package:bigbucks/models/person.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum UserInteraction { debtor, creditor }

class UserScreen extends ConsumerStatefulWidget {
  final String userUid;
  final UserInteraction userInteraction;
  const UserScreen(
      {Key? key, required this.userUid, required this.userInteraction})
      : super(key: key);

  static const String routeName = '/user-screen';

  @override
  ConsumerState<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends ConsumerState<UserScreen> {
  late TextEditingController payBackText;
  bool loader = false;
  Future<Person?> getUserInfo(String userUid) async {
    return ref.read(profileRepositoryProvider).getUserDetails(userUid);
  }

  Future<String?> openDialog() => showDialog<String?>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("pay back"),
          content: TextField(
            autofocus: true,
            controller: payBackText,
            decoration: const InputDecoration(
              hintText: "199",
              label: Text("Enter Amount"),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(payBackText.text);
              },
              child: const Text("Submit"),
            )
          ],
        ),
      );

  @override
  void initState() {
    payBackText = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    payBackText.dispose();
    super.dispose();
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
          floatingActionButton: FloatingActionButton(
          backgroundColor: CustomColors.blackColor,
          onPressed: () {
            Navigator.of(context).pushNamed(AddUserTransactions.routeName, arguments: {'phoneNumber': userDetails.phoneNumber, 'name': userDetails.name,},);
          },
          child: const Icon(Icons.add),
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
                          if (widget.userInteraction == UserInteraction.debtor)
                            ElevatedButton(
                              onPressed: () async {
                                loader = true;
                                final amount = await openDialog();
                                if (amount != null) {
                                  // ignore: use_build_context_synchronously
                                  await ref
                                      .read(homeControllerProvider)
                                      .paidBack(context, widget.userUid,
                                          double.parse(amount));
                                }
                                loader = false;
                              },
                              child: loader
                                  ? const CircularProgressIndicator()
                                  : const Text("Paid"),
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
