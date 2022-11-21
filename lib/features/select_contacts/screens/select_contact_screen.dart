
import 'package:bigbucks/features/select_contacts/controllers/select_contact_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectContactScreen extends ConsumerWidget {
  static const String routeName = '/select-contacts';

  const SelectContactScreen({Key? key}) : super(key: key);

  void selectContact(
      WidgetRef ref, Contact selectedContact, BuildContext context) {
    // TODO
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Contacts"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: ref.watch(getContactsProvider).when(
          data: (contactList) => ListView.builder(
            itemBuilder: (context, index) {
              final contact = contactList[index];
              return InkWell(
                onTap: () {
                  selectContact(ref, contact, context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    title: Text(contact.displayName),
                    leading: contact.photo == null
                        ? const CircleAvatar(
                      backgroundColor: Colors.pink,
                      radius: 30,
                    )
                        : CircleAvatar(
                      backgroundImage: MemoryImage(contact.photo!),
                      radius: 30,
                    ),
                  ),
                ),
              );
            },
            itemCount: contactList.length,
          ),
          error: (error, trace) {
            return Scaffold(
              body: Center(
                child: Text(error.toString()),
              ),
            );
          },
          loading: () {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }),
    );
  }
}
