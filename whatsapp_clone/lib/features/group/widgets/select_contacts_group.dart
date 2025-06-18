import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/widgets/error.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/select_contacts/controller/select_contact_controller.dart';

final selectGroupContacts = StateProvider<List<Contact>>((ref) => []);

class SelectContactsGroup extends ConsumerStatefulWidget {
  const SelectContactsGroup({super.key});

  @override
  ConsumerState<SelectContactsGroup> createState() =>
      _SelectContactsGroupState();
}

class _SelectContactsGroupState extends ConsumerState<SelectContactsGroup> {
  List<int> selectedContctsIndex = [];

  void selectContact(Contact selectedContact, int index) {
    if (selectedContctsIndex.contains(index)) {
      selectedContctsIndex.removeAt(index);
    } else {
      selectedContctsIndex.add(index);
    }
    setState(() {});
    ref
        // ignore: deprecated_member_use
        .read(selectGroupContacts.state)
        .update((state) => [...state, selectedContact]);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getContactsProvider).when(
        data: (contactList) => Expanded(
              child: ListView.builder(
                itemCount: contactList.length,
                itemBuilder: (context, index) {
                  final contact = contactList[index];
                  return InkWell(
                    onTap: () => selectContact(contact, index),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(
                          contact.displayName,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        leading: selectedContctsIndex.contains(index)
                            ? IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.done),
                              )
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
        error: (err, trace) => ErrorScreen(error: err.toString()),
        loading: () => Loader());
  }
}
