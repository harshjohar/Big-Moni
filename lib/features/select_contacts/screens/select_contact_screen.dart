import 'package:bigbucks/features/select_contacts/controllers/select_contact_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectContactScreen extends ConsumerStatefulWidget {
  static const String routeName = '/select-contacts';

  const SelectContactScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SelectContactScreen> createState() =>
      _SelectContactScreenState();
}

class _SelectContactScreenState extends ConsumerState<SelectContactScreen> {
  final TextEditingController _contactController = TextEditingController();
  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];

  @override
  void initState() {
    _contactController.addListener(() {
      filterContacts();
    });
    super.initState();
  }

  @override
  void dispose() {
    _contactController.dispose();
    super.dispose();
  }

  void selectContact(
      WidgetRef ref, Contact selectedContact, BuildContext context) {
    ref
        .read(selectContactControllerProvider)
        .selectContact(selectedContact, context);
  }

  void filterContacts() {
    List<Contact> l = [];
    l.addAll(contacts);
    if (_contactController.text.isNotEmpty) {
      l.retainWhere((ctc) {
        String search = _contactController.text.toLowerCase();
        String contactName = ctc.displayName.toLowerCase();
        return contactName.contains(search);
      });
    }
    setState(() {
      filteredContacts = l;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = _contactController.text.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: ClipRRect(
          borderRadius: BorderRadius.circular(9999),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 0,
            ),
            child: TextField(
              controller: _contactController,
              decoration: const InputDecoration(
                hintText: "Select Contacts",
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: ref.watch(getContactsProvider).when(data: (contactList) {
        setState(() {
          if (contacts.isEmpty) {
            contacts.addAll(contactList);
          }
        });
        return ListView.builder(
          itemCount: isSearching ? filteredContacts.length : contacts.length,
          itemBuilder: (context, index) {
            final contact =
                isSearching ? filteredContacts[index] : contacts[index];
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
                          backgroundColor: Colors.indigo,
                          backgroundImage: NetworkImage(
                            "https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png",
                          ),
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
        );
      }, error: (error, trace) {
        return Scaffold(
          body: Center(
            child: Text(error.toString()),
          ),
        );
      }, loading: () {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }),
    );
  }
}
