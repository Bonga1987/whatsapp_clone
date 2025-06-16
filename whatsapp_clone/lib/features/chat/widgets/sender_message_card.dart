import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whatsapp_clone/color.dart';
import 'package:whatsapp_clone/common/enum/message_enum.dart';
import 'package:whatsapp_clone/features/chat/widgets/display_text_image_gif.dart';

class SenderMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback onRightSwipe;
  final String replyText;
  final String username;
  final MessageEnum repliedMessageType;

  const SenderMessageCard(
      {super.key,
      required this.message,
      required this.date,
      required this.type,
      required this.onRightSwipe,
      required this.replyText,
      required this.username,
      required this.repliedMessageType});

  @override
  Widget build(BuildContext context) {
    bool isReplying = replyText.isNotEmpty;

    return SwipeTo(
      onRightSwipe: (details) => onRightSwipe(),
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: searchBarColor,
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
                    )),
                Positioned(
                  bottom: 2,
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
