import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  static const String routeName = '/user-information';
  const UserInformationScreen({super.key});

  @override
  ConsumerState<UserInformationScreen> createState() =>
      _UserInformationScreen();
}

class _UserInformationScreen extends ConsumerState<UserInformationScreen> {
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

  void storeUserData() async {
    String name = nameController.text.trim();
    if (name.isNotEmpty) {
      ref.read(authControllerProvider).saveUserDataToFirebase(
            context,
            name,
            image,
          );
    }
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
                onPressed: storeUserData,
                icon: Icon(Icons.done),
              ),
            ],
          )
        ],
      ),
    )));
  }
}
