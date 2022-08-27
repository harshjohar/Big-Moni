import 'package:bigbucks/features/home/widgets/list_person.dart';
import 'package:bigbucks/models/person.dart';
import 'package:flutter/material.dart';

class CreditorsList extends StatelessWidget {
  CreditorsList({Key? key}) : super(key: key);
  final total = 8900;

  final jolie = Person(
    name: "Angelina Jolie",
    phoneNumber: "345678987",
    photoUrl:
        "https://deadline.com/wp-content/uploads/2022/03/Angelina-Jolie-photo-Netflix-Alexei-Hay-e1646407877581.jpeg",
  );
  final rachel = Person(
    name: "Jennifer Aniston",
    phoneNumber: "3824834394",
    photoUrl:
        "https://media1.popsugar-assets.com/files/thumbor/ptdgPx5tCvvD9kUsU7pQFMUkBIA/207x134:1865x1792/fit-in/2048xorig/filters:format_auto-!!-:strip_icc-!!-/2019/09/09/028/n/1922398/066318895d76e2ef0c31d8.46065434_/i/Jennifer-Aniston.jpg",
  );
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
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
          user: jolie,
          type: Type.credit,
        ),
        ListPerson(
          money: 20,
          user: rachel,
          type: Type.credit,
        ),
      ]),
    );
  }
}
