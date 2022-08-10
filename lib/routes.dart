import 'package:flutter/material.dart';
import 'package:whatsapp_ui/features/auth/screen/loging_screen.dart';
import 'package:whatsapp_ui/features/auth/screen/otp_screen.dart';
import 'package:whatsapp_ui/features/auth/screen/user_information_screen.dart';
import 'package:whatsapp_ui/features/select_contact/screen/select_contact_screen.dart';
import 'package:whatsapp_ui/screens/mobile_chat_screen.dart';

import 'common/widgets/error.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context) => LoginScreen());
    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => OTPScreen(
                verificationId: verificationId,
              ));
    case UserInformationScreen.routeName:
      return MaterialPageRoute(builder: (context) => UserInformationScreen());
    case SelectContactScreen.routeName:
      return MaterialPageRoute(builder: (context) => SelectContactScreen());
    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'] as String;
      final uid = arguments['uid'] as String;
      return MaterialPageRoute(
          builder: (context) => MobileChatScreen(
                name: name,
                uid: uid,
              ));
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: 'This page doesn\'t exist'),
        ),
      );
  }
}
