import 'package:bigbucks/colors.dart';
import 'package:flutter/material.dart';

enum Type { debt, credit }

class ListPerson extends StatelessWidget {
  final String user;
  final String money;
  final Type type;
  final String photoUrl;
  final String otherUserId;
  const ListPerson({
    Key? key,
    required this.user,
    required this.money,
    required this.type,
    required this.photoUrl,
    required this.otherUserId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: const BoxDecoration(
          border: Border(
        bottom: BorderSide(width: 1.0, color: CustomColors.blackColor),
      )),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: Image.network(
              photoUrl,
              height: 60,
              width: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user,
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 16),
                ),
                Text(
                  otherUserId,
                  style: const TextStyle(
                      fontWeight: FontWeight.w200, fontSize: 12),
                )
              ],
            ),
          ),
          Text(
            money,
            style: TextStyle(
              color: type == Type.debt ? Colors.green : Colors.red,
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
