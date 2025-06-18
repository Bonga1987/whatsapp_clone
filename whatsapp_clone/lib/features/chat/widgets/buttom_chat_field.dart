import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/color.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';

class ButtomChatField extends ConsumerStatefulWidget {
  final String receiverUserId;
  final bool isGroupChat;
  const ButtomChatField({
    super.key,
    required this.receiverUserId,
    required this.isGroupChat,
  });

  @override
  ConsumerState<ButtomChatField> createState() => _ButtomChatFieldState();
}

class _ButtomChatFieldState extends ConsumerState<ButtomChatField> {
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();

  void sendTextMessage() {
    if (isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
            context,
            _messageController.text.trim(),
            widget.receiverUserId,
          );

      setState(() {
        _messageController.text = '';
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: TextFormField(
          controller: _messageController,
          onChanged: (value) => {
            if (value.isNotEmpty)
              {
                setState(() {
                  isShowSendButton = true;
                })
              }
            else
              {
                setState(() {
                  isShowSendButton = false;
                })
              }
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: mobileChatBoxColor,
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.emoji_emotions,
                        color: Colors.grey,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.gif,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            suffixIcon: SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Colors.grey,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.attach_file,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            hintText: 'Type a message!',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            contentPadding: const EdgeInsets.all(10),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
          bottom: 8,
          right: 2,
          left: 2,
        ),
        child: CircleAvatar(
          backgroundColor: Color(0xFF128C7E),
          radius: 25,
          child: GestureDetector(
            onTap: sendTextMessage,
            child: Icon(
              isShowSendButton ? (Icons.send) : (Icons.mic),
            ),
          ),
        ),
      ),
    ]);
  }
}
