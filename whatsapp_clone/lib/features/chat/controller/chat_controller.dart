import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/enum/message_enum.dart';
import 'package:whatsapp_clone/common/providers/message_reply_provider.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/chat/repository/chat_repository.dart';
import 'package:whatsapp_clone/models/chat_contact.dart';
import 'package:whatsapp_clone/models/message.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(chatRepository: chatRepository, ref: ref);
});

class ChatController {
  final ChatRepository chatRepository;
  final Ref ref;

  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<ChatContact>> getChatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<Message>> getChatStream(String receiverUserId) {
    return chatRepository.getChatStream(receiverUserId);
  }

  void sendTextMessage(
      BuildContext context, String text, String recieverUserId) {
    final messageReply = ref.read(messageReplyProvider);

    ref
        .read(userDataAuthProvider)
        .whenData((value) => chatRepository.sendTextMessage(
              context: context,
              text: text,
              recieverUserId: recieverUserId,
              senderUser: value!,
              messageReply: messageReply,
            ));
    // ignore: deprecated_member_use
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void sendGIFMessage(
      BuildContext context, String gifUrl, String recieverUserId) {
    final messageReply = ref.read(messageReplyProvider);

    ref
        .read(userDataAuthProvider)
        .whenData((value) => chatRepository.sendGIFMessage(
              context: context,
              gifUrl: gifUrl,
              recieverUserId: recieverUserId,
              senderUser: value!,
              messageReply: messageReply,
            ));
    // ignore: deprecated_member_use
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void sendFileMessage(
    BuildContext context,
    File file,
    String receiverUserId,
    MessageEnum messageEnum,
  ) {
    final messageReply = ref.read(messageReplyProvider);

    ref
        .read(userDataAuthProvider)
        .whenData((value) => chatRepository.sendFileMessage(
              context: context,
              file: file,
              receiverUserId: receiverUserId,
              senderUserData: value!,
              messageEnum: messageEnum,
              ref: ref,
              messageReply: messageReply,
            ));
    // ignore: deprecated_member_use
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void setMessageSeen(
    BuildContext context,
    String receiverUserId,
    String messageId,
  ) {
    chatRepository.setChatMessageSeen(
      context,
      receiverUserId,
      messageId,
    );
  }
}
