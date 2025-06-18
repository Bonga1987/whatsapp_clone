import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common/repository/common_firebase_storage_repository.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/models/group.dart' as model;

final groupRepositoryProvider = Provider(
  (ref) => GroupRepository(
    ref: ref,
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class GroupRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final Ref ref;

  GroupRepository({
    required this.ref,
    required this.auth,
    required this.firestore,
  });

  Future<void> createGroup(BuildContext context, String name, File profilePic,
      List<Contact> selectedContacts) async {
    try {
      List<String> uids = [];
      for (int i = 0; i < selectedContacts.length; i++) {
        var userCollection = await firestore
            .collection('users')
            .where('phoneNumber',
                isEqualTo:
                    selectedContacts[i].phones[0].number.replaceAll(' ', ''))
            .get();

        if (userCollection.docs.isNotEmpty && userCollection.docs[0].exists) {
          uids.add(userCollection.docs[0].data()['uid']);
        }
      }

      var groupId = const Uuid().v1();

      String profileUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase('group/$groupId', profilePic);

      model.Group group = model.Group(
        senderId: auth.currentUser!.uid,
        name: name,
        lastMessage: '',
        groupId: groupId,
        groupPic: profileUrl,
        membersUid: [auth.currentUser!.uid, ...uids],
        timeSent: DateTime.now(),
      );

      await firestore.collection('groups').doc(groupId).set(group.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
