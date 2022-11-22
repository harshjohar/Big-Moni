import 'package:bigbucks/common/screens/loader.dart';
import 'package:bigbucks/features/money/controller/money_controller.dart';
import 'package:bigbucks/features/money/screens/details_screen.dart';
import 'package:bigbucks/models/interaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class InteractionsList extends ConsumerWidget {
  const InteractionsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: StreamBuilder<List<Interaction>>(
        stream: ref.read(moneyControllerProvider).getInteractions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          if (snapshot.data == null) {
            return const Center(child: Text("No interactions"));
          }
          return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var interactionData = snapshot.data![index];
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          DetailsScreen.routeName,
                          arguments: {
                            'userId': interactionData.userId,
                            'name': interactionData.name,
                            'photoUrl': interactionData.photoUrl,
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(
                            interactionData.name,
                            style: const TextStyle(fontSize: 18),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              interactionData.lastTransactionDescription,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.indigo,
                            backgroundImage: NetworkImage(
                              interactionData.photoUrl.isNotEmpty
                                  ? interactionData.photoUrl
                                  : "https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png",
                            ),
                            radius: 30,
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              interactionData.balance >= 0
                                  ? Text(
                                      interactionData.balance.ceil().toString(),
                                      style: TextStyle(
                                        color: interactionData.balance > 0
                                            ? Colors.green
                                            : Colors.indigo,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    )
                                  : Text(
                                      (-interactionData.balance)
                                          .ceil()
                                          .toString(),
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                              Text(
                                DateFormat.Hm()
                                    .format(interactionData.timestamp),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Divider(color: Colors.grey, indent: 85),
                  ],
                );
              });
        },
      ),
    );
  }
}
