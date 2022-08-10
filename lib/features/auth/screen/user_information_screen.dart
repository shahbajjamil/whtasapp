import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  static const routeName = '/user-information';
  const UserInformationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UserInformationScreen> createState() =>
      _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final TextEditingController nameController = TextEditingController();
  File? image;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void storeUserData() async {
    String name = nameController.text;
    log("button clicked");
    if (name.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .saveUserDataToFirebase(context, name, image);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Stack(
                children: [
                  image == null
                      ? const CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey,
                          foregroundImage: NetworkImage(
                              "https://png.pngitem.com/pimgs/s/24-248235_user-profile-avatar-login-account-fa-user-circle.png"),
                          // child: Icon(
                          //   Icons.person,
                          //   size: 60,
                          //   color: Colors.white,
                          // ),
                        )
                      : CircleAvatar(
                          radius: 60, backgroundImage: FileImage(image!)),
                  Positioned(
                    bottom: -10,
                    right: 0,
                    child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo),
                        color: Colors.white),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: size.width * .85,
                    // height: 100,
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      controller: nameController,
                      decoration:
                          const InputDecoration(hintText: "Enter your name"),
                    ),
                  ),
                  IconButton(
                      onPressed: storeUserData,
                      icon: const Icon(Icons.done),
                      color: Colors.white),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
