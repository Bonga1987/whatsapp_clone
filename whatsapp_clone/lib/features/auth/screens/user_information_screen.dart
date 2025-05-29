import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';

class UserInformationScreen extends StatefulWidget {
  static const String routeName = '/user-information';
  const UserInformationScreen({super.key});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreen();
}

class _UserInformationScreen extends State<UserInformationScreen> {
  final TextEditingController nameController = TextEditingController();
  File? image;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
      child: Column(
        children: [
          Stack(
            children: [
              image == null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://images.icon-icons.com/3217/PNG/512/user_avatar_profile_person_man_icon_196571.png'),
                      radius: 64,
                      backgroundColor: Colors.white,
                    )
                  : CircleAvatar(
                      backgroundImage: FileImage(image!),
                      radius: 64,
                      backgroundColor: Colors.white,
                    ),
              Positioned(
                bottom: 5,
                right: -5,
                child: IconButton(
                  onPressed: selectImage,
                  icon: Icon(Icons.add_a_photo),
                  color: Colors.black,
                ),
              )
            ],
          ),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: EdgeInsets.all(20),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.done),
              ),
            ],
          )
        ],
      ),
    )));
  }
}
