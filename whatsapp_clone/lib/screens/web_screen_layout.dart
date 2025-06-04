import 'package:flutter/material.dart';
import 'package:whatsapp_clone/color.dart';
import 'package:whatsapp_clone/widgets/chat_list.dart';
import 'package:whatsapp_clone/features/chat/widgets/contacts_list.dart';
import 'package:whatsapp_clone/widgets/web_chat_appbar.dart';
import 'package:whatsapp_clone/widgets/web_profile_bar.dart';
import 'package:whatsapp_clone/widgets/web_search_bar.dart';

class WebScreenLayout extends StatelessWidget {
  const WebScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                WebProfileBar(),
                WebSearchBar(),
                ContactsList(),
              ],
            ),
          ),
        ),

        //web screen
        Container(
            width: MediaQuery.of(context).size.width * 0.70,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "assets/backgroundImage.png",
                  ),
                  fit: BoxFit.cover),
            ),
            child: Center(
              child: Column(
                children: [
                  //chat app bar
                  const WebChatAppbar(),
                  //chat list
                  const Expanded(
                    child: ChatList(receiverUserId: ''),
                  ),
                  //message input box
                  Container(
                    height: MediaQuery.of(context).size.height * 0.077,
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: dividerColor,
                        ),
                      ),
                      color: chatBarMessage,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.emoji_emotions_outlined,
                            color: Colors.grey,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 15,
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                fillColor: searchBarColor,
                                filled: true,
                                hintStyle: const TextStyle(fontSize: 14),
                                hintText: 'Type a message',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.only(left: 10),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.mic,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
      ],
    ));
  }
}
