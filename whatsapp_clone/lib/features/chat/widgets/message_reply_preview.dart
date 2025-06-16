import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/color.dart';
import 'package:whatsapp_clone/common/providers/message_reply_provider.dart';
import 'package:whatsapp_clone/features/chat/widgets/display_text_image_gif.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meesageReply = ref.watch(messageReplyProvider);

    void cancelReply(WidgetRef ref) {
      // ignore: deprecated_member_use
      ref.read(messageReplyProvider.state).update((state) => null);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      width: 350,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  meesageReply!.isMe ? 'You' : 'Opposite',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => cancelReply(ref),
                child: const Icon(
                  Icons.close,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          DisplayTextImageGif(
              message: meesageReply.message, type: meesageReply.messageEnum),
        ],
      ),
    );
  }
}
