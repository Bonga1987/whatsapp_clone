import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/widgets/error.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/select_contacts/controller/select_contact_controller.dart';
import 'package:whatsapp_clone/widgets/contacts_list.dart';

class SelectContactsScreen extends ConsumerWidget {
  static const String routeName = '/select-contact';
  const SelectContactsScreen({super.key});

  void selectContact(
      Contact selectedContact, WidgetRef ref, BuildContext context) {
    ref
        .read(selectContactControllerProvider)
        .selectContact(selectedContact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select contact'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert),
          )
        ],
      ),
      body: ref.watch(getContactsProvider).when(
          data: (contactList) => ListView.builder(
                itemCount: contactList.length,
                itemBuilder: (context, index) {
                  final contact = contactList[index];
                  return InkWell(
                    onTap: () => selectContact(contact, ref, context),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(
                          contact.displayName,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        leading: contact.photo == null
                            ? null
                            : CircleAvatar(
                                backgroundImage: MemoryImage(contact.photo!),
                                radius: 30,
                              ),
                      ),
                    ),
                  );
                },
              ),
          error: (err, trace) => ErrorScreen(error: err.toString()),
          loading: () => Loader()),
    );
  }
}
