import 'package:bigbucks/features/home/widgets/list_person.dart';
import 'package:bigbucks/models/person.dart';
import 'package:flutter/material.dart';

class DebtorsList extends StatelessWidget {
  DebtorsList({Key? key}) : super(key: key);

  final total = 6789;
  final hermione = Person(
    name: "Emma watson",
    phoneNumber: "3287462334",
    photoUrl:
        "https://media.glamour.com/photos/62c451524cef9e141c95d93f/master/w_2560%2Cc_limit/1406845793",
  );
  final gwen = Person(
    name: "Emma Stone",
    phoneNumber: "4762384234",
    upiID: "emmastone@okhdfcbank",
    photoUrl:
        "https://media.vanityfair.com/photos/55a674affff2c16856a6bd85/1:1/w_957,h_638,c_limit/emma-stone-aloha-miscast.jpg",
  );
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  total.toString(),
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          ListPerson(
            money: 20,
            user: gwen,
            type: Type.debit,
          ),
          ListPerson(
            money: 20,
            user: hermione,
            type: Type.debit,
          ),
        ],
      ),
    );
  }
}
