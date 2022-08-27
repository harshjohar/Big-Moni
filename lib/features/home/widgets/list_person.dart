import 'package:bigbucks/models/person.dart';
import 'package:flutter/material.dart';

enum Type { debit, credit }

class ListPerson extends StatelessWidget {
  final Person user;
  final double money;
  final Type type;
  const ListPerson({
    Key? key,
    required this.user,
    required this.money,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: const BoxDecoration(
          border: Border(
        bottom: BorderSide(width: 1.0, color: Colors.indigo),
      )),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: user.photoUrl != null
                ? Image.network(
                    user.photoUrl!,
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    "assets/images/user.png",
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
              child: Text(
            user.name,
            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          )),
          Text(
            money.ceil().toString(),
            style: TextStyle(
              color: type == Type.debit ? Colors.green : Colors.red,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            width: 30,
          ),
        ],
      ),
    );
  }
}
