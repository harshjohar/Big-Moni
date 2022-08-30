import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);
  static const String routeName = "/contact-screen";
  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];
  final _contactNameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getAllContacts();

    _contactNameController.addListener(() {
      filterContacts();
    });
  }

  void filterContacts() {
    List<Contact> l = [];
    l.addAll(contacts);
    if (_contactNameController.text.isNotEmpty) {
      l.retainWhere((ctc) {
        String searchterm = _contactNameController.text.toLowerCase();
        String contactName =
            ctc.displayName != null ? ctc.displayName!.toLowerCase() : "";
        return contactName.contains(searchterm);
      });
    }

    setState(() {
      contactsFiltered = l;
    });
  }

  Future<PermissionStatus> _contactsPermissions() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted) {
      Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ?? PermissionStatus.granted;
    } else {
      return permission;
    }
  }

  void getAllContacts() async {
    PermissionStatus contactsPermissionsStatus = await _contactsPermissions();
    if (contactsPermissionsStatus == PermissionStatus.granted) {
      List<Contact> c =
          (await ContactsService.getContacts(withThumbnails: false)).toList();
      setState(() {
        contacts = c;
      });
    }
  }

  @override
  void dispose() {
    _contactNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = _contactNameController.text.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Contact"),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: TextField(
                controller: _contactNameController,
                decoration: InputDecoration(
                  labelText: "Search",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: isSearching == true
                  ? contactsFiltered.length
                  : contacts.length,
              itemBuilder: (context, index) {
                Contact contact = isSearching == true
                    ? contactsFiltered[index]
                    : contacts[index];
                if (contact.displayName == null ||
                    contact.phones == null ||
                    contact.phones!.isEmpty) {
                  return Container();
                }
                return ListTile(
                  title: contact.displayName != null
                      ? Text(contact.displayName!)
                      : const Text("bug"),
                  subtitle: contact.phones != null && contact.phones!.isNotEmpty
                      ? Text(contact.phones!.elementAt(0).value!)
                      : const Text("No Number"),
                  leading:
                      (contact.avatar != null && contact.avatar!.isNotEmpty)
                          ? CircleAvatar(
                              backgroundImage: MemoryImage(contact.avatar!),
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.indigo,
                              child: Text(
                                contact.initials(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                  onTap: () {
                    Navigator.pop(
                      context,
                      contact.phones!.elementAt(0).value as String,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
