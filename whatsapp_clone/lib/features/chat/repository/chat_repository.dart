import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common/enum/message_enum.dart';
import 'package:whatsapp_clone/common/providers/message_reply_provider.dart';
import 'package:whatsapp_clone/common/repository/common_firebase_storage_repository.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/info.dart';
import 'package:whatsapp_clone/models/chat_contact.dart';
import 'package:whatsapp_clone/models/message.dart';
import 'package:whatsapp_clone/models/user_model.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({required this.firestore, required this.auth});

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];

      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);

        contacts.add(
          ChatContact(
              name: user.name,
              profilePic: user.profilePic,
              contactId: chatContact.contactId,
              timeSent: chatContact.timeSent,
              lastMessage: chatContact.lastMessage),
        );
      }
      return contacts;
    });
  }

  Stream<List<Message>> getChatStream(String receiverUserId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }

      return messages;
    });
  }

  void _saveDataTOContactsSubcollection(
    UserModel senderUserData,
    UserModel receiverUserData,
    String text,
    DateTime timeSent,
    String receiverUserId,
  ) async {
    var receiverChatContact = ChatContact(
      name: senderUserData.name,
      profilePic: senderUserData.profilePic,
      contactId: senderUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );

    await firestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(
          auth.currentUser!.uid,
        )
        .set(
          receiverChatContact.toMap(),
        );
    ////
    var senderChatContact = ChatContact(
      name: receiverUserData.name,
      profilePic: receiverUserData.profilePic,
      contactId: receiverUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .set(
          senderChatContact.toMap(),
        );
  }

  void _saveMessageToMessageSubCollection(
    String receiverUserId,
    String text,
    DateTime timeSent,
    String messageId,
    String username,
    String seceiverUsername,
    MessageEnum messageType,
    MessageReply? messageReply,
    String senderUsername,
    String receiverUsername,
    MessageEnum repliedMessageType,
  ) async {
    final message = Message(
      senderId: auth.currentUser!.uid,
      receiverId: receiverUserId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
      repliedMessage: messageReply == null ? '' : messageReply.message,
      repliedTo: messageReply == null
          ? ''
          : messageReply.isMe
              ? senderUsername
              : receiverUsername,
      repliedMessageType: repliedMessageType,
    );

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
    /////
    await firestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String recieverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel receiverUserData;

      var userDataMap =
          await firestore.collection('users').doc(recieverUserId).get();

      receiverUserData = UserModel.fromMap(userDataMap.data()!);
      var meesageId = const Uuid().v1();

      _saveDataTOContactsSubcollection(
        senderUser,
        receiverUserData,
        text,
        timeSent,
        recieverUserId,
      );

      _saveMessageToMessageSubCollection(
        recieverUserId,
        text,
        timeSent,
        meesageId,
        senderUser.name,
        receiverUserData.name,
        MessageEnum.text,
        messageReply,
        receiverUserData.name,
        senderUser.name,
        messageReply == null ? MessageEnum.text : messageReply.messageEnum,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String receiverUserId,
    required UserModel senderUserData,
    required Ref ref,
    required MessageEnum messageEnum,
    required MessageReply? messageReply,
  }) async {
    var timeSent = DateTime.now();
    var messageId = Uuid().v1();

    String imageUrl = await ref
        .read(commonFirebaseStorageRepositoryProvider)
        .storeFileToFirebase(
          'chat/${messageEnum.type}/${senderUserData.uid}/$receiverUserId/$messageId',
          file,
        );

    UserModel receiverUserData;
    var userDataMap =
        await firestore.collection('users').doc(receiverUserId).get();
    receiverUserData = UserModel.fromMap(userDataMap.data()!);

    String contactMsg;

    switch (messageEnum) {
      case MessageEnum.image:
        contactMsg = '📷 photo';
        break;
      case MessageEnum.video:
        contactMsg = '📽️ video';
        break;
      case MessageEnum.audio:
        contactMsg = '🎵 audio';
        break;
      case MessageEnum.gif:
        contactMsg = 'GIF';
        break;
      default:
        contactMsg = '';
    }

    _saveDataTOContactsSubcollection(
      senderUserData,
      receiverUserData,
      contactMsg,
      timeSent,
      receiverUserId,
    );

    _saveMessageToMessageSubCollection(
      receiverUserId,
      imageUrl,
      timeSent,
      messageId,
      senderUserData.name,
      receiverUserData.name,
      messageEnum,
      messageReply,
      receiverUserData.name,
      senderUserData.name,
      messageReply == null ? MessageEnum.text : messageReply.messageEnum,
    );
  }

  void sendGIFMessage({
    required BuildContext context,
    required String gifUrl,
    required String recieverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel receiverUserData;

      var userDataMap =
          await firestore.collection('users').doc(recieverUserId).get();

      receiverUserData = UserModel.fromMap(userDataMap.data()!);
      var meesageId = const Uuid().v1();

      _saveDataTOContactsSubcollection(
        senderUser,
        receiverUserData,
        'GIF',
        timeSent,
        recieverUserId,
      );

      _saveMessageToMessageSubCollection(
        recieverUserId,
        gifUrl,
        timeSent,
        meesageId,
        senderUser.name,
        receiverUserData.name,
        MessageEnum.gif,
        messageReply,
        receiverUserData.name,
        senderUser.name,
        messageReply == null ? MessageEnum.text : messageReply.messageEnum,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void setChatMessageSeen(
    BuildContext context,
    String receiverUserId,
    String messageId,
  ) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(receiverUserId)
          .collection('messages')
          .doc(messageId)
          .update({
        'isSeen': true,
      });
      /////
      await firestore
          .collection('users')
          .doc(receiverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({
        'isSeen': true,
      });
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
