import 'package:bigbucks/features/home/widgets/transactions_list.dart';
import 'package:bigbucks/models/person.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  final Person user;
  const UserScreen({Key? key, required this.user}) : super(key: key);
  static const String routeName = '/user-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(9999),
                    child: user.photoUrl != null
                        ? Image.network(
                            user.photoUrl!,
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
                      Text(user.phoneNumber),
                      user.upiID != null
                          ? Text(user.upiID!)
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
              const TransactionList(),
            ],
          ),
        ),
      ),
    );
  }
}
