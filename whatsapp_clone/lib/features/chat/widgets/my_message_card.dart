import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whatsapp_clone/color.dart';
import 'package:whatsapp_clone/common/enum/message_enum.dart';
import 'package:whatsapp_clone/features/chat/widgets/display_text_image_gif.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback onLeftSwipe;
  final String replyText;
  final String username;
  final MessageEnum repliedMessageType;
  final bool isSeen;

  const MyMessageCard({
    super.key,
    required this.message,
    required this.date,
    required this.type,
    required this.onLeftSwipe,
    required this.replyText,
    required this.username,
    required this.repliedMessageType,
    required this.isSeen,
  });

  @override
  Widget build(BuildContext context) {
    final isReplying = replyText.isNotEmpty;

    return SwipeTo(
      onLeftSwipe: (details) => onLeftSwipe(),
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: messageColor,
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 5,
            ),
            child: Stack(
              children: [
                Padding(
                  padding: type == MessageEnum.text
                      ? const EdgeInsets.only(
                          left: 10, right: 30, top: 5, bottom: 20)
                      : const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      if (isReplying) ...[
                        Text(
                          username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: backgroundColor.withOpacity(0.2),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(
                                5,
                              ),
                            ),
                          ),
                          child: DisplayTextImageGif(
                              message: replyText, type: repliedMessageType),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                      ],
                      DisplayTextImageGif(message: message, type: type),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 10,
                  child: Row(
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                            fontSize: 13, color: Colors.white60),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Icon(
                        isSeen ? Icons.done_all : Icons.done,
                        size: 20,
                        color: isSeen ? Colors.blue : Colors.white60,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
